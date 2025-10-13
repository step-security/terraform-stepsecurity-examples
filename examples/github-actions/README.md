# GitHub Actions Workflows for StepSecurity Terraform Provider

This directory contains example GitHub Actions workflows that demonstrate how to use the StepSecurity Terraform provider with GitHub Actions, featuring:

- S3 backend for remote state storage
- AWS OIDC authentication (no static credentials required)
- Automated Terraform plan on pull requests
- Automated Terraform apply on merge to main

## Workflows Overview

### 1. `terraform-plan.yml` - Plan on Pull Request

This workflow runs automatically when a pull request is opened or updated:

- **Trigger**: Pull requests to `main` branch
- **Permissions**: Read contents, write PR comments, request OIDC token
- **Actions**:
  - Runs `terraform fmt`, `init`, `validate`, and `plan`
  - Posts plan results as a PR comment
  - Fails the check if plan fails

### 2. `terraform-apply.yml` - Apply on Merge

This workflow runs automatically when changes are merged to main:

- **Trigger**: Push to `main` branch
- **Permissions**: Read contents, request OIDC token
- **Actions**:
  - Runs `terraform fmt`, `init`, `validate`, `plan`, and `apply`
  - Creates a job summary with apply results
  - Auto-approves and applies the plan

## Prerequisites

Before using these workflows, you need:

### 1. AWS Account Setup

#### Create an S3 Bucket for Terraform State

```bash
# Replace with your account ID and region
export AWS_ACCOUNT_ID="123456789012"
export AWS_REGION="us-west-2"

# Create S3 bucket for state
aws s3api create-bucket \
  --bucket terraform-state-${AWS_ACCOUNT_ID}-${AWS_REGION} \
  --region ${AWS_REGION} \
  --create-bucket-configuration LocationConstraint=${AWS_REGION}

# Enable versioning
aws s3api put-bucket-versioning \
  --bucket terraform-state-${AWS_ACCOUNT_ID}-${AWS_REGION} \
  --versioning-configuration Status=Enabled

```

#### Create IAM OIDC Provider for GitHub Actions

```bash
# Create OIDC provider
aws iam create-open-id-connect-provider \
  --url https://token.actions.githubusercontent.com \
  --client-id-list sts.amazonaws.com \
  --thumbprint-list 6938fd4d98bab03faadb97b34396831e3780aea1
```

#### Create IAM Role for GitHub Actions

Create a trust policy file `trust-policy.json`:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::YOUR_AWS_ACCOUNT_ID:oidc-provider/token.actions.githubusercontent.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
        },
        "StringLike": {
          "token.actions.githubusercontent.com:sub": "repo:YOUR_GITHUB_ORG/YOUR_REPO:*"
        }
      }
    }
  ]
}
```

Create the role:

```bash
# Create role
aws iam create-role \
  --role-name github-actions-terraform-role \
  --assume-role-policy-document file://trust-policy.json

# Attach policy for S3 state access
aws iam put-role-policy \
  --role-name github-actions-terraform-role \
  --policy-name terraform-state-access \
  --policy-document '{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ],
        "Resource": "arn:aws:s3:::terraform-state-YOUR_AWS_ACCOUNT_ID-YOUR_AWS_REGION/terraform.tfstate"
      },
      {
        "Effect": "Allow",
        "Action": [
          "s3:ListBucket"
        ],
        "Resource": "arn:aws:s3:::terraform-state-YOUR_AWS_ACCOUNT_ID-YOUR_AWS_REGION"
      }
    ]
  }'
```

### 2. GitHub Repository Setup

#### Add GitHub Secrets

Go to your repository's Settings > Secrets and variables > Actions, and add:

- `API_KEY`: Your StepSecurity API key

## Configuration

### Step 1: Copy Workflows

Copy the workflow files to your repository's `.github/workflows/` directory:

### Step 2: Update Placeholders

Edit both workflow files and replace the following placeholders:

#### Environment Variables (top of each file)

```yaml
env:
  AWS_REGION: YOUR_AWS_REGION # Replace with your AWS region (e.g., us-west-2)
  TERRAFORM_STATE_BUCKET: YOUR_TERRAFORM_STATE_BUCKET # Replace with your S3 bucket name
```

**Example:**
```yaml
env:
  AWS_REGION: us-west-2
  TERRAFORM_STATE_BUCKET: terraform-state-123456789012-us-west-2
```

#### AWS Credentials Configuration

In the "Configure AWS credentials" step:

```yaml
- name: Configure AWS credentials
  uses: aws-actions/configure-aws-credentials@v5.0.0
  with:
    role-to-assume: arn:aws:iam::YOUR_AWS_ACCOUNT_ID:role/YOUR_GITHUB_ACTIONS_ROLE
    role-session-name: GitHub-Actions-Terraform
    aws-region: ${{ env.AWS_REGION }}
```

**Replace:**
- `YOUR_AWS_ACCOUNT_ID`: Your 12-digit AWS account ID
- `YOUR_GITHUB_ACTIONS_ROLE`: The name of your IAM role (default: `github-actions-terraform-role`)

**Example:**
```yaml
role-to-assume: arn:aws:iam::123456789012:role/github-actions-terraform-role
```

## Usage

### Testing the Plan Workflow

1. Create a new branch:
   ```bash
   git checkout -b test-terraform-change
   ```

2. Make changes to your Terraform files

3. Commit and push:
   ```bash
   git add .
   git commit -m "Test terraform change"
   git push origin test-terraform-change
   ```

4. Open a pull request to `main`

5. The plan workflow will run automatically and post results as a comment

### Applying Changes

1. Review the plan output in the PR comment

2. Merge the pull request to `main`

3. The apply workflow will run automatically

4. Check the job summary for apply results

## Troubleshooting

### "Error: Unable to assume role"

- Verify your OIDC provider is configured correctly
- Check that the trust policy includes your repository
- Ensure the role ARN is correct in the workflow

### "Error: AccessDenied when calling S3"

- Verify the IAM role has permissions to access the S3 bucket
- Check that the bucket name is correct
- Ensure the bucket exists in the specified region

### "Error: API_KEY secret not found"

- Add the `API_KEY` secret to your repository settings
- Verify the secret name matches in the workflow

### Workflow doesn't trigger

- Check that the workflow file is in `.github/workflows/`
- Verify the trigger paths match your changed files
- Ensure GitHub Actions are enabled for the repository

## Additional Resources

- [StepSecurity Terraform Provider Documentation](https://registry.terraform.io/providers/step-security/stepsecurity/latest/docs)
- [GitHub Actions OIDC with AWS](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services)
- [Terraform S3 Backend](https://www.terraform.io/docs/language/settings/backends/s3.html)
