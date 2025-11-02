provider "aws" {
    region = "eu-north-1"
}

# Create SSH key pair
resource "aws_key_pair" "deployer" {
    key_name   = "sheep"
    public_key = file("~/.ssh/id_rsa.pub")
}

# Create EC2 instance for monitoring
resource "aws_instance" "monitor" {
    ami           = "ami-0c02fb55956c7d316" # Example Amazon Linux 2 AMI
    instance_type = "t2.micro"
    key_name      = "sheep"

    tags = {
        Name = "monitor-instance"
    }
}