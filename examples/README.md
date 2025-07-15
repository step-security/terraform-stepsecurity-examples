# StepSecurity Terraform Examples

This directory contains comprehensive examples for using the StepSecurity Terraform provider to manage your security configurations.

## Available Resource Examples

### [gh-policy-driven-pr/](./gh-policy-driven-pr/)
Examples for configuring automated security remediation through policy-driven pull requests.

**Primary Resource:** `stepsecurity_policy_driven_pr`

**Use Cases:**
- Automated security PR/issue creation
- Organization-specific security policies
- GitHub Actions hardening
- Security finding remediation

### [gh-org-notification-settings/](./gh-org-notification-settings/)
Examples for managing GitHub organization notification settings.

**Primary Resource:** `stepsecurity_github_org_notification_settings`

**Use Cases:**
- Centralized notification management
- Multi-organization configuration
- Custom notification rules

### [user-management/](./user-management/)
Examples for managing user access and permissions.

**Primary Resource:** `stepsecurity_user`

**Use Cases:**
- User provisioning and deprovisioning
- Role-based access control
- Permission management
- Team member onboarding

## Example Structure

Each resource directory follows a consistent structure:

```
resource-name/
├── README.md                    # Resource overview and available examples
├── main/                        # Basic/standard example
│   ├── README.md               # Detailed usage instructions
│   ├── main.tf                 # Terraform configuration
│   ├── variables.tf            # Input variables
│   ├── outputs.tf              # Output values
│   ├── terraform.tfvars.example # Example variable values
│   └── *.json                  # Configuration files (if needed)
└── [additional-examples]/       # Additional examples as they become available
```

## Getting Started

1. **Choose a Resource**: Select the resource type that matches your needs
2. **Pick an Example**: Navigate to the resource directory and choose an example
3. **Follow Instructions**: Each example has detailed README with setup steps
4. **Customize**: Modify the configuration for your specific environment

## Common Prerequisites

All examples require:
- Terraform >= 1.0
- StepSecurity account with API access
- Valid StepSecurity API key and customer

## Authentication

Set these environment variables for all examples:

```bash
export STEP_SECURITY_API_KEY="your-api-key-here"
export STEP_SECURITY_CUSTOMER="your-customer-id"
```

## Quick Start

For any example:

```bash
cd resource-name/main/
terraform init
terraform plan
terraform apply
```

## Contributing

When adding new examples:

1. Follow the established directory structure
2. Create comprehensive README files
3. Include terraform.tfvars.example files
4. Test thoroughly before submitting
5. Update relevant README files

## Support

- For example-specific issues: Check the README in the specific example directory
- For provider issues: Refer to the StepSecurity provider documentation
- For general questions: Open an issue in the repository

## Best Practices

1. **Start Simple**: Begin with the `main/` example in each resource directory
2. **Environment Variables**: Always use environment variables for sensitive data
3. **Version Control**: Keep your customized configurations in version control
4. **Testing**: Test configurations in a development environment first
5. **Documentation**: Document your specific use cases and customizations