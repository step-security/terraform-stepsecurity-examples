output "organizations_configured" {
  description = "List of organizations configured for notifications"
  value       = keys(stepsecurity_github_org_notification_settings.org_notifications)
}

output "notification_settings_details" {
  description = "Detailed notification settings for each organization"
  value = {
    for org_key, org_settings in stepsecurity_github_org_notification_settings.org_notifications : org_key => {
      organization_name = org_settings.owner
      notification_channels = {
        slack_configured = org_settings.notification_channels.slack_webhook_url != null
        teams_configured = org_settings.notification_channels.teams_webhook_url != null
        email_configured = org_settings.notification_channels.email != null
        email_address    = org_settings.notification_channels.email
      }
      security_events_enabled = {
        domain_blocked                        = org_settings.notification_events.domain_blocked
        file_overwrite                        = org_settings.notification_events.file_overwrite
        new_endpoint_discovered               = org_settings.notification_events.new_endpoint_discovered
        https_detections                      = org_settings.notification_events.https_detections
        secrets_detected                      = org_settings.notification_events.secrets_detected
        artifacts_secrets_detected            = org_settings.notification_events.artifacts_secrets_detected
        imposter_commits_detected             = org_settings.notification_events.imposter_commits_detected
        suspicious_network_call_detected      = org_settings.notification_events.suspicious_network_call_detected
        suspicious_process_events_detected    = org_settings.notification_events.suspicious_process_events_detected
        harden_runner_config_changes_detected = org_settings.notification_events.harden_runner_config_changes_detected
      }
      policy_events_enabled = {
        non_compliant_artifact_detected = org_settings.notification_events.non_compliant_artifact_detected
        run_blocked_by_policy          = org_settings.notification_events.run_blocked_by_policy
      }
      summary = {
        total_channels   = length([for k, v in org_settings.notification_channels : k if v != null])
        enabled_events   = length([for k, v in org_settings.notification_events : k if v == true])
        disabled_events  = length([for k, v in org_settings.notification_events : k if v == false])
      }
    }
  }
}

output "configuration_summary" {
  description = "Overall configuration summary"
  value = {
    total_organizations = length(keys(stepsecurity_github_org_notification_settings.org_notifications))
    organizations_list  = keys(stepsecurity_github_org_notification_settings.org_notifications)
    json_file_used     = var.organizations_json_file
  }
}