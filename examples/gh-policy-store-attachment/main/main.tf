terraform {
  required_version = ">= 1.0"
  required_providers {
    stepsecurity = {
      source  = "step-security/stepsecurity"
      version = "~> 0.0.4"
    }
  }
}

provider "stepsecurity" {
  # api_key and customer will be read from environment variables:
  # STEP_SECURITY_API_KEY and STEP_SECURITY_CUSTOMER
}

# Load policy attachments configuration from JSON file
locals {
  attachments_config = jsondecode(file(var.attachments_json_file))
  attachments = {
    for attachment in local.attachments_config.policy_attachments :
    "${attachment.owner}-${attachment.policy_name}" => attachment
  }
}

# Create GitHub policy store attachments from JSON configuration
resource "stepsecurity_github_policy_store_attachment" "policy_attachments" {
  for_each = local.attachments

  owner       = each.value.owner
  policy_name = each.value.policy_name

  # Organization and repository configuration
  org = try(each.value.org, null) != null ? {
    apply_to_org = try(each.value.org.apply_to_org, null)
    repositories = [
      for repo in try(each.value.org.repositories, []) : {
        name      = repo.name
        workflows = try(repo.workflows, [])
      }
    ]
  } : null

  # Cluster configuration
  clusters = try(each.value.clusters, [])
}
