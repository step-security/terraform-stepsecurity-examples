# StepSecurity Policy-Driven PR Example

This example demonstrates how to manage StepSecurity policy-driven PR configurations using Terraform. Policy-driven PRs automatically create pull requests to remediate security findings in your repositories.

## Features

- **Automatic Security Remediation**: Configure automatic PR creation for security findings
- **Flexible Repository Selection**: Target specific repositories for your organization
- **Comprehensive Security Options**: Configure various security hardening features
- **Action Management**: Control which actions to exempt from pinning and replace with StepSecurity actions
- **Production-Ready Configuration**: Real-world configuration ready for deployment

## Prerequisites

- Terraform >= 1.0
- StepSecurity account with API access
- Valid StepSecurity API key and customer
- GitHub organization with StepSecurity integration

## Usage

1. **Set up environment variables (recommended):**
   ```bash
   export STEP_SECURITY_API_KEY="your-api-key-here"
   export STEP_SECURITY_CUSTOMER="your-customer"
   ```

2. **Update the configuration in main.tf:**
   ```hcl
   # Edit main.tf and update:
   # - "organization-name" with your GitHub organization name
   # - Repository names for your organization
   # - Security settings as needed
   ```

3. **Initialize and apply Terraform:**
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## Configuration Example

This example configures policy-driven PR settings for a single GitHub organization:

### Terraform Configuration (main.tf)
```hcl
resource "stepsecurity_policy_driven_pr" "example" {
  owner          = "organization-name"
  selected_repos = ["repo1", "repo2", "repo3"]

  auto_remediation_options = {
    create_pr                                     = true
    create_issue                                  = false
    create_github_advanced_security_alert        = false
    harden_github_hosted_runner                  = true
    pin_actions_to_sha                           = true
    restrict_github_token_permissions            = true
    actions_to_exempt_while_pinning              = ["actions/checkout", "actions/setup-node"]
    actions_to_replace_with_step_security_actions = []
  }
}
```

## Configuration Fields

### Required Fields
- `owner`: GitHub organization/owner name
- `selected_repos`: Array of repository names or ["*"] for all repositories
- `auto_remediation_options`: Object containing remediation settings

### Auto Remediation Options

#### Notification Settings
- `create_pr`: Create a pull request when findings are detected
- `create_issue`: Create an issue when findings are detected  
- `create_github_advanced_security_alert`: Create GitHub Advanced Security alerts

**Important**: `create_pr` and `create_issue` cannot both be `true`. Also, `create_github_advanced_security_alert` can only be `true` if `create_issue` is `true`.

#### Security Hardening Features
- `harden_github_hosted_runner`: Install security agent on GitHub-hosted runners
- `pin_actions_to_sha`: Pin GitHub Actions to specific SHA commits
- `restrict_github_token_permissions`: Restrict GitHub token permissions

#### Action Management
- `actions_to_exempt_while_pinning`: Array of actions to exclude from SHA pinning
- `actions_to_replace_with_step_security_actions`: Array of actions to replace with StepSecurity alternatives

## Configuration Examples

### Basic Security Policy
```hcl
resource "stepsecurity_policy_driven_pr" "basic" {
  owner          = "my-org"
  selected_repos = ["app1", "app2"]
  
  auto_remediation_options = {
    create_pr                                     = true
    create_issue                                  = false
    create_github_advanced_security_alert        = false
    harden_github_hosted_runner                  = true
    pin_actions_to_sha                           = true
    restrict_github_token_permissions            = true
    actions_to_exempt_while_pinning              = ["actions/checkout"]
    actions_to_replace_with_step_security_actions = []
  }
}
```

### Comprehensive Security Policy
```hcl
resource "stepsecurity_policy_driven_pr" "comprehensive" {
  owner          = "security-focused-org"
  selected_repos = ["*"]
  
  auto_remediation_options = {
    create_pr                                     = false
    create_issue                                  = true
    create_github_advanced_security_alert        = true
    harden_github_hosted_runner                  = true
    pin_actions_to_sha                           = true
    restrict_github_token_permissions            = true
    actions_to_exempt_while_pinning              = ["actions/checkout", "actions/setup-node"]
    actions_to_replace_with_step_security_actions = ["EnricoMi/publish-unit-test-result-action", "dorny/test-reporter"]
  }
}
```

### Development Environment Policy
```hcl
resource "stepsecurity_policy_driven_pr" "development" {
  owner          = "dev-org"
  selected_repos = ["dev-*", "test-*"]
  
  auto_remediation_options = {
    create_pr                                     = false
    create_issue                                  = true
    create_github_advanced_security_alert        = false
    harden_github_hosted_runner                  = false
    pin_actions_to_sha                           = false
    restrict_github_token_permissions            = false
    actions_to_exempt_while_pinning              = []
    actions_to_replace_with_step_security_actions = []
  }
}
```

## Terraform Variables

### Optional Variables
```hcl
# variables.tf
variable "step_security_api_key" {
  description = "StepSecurity API key for authentication"
  type        = string
  sensitive   = true
  default     = null
}

variable "step_security_customer" {
  description = "StepSecurity customer"
  type        = string
  default     = null
}
```

## Outputs

The configuration provides comprehensive outputs:

- `policy_id`: The ID of the created policy
- `policy_details`: Detailed policy configuration including:
  - Policy ID and organization name
  - Selected repositories
  - Security features enabled/disabled status
  - Action management settings
  - Repository coverage information

## Repository Selection

### Specific Repositories
```hcl
selected_repos = ["repo1", "repo2", "repo3"]
```

### All Repositories
```hcl
selected_repos = ["*"]
```

### Pattern Matching
```hcl
selected_repos = ["frontend-*", "backend-*", "mobile-*"]
```

## Security Features Explained

### GitHub Hosted Runner Hardening
- Installs security agent on GitHub-hosted runners
- Prevents credential exfiltration
- Monitors the build process
- Detects anomalous outbound calls

### Action SHA Pinning
- Pins third-party actions to specific SHA commits
- Prevents supply chain attacks
- Follows GitHub security hardening guidelines
- Allows exemptions for trusted actions

### Token Permission Restriction
- Restricts GitHub token permissions to minimum required
- Reduces blast radius of potential security issues
- Follows principle of least privilege
- Improves overall security posture

## Action Management

### Exempting Actions from Pinning
```hcl
actions_to_exempt_while_pinning = [
  "actions/checkout",
  "actions/setup-node",
  "actions/setup-python"
]
```

### Replacing Actions with StepSecurity Alternatives
```hcl
actions_to_replace_with_step_security_actions = [
  "EnricoMi/publish-unit-test-result-action",
  "dorny/test-reporter"
]
```

## Security Best Practices

1. **API Key Management**: Use environment variables for sensitive data:
   ```bash
   export TF_VAR_step_security_api_key="your-api-key"
   export TF_VAR_step_security_customer="your-customer-id"
   ```

2. **Repository Selection**: 
   - Use specific repository lists for critical environments
   - Use wildcard "*" judiciously
   - Consider using patterns for logical grouping

3. **Gradual Rollout**: 
   - Start with non-critical repositories
   - Enable features incrementally
   - Monitor PR creation and feedback

## Importing Existing Policies

To import existing policy-driven PR configurations:

```hcl
import {
  to = stepsecurity_policy_driven_pr.example
  id = "your-organization-name"
}
```

Or use the CLI:
```bash
terraform import stepsecurity_policy_driven_pr.example your-organization-name
```

## Important Validation Rules

When configuring auto-remediation options, be aware of these provider validation rules:

1. **Mutual Exclusivity**: `create_pr` and `create_issue` cannot both be `true`
2. **Dependency Rule**: `create_github_advanced_security_alert` can only be `true` if `create_issue` is `true`
3. **Repository Requirement**: `selected_repos` must contain at least one repository

These rules ensure proper configuration and prevent conflicting remediation approaches.

## Troubleshooting

- **Validation Errors**: Check that your configuration follows the validation rules above
- **Organization Access**: Verify StepSecurity has access to the specified organization
- **Repository Permissions**: Ensure repositories exist and are accessible
- **API Permissions**: Verify API key has sufficient permissions for policy management

## Best Practices

1. **Start Simple**: Begin with basic policies before enabling advanced features
2. **Test in Development**: Use development organizations to test policy configurations
3. **Monitor Impact**: Review created PRs and issues to assess policy effectiveness
4. **Gradual Rollout**: Enable features incrementally
5. **Regular Reviews**: Periodically review and update policy configurations based on findings