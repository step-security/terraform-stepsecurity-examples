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

  # Build policy configuration dynamically based on enabled features
  policy_config = merge(
    # Base configuration
    {
      owner = each.value.owner
      name  = each.value.name
    },

    # Conditionally add action policy fields
    try(each.value.policy_config.enable_action_policy, false) ? {
      enable_action_policy = true
    } : {},

    try(each.value.policy_config.enable_action_policy, false) && can(each.value.policy_config.allowed_actions) ? {
      allowed_actions = each.value.policy_config.allowed_actions
    } : {},

    # Conditionally add runner policy fields
    try(each.value.policy_config.enable_runs_on_policy, false) ? {
      enable_runs_on_policy = true
    } : {},

    try(each.value.policy_config.enable_runs_on_policy, false) && can(each.value.policy_config.disallowed_runner_labels) ? {
      disallowed_runner_labels = each.value.policy_config.disallowed_runner_labels
    } : {},

    # Conditionally add secrets policy fields
    try(each.value.policy_config.enable_secrets_policy, false) ? {
      enable_secrets_policy = true
    } : {},

    # Conditionally add compromised actions policy fields
    try(each.value.policy_config.enable_compromised_actions_policy, false) ? {
      enable_compromised_actions_policy = true
    } : {},

    # Conditionally add exempted users for secrets policy
    try(each.value.policy_config.enable_secrets_policy, false) && can(each.value.policy_config.exempted_users) ? {
      exempted_users = each.value.policy_config.exempted_users
    } : {},

    # Conditionally add dry run mode
    try(each.value.policy_config.is_dry_run, false) ? {
      is_dry_run = true
    } : {}
  )
}
