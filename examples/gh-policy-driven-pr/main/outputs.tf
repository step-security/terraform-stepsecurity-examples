output "policy_id" {
  description = "The ID of the created policy"
  value       = stepsecurity_policy_driven_pr.example.id
}

output "policy_details" {
  description = "Detailed policy configuration"
  value = {
    policy_id      = stepsecurity_policy_driven_pr.example.id
    organization   = stepsecurity_policy_driven_pr.example.owner
    selected_repos = stepsecurity_policy_driven_pr.example.selected_repos
    security_features_enabled = {
      harden_github_hosted_runner        = stepsecurity_policy_driven_pr.example.auto_remediation_options.harden_github_hosted_runner
      pin_actions_to_sha                = stepsecurity_policy_driven_pr.example.auto_remediation_options.pin_actions_to_sha
      restrict_github_token_permissions = stepsecurity_policy_driven_pr.example.auto_remediation_options.restrict_github_token_permissions
      create_pr                         = stepsecurity_policy_driven_pr.example.auto_remediation_options.create_pr
      create_issue                      = stepsecurity_policy_driven_pr.example.auto_remediation_options.create_issue
      create_github_advanced_security_alert = stepsecurity_policy_driven_pr.example.auto_remediation_options.create_github_advanced_security_alert
    }
    action_management = {
      exempted_actions = stepsecurity_policy_driven_pr.example.auto_remediation_options.actions_to_exempt_while_pinning
      replaced_actions = stepsecurity_policy_driven_pr.example.auto_remediation_options.actions_to_replace_with_step_security_actions
    }
    repository_coverage = {
      covers_all_repos     = contains(stepsecurity_policy_driven_pr.example.selected_repos, "*")
      total_specific_repos = length(stepsecurity_policy_driven_pr.example.selected_repos)
      selected_repos       = stepsecurity_policy_driven_pr.example.selected_repos
    }
  }
}