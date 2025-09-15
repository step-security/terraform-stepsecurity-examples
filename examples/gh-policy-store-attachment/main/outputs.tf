output "policy_attachments" {
  description = "Information about created policy store attachments"
  value = {
    for k, attachment in stepsecurity_github_policy_store_attachment.policy_attachments : k => {
      id          = attachment.id
      owner       = attachment.owner
      policy_name = attachment.policy_name
    }
  }
}

output "attachment_ids" {
  description = "Map of policy attachment keys to their IDs"
  value = {
    for k, attachment in stepsecurity_github_policy_store_attachment.policy_attachments : k => attachment.id
  }
}

output "attachment_summary" {
  description = "Summary of policy attachments by type"
  value = {
    for k, attachment in stepsecurity_github_policy_store_attachment.policy_attachments : k => {
      owner       = attachment.owner
      policy_name = attachment.policy_name
      has_org     = try(length(attachment.org), 0) > 0
      has_cluster = try(length(attachment.clusters), 0) > 0
    }
  }
}