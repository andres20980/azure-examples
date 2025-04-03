resource "azurerm_consumption_budget_subscription" "ia" {
  name            = "SynergIA"
  subscription_id = "/subscriptions/${var.subscription_id}"

  amount     = 1000
  time_grain = "Monthly"

  # End date set to +10 years by default if not explicitly set
  time_period {
    start_date = "2024-06-01T00:00:00Z"
  }

  filter {
    tag {
      name   = "application"
      values = ["ia"]
    }
  }

  notification {
    enabled        = true
    threshold      = 50.0
    operator       = "EqualTo"
    contact_emails = ["dmoran@sacyr.com", "hiberus_problesa@sacyr.com"]
  }

  notification {
    enabled        = true
    threshold      = 100.0
    operator       = "EqualTo"
    contact_emails = ["dmoran@sacyr.com", "hiberus_problesa@sacyr.com"]
  }

  notification {
    enabled        = true
    threshold      = 100.0
    operator       = "GreaterThan"
    threshold_type = "Forecasted"
    contact_emails = ["dmoran@sacyr.com", "hiberus_problesa@sacyr.com"]
  }
}

resource "azurerm_consumption_budget_subscription" "aks" {
  name            = "AKS"
  subscription_id = "/subscriptions/${var.subscription_id}"

  amount     = 1500
  time_grain = "Monthly"

  # End date set to +10 years by default if not explicitly set
  time_period {
    start_date = "2024-06-01T00:00:00Z"
  }

  filter {

    tag {
      name   = "resource"
      values = ["aks"]
    }
  }

  notification {
    enabled        = true
    threshold      = 47.0
    operator       = "EqualTo"
    contact_emails = ["dmoran@sacyr.com", "hiberus_problesa@sacyr.com"]
  }

  notification {
    enabled        = true
    threshold      = 100.0
    operator       = "EqualTo"
    contact_emails = ["dmoran@sacyr.com", "hiberus_problesa@sacyr.com"]
  }

  notification {
    enabled        = true
    threshold      = 100.0
    operator       = "GreaterThan"
    threshold_type = "Forecasted"
    contact_emails = ["dmoran@sacyr.com", "hiberus_problesa@sacyr.com"]
  }
}