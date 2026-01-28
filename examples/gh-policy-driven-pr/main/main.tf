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



# Organization-wide policy with exclusions
# Apply policy to all repositories except specific ones
resource "stepsecurity_policy_driven_pr" "org_level_with_exclusions" {
  owner          = "organization-name"
  selected_repos = ["*"]
  excluded_repos = ["archived-repo", "test-repo-old"] # These repos opt-out

  auto_remediation_options = {
    create_pr                             = true
    create_issue                          = false
    create_github_advanced_security_alert = false
    harden_github_hosted_runner           = true
    pin_actions_to_sha                    = true
    restrict_github_token_permissions     = false
    secure_docker_file                    = false
  }
}

# Create policy-driven PR configuration for your organization
resource "stepsecurity_policy_driven_pr" "example" {
  owner          = "organization-name"
  selected_repos = ["test-repo-old"]

  auto_remediation_options = {
    create_pr                                     = true
    create_issue                                  = false
    create_github_advanced_security_alert         = false
    harden_github_hosted_runner                   = true
    pin_actions_to_sha                            = true
    restrict_github_token_permissions             = true
    secure_docker_file                            = true
    labels_to_replace = {
      "ubuntu-latest-8-cores" = "ubuntu-latest"
      "windows-latest-large"  = "windows-latest"
    }
    actions_to_exempt_while_pinning               = ["actions/checkout", "actions/setup-node"]
    actions_to_replace_with_step_security_actions = ["EnricoMi/publish-unit-test-result-action"]
    update_precommit_file                         = ["eslint"]
    package_ecosystem = [
      {
        package  = "npm"
        interval = "daily"
      },
      {
        package  = "pip"
        interval = "weekly"
      }
    ]
    add_workflows = "https://github.com/my-org/workflow-templates"
  }
}
