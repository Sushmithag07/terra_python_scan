variable "logging_level" {
  description = "Lambda logging level"
  type        = string
  default     = "ERROR"
}

variable "vpc_id" {
  description = "The vpc in which to create resources. If empty, will attempt to find it."
  type        = string
  default     = ""
}

variable "aws_region" {
  description = "Target AWS region"
  type        = string
  default     = "us-west-2"
}

variable "availability_zones" {
  description = "The availability zones in which to create resoures. If empty, will use all available in the vpc."
  type        = list(string)
  default     = []
}

variable "subnet_ids" {
  description = "A list of subnets ids to use for the resources instead of all subnets from the vpc."
  type        = list(string)
  default     = []
}

variable "security_group_ids" {
  description = "IDs of security groups to place resources into. These are in addition to a group that allows communication among the resources in this configuration."
  type        = list(string)
  default     = []
}

variable "environment" {
  description = "AWS account name"
  type        = string
  default     = "dev"
}
