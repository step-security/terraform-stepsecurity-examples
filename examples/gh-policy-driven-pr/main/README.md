# StepSecurity Policy-Driven PR Example

This example demonstrates how to manage StepSecurity policy-driven PR configurations using Terraform. Policy-driven PRs automatically create pull requests to remediate security findings in your repositories.

## Features

- **Automatic Security Remediation**: Configure automatic PR creation for security findings
- **Flexible Repository Selection**: Target specific repositories for your organization
- **Comprehensive Security Options**: Configure various security hardening features
- **Action Management**: Control which actions to exempt from pinning and replace with StepSecurity actions
- **Production-Ready Configuration**: Real-world configuration ready for deployment

## Prerequisites

- Terraform >= 1.0
- StepSecurity account with API access
- Valid StepSecurity API key and customer
- GitHub organization with StepSecurity integration

## Usage

1. **Set up environment variables (recommended):**

   ```bash
   export STEP_SECURITY_API_KEY="your-api-key-here"
   export STEP_SECURITY_CUSTOMER="your-customer"
   ```

2. **Update the configuration in main.tf:**

   ```hcl
   # Edit main.tf and update:
   # - "organization-name" with your GitHub organization name
   # - Repository names in both resources
   # - Security settings as needed for each policy level

   # The file demonstrates using both resources simultaneously:
   # 1. Organization-wide policy with exclusions (baseline security)
   # 2. Specific policy for an excluded repo (enhanced security)

   # You can customize this pattern to fit your needs:
   # - Remove the second resource to only use org-wide policy
   # - Remove the first resource to only use specific repo policies
   # - Keep both to implement graduated security levels
   ```

3. **Initialize and apply Terraform:**
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## Configuration Example

This example demonstrates a powerful pattern: **combining organization-wide policy with specific repository overrides**.

The `main.tf` file shows both resources working together:

1. **Organization-wide policy** with exclusions - Applies baseline security to all repos except specified ones
2. **Specific repository policy** - Applies different settings to an excluded repo

This pattern allows you to:

- Set organization-wide defaults with `selected_repos = ["*"]`
- Exclude specific repos that need different treatment with `excluded_repos`
- Apply custom policies to those excluded repos with a separate resource

### Combined Configuration (main.tf)

#### Organization-Wide Policy with Exclusions

```hcl
# Apply baseline policy to all repositories except specific ones
resource "stepsecurity_policy_driven_pr" "org_level_with_exclusions" {
  owner          = "organization-name"
  selected_repos = ["*"]
  excluded_repos = ["archived-repo", "test-repo-old"] # These repos opt-out

  auto_remediation_options = {
    create_pr                             = true
    create_issue                          = false
    create_github_advanced_security_alert = false
    harden_github_hosted_runner           = true
    pin_actions_to_sha                    = true
    restrict_github_token_permissions     = false
    secure_docker_file                    = false
  }
}
```

#### Specific Policy for Excluded Repository

```hcl
# Apply enhanced policy with v2 features to a specific excluded repo
resource "stepsecurity_policy_driven_pr" "example" {
  owner          = "organization-name"
  selected_repos = ["test-repo-old"] # One of the excluded repos from above

  auto_remediation_options = {
    create_pr                                     = true
    create_issue                                  = false
    create_github_advanced_security_alert         = false
    harden_github_hosted_runner                   = true
    pin_actions_to_sha                            = true
    restrict_github_token_permissions             = true
    secure_docker_file                            = true
    actions_to_exempt_while_pinning               = ["actions/checkout", "actions/setup-node"]
    actions_to_replace_with_step_security_actions = ["EnricoMi/publish-unit-test-result-action"]
    update_precommit_file                         = ["eslint"]
    package_ecosystem = [
      {
        package  = "npm"
        interval = "daily"
      },
      {
        package  = "pip"
        interval = "weekly"
      }
    ]
    add_workflows = "https://github.com/my-org/workflow-templates"
  }
}
```

**How this works:**

1. `org_level_with_exclusions` applies a baseline policy to all repos except "archived-repo" and "test-repo-old"
2. `example` applies an enhanced policy with v2 features specifically to "test-repo-old"
3. "archived-repo" remains excluded with no policy applied

This pattern is useful for:

- **Staged rollouts**: Apply basic security org-wide, then enable advanced features for specific repos
- **Different team requirements**: Some repos need more/less strict policies
- **Legacy repositories**: Exclude old repos from org policy while maintaining custom configs

## Configuration Fields

### Required Fields

- `owner`: GitHub organization/owner name
- `selected_repos`: Array of repository names or ["*"] for all repositories
- `auto_remediation_options`: Object containing remediation settings

### Optional Fields

- `excluded_repos`: Array of repository names to exclude when `selected_repos` is ["*"]. This allows you to opt-out specific repos from org-wide policies.

### Auto Remediation Options

#### Notification Settings

- `create_pr`: Create a pull request when findings are detected
- `create_issue`: Create an issue when findings are detected
- `create_github_advanced_security_alert`: Create GitHub Advanced Security alerts

**Important**: `create_pr` and `create_issue` cannot both be `true`. Also, `create_github_advanced_security_alert` can only be `true` if `create_issue` is `true`.

#### Security Hardening Features

- `harden_github_hosted_runner`: Install security agent on GitHub-hosted runners
- `pin_actions_to_sha`: Pin GitHub Actions to specific SHA commits
- `restrict_github_token_permissions`: Restrict GitHub token permissions
- `secure_docker_file`: Enable Dockerfile security scanning and hardening

#### Action Management

- `actions_to_exempt_while_pinning`: Array of actions to exclude from SHA pinning
- `actions_to_replace_with_step_security_actions`: Array of actions to replace with StepSecurity alternatives

#### Advanced Features (v2)

- `update_precommit_file`: Array of pre-commit config files to update with security hooks
- `package_ecosystem`: Array of dependency update configurations for automated dependency updates
  - Each entry includes `package` (npm, pip, etc.) and `interval` (daily, weekly, monthly)
- `add_workflows`: URL to GitHub repository containing workflow templates to add to repositories

## Configuration Examples

### Basic Security Policy

```hcl
resource "stepsecurity_policy_driven_pr" "basic" {
  owner          = "my-org"
  selected_repos = ["app1", "app2"]

  auto_remediation_options = {
    create_pr                                     = true
    create_issue                                  = false
    create_github_advanced_security_alert        = false
    harden_github_hosted_runner                  = true
    pin_actions_to_sha                           = true
    restrict_github_token_permissions            = true
    actions_to_exempt_while_pinning              = ["actions/checkout"]
    actions_to_replace_with_step_security_actions = []
  }
}
```

### Comprehensive Security Policy with v2 Features

```hcl
resource "stepsecurity_policy_driven_pr" "comprehensive" {
  owner          = "security-focused-org"
  selected_repos = ["*"]

  auto_remediation_options = {
    create_pr                                     = false
    create_issue                                  = true
    create_github_advanced_security_alert         = true
    harden_github_hosted_runner                   = true
    pin_actions_to_sha                            = true
    restrict_github_token_permissions             = true
    secure_docker_file                            = true
    actions_to_exempt_while_pinning               = ["actions/checkout", "actions/setup-node"]
    actions_to_replace_with_step_security_actions = ["EnricoMi/publish-unit-test-result-action", "dorny/test-reporter"]
    update_precommit_file                         = ["eslint"]
    package_ecosystem = [
      {
        package  = "npm"
        interval = "daily"
      },
      {
        package  = "pip"
        interval = "weekly"
      }
    ]
    add_workflows = "https://github.com/my-org/workflow-templates"
  }
}
```

### Organization-Wide Policy with Exclusions

```hcl
resource "stepsecurity_policy_driven_pr" "org_level_with_exclusions" {
  owner          = "test-organization"
  selected_repos = ["*"]
  excluded_repos = ["archived-repo", "test-repo-old"] # These repos opt-out

  auto_remediation_options = {
    create_pr                             = true
    create_issue                          = false
    create_github_advanced_security_alert = false
    harden_github_hosted_runner           = true
    pin_actions_to_sha                    = true
    restrict_github_token_permissions     = false
    secure_docker_file                    = false
  }
}
```

### Topic-Based Repository Filtering

```hcl
resource "stepsecurity_policy_driven_pr" "topic_filtered" {
  owner          = "my-org"
  selected_repos = ["*"]
  selected_repos_filter = {
    include_repos_only_with_topics = ["production", "security-critical"]
  }

  auto_remediation_options = {
    create_pr                             = true
    create_issue                          = false
    create_github_advanced_security_alert = false
    harden_github_hosted_runner           = true
    pin_actions_to_sha                    = true
    restrict_github_token_permissions     = true
    secure_docker_file                    = true
  }
}
```

### Development Environment Policy

```hcl
resource "stepsecurity_policy_driven_pr" "development" {
  owner          = "dev-org"
  selected_repos = ["dev-*", "test-*"]

  auto_remediation_options = {
    create_pr                                     = false
    create_issue                                  = true
    create_github_advanced_security_alert        = false
    harden_github_hosted_runner                  = false
    pin_actions_to_sha                           = false
    restrict_github_token_permissions            = false
    actions_to_exempt_while_pinning              = []
    actions_to_replace_with_step_security_actions = []
  }
}
```

## Terraform Variables

### Optional Variables

```hcl
# variables.tf
variable "step_security_api_key" {
  description = "StepSecurity API key for authentication"
  type        = string
  sensitive   = true
  default     = null
}

variable "step_security_customer" {
  description = "StepSecurity customer"
  type        = string
  default     = null
}
```

## Outputs

The configuration provides comprehensive outputs:

- `policy_id`: The ID of the created policy
- `policy_details`: Detailed policy configuration including:
  - Policy ID and organization name
  - Selected repositories
  - Security features enabled/disabled status
  - Action management settings
  - Repository coverage information

## Repository Selection

### Specific Repositories

```hcl
selected_repos = ["repo1", "repo2", "repo3"]
```

### All Repositories

```hcl
selected_repos = ["*"]
```

### All Repositories with Exclusions

Apply policy to all repositories except specific ones:

```hcl
selected_repos = ["*"]
excluded_repos = ["archived-repo", "legacy-app", "test-sandbox"]
```

**How it works:**

- When `selected_repos = ["*"]`, the policy applies to all current and future repositories in the organization
- `excluded_repos` allows you to opt-out specific repositories from this org-wide policy
- Excluded repos can then:
  - Have their own specific policy defined in a separate resource (see main.tf example)
  - Retain their existing policy configuration (if they had one before)
  - Have no policy applied (if you want to exclude them completely)
- This is useful for:
  - **Graduated security**: Apply baseline security org-wide, enhanced security to specific repos
  - **Team-specific policies**: Different repos managed by different teams with separate requirements
  - **Archived repositories**: Exclude repos that should not receive automated PRs
  - **Legacy repositories**: Exclude old repos from org policy while maintaining custom configs
  - **Test/sandbox repositories**: Exclude experimental repos from production policies

**Important:** `excluded_repos` can only be used when `selected_repos = ["*"]`. Using it with specific repo names will result in a validation error.

**Tip:** You can define multiple resources - one with org-wide config and exclusions, and others with specific policies for excluded repos. This allows you to implement sophisticated security patterns as shown in the main.tf example.

### Filtering by Repository Topics

Apply policy only to repositories with specific GitHub topics:

```hcl
selected_repos = ["*"]
selected_repos_filter = {
  include_repos_only_with_topics = ["production", "security-critical"]
}
```

**How it works:**

- `selected_repos_filter` allows you to apply policies based on GitHub repository topics
- `include_repos_only_with_topics` specifies an array of topics - only repos with these topics will be included
- Can be combined with `selected_repos = ["*"]` for organization-wide filtering
- Can be combined with `excluded_repos` to further refine repository selection

**Use cases:**

- **Environment-based policies**: Apply stricter policies to repos tagged with "production" or "staging"
- **Security classification**: Target repos tagged as "security-critical" or "compliance-required"
- **Team-based policies**: Apply policies to repos managed by specific teams using team-specific topics
- **Technology-specific policies**: Target repos with topics like "nodejs", "python", or "docker"

**Example with topics and exclusions:**

```hcl
resource "stepsecurity_policy_driven_pr" "production_repos" {
  owner          = "my-org"
  selected_repos = ["*"]
  selected_repos_filter = {
    include_repos_only_with_topics = ["production", "security-critical"]
  }
  excluded_repos = ["legacy-prod-app"] # Exclude specific production repos

  auto_remediation_options = {
    create_pr                             = true
    harden_github_hosted_runner           = true
    pin_actions_to_sha                    = true
    restrict_github_token_permissions     = true
    secure_docker_file                    = true
  }
}
```

### Pattern Matching

```hcl
selected_repos = ["frontend-*", "backend-*", "mobile-*"]
```

## Security Features Explained

### GitHub Hosted Runner Hardening

- Installs security agent on GitHub-hosted runners
- Prevents credential exfiltration
- Monitors the build process
- Detects anomalous outbound calls

### Action SHA Pinning

- Pins third-party actions to specific SHA commits
- Prevents supply chain attacks
- Follows GitHub security hardening guidelines
- Allows exemptions for trusted actions

### Token Permission Restriction

- Restricts GitHub token permissions to minimum required
- Reduces blast radius of potential security issues
- Follows principle of least privilege
- Improves overall security posture

### Dockerfile Security

- Scans Dockerfiles for security vulnerabilities
- Suggests security best practices for container images
- Identifies outdated base images and dependencies
- Helps maintain secure containerized applications

## Advanced v2 Features

### Pre-commit Hook Management

Automatically updates pre-commit configuration files with security hooks:

- Adds StepSecurity recommended pre-commit hooks
- Ensures security checks run before commits
- Maintains existing pre-commit configuration
- Supports custom pre-commit config file paths

### Automated Dependency Updates

Configure automated dependency update PRs for different package ecosystems:

- **npm**: JavaScript/Node.js dependencies
- **pip**: Python dependencies
- **docker**: Container base images
- **go**: Go modules
- Customizable update intervals (daily, weekly, monthly)
- Keeps dependencies up-to-date with security patches

### Workflow Template Integration

Add organization-standard workflows to repositories:

- Deploy CI/CD workflows from a central repository
- Ensure consistent security practices across all repos
- Automatically add workflows like security scanning, testing, etc.
- Supports custom workflow template repositories

## Action Management

### Exempting Actions from Pinning

```hcl
actions_to_exempt_while_pinning = [
  "actions/checkout",
  "actions/setup-node",
  "actions/setup-python"
]
```

### Replacing Actions with StepSecurity Alternatives

```hcl
actions_to_replace_with_step_security_actions = [
  "EnricoMi/publish-unit-test-result-action",
  "dorny/test-reporter"
]
```

### Configuring Pre-commit Hooks

```hcl
update_precommit_file = ["eslint", "gitleaks"]
```

### Dependency Update Configuration

```hcl
package_ecosystem = [
  {
    package  = "npm"
    interval = "daily"
  },
  {
    package  = "pip"
    interval = "weekly"
  },
  {
    package  = "docker"
    interval = "weekly"
  }
]
```

### Adding Workflow Templates

```hcl
add_workflows = "https://github.com/my-org/workflow-templates"
```

## Security Best Practices

1. **API Key Management**: Use environment variables for sensitive data:

   ```bash
   export TF_VAR_step_security_api_key="your-api-key"
   export TF_VAR_step_security_customer="your-customer-id"
   ```

2. **Repository Selection**:

   - Use specific repository lists for critical environments
   - Use wildcard "\*" judiciously
   - Consider using patterns for logical grouping

3. **Gradual Rollout**:
   - Start with non-critical repositories
   - Enable features incrementally
   - Monitor PR creation and feedback

## Importing Existing Policies

To import existing policy-driven PR configurations:

```hcl
import {
  to = stepsecurity_policy_driven_pr.example
  id = "your-organization-name"
}
```

Or use the CLI:

```bash
terraform import stepsecurity_policy_driven_pr.example your-organization-name
```

## Important Validation Rules

When configuring auto-remediation options, be aware of these provider validation rules:

1. **Mutual Exclusivity**: `create_pr` and `create_issue` cannot both be `true`
2. **Dependency Rule**: `create_github_advanced_security_alert` can only be `true` if `create_issue` is `true`
3. **Repository Requirement**: `selected_repos` must contain at least one repository
4. **Exclusion Rule**: `excluded_repos` can only be used when `selected_repos = ["*"]` (wildcard for all repos)

These rules ensure proper configuration and prevent conflicting remediation approaches.

## Troubleshooting

- **Validation Errors**: Check that your configuration follows the validation rules above
- **Organization Access**: Verify StepSecurity has access to the specified organization
- **Repository Permissions**: Ensure repositories exist and are accessible
- **API Permissions**: Verify API key has sufficient permissions for policy management

## Best Practices

1. **Start Simple**: Begin with basic policies before enabling advanced features
2. **Test in Development**: Use development organizations to test policy configurations
3. **Monitor Impact**: Review created PRs and issues to assess policy effectiveness
4. **Gradual Rollout**: Enable features incrementally
5. **Regular Reviews**: Periodically review and update policy configurations based on findings
