# StepSecurity GitHub Suppression Rules Examples

This directory contains examples demonstrating how to use the `stepsecurity_github_supression_rule` resource to create suppression rules for GitHub security findings detected by StepSecurity.

## Available Examples

### [main/](./main/)
Comprehensive example showing how to configure multiple GitHub suppression rules using JSON-driven configuration.

**Features:**
- Multiple rule types support (network calls and file overwrites)
- JSON-driven configuration for easy management
- Flexible targeting with wildcards
- Production-ready setup with outputs
- Comprehensive documentation and examples

**Best for:** Managing suppression rules across multiple repositories and organizations, centralized rule configuration.

## Future Examples

Additional examples will be added as the provider capabilities expand.

## Getting Started

1. Choose the example that best fits your needs
2. Navigate to the example directory
3. Follow the README instructions in that directory
4. Customize the configuration for your specific requirements

## Common Prerequisites

All examples require:
- Terraform >= 1.0
- StepSecurity account with API access
- Valid StepSecurity API key and customer ID
- GitHub organization(s) with StepSecurity integration

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

## Understanding Suppression Rules

GitHub suppression rules allow you to ignore specific types of security findings that StepSecurity detects in your repositories. This is useful for:

- **False positives**: Legitimate activities that trigger security alerts
- **Expected behavior**: Known safe operations that should not be flagged
- **Third-party integrations**: Approved external connections and processes

### Rule Types

1. **anomalous_outbound_network_call**: Suppress network connection alerts
   - Target specific domains or IP addresses
   - Filter by process name patterns
   - Apply to specific repositories or organization-wide

2. **source_code_overwritten**: Suppress file modification alerts
   - Target specific files or file paths
   - Apply to specific workflows and jobs
   - Filter by repository and organization

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