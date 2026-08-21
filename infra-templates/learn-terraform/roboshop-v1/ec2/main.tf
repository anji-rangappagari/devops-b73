resource "aws_instance" "web" {
  ami                    = data.aws_ami.rhel9_devops.id
  instance_type          = "t2.small"
  vpc_security_group_ids = [aws_security_group.sg.id]

  # connection {
  #   type     = "ssh"
  #   user     = "ec2-user"
  #   password = "DevOps321"
  #   host     = self.public_ip
  # }

  # provisioner "file" {
  #   source      = "${path.module}/../../../roboshop-shell"
  #   destination = "/tmp/roboshop-shell"
  # }

  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo rm -rf /home/ec2-user/devops-b73/infra-templates/roboshop-shell",
  #     "sudo mkdir -p /home/ec2-user/devops-b73/infra-templates",
  #     "sudo mv /tmp/roboshop-shell /home/ec2-user/devops-b73/infra-templates/roboshop-shell",
  #     "sudo bash /home/ec2-user/devops-b73/infra-templates/roboshop-shell/${var.name}.sh"
  #   ]
  # }

  tags = {
    Name = var.name
  }
}

resource "aws_route53_record" "www" {
  zone_id = "Z073797429P7BFE4RYO6N"
  name    = "${var.name}-dev.oneseven.space"
  type    = "A"
  ttl     = 30
  records = [aws_instance.web.private_ip]
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

resource "aws_security_group" "sg" {
  name        = var.name
  description = "Allow SSH inbound traffic and all outbound traffic"
  
  ingress {
    description = "SSH"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
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


variable "name" {}

output "public_ip" {
  value = aws_instance.web.public_ip
}