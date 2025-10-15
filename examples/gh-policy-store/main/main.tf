terraform {
  required_version = ">= 1.0"
  required_providers {
    stepsecurity = {
      source  = "step-security/stepsecurity"
      version = "~> 0.0.9"
    }
  }
}

provider "stepsecurity" {
  # api_key and customer will be read from environment variables:
  # STEP_SECURITY_API_KEY and STEP_SECURITY_CUSTOMER
}

# Load policy stores configuration from JSON file
locals {
  policies_config = jsondecode(file(var.policies_json_file))
  policies = {
    for policy in local.policies_config.harden_runner_policies :
    "${policy.owner}-${policy.policy_name}" => policy
  }
}

# Create GitHub policy stores from JSON configuration
resource "stepsecurity_github_policy_store" "harden_runner_policies" {
  for_each = local.policies

  owner       = each.value.owner
  policy_name = each.value.policy_name

  # Required egress policy setting
  egress_policy = each.value.egress_policy

  # Optional endpoint allowlist for block mode
  allowed_endpoints = try(each.value.allowed_endpoints, [])

  # Optional security settings
  disable_telemetry       = try(each.value.disable_telemetry, false)
  disable_sudo            = try(each.value.disable_sudo, false)
  disable_file_monitoring = try(each.value.disable_file_monitoring, false)
}
