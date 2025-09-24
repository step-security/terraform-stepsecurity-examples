# GitHub Checks Configuration Example

This example demonstrates how to configure GitHub checks using the StepSecurity Terraform provider. GitHub checks help enforce security controls across your organization's repositories, including package security, script injection detection, and more.

## Overview

This example creates GitHub checks configurations for three different organizational scenarios:

- **security-org**: Maximum security with comprehensive controls on all repositories
- **development-org**: Flexible controls for development workflows
- **minimal-org**: Basic security controls for lightweight setups

## Prerequisites

- Terraform >= 1.0
- StepSecurity account with API access
- Valid StepSecurity API key and customer ID
- Appropriate permissions to configure GitHub checks in target organizations

## Configuration

The example uses direct Terraform resource definitions with hardcoded values, making it simple to understand and customize. This approach provides:

- Clear, straightforward configuration
- Easy customization by editing main.tf directly
- No external dependencies on JSON files
- Working examples that can be deployed immediately

### Controls Available

The example demonstrates various GitHub check controls:

| Control | Description | Settings |
|---------|-------------|----------|
| **NPM Package Cooldown** | Prevents use of newly published packages | `cool_down_period`, `packages_to_exempt_in_cooldown_check` |
| **Script Injection** | Detects potential script injection attacks | None |
| **NPM Package Compromised Updates** | Detects compromised NPM package updates | None |
| **PWN Request** | Detects potential PWN requests in workflows | None |

### Check Types

- **Required**: Must pass for PR to be merged
- **Optional**: Provides warnings but doesn't block merges

### Repository Targeting

- **required_checks**: Repositories where checks are mandatory
- **optional_checks**: Repositories where checks are advisory
- **baseline_check**: Applies baseline security across repositories

## Files

- `main.tf` - Primary Terraform configuration with direct resource definitions
- `variables.tf` - Input variable definitions (minimal set for authentication)
- `outputs.tf` - Output definitions
- `terraform.tfvars.example` - Example variable values

## Usage

1. **Copy the example configuration**:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. **Set your authentication**:
   ```bash
   export STEP_SECURITY_API_KEY="your-api-key"
   export STEP_SECURITY_CUSTOMER="your-customer-id"
   ```

3. **Customize the configuration**:
   Edit `main.tf` to match your organizations and requirements:
   ```hcl
   resource "stepsecurity_github_checks" "your_org" {
     owner = "your-organization-name"

     controls = [
       {
         control = "NPM Package Cooldown"
         enable  = true
         type    = "required"
         settings = {
           cool_down_period = 7
           packages_to_exempt_in_cooldown_check = ["@types/*"]
         }
       }
     ]

     required_checks = {
       repos = ["*"]
     }
   }
   ```

4. **Deploy the configuration**:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## Example Configurations

### Security-Focused Organization
```hcl
resource "stepsecurity_github_checks" "security_org" {
  owner = "security-org"

  controls = [
    {
      control = "NPM Package Cooldown"
      enable  = true
      type    = "required"
      settings = {
        cool_down_period = 7
        packages_to_exempt_in_cooldown_check = ["@types/*", "lodash", "express"]
      }
    },
    {
      control = "Script Injection"
      enable  = true
      type    = "required"
    }
  ]

  required_checks = {
    repos      = ["*"]
    omit_repos = ["legacy-repo", "deprecated-repo"]
  }

  baseline_check = {
    repos      = ["*"]
    omit_repos = ["archived-repo"]
  }
}
```

### Development Organization
```hcl
resource "stepsecurity_github_checks" "development_org" {
  owner = "development-org"

  controls = [
    {
      control = "NPM Package Cooldown"
      enable  = true
      type    = "optional"
      settings = {
        cool_down_period = 3
        packages_to_exempt_in_cooldown_check = ["test-package/*", "@dev-tools/*"]
      }
    }
  ]

  required_checks = {
    repos = ["production-app", "main-service"]
  }

  optional_checks = {
    repos = ["dev-app", "feature-service"]
  }
}
```

### Minimal Setup
```hcl
resource "stepsecurity_github_checks" "minimal_org" {
  owner = "minimal-org"

  controls = [
    {
      control = "Script Injection"
      enable  = true
      type    = "required"
    }
  ]

  baseline_check = {
    repos = ["*"]
  }
}
```

## Importing Existing Configurations

If you have existing GitHub checks configurations, you can import them:

1. **Uncomment the import block** in `main.tf`
2. **Update the organization name**:
   ```hcl
   import {
     to = stepsecurity_github_checks.security_org
     id = "your-organization-name"
   }
   ```
3. **Run the import**:
   ```bash
   terraform plan
   terraform apply
   ```

## Outputs

The configuration provides:

- `organizations_configured` - GitHub organizations with checks configured

## Customization

To customize for your environment:

1. **Change organization names**: Update the `owner` field in each resource
2. **Modify controls**: Add, remove, or modify controls in the `controls` block
3. **Adjust repository lists**: Update `repos` and `omit_repos` with specific names or `["*"]`
4. **Change check types**: Switch between "required" and "optional" types
5. **Add/remove resources**: Comment out or add new `stepsecurity_github_checks` resources

## Best Practices

1. **Start with Optional Checks**: Begin with optional checks to understand impact
2. **Use Repository Lists**: Use `["*"]` for all repos or specific repository names
3. **Test in Development**: Test changes in development organizations first
4. **Monitor Impact**: Monitor build times and developer feedback
5. **Regular Reviews**: Periodically review and update check configurations

## Troubleshooting

### Invalid Control Names
Ensure control names match exactly as supported by StepSecurity:
- "NPM Package Cooldown"
- "Script Injection"
- "NPM Package Compromised Updates"
- "PWN Request"

### Repository Configuration Issues
- Use `["*"]` for all repositories
- Use `["repo-name"]` for specific repositories
- Pattern matching (like `["prefix-*"]`) is not supported - use exact repository names

### Settings Validation
Check that control settings match expected format:
```hcl
settings = {
  cool_down_period = 7  # number
  packages_to_exempt_in_cooldown_check = ["package/*"]  # list of strings
}
```

## Support

- For provider issues: [StepSecurity Provider Documentation](https://registry.terraform.io/providers/step-security/stepsecurity/latest/docs)
- For GitHub checks: StepSecurity platform documentation
- For issues: Create an issue in the repository