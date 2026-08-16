provider "aws" {
  region = "us-east-1"
}
resource "aws_instance" "web" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.sg.id]

  tags = {
    Name = var.name
  }
provisioner "remote-exec" {

connection {
    type        = "ssh"
    user        = "ec2-user"
    host        = self.public_ip
    }
    inline = [
      "sudo yum install -y httpd",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd"
    ]
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_security_group" "sg" {
  name        = var.name
  description = "Allow SSH inbound traffic and all outbound traffic"
  
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.name
  }
}


variable "name" {
 description = "Name of the EC2 instance and security group"
  type        = string
  default     = "my-ec2-instance"
}

output "public_ip" {
  value = aws_instance.web.public_ip
}