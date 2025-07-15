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

variable "users_json_file" {
  description = "Path to JSON file containing users configuration"
  type        = string
  default     = "users.json"
  validation {
    condition     = can(regex(".*\\.json$", var.users_json_file))
    error_message = "The users_json_file must be a JSON file with .json extension."
  }
}