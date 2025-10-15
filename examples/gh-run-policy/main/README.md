# GitHub Run Policy - JSON Configuration Example

This example demonstrates how to create and manage multiple GitHub run policies using a JSON-driven configuration approach. This method allows for easy management of complex policy configurations across multiple organizations and repositories.

## Features

- **Action Policies**: Control which GitHub Actions can be used in workflows
- **Runner Policies**: Restrict runner types and labels
- **Secrets Policies**: Prevent secrets exfiltration with configurable user exemptions
- **Compromised Actions Policies**: Block known malicious actions
- **Multi-scope Support**: Apply policies to all orgs, all repos, or specific repositories
- **Dry Run Mode**: Test policies without enforcement
- **User Exemptions**: Exempt specific users/bots from secrets policy checks
- **JSON-driven Configuration**: Easy to maintain and version control

## Quick Start

1. **Set Environment Variables**:
   ```bash
   export STEP_SECURITY_API_KEY="your-api-key"
   export STEP_SECURITY_CUSTOMER="your-customer-id"
   ```

2. **Copy and Customize Configuration**:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars if needed (default configuration should work)
   ```

3. **Customize Policy Configuration**:
   Edit `github_run_policies.json` to match your organizations and requirements:
   ```bash
   # Review the example policies
   cat github_run_policies.json
   
   # Customize for your environment
   vim github_run_policies.json
   ```

4. **Deploy**:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## Configuration Structure

### JSON Configuration Format

The `github_run_policies.json` file contains an array of policy configurations:

```json
{
  "github_run_policies": [
    {
      "owner": "my-org",
      "name": "Policy Name",
      "all_repos": true,
      "policy_config": {
        "enable_action_policy": true,
        "allowed_actions": {
          "actions/checkout": "allow",
          "step-security/harden-runner": "allow"
        }
      }
    }
  ]
}
```

### Policy Scope Options

Choose one of these scope options for each policy:

- `all_orgs: true` - Apply to all organizations
- `all_repos: true` - Apply to all repositories in the organization
- `repositories: ["repo1", "repo2"]` - Apply to specific repositories

### Policy Configuration Options

#### Action Policies
```json
{
  "enable_action_policy": true,
  "allowed_actions": {
    "actions/checkout": "allow",
    "actions/setup-node": "allow",
    "step-security/harden-runner": "allow"
  }
}
```

#### Runner Policies
```json
{
  "enable_runs_on_policy": true,
  "disallowed_runner_labels": [
    "self-hosted",
    "windows-latest",
    "macos-latest"
  ]
}
```

#### Secrets Policies
```json
{
  "enable_secrets_policy": true,
  "exempted_users": [
    "dependabot[bot]",
    "renovate[bot]",
    "github-actions[bot]"
  ]
}
```

The `exempted_users` field allows you to specify users or bots that should be exempt from secrets exfiltration detection. This is useful for automated tools that may trigger false positives.

#### Compromised Actions Policies
```json
{
  "enable_compromised_actions_policy": true
}
```

#### Dry Run Mode
```json
{
  "is_dry_run": true
}
```

## Example Policies Included

The default configuration includes several example policies:

1. **Allowed Actions Policy**: Strict actions for specific critical repositories
2. **Secure Runners Policy**: Blocks potentially insecure runner types
3. **Secrets Protection Policy**: Organization-wide secrets protection with bot exemptions
4. **Compromised Actions Protection**: Blocks known malicious actions

### User Exemptions in Secrets Policy

The **Secrets Protection Policy** includes exemptions for common automation bots:
- `dependabot[bot]` - For automated dependency updates
- `renovate[bot]` - For Renovate dependency management
- `github-actions[bot]` - For GitHub Actions automation

These exemptions prevent false positives while maintaining security for human users and unknown automation.

## Common Use Cases

### Development Environment
```json
{
  "owner": "my-org",
  "name": "Development Policy",
  "all_repos": true,
  "policy_config": {
    "enable_action_policy": true,
    "allowed_actions": {
      "actions/checkout": "allow",
      "actions/setup-node": "allow",
      "actions/cache": "allow"
    },
    "is_dry_run": true
  }
}
```

### Production Environment
```json
{
  "owner": "my-org",
  "name": "Production Policy",
  "repositories": ["critical-app"],
  "policy_config": {
    "enable_action_policy": true,
    "enable_secrets_policy": true,
    "allowed_actions": {
      "actions/checkout": "allow",
      "step-security/harden-runner": "allow"
    },
    "exempted_users": [
      "dependabot[bot]",
      "github-actions[bot]"
    ],
    "is_dry_run": false
  }
}
```

### Security Baseline
```json
{
  "owner": "my-org",
  "name": "Security Baseline",
  "all_orgs": true,
  "policy_config": {
    "enable_compromised_actions_policy": true,
    "enable_secrets_policy": true,
    "exempted_users": [
      "dependabot[bot]",
      "renovate[bot]",
      "github-actions[bot]"
    ],
    "is_dry_run": false
  }
}
```

## Outputs

This configuration provides comprehensive outputs:

- **`created_policies`**: Details of all created policies
- **`policy_summary`**: Summary statistics by type and scope
- **`policy_owners`**: List of unique policy owners

## Validation and Testing

1. **Validate JSON Configuration**:
   ```bash
   # Check JSON syntax
   cat github_run_policies.json | jq .
   ```

2. **Plan Before Apply**:
   ```bash
   terraform plan
   ```

3. **Use Dry Run Mode**: Start with `is_dry_run: true` to test policy impact

4. **Monitor Policy Effects**: Check GitHub workflow logs and StepSecurity dashboard

## Maintenance

### Adding New Policies
1. Add new policy object to the `github_run_policies` array in JSON file
2. Run `terraform plan` to preview changes
3. Apply changes with `terraform apply`

### Updating Existing Policies
1. Modify the relevant policy configuration in JSON file
2. Terraform will detect and apply the changes

### Removing Policies
1. Remove policy object from JSON file
2. Run `terraform apply` to destroy the policy

## Security Best Practices

1. **Start with Dry Run**: Always test new policies with `is_dry_run: true`
2. **Gradual Rollout**: Apply to test repositories before production
3. **Monitor Impact**: Watch for workflow failures after policy deployment
4. **Keep Allowlists Minimal**: Only allow actions that are actually needed
5. **Regular Review**: Periodically review and update policies
6. **Version Control**: Store JSON configuration in version control

## Troubleshooting

### Common Issues

1. **Invalid JSON**: Use `jq` to validate JSON syntax
2. **Policy Conflicts**: Ensure policy names are unique per owner
3. **Scope Conflicts**: Don't specify multiple scope options for one policy
4. **Authentication**: Verify environment variables are set correctly

### Validation Commands
```bash
# Validate JSON syntax
jq . github_run_policies.json

# Check Terraform configuration
terraform validate

# Preview changes
terraform plan -detailed-exitcode
```

## Files

- `main.tf` - Main Terraform configuration
- `variables.tf` - Variable definitions
- `outputs.tf` - Output definitions
- `github_run_policies.json` - Policy configurations
- `terraform.tfvars.example` - Example variable values
- `README.md` - This documentation