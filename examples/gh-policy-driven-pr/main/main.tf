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
}

# Create policy-driven PR configuration for your organization
resource "stepsecurity_policy_driven_pr" "example" {
  owner          = "organization-name"
  selected_repos = ["repo1", "repo2", "repo3"]

  auto_remediation_options = {
    create_pr                                     = true
    create_issue                                  = false
    create_github_advanced_security_alert        = false
    harden_github_hosted_runner                  = true
    pin_actions_to_sha                           = true
    restrict_github_token_permissions            = true
    actions_to_exempt_while_pinning              = ["actions/checkout", "actions/setup-node"]
    actions_to_replace_with_step_security_actions = []
  }
}
