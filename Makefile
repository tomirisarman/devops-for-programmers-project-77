run: terraform-decrypt-secrets run-terraform generate-inventory run-ansible

prepare-vault-file:
	@echo "$${VAULT_PASSWORD:-examplePassword}" > vault_password_file

terraform-decrypt-secrets:
	$(MAKE) -C terraform decrypt-secrets

ansible-edit-secrets:
	$(MAKE) -C ansible edit-secrets

init-terraform:
	$(MAKE) -C terraform init

run-terraform:
	$(MAKE) -C terraform run

generate-inventory:
	$(MAKE) -C ansible generate-inventory

run-ansible:
	$(MAKE) -C ansible run