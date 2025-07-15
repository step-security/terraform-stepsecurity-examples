# StepSecurity User Management Example

This example demonstrates how to manage StepSecurity users using Terraform with a JSON-based configuration approach. All user definitions and policies are declared in a JSON file for easy management and version control.

## Features

- **JSON-based Configuration**: Define all users and policies in a structured JSON file
- **Multiple Authentication Types**: Support for GitHub, SSO, and Local authentication
- **Flexible Policy Management**: Multiple policies per user with different platforms (GitHub, GitLab)
- **Domain-based Access**: Grant access based on email domain suffixes
- **Repository/Project-specific Access**: Granular permissions for specific repositories or projects
- **Multi-platform Support**: Support for both GitHub and GitLab platforms
- **Comprehensive Outputs**: Detailed information about created users and their configurations

## Prerequisites

- Terraform >= 1.0
- StepSecurity account with API access
- Valid StepSecurity API key and customer

## Usage

1. **Set up environment variables (recommended):**
   ```bash
   export STEP_SECURITY_API_KEY="your-api-key-here"
   export STEP_SECURITY_CUSTOMER="your-customer-id"
   ```

2. **Configure your users in the JSON file:**
   ```bash
   cp users.json users.json.bak
   # Edit users.json with your configuration
   ```

3. **Initialize and apply Terraform:**
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## JSON Configuration Structure

The `users.json` file defines all users and their policies:

```json
{
  "users": [
    {
      "user_name": "github-user",
      "auth_type": "Github",
      "policies": [
        {
          "type": "github",
          "role": "auditor",
          "scope": "organization",
          "organization": "your-org-name"
        }
      ]
    },
    {
      "email": "admin@yourcompany.com",
      "auth_type": "SSO",
      "policies": [
        {
          "type": "github",
          "role": "admin",
          "scope": "customer"
        }
      ]
    }
  ]
}
```

### User Configuration Fields

#### Required Fields
- `auth_type`: Authentication type ("Github", "SSO", "Local")
- `policies`: Array of policy objects

#### User Identity Fields (choose one based on auth_type)
- `user_name`: GitHub username (required for auth_type = "Github")
- `email`: Email address (required for auth_type = "SSO" or "Local")
- `email_suffix`: Email domain suffix (for domain-based access with auth_type = "SSO")

#### Policy Fields
- `type`: Platform type ("github")
- `role`: User role ("admin", "auditor")
- `scope`: Permission scope ("customer", "organization", "repository", "group", "project")

#### Optional Policy Fields (scope-dependent)
- `organization`: GitHub organization name (for GitHub organization/repository scope)

## Configuration Examples

### GitHub Users

```json
{
  "user_name": "github-auditor",
  "auth_type": "Github",
  "policies": [
    {
      "type": "github",
      "role": "auditor",
      "scope": "organization",
      "organization": "your-org-name"
    }
  ]
}
```

### SSO Users

```json
{
  "email": "admin@yourcompany.com",
  "auth_type": "SSO",
  "policies": [
    {
      "type": "github",
      "role": "admin",
      "scope": "customer"
    }
  ]
}
```

### Domain-based Access

```json
{
  "email_suffix": "yourcompany.com",
  "auth_type": "SSO",
  "policies": [
    {
      "type": "github",
      "role": "auditor",
      "scope": "organization",
      "organization": "your-org-name"
    }
  ]
}
```

## Terraform Variables

### Authentication Variables (Optional)

The provider will automatically use environment variables `STEP_SECURITY_API_KEY` and `STEP_SECURITY_CUSTOMER`. 

If you prefer to use Terraform variables instead:

```hcl
# terraform.tfvars
step_security_api_key  = "your-api-key-here"
step_security_customer = "your-customer-id-here"
```

### Configuration Variables

```hcl
# Use a different JSON file
users_json_file = "custom-users.json"
```

## Outputs

The configuration provides comprehensive outputs:

- `users_ids`: Map of all created users and their IDs
- `users_summary`: Complete summary of all users with their configuration
- `users_by_auth_type`: Users grouped by authentication type (GitHub, SSO, Local)
- `users_by_platform`: Users grouped by platform type (GitHub, GitLab)
- `total_users_count`: Total number of users created

## Security Best Practices

1. **API Key Management**: Use environment variables for sensitive data (recommended):
   ```bash
   export STEP_SECURITY_API_KEY="your-api-key"
   export STEP_SECURITY_CUSTOMER="your-customer"
   ```

2. **JSON File Management**: 
   - Store users.json in version control
   - Use proper git commit messages when updating users
   - Review changes carefully before applying

3. **Access Control**: Follow principle of least privilege in policy definitions

4. **Regular Auditing**: Review user access regularly and update JSON configuration

## Importing Existing Users

To import existing users into Terraform state:

```hcl
import {
  to = stepsecurity_user.users["existing-user-key"]
  id = "existing-user-id"
}
```

Or use the CLI:
```bash
terraform import 'stepsecurity_user.users["existing-user-key"]' existing-user-id
```

## Troubleshooting

- **JSON Validation**: Ensure your JSON is valid using `terraform validate`
- **User Keys**: Each user must have a unique identifier (user_name, email, or email_suffix)
- **Policy Validation**: Verify all required fields are present for each policy type
- **Platform Support**: Ensure the StepSecurity provider supports the platform types you're using

## Advanced Usage

### Environment-specific Configurations

Create different JSON files for different environments:

```bash
# Development
terraform apply -var="users_json_file=users-dev.json"

# Production
terraform apply -var="users_json_file=users-prod.json"
```

### Automation

The JSON-based approach makes it easy to integrate with CI/CD pipelines and user management systems.