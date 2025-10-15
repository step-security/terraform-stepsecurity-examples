output "pr_template_id" {
  description = "The ID of the created PR template"
  value       = stepsecurity_github_pr_template.example.id
}

output "pr_template_details" {
  description = "Detailed PR template configuration"
  value = {
    id             = stepsecurity_github_pr_template.example.id
    owner          = stepsecurity_github_pr_template.example.owner
    title          = stepsecurity_github_pr_template.example.title
    labels         = stepsecurity_github_pr_template.example.labels
  }
}
