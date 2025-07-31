output "harden_runner_policies" {
  description = "Information about created policy stores"
  value = {
    for k, policy in stepsecurity_github_policy_store.harden_runner_policies : k => {
      id            = policy.id
      owner         = policy.owner
      policy_name   = policy.policy_name
      egress_policy = policy.egress_policy
    }
  }
}

output "policy_ids" {
  description = "Map of policy store keys to their IDs"
  value = {
    for k, policy in stepsecurity_github_policy_store.harden_runner_policies : k => policy.id
  }
}

output "policy_references" {
  description = "Policy references that can be used in GitHub workflows"
  value = {
    for k, policy in stepsecurity_github_policy_store.harden_runner_policies : k => {
      owner       = policy.owner
      policy_name = policy.policy_name
      reference   = "${policy.owner}/${policy.policy_name}"
    }
  }
}