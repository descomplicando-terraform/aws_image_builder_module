variable "name" {
  description = "The name of the image builder pipeline"
  type        = string
  default     = "linuxtips"
  
}

variable "github_token_secret_arn" {
  description = "The ARN of the secret containing the GitHub token"
  type        = string
  default     = "arn:aws:secretsmanager:us-east-1:123456789012:secret:github"  
}

variable "component_docker_arn" {
  description = "The ARN of the Docker component"
  default = "arn:aws:imagebuilder:us-east-1:aws:component/docker-ce-linux/1.0.0/1"
}

variable "cron_expression" {
  description = "The cron expression for the schedule"
  type        = string
  default     = "cron(0 0 * * ? *)"
  
}