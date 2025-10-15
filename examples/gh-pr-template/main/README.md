# GitHub PR Template Example

This example demonstrates how to manage GitHub PR template configuration using the StepSecurity Terraform provider.

## What This Example Does

This Terraform configuration:
- Creates a PR template for policy-driven pull requests in your organization
- Customizes the PR title, summary, commit message, and labels
- Uses the `{{STEPSECURITY_SECURITY_FIXES}}` placeholder to dynamically include security fixes

## Prerequisites

- Terraform >= 1.0
- StepSecurity account with API access
- GitHub organization with StepSecurity installed

## Setup

1. Copy the example tfvars file:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. Edit `terraform.tfvars` and add your credentials, or set environment variables:
   ```bash
   export STEP_SECURITY_API_KEY="your-api-key"
   export STEP_SECURITY_CUSTOMER="your-customer-id"
   ```

3. Update the `owner` field in `main.tf` with your organization name.

## Usage

Initialize Terraform:
```bash
terraform init
```

Review the planned changes:
```bash
terraform plan
```

Apply the configuration:
```bash
terraform apply
```

## Configuration Options

The PR template resource supports the following attributes:

- `owner`: GitHub organization name (required)
- `title`: Title for policy-driven PRs (required)
- `summary`: PR description body with optional placeholders (required)
- `commit_message`: Commit message for the PR (required)
- `labels`: List of labels to apply to PRs (optional)

## Import Existing PR Templates

If you have an existing PR template configuration, you can import it:

```bash
terraform import stepsecurity_github_pr_template.example organization-name
```

## Cleanup

To remove the PR template configuration:
```bash
terraform destroy
```

## Additional Resources

- [StepSecurity Documentation](https://docs.stepsecurity.io/)
- [Terraform Provider Documentation](https://registry.terraform.io/providers/step-security/stepsecurity/latest/docs)
