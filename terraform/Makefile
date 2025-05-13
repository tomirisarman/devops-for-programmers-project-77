decrypt-secrets:
	@bash -c 'ansible-vault decrypt secrets/vault.secrets.auto.tfvars \
		--vault-pass-file ../vault_password_file --output terraform/secrets.auto.tfvars'
	@bash -c 'ansible-vault decrypt secrets/vault.secrets.backend.tfvars \
		--vault-pass-file ../vault_password_file --output terraform/secrets.backend.tfvars'

init:
	terraform init -backend-config=secrets.backend.tfvars

run: decrypt-secrets init
	terraform apply