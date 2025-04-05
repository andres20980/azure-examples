resource "azurerm_application_gateway" "waf_new" {
  name                = "${var.environment}-application-gateway-new"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags

  lifecycle {
    ignore_changes = [
      backend_address_pool,
      backend_http_settings,
      frontend_ip_configuration,
      frontend_port,
      http_listener,
      request_routing_rule,
      probe,
      ssl_certificate,
      url_path_map,
      tags
    ]
  }

  force_firewall_policy_association = true

  sku {
    name = "WAF_v2"
    tier = "WAF_v2"
  }

  # Recommended ssl policy
  # Source: https://learn.microsoft.com/en-us/azure/application-gateway/application-gateway-ssl-policy-overview
  ssl_policy {
    policy_type = "Predefined"
    policy_name = "AppGwSslPolicy20220101"
  }

  # Configure a posteriori the targets in the web UI - which are the aks VMSS
  backend_address_pool {
    name = "default"
  }

  backend_http_settings {
    name                  = "default"
    cookie_based_affinity = "Enabled"
    port                  = 80
    protocol              = "Http"
  }

  frontend_ip_configuration {
    name                 = "gateway-frontend-ip-configuration"
    public_ip_address_id = azurerm_public_ip.ip_new.id
  }

  frontend_port {
    name = "default"
    port = 80
  }

  gateway_ip_configuration {
    name      = "gateway-ip-configuration"
    subnet_id = azurerm_subnet.waf_subnet_new.id
  }

  http_listener {
    name                           = "default"
    frontend_ip_configuration_name = "gateway-frontend-ip-configuration"
    protocol                       = "Http"
    frontend_port_name             = "default"
  }

  request_routing_rule {
    name                       = "default"
    rule_type                  = "Basic"
    http_listener_name         = "default"
    backend_address_pool_name  = "default"
    backend_http_settings_name = "default"
    priority                   = 100
  }

  waf_configuration {
    enabled          = true
    firewall_mode    = "Prevention"
    rule_set_type    = "OWASP"
    rule_set_version = "3.2"
  }

  autoscale_configuration {
    min_capacity = 1
    max_capacity = 10
  }

  firewall_policy_id = azurerm_web_application_firewall_policy.waf_policy.id
}

resource "azurerm_web_application_firewall_policy" "waf_policy" {
  name                = "waf-policy"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags
  policy_settings {
    enabled                     = true
    mode                        = "Prevention"
    request_body_check          = true
    file_upload_limit_in_mb     = 500
    max_request_body_size_in_kb = 128
  }

  custom_rules {
    name                 = "rate-limit-rule"
    enabled              = true
    rule_type            = "RateLimitRule"
    action               = "Block"
    priority             = 100
    rate_limit_duration  = "OneMin"
    rate_limit_threshold = 200
    group_rate_limit_by  = "ClientAddr"
    match_conditions {
      operator     = "IPMatch"
      match_values = ["255.255.255.255/32"]
      match_variables {
        variable_name = "RemoteAddr"
      }
    }
  }

  managed_rules {
    managed_rule_set {
      type    = "Microsoft_BotManagerRuleSet"
      version = "1.0"
    }
    managed_rule_set {
      type    = "OWASP"
      version = "3.2"
      rule_group_override {
        rule_group_name = "REQUEST-942-APPLICATION-ATTACK-SQLI"
        rule {
          id      = "942150"
          enabled = true
          action  = "Log"
        }
        rule {
          id      = "942410"
          enabled = true
          action  = "Log"
        }
        rule {
          id      = "942440"
          enabled = true
          action  = "Log"
        }
        rule {
          id      = "942470"
          enabled = true
          action  = "Log"
        }
      }
       rule_group_override {
        rule_group_name = "REQUEST-920-PROTOCOL-ENFORCEMENT"
        rule {
          id      = "920120"
          enabled = true
          action  = "Log"
        }
        rule {
          id      = "920121"
          enabled = true
          action  = "Log"
        }
        rule {
          id      = "920440"
          enabled = true
          action  = "Log"
        }
      }
    }
    # Exclusion rules for grafana/prometheus
    exclusion {
      match_variable          = "RequestArgNames"
      selector_match_operator = "Contains"
      selector                = "queries"
    }
    exclusion {
      match_variable          = "RequestArgNames"
      selector_match_operator = "Contains"
      selector                = "match"
    }
    # Exclusion rules for front Odata queries
    exclusion {
      match_variable          = "RequestArgNames"
      selector_match_operator = "Contains"
      selector                = "filter"
    }
    exclusion {
      match_variable          = "RequestArgNames"
      selector_match_operator = "Contains"
      selector                = "dateSeparators"
    }
    exclusion {
      match_variable          = "RequestArgNames"
      selector_match_operator = "Contains"
      selector                = "decimalSeparators"
    }
    exclusion {
      match_variable          = "RequestArgNames"
      selector_match_operator = "Contains"
      selector                = "groupSeparators"
    }
    exclusion {
      match_variable          = "RequestArgNames"
      selector_match_operator = "Contains"
      selector                = "upload"
    }
    # Exclusion para los parametros de subida de archivos de Nubia
    exclusion {
      match_variable          = "RequestArgNames"
      selector_match_operator = "Contains"
      selector                = "documentoMetadatosJson"
    }
    # Exclusion para los parametros de Elsa de Nubia
    exclusion {
      match_variable          = "RequestArgNames"
      selector_match_operator = "Contains"
      selector                = "stringData"
    }
    # Exclusion para el parametro fileName de Synergia
    exclusion {
      match_variable          = "RequestArgNames"
      selector_match_operator = "Contains"
      selector                = "fileName"
    }
  }
}
