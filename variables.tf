# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "ami" {
  description = "The AMI to use for the instance"
  type        = string
}

variable "subnet_id" {
  description = "The VPC Subnet ID to launch in"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC the resources are being created in"
  type        = string
}


# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "instance_count" {
  description = "number of ec2 instnces required"
  type        = number
  default     = 1
}

variable "instance_type" {
  description = "The type of instance to start"
  type        = string
  default     = "t2.micro"
}

variable "ec2_instance_name" {
  description = "Name prefix for instance"
  type        = string
  default     = "ec2inst"
}

variable "elb_name" {
  description = "Elastic Load balnacer name"
  type        = string
  default     = "elbinst"
}