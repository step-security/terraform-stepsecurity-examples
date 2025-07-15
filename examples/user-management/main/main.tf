terraform {
  required_version = ">= 1.0"
  required_providers {
    stepsecurity = {
      source  = "step-security/stepsecurity"
      version = "~> 0.0.2"
    }
  }
}

provider "stepsecurity" {
  # api_key and customer will be read from environment variables:
  # STEP_SECURITY_API_KEY and STEP_SECURITY_CUSTOMER
  # Or can be provided via variables
}

# Load users configuration from JSON file
locals {
  users_config = jsondecode(file(var.users_json_file))
  users = { 
    for user in local.users_config.users : 
    (
      try(user.user_name, null) != null ? user.user_name : 
      try(user.email, null) != null ? user.email : 
      user.email_suffix
    ) => user 
  }
}

# Create StepSecurity users from JSON configuration
resource "stepsecurity_user" "users" {
  for_each = local.users

  # Set user identifier based on auth_type
  user_name    = each.value.auth_type == "Github" ? try(each.value.user_name, null) : null
  email        = contains(["SSO", "Local"], each.value.auth_type) ? try(each.value.email, null) : null
  email_suffix = try(each.value.email_suffix, null)
  auth_type    = each.value.auth_type

  # Apply policies from JSON
  policies = [
    for policy in each.value.policies : {
      type         = policy.type
      role         = policy.role
      scope        = policy.scope
      organization = try(policy.organization, null)
      repos        = try(policy.repos, null)
      group        = try(policy.group, null)
      projects     = try(policy.projects, null)
    }
  ]
}