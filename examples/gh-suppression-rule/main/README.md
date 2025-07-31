# StepSecurity GitHub Suppression Rules - Main Example

This example demonstrates how to create GitHub suppression rules using the `stepsecurity_github_supression_rule` resource. The example uses a JSON configuration file to define multiple suppression rules for different types of security findings.

## What This Example Does

This configuration creates suppression rules that allow you to ignore specific types of security findings detected by StepSecurity in your GitHub repositories. The example supports:

- **Anomalous Outbound Network Call Rules**: Ignore network connections to specific domains or IP addresses
- **Source Code Overwritten Rules**: Ignore file overwrite detections for specific files or paths

## Features

- **JSON-driven configuration**: Define rules in a structured JSON format
- **Multiple rule types support**: Handle both network call and file overwrite suppression
- **Flexible targeting**: Apply rules to specific organizations, repositories, workflows, or jobs
- **Wildcard support**: Use wildcards for broad rule application
- **Dynamic configuration**: Rules are created dynamically based on JSON input

## Prerequisites

- Terraform >= 1.0
- StepSecurity account with API access
- Valid StepSecurity API key and customer ID
- GitHub organization(s) with StepSecurity integration

## File Structure

```
main/
├── main.tf                    # Main Terraform configuration
├── variables.tf               # Variable definitions
├── outputs.tf                 # Output definitions
├── terraform.tfvars.example   # Example variable values
└── suppression_rules.json     # JSON configuration for rules
```

## Configuration

### Environment Variables

Set these environment variables for authentication:

```bash
export STEP_SECURITY_API_KEY="your-api-key-here"
export STEP_SECURITY_CUSTOMER="your-customer-id"
```

### JSON Configuration

The `suppression_rules.json` file defines the rules to create. Each rule must have:

**Required fields:**
- `name`: Unique name for the rule
- `type`: Either `anomalous_outbound_network_call` or `source_code_overwritten`
- `action`: Currently only `ignore` is supported
- `description`: Description of what the rule does
- `owner`: GitHub organization name (use `*` for all organizations)

**Optional fields for anomalous_outbound_network_call:**
- `process`: Process name pattern (supports wildcards)
- `destination`: Object with either `domain` or `ip` (not both)

**Optional fields for source_code_overwritten:**
- `repo`: Repository name
- `workflow`: Workflow name
- `job`: Job name
- `file`: File name
- `file_path`: File path

### Example JSON Configuration

```json
{
  "suppression_rules": [
    {
      "name": "ignore-aws-connections",
      "type": "anomalous_outbound_network_call",
      "action": "ignore",
      "description": "Ignore new connections to Amazon AWS services",
      "owner": "*",
      "process": "*",
      "destination": {
        "domain": "*.amazonaws.com"
      }
    },
    {
      "name": "ignore-source-overwrite-test-files",
      "type": "source_code_overwritten",
      "action": "ignore",
      "description": "Ignore source code overwritten findings on test files",
      "owner": "my-org",
      "repo": "my-repo",
      "workflow": "ci",
      "job": "test",
      "file": "test_file.txt",
      "file_path": "/tests/test_file.txt"
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
   rules_json_file = "suppression_rules.json"
   ```

3. **Customize `suppression_rules.json`** with your specific rules

4. **Initialize and apply:**
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## Importing Existing Rules

If you have existing suppression rules that you want to manage with Terraform, you can import them using the following commands:

### For Network Call Rules (anomalous_outbound_network_call)
```bash
terraform import 'stepsecurity_github_supression_rule.network_rules["RULE_NAME_FROM_JSON"]' RULE_ID
```

### For File Rules (source_code_overwritten)
```bash
terraform import 'stepsecurity_github_supression_rule.file_rules["RULE_NAME_FROM_JSON"]' RULE_ID
```

### Import Process

1. **Find the Rule ID**: You can get existing rule IDs from the StepSecurity dashboard or API
2. **Add to JSON**: Add the rule configuration to your `suppression_rules.json` file
3. **Import**: Run the appropriate import command above
4. **Verify**: Run `terraform plan` to ensure the imported rule matches your configuration

### Import Examples

```bash
# Import a network rule named "ignore-aws-connections"
terraform import 'stepsecurity_github_supression_rule.network_rules["ignore-aws-connections"]' 12345

# Import a file rule named "ignore-test-overwrites"  
terraform import 'stepsecurity_github_supression_rule.file_rules["ignore-test-overwrites"]' 67890
```

**Important Notes:**
- The rule name in the import command must match the `name` field in your JSON configuration
- Rule IDs are unique identifiers assigned by StepSecurity
- After importing, always run `terraform plan` to verify the configuration matches

## Outputs

The configuration provides these outputs:

- `suppression_rules`: Detailed information about all created rules
- `rule_ids`: Map of rule names to their generated IDs

## Rule Types

### Anomalous Outbound Network Call Rules

These rules suppress alerts for network connections that StepSecurity detects as potentially suspicious.

**Use cases:**
- Legitimate connections to cloud services (AWS, Azure, GCP)
- Expected connections to third-party APIs
- Known safe domains that trigger false positives

**Example:**
```json
{
  "name": "ignore-npm-registry",
  "type": "anomalous_outbound_network_call",
  "action": "ignore",
  "description": "Allow connections to npm registry",
  "owner": "my-org",
  "process": "npm*",
  "destination": {
    "domain": "*.npmjs.org"
  }
}
```

### Source Code Overwritten Rules

These rules suppress alerts when StepSecurity detects files being overwritten during CI/CD processes.

**Use cases:**
- Generated files that are legitimately overwritten
- Test files that are modified during testing
- Build artifacts that are recreated

**Example:**
```json
{
  "name": "ignore-build-artifacts",
  "type": "source_code_overwritten",
  "action": "ignore",
  "description": "Allow overwriting of build artifacts",
  "owner": "my-org",
  "repo": "my-project",
  "workflow": "build",
  "file_path": "/dist/*"
}
```

## Best Practices

1. **Start specific**: Begin with narrow rules targeting specific repos/workflows
2. **Use wildcards carefully**: Broad wildcard rules can mask legitimate security issues
3. **Regular review**: Periodically review and update suppression rules
4. **Document purpose**: Use clear descriptions explaining why each rule exists
5. **Test incrementally**: Add rules one at a time to verify their impact

## Troubleshooting

**Common issues:**

1. **Authentication errors**: Verify API key and customer ID are correct
2. **Invalid rule configuration**: Check JSON syntax and required fields
3. **Permission errors**: Ensure API key has necessary permissions
4. **Rule conflicts**: Avoid overlapping rules that might interfere

**Debug steps:**

1. Run `terraform plan` to preview changes
2. Check the JSON file syntax with a JSON validator
3. Verify environment variables are set correctly
4. Review StepSecurity API documentation for field requirements

## Security Considerations

- Store API keys securely (use environment variables or secret management)
- Regularly audit suppression rules to prevent security blind spots
- Use least-privilege principles when setting rule scope
- Monitor for changes in your threat landscape that might require rule updates

## Support

For issues with this example:
1. Check the JSON configuration syntax
2. Verify authentication credentials
3. Review the StepSecurity provider documentation
4. Check Terraform logs for detailed error messages