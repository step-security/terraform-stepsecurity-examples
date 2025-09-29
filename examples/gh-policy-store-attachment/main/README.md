# StepSecurity GitHub Policy Store Attachment - Main Example

This example demonstrates how to create GitHub policy store attachments using the `stepsecurity_github_policy_store_attachment` resource. Policy store attachments provide granular control over where existing policies are applied, allowing you to attach policies to specific workflows, repositories, organizations, or clusters.

## What This Example Does

This configuration creates policy store attachments that bind existing policies to specific resources. Policy store attachments allow you to:

- **Attach policies to specific workflows**: Apply policies only to designated workflow files
- **Attach policies to repositories**: Apply policies to entire repositories
- **Attach policies to organizations**: Apply policies organization-wide
- **Attach policies to clusters**: Apply policies to Kubernetes clusters
- **Create mixed attachments**: Combine different attachment types for complex scenarios

## Features

- **JSON-driven configuration**: Define attachments in a structured JSON format
- **Multiple attachment types**: Support for workflow, repository, organization, and cluster attachments
- **Flexible targeting**: Precise control over which resources policies apply to
- **Reusable policies**: Same policy can be attached to different scopes via separate attachments
- **Mixed attachments**: Combine organization and cluster attachments in a single resource
- **Separation of concerns**: Policy definition separate from policy application

## Prerequisites

- Terraform >= 1.0
- StepSecurity account with API access
- Valid StepSecurity API key and customer ID
- GitHub organization(s) with StepSecurity integration
- **Existing policy stores**: This example requires pre-existing policies to attach
- Understanding of HardenRunner and GitHub Actions security

## File Structure

```
main/
├── main.tf                    # Main Terraform configuration
├── variables.tf               # Variable definitions
├── outputs.tf                 # Output definitions
├── terraform.tfvars.example   # Example variable values
└── policy_attachments.json    # JSON configuration for policy store attachments
```

## Configuration

### Environment Variables

Set these environment variables for authentication:

```bash
export STEP_SECURITY_API_KEY="your-api-key-here"
export STEP_SECURITY_CUSTOMER="your-customer-id"
```

### JSON Configuration

The `policy_attachments.json` file defines how existing policies are attached to resources. Each attachment must reference:

**Required fields:**

- `owner`: GitHub organization name
- `policy_name`: Name of existing policy to attach

**Optional fields:**

- `org`: Organization and repository attachment configuration
- `clusters`: Array of cluster names for cluster attachments

### Attachment Logic

The attachment logic has been simplified:

- **Repository + workflows specified**: Policy applies only to those specific workflow files
- **Repository + no workflows**: Policy applies to the entire repository
- **`apply_to_org: true`**: Policy applies to the entire organization
- **Clusters specified**: Policy applies to the specified Kubernetes clusters

### Example JSON Configuration

```json
{
  "policy_attachments": [
    {
      "owner": "my-organization",
      "policy_name": "workflow-policy",
      "org": {
        "apply_to_org": false,
        "repositories": [
          {
            "name": "frontend-app",
            "workflows": ["ci.yml", "deploy.yml"]
          },
          {
            "name": "backend-api",
            "workflows": ["test.yml"]
          }
        ]
      }
    },
    {
      "owner": "my-organization",
      "policy_name": "repo-policy",
      "org": {
        "apply_to_org": false,
        "repositories": [
          {
            "name": "frontend-app"
          },
          {
            "name": "backend-api"
          }
        ]
      }
    },
    {
      "owner": "dev-organization",
      "policy_name": "cluster-policy",
      "clusters": ["production-k8s-cluster", "staging-k8s-cluster"]
    }
  ]
}
```

## Usage

1. **Ensure policies exist**: Make sure the referenced policies already exist in your StepSecurity account

2. **Copy the example configuration:**

   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

3. **Edit `terraform.tfvars`** (optional if using environment variables):

   ```hcl
   step_security_api_key  = "your-api-key-here"
   step_security_customer = "your-customer-id"
   attachments_json_file = "policy_attachments.json"
   ```

4. **Customize `policy_attachments.json`** with your specific attachments

5. **Initialize and apply:**
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## Attachment Types

### Workflow-Level Attachments

Apply policies to specific workflow files within repositories:

```json
{
  "owner": "my-organization",
  "policy_name": "workflow-policy",
  "org": {
    "repositories": [
      {
        "name": "frontend-app",
        "workflows": ["ci.yml", "deploy.yml"]
      },
      {
        "name": "backend-api",
        "workflows": ["test.yml"]
      }
    ]
  }
}
```

**Use cases:**

- Applying stricter policies to production deployment workflows
- Different security requirements for CI vs deployment workflows
- Granular control over specific workflow security

### Repository-Level Attachments

Apply policies to entire repositories:

```json
{
  "owner": "my-organization",
  "policy_name": "repo-policy",
  "org": {
    "repositories": [
      {
        "name": "frontend-app"
      },
      {
        "name": "backend-api"
      }
    ]
  }
}
```

**Use cases:**

- Team-specific security policies
- Different requirements for different applications
- Repository-based security boundaries

### Organization-Level Attachments

Apply policies to the entire organization:

```json
{
  "owner": "my-organization",
  "policy_name": "org-policy",
  "org": {
    "apply_to_org": true
  }
}
```

**Use cases:**

- Organization-wide baseline security policies
- Compliance requirements across all repositories
- Default security posture

### Cluster-Level Attachments

Apply policies to Kubernetes clusters:

```json
{
  "owner": "dev-organization",
  "policy_name": "cluster-policy",
  "clusters": ["production-k8s-cluster", "staging-k8s-cluster"]
}
```

**Use cases:**

- Environment-specific security policies
- Different requirements for production vs staging clusters
- Infrastructure-based security boundaries

### Mixed Attachments

Combine organization/repository and cluster attachments:

```json
{
  "owner": "my-organization",
  "policy_name": "mixed-policy",
  "org": {
    "repositories": [
      {
        "name": "critical-repo"
      },
      {
        "name": "staging-repo",
        "workflows": ["test.yml", "deploy-staging.yml"]
      }
    ]
  },
  "clusters": ["dev-k8s-cluster"]
}
```

**Use cases:**

- Complex security architectures
- Policies that span both GitHub and Kubernetes environments
- Unified security policies across different infrastructure types

## Policy Store vs Policy Store Attachments

### Policy Store (with `apply_to` fields)

- Policy definition includes attachment information
- Simpler for basic use cases
- Policy and attachment are coupled
- Good for static, simple attachments

### Policy Store Attachments

- Separate resource for attaching policies
- More flexible and granular control
- Reusable policies with different attachments
- Better for complex scenarios
- Dynamic attachment management

## Importing Existing Policy Attachments

If you have existing policy attachments that you want to manage with Terraform, you can import them:

### Import Command Format

```bash
terraform import 'stepsecurity_github_policy_store_attachment.policy_attachments["OWNER-POLICY_NAME"]' 'OWNER:::POLICY_NAME'
```

### Import Examples

```bash
# Import a policy attachment
terraform import 'stepsecurity_github_policy_store_attachment.policy_attachments["my-org-workflow-policy"]' 'my-org:::workflow-policy'

# Import a cluster policy attachment
terraform import 'stepsecurity_github_policy_store_attachment.policy_attachments["dev-org-cluster-policy"]' 'dev-org:::cluster-policy'
```

**Important Notes:**

- The import ID format is `OWNER:::POLICY_NAME` (three colons)
- The resource key in Terraform is `OWNER-POLICY_NAME` (single dash)
- Policy must exist before creating attachments
- After importing, always run `terraform plan` to verify the configuration

## Outputs

The configuration provides these outputs:

- `policy_attachments`: Detailed information about all created policy store attachments
- `attachment_ids`: Map of policy attachment keys to their IDs
- `attachment_summary`: Summary of policy attachments by type

## Best Practices

1. **Create policies first**: Ensure all referenced policies exist before creating attachments
2. **Plan attachment hierarchy**: Understand org > repo > workflow precedence
3. **Use descriptive names**: Make policy names clear and purposeful
4. **Test in staging**: Verify attachments work in non-production environments first
5. **Document dependencies**: Clearly document which policies must exist for attachments to work
6. **Regular reviews**: Periodically review and update attachment configurations
7. **Separation of concerns**: Keep policy definitions and attachments in separate configurations when possible

## Common Use Cases

### Development Team Workflows

```json
{
  "owner": "my-organization",
  "policy_name": "development-policy",
  "org": {
    "apply_to_org": false,
    "repositories": [
      {
        "name": "team-frontend",
        "workflows": ["ci.yml", "test.yml"]
      },
      {
        "name": "team-backend",
        "workflows": ["ci.yml", "test.yml"]
      }
    ]
  }
}
```

### Production Deployment Security

```json
{
  "owner": "my-organization",
  "policy_name": "production-policy",
  "org": {
    "apply_to_org": false,
    "repositories": [
      {
        "name": "production-app",
        "workflows": ["deploy-prod.yml", "release.yml"]
      }
    ]
  }
}
```

### Multi-Environment Clusters

```json
{
  "owner": "my-organization",
  "policy_name": "multi-env-policy",
  "clusters": [
    "production-cluster-us-east",
    "production-cluster-eu-west",
    "staging-cluster-shared"
  ]
}
```

## Troubleshooting

**Common issues:**

1. **Policy not found**: Ensure the referenced policy exists before creating attachments
2. **Authentication errors**: Verify API key and customer ID are correct
3. **Invalid attachment configuration**: Check JSON syntax and required fields
4. **Import failures**: Ensure correct import ID format (OWNER:::POLICY_NAME)
5. **Conflicting attachments**: Check for duplicate or conflicting attachment configurations

**Debug steps:**

1. Verify referenced policies exist in StepSecurity dashboard
2. Run `terraform plan` to preview changes
3. Check the JSON file syntax with a JSON validator
4. Verify environment variables are set correctly
5. Test with simple attachment configurations first
6. Check Terraform logs for detailed error messages

## Security Considerations

- Ensure referenced policies exist and are properly configured
- Regularly audit attachment effectiveness and coverage
- Monitor for legitimate workflows being affected by policy attachments
- Keep attachment configurations minimal and specific
- Review and update attachments when organizational structure changes
- Document policy dependencies and attachment relationships

## Support

For issues with this example:

1. Ensure all referenced policies exist in your StepSecurity account
2. Check the JSON configuration syntax
3. Verify authentication credentials
4. Review the StepSecurity provider documentation
5. Check Terraform logs for detailed error messages
6. Test with a minimal attachment configuration first
