# StepSecurity GitHub Organization Notification Settings Example

This example demonstrates how to configure GitHub organization notification settings for multiple organizations using Terraform. These settings control how and when you receive notifications about security findings detected by StepSecurity in your repositories.

## Features

- **Multiple Organization Support**: Configure notifications for multiple GitHub organizations from a single JSON file
- **Multiple Notification Channels**: Configure Slack, Microsoft Teams, and email notifications per organization
- **Comprehensive Security Events**: Enable notifications for various security detection events
- **Granular Control**: Fine-tune which events trigger notifications per organization
- **JSON-Driven Configuration**: Easy-to-maintain configuration using JSON files
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
   export STEP_SECURITY_CUSTOMER="your-customer-id-here"
   ```

2. **Or configure Terraform variables:**

   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your API credentials
   ```

3. **Update configuration in organizations.json:**

   ```bash
   # Edit organizations.json and update:
   # - "your-main-org", "your-dev-org", "your-prod-org" with your GitHub organization names
   # - Slack webhook URLs with your actual webhooks
   # - Email addresses with your security team's emails
   # - Enable/disable notification events per organization
   ```

4. **Initialize and apply Terraform:**
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## Configuration Example

This example configures notification settings for multiple GitHub organizations using a JSON file:

### JSON Configuration (organizations.json)

```json
{
  "organizations": [
    {
      "owner": "your-main-org",
      "notification_channels": {
        "slack_webhook_url": "https://hooks.slack.com/services/YOUR/MAIN/WEBHOOK",
        "teams_webhook_url": null,
        "email": "security-alerts@yourcompany.com"
      },
      "notification_events": {
        "domain_blocked": true,
        "secrets_detected": true,
        "file_overwrite": true,
        "new_endpoint_discovered": true
      }
    },
    {
      "owner": "your-dev-org",
      "notification_channels": {
        "slack_webhook_url": "https://hooks.slack.com/services/YOUR/DEV/WEBHOOK",
        "email": "dev-security@yourcompany.com"
      },
      "notification_events": {
        "domain_blocked": true,
        "secrets_detected": true,
        "new_endpoint_discovered": false
      }
    },
    {
      "owner": "your-prod-org",
      "notification_channels": {
        "slack_notification_method": "webhook",
        "slack_webhook_url": "https://hooks.slack.com/services/YOUR/PROD/WEBHOOK",
        "teams_webhook_url": "https://outlook.office.com/webhook/your-teams-webhook",
        "email": "prod-security@yourcompany.com"
      },
      "notification_events": {
        "domain_blocked": true,
        "secrets_detected": true,
        "file_overwrite": true,
        "new_endpoint_discovered": true
      }
    },
    {
      "owner": "your-oauth-org",
      "notification_channels": {
        "slack_notification_method": "oauth",
        "slack_channel_id": "C01234567890",
        "email": "security@yourcompany.com"
      },
      "notification_events": {
        "domain_blocked": true,
        "secrets_detected": true,
        "file_overwrite": true
      }
    }
  ]
}
```

### Terraform Configuration (main.tf)

```hcl
resource "stepsecurity_github_org_notification_settings" "org_notifications" {
  for_each = local.organizations

  owner = each.value.owner

  notification_channels = {
    slack_webhook_url         = try(each.value.notification_channels.slack_webhook_url, null)
    teams_webhook_url         = try(each.value.notification_channels.teams_webhook_url, null)
    email                     = try(each.value.notification_channels.email, null)
    slack_notification_method = try(each.value.notification_channels.slack_notification_method, null)
    slack_channel_id          = try(each.value.notification_channels.slack_channel_id, null)
  }

  notification_events = {
    domain_blocked        = try(each.value.notification_events.domain_blocked, true)
    secrets_detected      = try(each.value.notification_events.secrets_detected, true)
    # ... other security events with try() for optional configuration
  }
}
```

## Notification Channels

### Slack Integration

StepSecurity supports two methods for Slack notifications:

#### Method 1: Webhook (Default)

```hcl
notification_channels = {
  slack_webhook_url = "https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX"
}
```

#### Method 2: OAuth

```hcl
notification_channels = {
  slack_notification_method = "oauth"
  slack_channel_id          = "C01234567890"  # Slack channel ID
}
```

**When to use OAuth:**

- Centralized authentication through StepSecurity
- No need to manage individual webhook URLs
- Easier to configure for multiple channels
- Better control and revocation capabilities

**When to use Webhook:**

- Simple, direct integration
- No additional OAuth setup required
- Works with existing webhook infrastructure

**Finding your Slack Channel ID:**

1. Open Slack in a web browser
2. Navigate to the channel you want to use
3. The channel ID is in the URL: `https://app.slack.com/client/TXXXXXXXX/C01234567890`
   - The part after the last `/` is your channel ID (e.g., `C01234567890`)
4. Alternatively, right-click the channel name and select "Copy link" to get the full URL

### Microsoft Teams Integration

```hcl
notification_channels = {
  teams_webhook_url = "https://outlook.office.com/webhook/your-teams-webhook-url"
}
```

### Email Notifications

```hcl
notification_channels = {
  email = "security-team@yourcompany.com"
}
```

## Security Detection Events

### Critical Security Events (Enabled by Default)

- **`domain_blocked`**: Outbound traffic to a domain is blocked
- **`file_overwrite`**: Source code file is overwritten
- **`secrets_detected`**: Secrets detected in build logs
- **`artifacts_secrets_detected`**: Secrets detected in build artifacts
- **`imposter_commits_detected`**: Imposter commits detected

### Network Security Events

- **`new_endpoint_discovered`**: Anomalous outbound call discovered
- **`https_detections`**: Anomalous HTTPS outbound call discovered
- **`suspicious_network_call_detected`**: Suspicious network calls detected

### Runtime Security Events

- **`suspicious_process_events_detected`**: Suspicious process events detected
- **`harden_runner_config_changes_detected`**: Harden runner config changes detected

### Policy and Compliance Events (Disabled by Default)

- **`non_compliant_artifact_detected`**: Non-compliant artifacts detected
- **`run_blocked_by_policy`**: Run blocked by policy

## Customization

To customize the notification settings:

1. **Update Organization Names**: Replace `"your-main-org"`, `"your-dev-org"`, etc. with your GitHub organization names
2. **Configure Notification Channels**: Update webhook URLs and email addresses per organization
3. **Adjust Event Settings**: Enable/disable specific notification events based on your needs per organization
4. **Add/Remove Organizations**: Add or remove organizations from the JSON array

### Example Customization

**Example 1: Using Slack Webhook (Explicit)**

```json
{
  "organizations": [
    {
      "owner": "acme-corp",
      "notification_channels": {
        "slack_notification_method": "webhook",
        "slack_webhook_url": "https://hooks.slack.com/services/YOUR/ACME/WEBHOOK",
        "email": "security@acme-corp.com"
      },
      "notification_events": {
        "domain_blocked": true,
        "secrets_detected": true,
        "file_overwrite": true
      }
    }
  ]
}
```

**Note:** You can also omit `slack_notification_method` when using webhooks, as "webhook" is the default method.

**Example 2: Using Slack OAuth**

```json
{
  "organizations": [
    {
      "owner": "acme-corp",
      "notification_channels": {
        "slack_notification_method": "oauth",
        "slack_channel_id": "C01234567890",
        "email": "security@acme-corp.com"
      },
      "notification_events": {
        "domain_blocked": true,
        "secrets_detected": true,
        "file_overwrite": true
      }
    }
  ]
}
```

## Security Best Practices

1. **Webhook Security**:

   - Store webhook URLs securely
   - Use environment variables for sensitive data
   - Regularly rotate webhook URLs

2. **Event Configuration**:

   - Start with critical events enabled
   - Gradually enable additional events based on your security requirements
   - Disable events that create too much noise for your team

3. **Channel Management**:
   - Use dedicated security channels for notifications
   - Ensure appropriate team members have access
   - Set up proper alerting and escalation procedures

## Environment Variables

Set these environment variables to avoid storing credentials in files:

```bash
export STEP_SECURITY_API_KEY="your-api-key-here"
export STEP_SECURITY_CUSTOMER="your-customer-id-here"
```

## Outputs

The configuration provides detailed outputs for multiple organizations:

- `organizations_configured`: List of all organizations configured for notifications
- `notification_settings_details`: Detailed settings for each organization including:
  - Organization name
  - Notification channels configuration
  - Security events enabled/disabled status
  - Policy events enabled/disabled status
  - Configuration summary (total channels, enabled/disabled events count)
- `configuration_summary`: Overall configuration summary including:
  - Total number of organizations configured
  - List of organization names
  - JSON file path used for configuration

## Importing Existing Settings

To import existing notification settings for multiple organizations:

```hcl
import {
  to = stepsecurity_github_org_notification_settings.org_notifications["your-main-org"]
  id = "your-main-org"
}

import {
  to = stepsecurity_github_org_notification_settings.org_notifications["your-dev-org"]
  id = "your-dev-org"
}
```

Or use the CLI:

```bash
terraform import 'stepsecurity_github_org_notification_settings.org_notifications["your-main-org"]' your-main-org
terraform import 'stepsecurity_github_org_notification_settings.org_notifications["your-dev-org"]' your-dev-org
```

## Troubleshooting

- **Webhook Validation**: Test webhook URLs before applying configuration
- **Organization Access**: Verify StepSecurity app is installed in your GitHub organization
- **API Permissions**: Ensure API key has sufficient permissions for notification management
- **Email Delivery**: Check spam filters if email notifications aren't received

## Best Practices

1. **Start Conservative**: Begin with critical security events only
2. **Test Channels**: Verify all notification channels are working properly
3. **Monitor Volume**: Adjust event settings if receiving too many notifications
4. **Regular Reviews**: Periodically review and update notification settings
5. **Team Coordination**: Ensure security team is prepared to respond to notifications
