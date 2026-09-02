module "roboshop-app" {
  source    = "./tf-modules-app"
  component = each.key
  env       = var.env
}