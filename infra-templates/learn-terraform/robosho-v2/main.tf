provider "aws" {
  region = "us-east-1"
}

module "instances" {
  for_each = var.instace_count
  source = "./ec2"
  name   = each.key
}
variable "instace_count" {
  default = {
    frontend1  = {}
    frontend2  = {}
    # catalogue = {}
    # mongodb   = {}
    # user      = {}
    # redis     = {}
    # cart      = {}
    # mysql     = {}
    # shipping  = {}
    # payment   = {}
    # rabbitmq  = {}
    # dispatch  = {}
  }
}