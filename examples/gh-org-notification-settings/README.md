# StepSecurity GitHub Organization Notification Settings Examples

This directory contains examples demonstrating how to use the `stepsecurity_github_org_notification_settings` resource to configure notification settings for your GitHub organizations.

## Available Examples

### [main/](./main/)
Basic example showing how to configure notification settings for multiple GitHub organizations with comprehensive notification options.

**Features:**
- Multiple organization configuration
- JSON-driven configuration
- Comprehensive notification settings
- Flexible organization management
- Production-ready setup

**Best for:** Managing notification settings across multiple GitHub organizations, centralized configuration management.

## Future Examples

Additional examples will be added as the provider capabilities expand.

## Getting Started

1. Choose the example that best fits your needs
2. Navigate to the example directory
3. Follow the README instructions in that directory
4. Customize the configuration for your organizations

## Common Prerequisites

All examples require:
- Terraform >= 1.0
- StepSecurity account with API access
- Valid StepSecurity API key and customer
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

## Contributing

When adding new examples:

1. Create a new subdirectory with a descriptive name
2. Include all necessary Terraform files
3. Provide a comprehensive README.md
4. Update this main README.md with the new example
5. Test the example thoroughly

## Support

For issues specific to an example, check the README.md in that example's directory. For general StepSecurity provider issues, refer to the provider documentation.