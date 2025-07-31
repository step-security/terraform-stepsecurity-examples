# StepSecurity GitHub Policy Store - Main Example

This example demonstrates how to create GitHub policy stores using the `stepsecurity_github_policy_store` resource. Policy stores define security policies that can be referenced in GitHub workflows to control egress traffic and security settings for HardenRunner.

## What This Example Does

This configuration creates policy stores that define security policies for your GitHub organizations. These policies can be referenced in GitHub workflows to:

- **Control egress traffic**: Block or audit outbound network connections
- **Manage allowed endpoints**: Define which external services workflows can access
- **Configure security settings**: Control telemetry, sudo access, and file monitoring

## Features

- **JSON-driven configuration**: Define policies in a structured JSON format
- **Multiple policy support**: Create different policies for different use cases
- **Flexible egress control**: Support for both "audit" and "block" modes
- **Endpoint management**: Configure allowed endpoints for blocked egress
- **Security customization**: Fine-tune telemetry, sudo, and file monitoring settings
- **Multi-organization support**: Manage policies across multiple GitHub organizations

## Prerequisites

- Terraform >= 1.0
- StepSecurity account with API access
- Valid StepSecurity API key and customer ID
- GitHub organization(s) with StepSecurity integration
- Understanding of HardenRunner and GitHub Actions security

## File Structure

```
main/
├── main.tf                    # Main Terraform configuration
├── variables.tf               # Variable definitions
├── outputs.tf                 # Output definitions
├── terraform.tfvars.example   # Example variable values
└── harden_runner_policies.json         # JSON configuration for policy stores
```

## Configuration

### Environment Variables

Set these environment variables for authentication:

```bash
export STEP_SECURITY_API_KEY="your-api-key-here"
export STEP_SECURITY_CUSTOMER="your-customer-id"
```

### JSON Configuration

The `harden_runner_policies.json` file defines the policies to create. Each policy must have:

**Required fields:**
- `owner`: GitHub organization name
- `policy_name`: Unique name for the policy within the organization
- `egress_policy`: Either `"audit"` or `"block"`

**Optional fields:**
- `allowed_endpoints`: Array of allowed endpoints (required for block mode)
- `disable_telemetry`: Boolean to disable telemetry collection
- `disable_sudo`: Boolean to disable sudo access
- `disable_file_monitoring`: Boolean to disable file monitoring

### Example JSON Configuration

```json
{
  "harden_runner_policies": [
    {
      "owner": "my-organization",
      "policy_name": "strict-security-policy",
      "egress_policy": "block",
      "allowed_endpoints": [
        "github.com:443",
        "api.github.com:443",
        "registry.npmjs.org:443",
        "pypi.org:443"
      ],
      "disable_telemetry": false,
      "disable_sudo": true,
      "disable_file_monitoring": false
    },
    {
      "owner": "my-organization", 
      "policy_name": "audit-only-policy",
      "egress_policy": "audit",
      "allowed_endpoints": [],
      "disable_telemetry": false,
      "disable_sudo": false,
      "disable_file_monitoring": false
    }
  ]
}
```

## Usage

1. **Copy the example configuration:**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. **Edit `terraform.tfvars`** (optional if using environment variables):
   ```hcl
   step_security_api_key  = "your-api-key-here"
   step_security_customer = "your-customer-id"
   policies_json_file = "harden_runner_policies.json"
   ```

3. **Customize `harden_runner_policies.json`** with your specific policies

4. **Initialize and apply:**
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## Importing Existing Policy Stores

If you have existing policy stores that you want to manage with Terraform, you can import them:

### Import Command Format
```bash
terraform import 'stepsecurity_github_policy_store.harden_runner_policies["OWNER-POLICY_NAME"]' 'OWNER:::POLICY_NAME'
```

### Import Process

1. **Find existing policies**: Check your StepSecurity dashboard for existing policy stores
2. **Add to JSON**: Add the policy configuration to your `harden_runner_policies.json` file
3. **Import**: Run the import command with the correct format
4. **Verify**: Run `terraform plan` to ensure the imported policy matches your configuration

### Import Examples

```bash
# Import a policy named "strict-security-policy" for organization "my-org"
terraform import 'stepsecurity_github_policy_store.harden_runner_policies["my-org-strict-security-policy"]' 'my-org:::strict-security-policy'

# Import an audit policy
terraform import 'stepsecurity_github_policy_store.harden_runner_policies["dev-org-audit-only-policy"]' 'dev-org:::audit-only-policy'
```

**Important Notes:**
- The import ID format is `OWNER:::POLICY_NAME` (three colons)
- The resource key in Terraform is `OWNER-POLICY_NAME` (single dash)
- Policy names must be unique within each organization
- After importing, always run `terraform plan` to verify the configuration

## Outputs

The configuration provides these outputs:

- `harden_runner_policies`: Detailed information about all created policy stores
- `policy_ids`: Map of policy store keys to their IDs
- `policy_references`: Policy references for use in GitHub workflows

## Policy Types and Use Cases

### Audit Mode Policies

**Purpose**: Monitor and log egress traffic without blocking

**Use cases:**
- Development environments where you need visibility
- Testing new security policies before enforcement
- Compliance monitoring and reporting

**Example:**
```json
{
  "owner": "my-org",
  "policy_name": "monitoring-policy",
  "egress_policy": "audit",
  "allowed_endpoints": [],
  "disable_telemetry": false,
  "disable_sudo": false,
  "disable_file_monitoring": false
}
```

### Block Mode Policies

**Purpose**: Restrict egress traffic to only allowed endpoints

**Use cases:**
- Production environments requiring strict security
- Compliance with security policies
- Preventing data exfiltration

**Example:**
```json
{
  "owner": "my-org",
  "policy_name": "production-policy",
  "egress_policy": "block",
  "allowed_endpoints": [
    "github.com:443",
    "api.github.com:443",
    "registry.npmjs.org:443"
  ],
  "disable_telemetry": false,
  "disable_sudo": true,
  "disable_file_monitoring": false
}
```

## Common Allowed Endpoints

### Package Registries
- `registry.npmjs.org:443` - npm packages
- `registry.yarnpkg.com:443` - Yarn packages  
- `pypi.org:443` - Python packages
- `files.pythonhosted.org:443` - Python package files
- `repo1.maven.org:443` - Maven packages
- `plugins.gradle.org:443` - Gradle plugins

### Cloud Services
- `*.amazonaws.com:443` - AWS services
- `*.azure.com:443` - Azure services
- `*.googleapis.com:443` - Google Cloud services

### Container Registries
- `docker.io:443` - Docker Hub
- `registry-1.docker.io:443` - Docker Hub registry
- `ghcr.io:443` - GitHub Container Registry
- `quay.io:443` - Red Hat Quay

### Development Tools
- `github.com:443` - GitHub API and services
- `api.github.com:443` - GitHub API
- `raw.githubusercontent.com:443` - GitHub raw content

## Using Policy Stores in GitHub Workflows

Once created, reference your policy stores in GitHub workflows:

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
        egress-policy: my-organization/strict-security-policy
    - name: Run build
      run: npm ci && npm run build
```

## Best Practices

1. **Start with audit mode**: Begin with audit policies to understand traffic patterns
2. **Gradually restrict**: Move to block mode after identifying necessary endpoints
3. **Environment-specific policies**: Use different policies for dev, staging, and production
4. **Regular review**: Periodically review and update allowed endpoints
5. **Documentation**: Document the purpose and scope of each policy
6. **Testing**: Test policies in non-production environments first

## Troubleshooting

**Common issues:**

1. **Authentication errors**: Verify API key and customer ID are correct
2. **Invalid policy configuration**: Check JSON syntax and required fields
3. **Import failures**: Ensure correct import ID format (OWNER:::POLICY_NAME)
4. **Workflow failures**: Check if required endpoints are in the allowed list

**Debug steps:**

1. Run `terraform plan` to preview changes
2. Check the JSON file syntax with a JSON validator
3. Verify environment variables are set correctly
4. Review StepSecurity dashboard for existing policies
5. Test policies with simple workflows first

## Security Considerations

- Store API keys securely (use environment variables or secret management)
- Regularly audit policy effectiveness and coverage
- Monitor for legitimate traffic being blocked by policies
- Keep allowed endpoints list minimal and specific
- Review and update policies when dependencies change

## Support

For issues with this example:
1. Check the JSON configuration syntax
2. Verify authentication credentials
3. Review the StepSecurity provider documentation
4. Check Terraform logs for detailed error messages
5. Test with a minimal policy configuration first