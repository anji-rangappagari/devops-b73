provider "aws" {
    region = "us-east-1"
}
resource "aws_instance" "web" {
  count                  = length(var.instace_count)
  ami                    = data.aws_ami.rhel9_devops.id
  instance_type          = "t2.small"

  tags = {
    Name = element(var.instace_count, count.index)
}
}

data "aws_ami" "rhel9_devops" {
  most_recent = true
  owners      = ["973714476881"]

  filter {
    name   = "name"
    values = ["Redhat-9-DevOps-Practice"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

variable "instace_count" {
  default     = ["frontend","catalog","user"]

}



