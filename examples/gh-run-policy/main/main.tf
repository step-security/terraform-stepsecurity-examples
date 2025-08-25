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

# Load run policies configuration from JSON file
locals {
  policies_config = jsondecode(file(var.policies_json_file))
  policies = {
    for policy in local.policies_config.github_run_policies :
    "${policy.owner}-${policy.name}" => policy
  }
}

# Create GitHub run policies from JSON configuration
resource "stepsecurity_github_run_policy" "github_run_policies" {
  for_each = local.policies

  owner = each.value.owner
  name  = each.value.name

  # Policy scope - mutually exclusive options
  all_orgs     = try(each.value.all_orgs, false)
  all_repos    = try(each.value.all_repos, false)
  repositories = try(each.value.repositories, null)

  # Policy configuration
  policy_config = {
    owner = each.value.owner
    name  = each.value.name

    # Action policy settings
    enable_action_policy = try(each.value.policy_config.enable_action_policy, false)
    allowed_actions      = try(each.value.policy_config.allowed_actions, {})

    # Runner policy settings
    enable_runs_on_policy    = try(each.value.policy_config.enable_runs_on_policy, false)
    disallowed_runner_labels = try(each.value.policy_config.disallowed_runner_labels, [])

    # Secrets policy settings
    enable_secrets_policy = try(each.value.policy_config.enable_secrets_policy, false)

    # Compromised actions policy settings
    enable_compromised_actions_policy = try(each.value.policy_config.enable_compromised_actions_policy, false)

    # Dry run mode - for testing policies without enforcement
    is_dry_run = try(each.value.policy_config.is_dry_run, false)
  }
}