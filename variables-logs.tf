# Logs/Diagnostics

variable "logs_destinations_ids" {
  description = "List of IDs (storage, logAnalytics Workspace, EventHub) to push logs to."
  type        = list(string)
  default     = null
}

variable "logs_categories" {
  description = "List of logs categories to log"
  type        = list(string)
  default     = null
}

variable "logs_metrics_categories" {
  description = "List of metrics categories to log"
  type        = list(string)
  default     = null
}

variable "logs_retention_days" {
  description = "Number of days to keep logs."
  type        = number
  default     = 32
}
