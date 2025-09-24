output "organizations_configured" {
  description = "GitHub organizations with checks configured"
  value = [
    stepsecurity_github_checks.security_org.owner,
    stepsecurity_github_checks.development_org.owner,
    stepsecurity_github_checks.minimal_org.owner
  ]
}