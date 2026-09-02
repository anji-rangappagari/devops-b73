module "roboshop-app" {
  source    = "./tf-modules-app"
  component = "frontend"
  env       = var.env
  name      = "frontend"
}