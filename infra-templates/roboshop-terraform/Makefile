dev:
	@rm -rf .terraform
	@terraform init -backend-config=env-dev/state.tfvars
	@terraform plan -var-file=env-dev/main.tfvars

dev-apply:
	@rm -rf .terraform
	@terraform init -backend-config=env-dev/state.tfvars
	@terraform apply -var-file=env-dev/main.tfvars

prod:
	@rm -rf .terraform
	@terraform init -backend-config=env-prod/state.tfvars
	@terraform plan -var-file=env-prod/main.tfvars

prod-apply:
	@rm -rf .terraform
	@terraform init -backend-config=env-prod/state.tfvars
	@terraform apply -var-file=env-prod/main.tfvars