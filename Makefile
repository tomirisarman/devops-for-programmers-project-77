run: terraform-decrypt-secrets run-terraform generate-inventory run-ansible

prepare-vault-file:
	@echo "$${VAULT_PASSWORD:-examplePassword}" > vault_password_file

terraform-decrypt-secrets:
	@bash -c 'ansible-vault decrypt terraform/secrets/vault.secrets.auto.tfvars \
		--vault-pass-file vault_password_file --output terraform/secrets.auto.tfvars'

ansible-edit-secrets:
	@bash -c 'ansible-vault edit ansible/group_vars/all/vault.yml \
		--vault-pass-file vault_password_file'

run-terraform: terraform-decrypt-secrets
	cd terraform && terraform apply
	rm -f terraform/secrets.auto.tfvars

generate-inventory:
	cd ansible && bash generate-inventory.sh > inventory.ini

run-ansible:
	cd ansible && ansible-playbook -i inventory.ini --vault-password-file ../vault_password_file playbook.yml