variable "policies_json_file" {
  description = "Path to the JSON file containing GitHub run policies configuration"
  type        = string
  default     = "github_run_policies.json"

  validation {
    condition     = can(regex(".*\\.json$", var.policies_json_file))
    error_message = "The policies_json_file must be a JSON file (end with .json)."
  }
}