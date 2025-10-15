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

# Example 1: Security-focused organization with all comprehensive checks
resource "stepsecurity_github_checks" "security_org" {
  owner = "security-org"

  controls = [
    {
      control = "NPM Package Compromised Updates"
      enable  = true
      type    = "required"
    },
    {
      control = "NPM Package Cooldown"
      enable  = true
      type    = "required"
      settings = {
        cool_down_period                     = 7
        packages_to_exempt_in_cooldown_check = []
      }
    },
    {
      control = "PWN Request"
      enable  = true
      type    = "required"
    },
    {
      control = "Script Injection"
      enable  = true
      type    = "required"
    },
  ]

  required_checks = {
    repos      = ["*"]
    omit_repos = ["test-repo-2"]
  }

  baseline_check = {
    repos = ["*"]
  }
}

# Example 2: Development organization with flexible controls
resource "stepsecurity_github_checks" "development_org" {
  owner = "development-org"

  controls = [
    {
      control = "NPM Package Cooldown"
      enable  = true
      type    = "required"
      settings = {
        cool_down_period                     = 3
        packages_to_exempt_in_cooldown_check = ["test-package/*", "@dev-tools/*"]
      }
    },
    {
      control = "Script Injection"
      enable  = true
      type    = "optional"
    },
    {
      control = "PWN Request"
      enable  = true
      type    = "optional"
    }
  ]

  required_checks = {
    repos = ["production-app-repo", "main-service-repo"]
  }

  optional_checks = {
    repos = ["dev-app-repo", "feature-service-repo", "test-repo"]
  }

  baseline_check = {
    repos      = ["*"]
    omit_repos = ["prototype-repo", "temp-repo"]
  }
}

# Example 3: Minimal organization setup
resource "stepsecurity_github_checks" "minimal_org" {
  owner = "minimal-org"

  controls = [
    {
      control = "Script Injection"
      enable  = true
      type    = "required"
    }
  ]

  required_checks = {
    repos = ["*"]
  }

  baseline_check = {
    repos = ["*"]
  }
}

# Optional: Import existing GitHub checks configurations
# Uncomment and modify the import blocks below if you want to import existing configurations

# import {
#   to = stepsecurity_github_checks.security_org
#   id = "security-org"
# }

# import {
#   to = stepsecurity_github_checks.development_org
#   id = "development-org"
# }
