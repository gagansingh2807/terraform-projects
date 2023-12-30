variable "private_data_subnet_az1_cidr" {
  default     = "10.0.4.0/24"
  description = "private data subnet az1 cidr block"
  type        = string
}

variable "private_data_subnet_az2_cidr" {
  default     = "10.0.5.0/24"
  description = "private data subnet az2 cidr block"
  type        = string
}

# Security group variables
variable "ssh_location" {
  default     = "0.0.0.0/0"
  description = "the IP address that can SSH into the EC2"
  type        = string
}

# Add any additional variables below this line that you may need in your configuration.

# Note: Replace the default values with the actual values that you want to use,
# or set them through Terraform CLI or a tfvars file.
