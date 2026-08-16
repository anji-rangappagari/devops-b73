variable "class" {
  default = "devops"
}

output "class" {
  value = upper(var.class)
}


variable "fruits" {
  default = ["apple", "banana", "orange"]
}

output "fruits" {
  value = length(var.fruits)
}

variable "class_01" {
  default = {
    devops = {
        name = "devops"
        topics    = ["terraform", "ansible", "docker"]
    }
    aws = {
        name = "aws"
    }
  }
}

output "class_01" {
  value = var.class_01["devops"]["topics"]
}

output "aws_topics" {
  value = lookup(lookup(var.class_01, "aws", "null"), "topics", "null")
}

output "fruits_0" {
  value = var.fruits[0]
}

output "fruits_01" {
  value = element(var.fruits, 1)
}