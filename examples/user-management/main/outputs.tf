output "users_ids" {
  description = "Map of all created users and their IDs"
  value       = { for k, v in stepsecurity_user.users : k => v.id }
}

output "users_summary" {
  description = "Summary of all created users with their configuration"
  value = {
    for k, v in stepsecurity_user.users : k => {
      id           = v.id
      user_name    = v.user_name
      email        = v.email
      email_suffix = v.email_suffix
      auth_type    = v.auth_type
      policies     = local.users[k].policies
    }
  }
}

output "users_by_auth_type" {
  description = "Users grouped by authentication type"
  value = {
    github = {
      for k, v in stepsecurity_user.users : k => {
        id        = v.id
        user_name = v.user_name
        policies  = local.users[k].policies
      }
      if v.auth_type == "Github"
    }
    sso = {
      for k, v in stepsecurity_user.users : k => {
        id           = v.id
        email        = v.email
        email_suffix = v.email_suffix
        policies     = local.users[k].policies
      }
      if v.auth_type == "SSO"
    }
    local = {
      for k, v in stepsecurity_user.users : k => {
        id       = v.id
        email    = v.email
        policies = local.users[k].policies
      }
      if v.auth_type == "Local"
    }
  }
}

output "users_by_platform" {
  description = "Users grouped by platform type in their policies"
  value = {
    github = {
      for k, v in stepsecurity_user.users : k => {
        id        = v.id
        auth_type = v.auth_type
        policies = [
          for policy in local.users[k].policies : policy
          if policy.type == "github"
        ]
      }
      if length([
        for policy in local.users[k].policies : policy
        if policy.type == "github"
      ]) > 0
    }
  }
}

output "total_users_count" {
  description = "Total number of users created"
  value       = length(stepsecurity_user.users)
}