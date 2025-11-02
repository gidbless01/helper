variable "aws_region" {
  type    = string
  default = "eu-north-1"
}

variable "instance_type" {
  type    = string
  default = "t2.micro" # start small; scale as needed
}

variable "ssh_key_name" {
  type = string
  description = "sheep"
}

variable "public_key_path" {
  type = string
  description = "sheep"
}
