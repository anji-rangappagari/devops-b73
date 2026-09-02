variable "sample" {
    default = "Hello World"
}


variable "sample1" {
    default = 100
}
output "sample" {
    value = var.sample
}

output "sample1" {
    value = var.sample1
}

# sometimes if variable/any refernce with the combination of some other string then we have to access those in ${}

output "sample-ext"{
    value = "${var.sample} - ${var.sample1}"
}

variable "env" {
    default = "dev"
}

output "env" {
    value = var.env
}

variable "course" {
    default = ["Devops", "SRE", "Platform Engineering"]
}

variable "env" {}

output "env" {
    value = var.env
  
}

variable "URL" {}

output "URL" {
    value = var.URL
}