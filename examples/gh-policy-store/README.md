# StepSecurity GitHub Policy Store Examples

This directory contains examples demonstrating how to use the `stepsecurity_github_policy_store` resource to create and manage GitHub policy stores that control egress traffic and security settings for HardenRunner.

## Available Examples

### [main/](./main/)
Comprehensive example showing how to configure multiple GitHub policy stores using JSON-driven configuration.

**Features:**
- Support for both audit and block egress policies
- JSON-driven configuration for easy management
- Multi-organization policy management
- Flexible endpoint allowlists
- Security setting customization (telemetry, sudo, file monitoring)
- Production-ready setup with comprehensive outputs

**Best for:** Managing security policies across multiple GitHub organizations, implementing graduated security controls, centralizing policy configuration.

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
- Understanding of HardenRunner and GitHub Actions security

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

## Understanding Policy Stores

GitHub policy stores define security policies that can be referenced in GitHub workflows to control:

- **Egress Traffic Control**: Block or audit outbound network connections from workflow runners
- **Endpoint Allowlists**: Define which external services workflows can access
- **Security Settings**: Control telemetry collection, sudo access, and file monitoring
- **Compliance**: Implement organization-wide security policies

### Policy Modes

1. **Audit Mode**: Monitor and log egress traffic without blocking
   - Best for development environments
   - Useful for understanding traffic patterns
   - Compliance monitoring and reporting

2. **Block Mode**: Restrict egress traffic to only allowed endpoints
   - Ideal for production environments
   - Enforces strict security policies
   - Prevents unauthorized data exfiltration

### Using Policies in Workflows

Reference your policy stores in GitHub workflows:

```yaml
name: CI
on: [push]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    - uses: step-security/harden-runner@v2
      with:
        egress-policy: my-organization/my-policy-name
    - name: Run build
      run: npm ci && npm run build
```

## Common Use Cases

### Development Policies
- Audit mode for visibility
- Relaxed endpoint restrictions
- Enable debugging features

### Staging Policies  
- Transition from audit to block mode
- Test endpoint restrictions
- Validate security controls

### Production Policies
- Strict block mode enforcement
- Minimal endpoint allowlists
- Enhanced security settings

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