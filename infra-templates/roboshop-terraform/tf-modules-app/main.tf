# IAM Policy
resource "aws_iam_policy" "policy" {
  name        = "${var.component}-${var.env}-ssm-pm-policy"
  path        = "/"
  description = "My test policy"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "ssm:GetParameterHistory",
                "ssm:GetParametersByPath",
                "ssm:GetParameters",
                "ssm:GetParameter",
                "ssm:PutParameter"
            ],
            "Resource": "arn:aws:ssm:us-east-1:563336977955:parameter/roboshop/${var.env}/${var.component}/*"
        }
    ]
}
)
}
# IAM role

resource "aws_iam_role" "ec2_role" {
  name = "${var.component}-${var.env}-ec2-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "tag-value"
  }
}

resource "aws_iam_instance_profile" "test_profile" {
  name = "${var.component}-${var.env}-ec2-profile"
  role = aws_iam_role.role.name
}

resource "aws_iam_role_policy_attachment" "policy-attach" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy.arn
}
# Security Group

resource "aws_security_group" "sg" {
  name       = "${var.component}-${var.env}-sg"
  description = "${var.component}-${var.env}-sg"
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
    Name = "${var.component}-${var.env}-sg"
  }
}
# EC2
resource "aws_instance" "instaance" {
  ami                    = data.aws_ami.rhel9_devops.id
  instance_type          = "t2.small"
  vpc_security_group_ids = [aws_security_group.sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  tags = {
    Name = "${var.component}-${var.env}-ec2"
  }
}
# DNS Record


resource "aws_route53_record" "dns" {
  zone_id = "Z073797429P7BFE4RYO6N"
  name    = "${var.component}-dev.oneseven.space"
  type    = "A"
  ttl     = 30
  records = [aws_instance.instance.private_ip]
}
# Null Resource Ansible

resource "null_resource" "ansible" {
  depends_on = [aws_instance.web, aws_route53_record.dns]
   connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.instance.public_ip
  }
  provisioner "file" {
    source      = "${path.module}/../../../roboshop-ansible"
    destination = "/tmp/roboshop-ansible"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo rm -rf /home/ec2-user/devops-b73/infra-templates/roboshop-ansible",
      "sudo mkdir -p /home/ec2-user/devops-b73/infra-templates",
      "sudo mv /tmp/roboshop-ansible /home/ec2-user/devops-b73/infra-templates/roboshop-ansible",
      <<-EOT
      for role in frontend mongodb catalogue redis user cart mysql shipping rabbitmq payment; do
        ansible-playbook main.yaml \\
          -i "${role}-${var.env}.oneseven.space," \\
          -e "env=${var.env} ansible_user=ec2-user ansible_password=DevOps321 role_name=${role}" || break
      done
      EOT
    ]
  }
}