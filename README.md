# StepSecurity Terraform Examples

This repository contains comprehensive examples and reusable modules for the [StepSecurity Terraform Provider](https://registry.terraform.io/providers/step-security/stepsecurity/latest/docs). It serves as the definitive resource for implementing StepSecurity's security features across various CI/CD platforms using Infrastructure as Code.

## 🚀 Quick Start

1. **Prerequisites**: Ensure you have Terraform installed and StepSecurity account credentials
2. **Authentication**: Set up your StepSecurity provider credentials
3. **Choose a resource**: Select from our available resource examples
4. **Deploy**: Run terraform commands to manage StepSecurity resources

## 📁 Repository Structure

```
terraform-stepsecurity-examples/
├── examples/             # Resource-specific examples
│   ├── gh-checks/                  # GitHub checks configuration examples
│   │   ├── main/                   # Basic example
│   │   └── README.md               # Resource overview
│   ├── gh-org-notification-settings/  # Notification settings examples
│   │   ├── main/                   # Basic example
│   │   └── README.md               # Resource overview
│   ├── gh-policy-driven-pr/        # Policy-driven PR examples
│   │   ├── main/                   # Basic example
│   │   └── README.md               # Resource overview
│   ├── gh-policy-store/            # GitHub policy store examples
│   │   ├── main/                   # Basic example
│   │   └── README.md               # Resource overview
│   ├── gh-policy-store-attachment/ # Policy store attachment examples
│   │   ├── main/                   # Basic example
│   │   └── README.md               # Resource overview
│   ├── gh-run-policy/              # GitHub run policy examples
│   │   ├── main/                   # Basic example
│   │   └── README.md               # Resource overview
│   ├── gh-suppression-rule/        # GitHub suppression rule examples
│   │   ├── main/                   # Basic example
│   │   └── README.md               # Resource overview
│   ├── github-actions/             # GitHub Actions workflow examples
│   │   ├── terraform-plan.yml      # Plan workflow with OIDC
│   │   ├── terraform-apply.yml     # Apply workflow with OIDC
│   │   └── README.md               # Setup and configuration guide
│   ├── user-management/            # User management examples
│   │   ├── main/                   # Basic example
│   │   └── README.md               # Resource overview
│   └── README.md                   # Examples overview
└── README.md                       # This file
```

## 💡 Examples

### Available Resource Examples

| Resource | Description | Primary Use Case |
|----------|-------------|------------------|
| [gh-checks](./examples/gh-checks) | GitHub pr checks configuration | Configure security controls for repositories as pr runtime checks|
| [gh-org-notification-settings](./examples/gh-org-notification-settings) | GitHub organization notification settings | Configure notifications for security findings |
| [gh-policy-driven-pr](./examples/gh-policy-driven-pr) | Automated security remediation through policy-driven PRs | Auto-remediate security findings with pull requests |
| [gh-policy-store](./examples/gh-policy-store) | GitHub policy store management for controlling egress traffic | Control workflow egress traffic and security settings |
| [gh-policy-store-attachment](./examples/gh-policy-store-attachment) | Attach policy stores to GitHub organizations/repositories | Apply policy stores to specific orgs and repos |
| [gh-run-policy](./examples/gh-run-policy) | GitHub run policy configuration | Manage GitHub Actions workflow policies |
| [gh-suppression-rule](./examples/gh-suppression-rule) | GitHub suppression rule management | Suppress false positive security alerts |
| [github-actions](./examples/github-actions) | GitHub Actions workflow examples with OIDC and S3 backend | Integrate Terraform with GitHub Actions using secure authentication |
| [user-management](./examples/user-management) | User management with role-based access control | Manage user permissions and access |

Each resource directory contains:
- **main/**: Basic working example with detailed README
- **README.md**: Resource overview and available examples

## 🔐 Authentication

The StepSecurity provider requires authentication using API keys. Set up your credentials:

```bash
export STEP_SECURITY_API_KEY="your-api-key"
export STEP_SECURITY_CUSTOMER="your-customer-name"
```
Or configure directly in your Terraform:

```hcl
provider "stepsecurity" {
  api_key  = var.stepsecurity_api_key
  customer = var.stepsecurity_customer
}
```

## 📚 Documentation

Each example includes comprehensive documentation:
- Resource-specific README files with usage instructions
- Terraform variable descriptions and examples
- Output explanations and use cases

## 🏃‍♂️ Getting Started

1. **Clone the repository**:
   ```bash
   git clone https://github.com/step-security/terraform-stepsecurity-examples.git
   cd terraform-stepsecurity-examples
   ```

2. **Set up authentication**:
   ```bash
   export STEP_SECURITY_API_KEY="your-api-key"
   export STEP_SECURITY_CUSTOMER="your-customer-name"
   ```

3. **Choose an example**:
   ```bash
   cd examples/gh-policy-driven-pr/main
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your values
   ```

4. **Deploy**:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## 🆘 Support

- **Issues**: Report bugs and request features in our [GitHub Issues](https://github.com/step-security/terraform-stepsecurity-examples/issues)

## 📈 Resources

- [StepSecurity Provider Documentation](https://registry.terraform.io/providers/step-security/stepsecurity/latest/docs)
- [StepSecurity Platform](https://app.stepsecurity.io)

---
