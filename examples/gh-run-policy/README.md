# StepSecurity GitHub Run Policy Examples

This directory contains examples demonstrating how to use the `stepsecurity_github_run_policy` resource to create and manage GitHub run policies that control actions, runners, secrets, and security settings for GitHub workflows.

## Available Examples

### [main/](./main/)
Comprehensive example showing how to configure multiple GitHub run policies using JSON-driven configuration.

**Features:**
- Support for action policies (allowed/disallowed actions)
- Runner label policies (allowed/disallowed runner types)
- Secrets policies (prevent secrets exfiltration)
- Compromised actions policies (block known malicious actions)
- JSON-driven configuration for easy management
- Multi-organization and repository-specific policies
- Dry run mode for testing policies
- Production-ready setup with comprehensive outputs

**Best for:** Managing security policies across multiple GitHub organizations and repositories, implementing graduated security controls, centralizing policy configuration.

## Future Examples

Additional examples will be added as the provider capabilities expand.

## Getting Started

1. Choose the example that best fits your needs
2. Navigate to the example directory
3. Follow the README instructions in that directory
4. Customize the configuration for your specific security requirements

## Common Prerequisites

All examples require:
- Terraform >= 1.0
- StepSecurity account with API access
- Valid StepSecurity API key and customer ID
- GitHub organization(s) with StepSecurity integration
- Understanding of GitHub Actions security

## Environment Variables

Set these environment variables for authentication:

```bash
export STEP_SECURITY_API_KEY="your-api-key-here"
export STEP_SECURITY_CUSTOMER="your-customer-id"
```

## Quick Start

For a quick start, use the `main/` example:

```bash
cd main/
terraform init
terraform plan
terraform apply
```

## Understanding Run Policies

GitHub run policies define security policies that control various aspects of GitHub workflow execution:

- **Action Policies**: Control which GitHub Actions can be used in workflows
- **Runner Policies**: Restrict which runner types/labels can be used
- **Secrets Policies**: Prevent secrets from being exfiltrated or misused
- **Compromised Actions Policies**: Block known compromised or malicious actions

### Policy Scopes

1. **All Organizations**: Apply policy across all organizations in your account
2. **All Repositories**: Apply policy to all repositories in a specific organization
3. **Specific Repositories**: Target specific repositories with tailored policies

### Policy Modes

1. **Enforcement Mode**: Actively block violations
   - Ideal for production environments
   - Enforces strict security policies
   - Prevents policy violations

2. **Dry Run Mode**: Monitor and report violations without blocking
   - Best for development and testing
   - Useful for understanding impact before enforcement
   - Compliance monitoring and reporting

### Policy Types

#### Action Policies
Control which GitHub Actions can be used:

```yaml
name: CI
on: [push]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4  # Allowed action
    - uses: step-security/harden-runner@v2
    - name: Run build
      run: npm ci && npm run build
```

#### Runner Policies
Restrict runner types and labels:

```yaml
jobs:
  build:
    runs-on: ubuntu-latest  # Policy may restrict this
    steps:
    - name: Build
      run: echo "Building on allowed runner"
```

#### Secrets Policies
Prevent secrets exfiltration and enforce secure handling.

#### Compromised Actions Policies
Automatically block actions that have been identified as compromised or malicious.

## Common Use Cases

### Development Environment
- Action policies with commonly used actions
- Relaxed runner restrictions
- Dry run mode for policy testing
- Audit-focused secrets policies

### Staging Environment
- Stricter action policies
- Limited runner types
- Test enforcement mode
- Validate security controls

### Production Environment
- Minimal allowed actions
- Strict runner policies
- Full secrets protection
- Compromised actions blocking

### Organization-wide Governance
- Consistent policies across all repositories
- Security baseline enforcement
- Compliance requirements
- Centralized policy management

## Policy Configuration Examples

### Basic Action Policy
```hcl
resource "stepsecurity_github_run_policy" "basic_actions" {
  owner     = "my-org"
  name      = "Basic Actions Policy"
  all_repos = true

  policy_config = {
    owner                = "my-org"
    name                 = "Basic Actions Policy"
    enable_action_policy = true
    allowed_actions = {
      "actions/checkout"            = "allow"
      "actions/setup-node"          = "allow"
      "step-security/harden-runner" = "allow"
    }
  }
}
```

### Runner Restrictions
```hcl
resource "stepsecurity_github_run_policy" "runner_policy" {
  owner     = "my-org"
  name      = "Secure Runners Only"
  all_repos = true

  policy_config = {
    owner                    = "my-org"
    name                     = "Secure Runners Only"
    enable_runs_on_policy    = true
    disallowed_runner_labels = ["self-hosted", "windows-latest"]
  }
}
```

## Contributing

When adding new examples:

1. Create a new subdirectory with a descriptive name
2. Include all necessary Terraform files
3. Provide a comprehensive README.md
4. Update this main README.md with the new example
5. Test the example thoroughly
6. Follow the established patterns from existing examples

## Support

For issues specific to an example, check the README.md in that example's directory. For general StepSecurity provider issues, refer to the provider documentation.