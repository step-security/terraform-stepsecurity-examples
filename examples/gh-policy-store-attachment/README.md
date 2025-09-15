# StepSecurity GitHub Policy Store Attachment Examples

This directory contains examples demonstrating how to use the `stepsecurity_github_policy_store_attachment` resource to attach existing GitHub policy stores to specific scopes.

## Overview

Policy store attachments provide granular control over where existing policies are applied. Unlike policy stores that define both the policy and its scope, policy store attachments allow you to create reusable policies and attach them to different resources as needed.

## Examples

### Main Example (`main/`)

The main example demonstrates comprehensive policy store attachment configurations including:

- **Workflow-level attachments**: Attaching policies to specific workflow files
- **Repository-level attachments**: Attaching policies to entire repositories
- **Organization-level attachments**: Attaching policies organization-wide
- **Cluster-level attachments**: Attaching policies to Kubernetes clusters
- **Mixed attachments**: Combining multiple attachment types in a single resource

## Key Features

- **Separation of concerns**: Policy definitions are separate from policy applications
- **Reusability**: Same policy can be attached to different scopes
- **Flexibility**: Complex attachment patterns with mixed scope types
- **JSON-driven configuration**: Easy-to-manage structured configuration
- **Dynamic management**: Change policy attachments without modifying policies

## Prerequisites

- Existing StepSecurity GitHub policy stores (policies must exist before creating attachments)
- StepSecurity account with API access
- Valid StepSecurity API key and customer ID
- GitHub organization(s) with StepSecurity integration

## When to Use Policy Store Attachments

Choose policy store attachments over direct policy scoping when you need:

1. **Reusable policies**: Apply the same policy to different scopes
2. **Complex attachment patterns**: Mix organization, repository, and cluster attachments
3. **Dynamic attachment management**: Change policy applications without modifying policies
4. **Separation of concerns**: Keep policy definitions separate from policy applications
5. **Fine-grained control**: Precise control over policy application scope

## Getting Started

1. Navigate to the `main/` directory
2. Review the example configuration and README
3. Ensure you have existing policies to attach
4. Customize the configuration for your environment
5. Follow the usage instructions in the main example

## Related Examples

- [`../gh-policy-store/`](../gh-policy-store/) - Creating GitHub policy stores
- [`../gh-run-policy/`](../gh-run-policy/) - GitHub Actions run policies

For detailed implementation instructions, see the README in each example subdirectory.