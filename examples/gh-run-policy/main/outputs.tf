output "created_policies" {
  description = "Details of all created GitHub run policies"
  value = {
    for key, policy in stepsecurity_github_run_policy.github_run_policies : key => {
      id           = policy.id
      owner        = policy.owner
      name         = policy.name
      all_orgs     = policy.all_orgs
      all_repos    = policy.all_repos
      repositories = policy.repositories
      policy_config = {
        enable_action_policy              = policy.policy_config.enable_action_policy
        enable_runs_on_policy             = policy.policy_config.enable_runs_on_policy
        enable_secrets_policy             = policy.policy_config.enable_secrets_policy
        enable_compromised_actions_policy = policy.policy_config.enable_compromised_actions_policy
        is_dry_run                        = policy.policy_config.is_dry_run
      }
    }
  }
}

output "policy_summary" {
  description = "Summary of created policies by type and scope"
  value = {
    total_policies = length(stepsecurity_github_run_policy.github_run_policies)
    
    by_scope = {
      all_orgs_policies = length([
        for policy in stepsecurity_github_run_policy.github_run_policies : policy
        if policy.all_orgs == true
      ])
      all_repos_policies = length([
        for policy in stepsecurity_github_run_policy.github_run_policies : policy
        if policy.all_repos == true
      ])
      repository_specific_policies = length([
        for policy in stepsecurity_github_run_policy.github_run_policies : policy
        if policy.repositories != null
      ])
    }
    
    by_type = {
      action_policies = length([
        for policy in stepsecurity_github_run_policy.github_run_policies : policy
        if policy.policy_config.enable_action_policy == true
      ])
      runner_policies = length([
        for policy in stepsecurity_github_run_policy.github_run_policies : policy
        if policy.policy_config.enable_runs_on_policy == true
      ])
      secrets_policies = length([
        for policy in stepsecurity_github_run_policy.github_run_policies : policy
        if policy.policy_config.enable_secrets_policy == true
      ])
      compromised_actions_policies = length([
        for policy in stepsecurity_github_run_policy.github_run_policies : policy
        if policy.policy_config.enable_compromised_actions_policy == true
      ])
    }
    
    dry_run_policies = length([
      for policy in stepsecurity_github_run_policy.github_run_policies : policy
      if policy.policy_config.is_dry_run == true
    ])
  }
}

output "policy_owners" {
  description = "List of unique policy owners"
  value       = distinct([for policy in stepsecurity_github_run_policy.github_run_policies : policy.owner])
}