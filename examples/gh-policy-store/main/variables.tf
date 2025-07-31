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

variable "policies_json_file" {
  description = "Path to JSON file containing policy stores configuration"
  type        = string
  default     = "harden_runner_policies.json"
}