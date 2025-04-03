# Ref: https://towardsdev.com/automatically-stop-and-start-aks-clusters-using-azure-automation-and-terraform-4890ff945f73
locals {
  current_time           = timestamp()
  current_wallclock_time = formatdate("h.mm", local.current_time)
  today                  = formatdate("YYYY-MM-DD", local.current_time)
  tomorrow               = formatdate("YYYY-MM-DD", timeadd(local.current_time, "24h"))
}

resource "azurerm_automation_account" "automation_account" {
  name                = "${var.environment}-aks-automation"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "Basic"
  tags                = var.tags
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_automation_runbook" "aks_start_stop" {
  depends_on              = [azurerm_automation_account.automation_account]
  name                    = "aks-start-stop"
  location                = var.location
  resource_group_name     = azurerm_resource_group.rg.name
  automation_account_name = azurerm_automation_account.automation_account.name
  log_verbose             = "false"
  log_progress            = "true"
  description             = "An Azure Automation Runbook for stopping and starting your AKS Cluster"
  runbook_type            = "PowerShell"
  tags                    = var.tags
  content                 = <<-EOF
    <#
        .SYNOPSIS
            This Azure Automation runbook automates the scheduled shutdown and startup of AKS Clusters in an Azure subscription.

        .DESCRIPTION
            This is a PowerShell runbook, as opposed to a PowerShell Workflow runbook.
      Note that the Automation Account will need RBAC permission on the Cluster (scoped directly or inherited) in order to
      perform the start/stop operation.

        .PARAMETER ResourceGroupName
            The name of the ResourceGroup where the AKS Cluster is located

        .PARAMETER AksClusterName
            The name of the AKS Cluster to

        .PARAMETER Operation
            Currently supported operations are 'start' and 'stop'

        .INPUTS
            None.

        .OUTPUTS
            Human-readable informational and error messages produced during the job. Not intended to be consumed by another runbook.
    #>

    Param(
          [parameter(Mandatory=$true)]
      [String] $ResourceGroupName,
          [parameter(Mandatory=$true)]
      [String] $AksClusterName,
          [parameter(Mandatory=$true)]
      [ValidateSet('start','stop')]
          [String]$Operation
    )

    try
    {
      Disable-AzContextAutosave -Scope Process

      #System Managed Identity
      Write-Output "Logging into Azure using System Managed Identity"
      $AzureContext = (Connect-AzAccount -Identity).context
      $AzureContext = Set-AzContext -SubscriptionName $AzureContext.Subscription -DefaultProfile $AzureContext
    }
    catch {
      Write-Error -Message $_.Exception
      throw $_.Exception
    }

    $success = 'false'
    $maxRetries = 10
    $count = 0
    do {
      try {
        Write-Output "Performing $Operation"
        switch -CaseSensitive ($Operation)
        {
          'start'
          {
          Write-Output "Starting Cluster $AksClusterName in $ResourceGroupName"
          Start-AzAksCluster -ResourceGroupName $ResourceGroupName -Name $AksClusterName
          }
          'stop'
          {
          Write-Output "Stopping Cluster $AksClusterName in $ResourceGroupName"
          Stop-AzAksCluster -ResourceGroupName $ResourceGroupName -Name $AksClusterName
          }
        }
        $success = 'true'
      }
      catch {
        Write-Output "Operation failed, trying again..."
        $count++
      }
    } while ($success -ne 'true' -And $count -lt $maxRetries)
    
  EOF
}

resource "azurerm_automation_schedule" "monday_friday_morning" {
  name                    = "monday-friday-morning"
  description             = "Run Monday to Friday early morning"
  resource_group_name     = azurerm_resource_group.rg.name
  automation_account_name = azurerm_automation_account.automation_account.name
  frequency               = "Week"
  interval                = 1
  timezone                = "Europe/Madrid"
  start_time              = "${local.current_wallclock_time >= "5.50" ? local.tomorrow : local.today}T04:55:00Z" # Azure runs it in UTC horario de verano
  week_days               = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
}

resource "azurerm_automation_schedule" "monday_friday_evening" {
  name                    = "monday-friday-evening"
  description             = "Run Monday to Friday late evening"
  resource_group_name     = azurerm_resource_group.rg.name
  automation_account_name = azurerm_automation_account.automation_account.name
  frequency               = "Week"
  interval                = 1
  timezone                = "Europe/Madrid"
  start_time              = "${local.current_wallclock_time >= "20.50" ? local.tomorrow : local.today}T19:55:00Z" # Azure runs it in UTC horario de verano
  week_days               = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
}

# resource "azurerm_automation_job_schedule" "aks_start" {
#   resource_group_name     = azurerm_resource_group.rg.name
#   automation_account_name = azurerm_automation_account.automation_account.name
#   schedule_name           = azurerm_automation_schedule.monday_friday_morning.name
#   runbook_name            = azurerm_automation_runbook.aks_start_stop.name
#   parameters = {
#     resourcegroupname = azurerm_resource_group.rg.name
#     aksclustername    = azurerm_kubernetes_cluster.aks.name
#     operation         = "start"
#   }
# }

# resource "azurerm_automation_job_schedule" "aks_stop" {
#   resource_group_name     = azurerm_resource_group.rg.name
#   automation_account_name = azurerm_automation_account.automation_account.name
#   schedule_name           = azurerm_automation_schedule.monday_friday_evening.name
#   runbook_name            = azurerm_automation_runbook.aks_start_stop.name
#   parameters = {
#     resourcegroupname = azurerm_resource_group.rg.name
#     aksclustername    = azurerm_kubernetes_cluster.aks.name
#     operation         = "stop"
#   }
# }

resource "azurerm_role_assignment" "automation_account_principal_aks_contributor" {
  scope                = azurerm_kubernetes_cluster.aks.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_automation_account.automation_account.identity[0].principal_id
}
