# GitHub Checks Examples

Examples for configuring GitHub security checks using the StepSecurity Terraform provider.

**Primary Resource:** `stepsecurity_github_checks`

## Use Cases

- **Package Security**: Control NPM package usage with cooldown periods and exemptions
- **Script Injection Prevention**: Detect and prevent script injection attacks
- **Compromised Package Detection**: Identify and prevent compromised NPM package updates
- **PWN Request Detection**: Detect potential PWN requests in GitHub workflows
- **Repository Governance**: Apply security policies across organization repositories
- **Development Workflow Security**: Balance security with development productivity

## Available Examples

### [main/](./main/)
Comprehensive GitHub checks configuration demonstrating:

- Multiple organization configurations (3 different scenarios)
- Various security controls (NPM cooldown, script injection, compromised updates, PWN request)
- Different check types (required vs optional)
- Repository targeting strategies with omit_repos support
- Direct Terraform resource configuration (no external dependencies)
- Import of existing configurations

**Scenarios Covered:**
- **Security-focused organization**: Maximum security with strict required controls
- **Development organization**: Balanced security with optional controls for development workflows
- **Minimal setup**: Basic security controls for lightweight requirements

## Security Controls

### NPM Package Cooldown
Prevents usage of newly published packages to avoid supply chain attacks:
- Configurable cooldown period (days)
- Package exemption lists
- Package exemption supports wildcard patterns (like `@types/*`)

### Script Injection Detection
Identifies potential script injection attacks in workflows and configurations:
- No configuration required
- Analyzes workflow files and scripts
- Detects common injection patterns

### NPM Package Compromised Updates
Detects compromised NPM package updates:
- No configuration required
- Monitors for known compromised package versions
- Prevents installation of compromised updates

### PWN Request Detection
Detects potential PWN requests in workflows:
- No configuration required
- Analyzes workflow patterns for suspicious activities
- Identifies potential security vulnerabilities

## Repository Targeting

### Required Checks
- Must pass for PR merging
- Applied to critical repositories
- Supports `["*"]` for all repositories or specific repository names

### Optional Checks
- Provides warnings/feedback
- Doesn't block merges
- Good for gradual adoption

### Baseline Checks
- Organization-wide baseline security
- Can omit specific repositories
- Consistent security posture

## Configuration Patterns

### Direct Terraform Configuration
```hcl
resource "stepsecurity_github_checks" "example_org" {
  owner = "organization-name"

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
    repos = ["*"]  # or specific repo names
  }
}
```

### Repository Configuration
- `["*"]` - All repositories
- `["repo1", "repo2"]` - Specific repositories
- Pattern matching (like `["prefix-*"]`) is not supported

### Control Settings
Each control can have custom settings:
```hcl
settings = {
  cool_down_period = 7  # number
  packages_to_exempt_in_cooldown_check = ["@types/*"]  # list with wildcards
}
```

## Getting Started

1. **Choose your organization**: Identify GitHub organizations to configure
2. **Select controls**: Choose appropriate security controls
3. **Define repositories**: Determine repository targeting strategy
4. **Configure settings**: Set control-specific parameters
5. **Deploy gradually**: Start with optional checks, move to required

## Best Practices

### Gradual Rollout
1. Start with baseline checks
2. Add optional checks for visibility
3. Convert to required checks after validation
4. Monitor and adjust based on feedback

### Repository Strategy
- Use `["*"]` for all repos or specific repository names
- Group repositories by risk level
- Consider development workflows
- Plan for new repositories

### Settings Optimization
- Balance security with productivity
- Use exemptions judiciously
- Regular policy reviews
- Monitor check performance

### Team Communication
- Document security policies
- Train developers on new checks
- Provide clear error messages
- Establish escalation procedures

## Integration

### CI/CD Integration
GitHub checks integrate automatically with:
- Pull request workflows
- Branch protection rules
- Status checks
- Merge requirements

### Monitoring
- Check pass/fail rates
- Developer feedback
- Security incident correlation
- Policy compliance metrics

### Automation
- Terraform for infrastructure
- Direct resource configuration
- Import for existing setups
- Outputs for monitoring

## Support

- **Example-specific issues**: Check the main/ directory README
- **Provider documentation**: [StepSecurity Terraform Provider](https://registry.terraform.io/providers/step-security/stepsecurity/latest/docs)
- **GitHub checks documentation**: StepSecurity platform docs
- **General questions**: Create an issue in this repository