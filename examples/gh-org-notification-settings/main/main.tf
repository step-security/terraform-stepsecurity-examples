terraform {
  required_version = ">= 1.0"
  required_providers {
    stepsecurity = {
      source  = "step-security/stepsecurity"
      version = "~> 0.0.2"
    }
  }
}

provider "stepsecurity" {
  # api_key and customer will be read from environment variables:
  # STEP_SECURITY_API_KEY and STEP_SECURITY_CUSTOMER
}

# Load organizations configuration from JSON file
locals {
  organizations_config = jsondecode(file(var.organizations_json_file))
  organizations = {
    for org in local.organizations_config.organizations :
    org.owner => org
  }
}

# Create GitHub organization notification settings from JSON configuration
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
    domain_blocked                        = try(each.value.notification_events.domain_blocked, true)
    file_overwrite                        = try(each.value.notification_events.file_overwrite, true)
    new_endpoint_discovered               = try(each.value.notification_events.new_endpoint_discovered, true)
    https_detections                      = try(each.value.notification_events.https_detections, true)
    secrets_detected                      = try(each.value.notification_events.secrets_detected, true)
    artifacts_secrets_detected            = try(each.value.notification_events.artifacts_secrets_detected, true)
    imposter_commits_detected             = try(each.value.notification_events.imposter_commits_detected, true)
    suspicious_network_call_detected      = try(each.value.notification_events.suspicious_network_call_detected, true)
    suspicious_process_events_detected    = try(each.value.notification_events.suspicious_process_events_detected, true)
    harden_runner_config_changes_detected = try(each.value.notification_events.harden_runner_config_changes_detected, true)
    non_compliant_artifact_detected       = try(each.value.notification_events.non_compliant_artifact_detected, false)
    run_blocked_by_policy                 = try(each.value.notification_events.run_blocked_by_policy, false)
    baseline_check_failures               = try(each.value.notification_events.baseline_check_failures, false)
    required_check_failures               = try(each.value.notification_events.required_check_failures, false)
    optional_check_failures               = try(each.value.notification_events.optional_check_failures, false)
  }
}
