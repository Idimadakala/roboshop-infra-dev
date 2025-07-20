locals {
  # Common tags for all resources
  # This is a good place to define common tags that will be used across multiple resources
  common_tags = {
        Project = var.project
        Environment = var.environment
        Terraform = true
    }
}