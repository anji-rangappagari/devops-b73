provider "aws" {
  region = "us-east-1"
}

module "frontend" {
  source = "./ec2"
  name   = "frontend"
}

module "mongodb" {
  source = "./ec2"
  name   = "mongodb"
}

module "catalogue" {
  source = "./ec2"
  name   = "catalogue"
}

module "user" {
  source = "./ec2"
  name   = "user"
}

module "cart" {
  source = "./ec2"
  name   = "cart"
}

module "mysql" {
  source = "./ec2"
  name   = "mysql"
}

module "shipping" {
  source     = "./ec2"
  name       = "shipping"
  depends_on = [module.mysql]
}

module "redis" {
  source = "./ec2"
  name   = "redis"
}

module "payment" {
  source = "./ec2"
  name   = "payment"
}

module "rabbitmq" {
  source = "./ec2"
  name   = "rabbitmq"
}

module "dispatch" {
  source = "./ec2"
  name   = "dispatch"
}