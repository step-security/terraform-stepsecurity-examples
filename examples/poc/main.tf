terraform {
  required_version = ">= 1.0"
  required_providers {
    stepsecurity = {
      source  = "step-security/stepsecurity"
      version = "~> 0.0.24"
    }
  }
}

provider "stepsecurity" {
  # api_key and customer are read from environment variables:
  # STEP_SECURITY_API_KEY and STEP_SECURITY_CUSTOMER
}

variable "poc_org" {
  type        = string
  description = "GitHub organization to apply the PoC configuration to."
}

variable "poc_repos" {
  type        = list(string)
  description = "Repositories within poc_org to scope the PoC to."
}

# -----------------------------------------------------------------------------
# GitHub Checks: NPM + PyPI supply-chain controls, required on PoC repos only
# -----------------------------------------------------------------------------
resource "stepsecurity_github_checks" "poc" {
  owner = var.poc_org

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
        cool_down_period = 2
      }
    },
    {
      control = "PyPI Package Compromised Updates"
      enable  = true
      type    = "required"
    },
    {
      control = "PyPI Package Cooldown"
      enable  = true
      type    = "required"
      settings = {
        cool_down_period = 2
      }
    },
  ]

  required_checks = {
    repos = var.poc_repos
  }
}

# -----------------------------------------------------------------------------
# PR template: used by the policy-driven PRs created below
# -----------------------------------------------------------------------------
resource "stepsecurity_github_pr_template" "poc" {
  owner          = var.poc_org
  title          = "[StepSecurity PoC] Apply security best practices"
  summary        = <<-EOT
    ## Summary

    This pull request was generated as part of the StepSecurity PoC to apply
    recommended security best practices.

    ## Security Fixes

    {{STEPSECURITY_SECURITY_FIXES}}
  EOT
  commit_message = <<-EOT
    [StepSecurity PoC] Apply security best practices

    Signed-off-by: StepSecurity Bot <bot@stepsecurity.io>
  EOT
}

# -----------------------------------------------------------------------------
# Policy-driven PR: harden runner, pin actions, restrict token perms on PoC repos
# -----------------------------------------------------------------------------
resource "stepsecurity_policy_driven_pr" "poc" {
  owner          = var.poc_org
  selected_repos = var.poc_repos

  auto_remediation_options = {
    create_pr                             = true
    create_issue                          = false
    create_github_advanced_security_alert = false
    harden_github_hosted_runner           = true
    pin_actions_to_sha                    = true
    restrict_github_token_permissions     = true
    secure_docker_file                    = false

    # Replace these third-party actions with StepSecurity-maintained equivalents.
    # Only replace when the major tag matches what StepSecurity has published.
    actions_to_replace_with_step_security_actions = [
      "tj-actions/changed-files",
      "enricomi/publish-unit-test-result-action",
    ]
    replace_action_on_major_tag_match = true
  }
}

# -----------------------------------------------------------------------------
# Policy store: block-mode egress policy for the PoC.
# Only the endpoints listed below are reachable from workflow runs.
# -----------------------------------------------------------------------------
resource "stepsecurity_github_policy_store" "poc" {
  owner         = var.poc_org
  policy_name   = "poc-block-policy"
  egress_policy = "block"
  allowed_endpoints = [
    "github.com:443",
    "api.github.com:443",
    "objects.githubusercontent.com:443",
    "registry.npmjs.org:443",
  ]
}

# -----------------------------------------------------------------------------
# Attach the policy at the repo level to each PoC repo
# -----------------------------------------------------------------------------
resource "stepsecurity_github_policy_store_attachment" "poc" {
  owner       = var.poc_org
  policy_name = stepsecurity_github_policy_store.poc.policy_name

  org = {
    repositories = [
      for repo in var.poc_repos : {
        name = repo
      }
    ]
  }
}
