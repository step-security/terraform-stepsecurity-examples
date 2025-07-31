terraform {
  required_version = ">= 1.0"
  required_providers {
    stepsecurity = {
      source  = "step-security/stepsecurity"
      version = "~> 0.0.4"
    }
  }
}

provider "stepsecurity" {
  # api_key and customer will be read from environment variables:
  # STEP_SECURITY_API_KEY and STEP_SECURITY_CUSTOMER
}

# Load suppression rules configuration from JSON file
locals {
  rules_config = jsondecode(file(var.rules_json_file))
  rules = {
    for rule in local.rules_config.suppression_rules :
    rule.name => rule
  }
}

# Create GitHub suppression rules for network call type
resource "stepsecurity_github_supression_rule" "network_rules" {
  for_each = {
    for k, v in local.rules : k => v
    if v.type == "anomalous_outbound_network_call"
  }

  name        = each.value.name
  type        = each.value.type
  action      = each.value.action
  description = each.value.description
  owner       = each.value.owner

  # Optional fields
  repo     = try(each.value.repo, null)
  workflow = try(each.value.workflow, null)
  job      = try(each.value.job, null)
  process  = try(each.value.process, null)

  # Destination block for network rules
  destination = {
    domain = try(each.value.destination.domain, null)
    ip     = try(each.value.destination.ip, null)
  }
}

# Create GitHub suppression rules for source code overwritten type
resource "stepsecurity_github_supression_rule" "file_rules" {
  for_each = {
    for k, v in local.rules : k => v
    if v.type == "source_code_overwritten"
  }

  name        = each.value.name
  type        = each.value.type
  action      = each.value.action
  description = each.value.description
  owner       = each.value.owner

  # Optional fields for file rules
  repo      = try(each.value.repo, null)
  workflow  = try(each.value.workflow, null)
  job       = try(each.value.job, null)
  file      = try(each.value.file, null)
  file_path = try(each.value.file_path, null)
}