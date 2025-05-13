edit-secrets:
	@bash -c 'ansible-vault edit group_vars/all/vault.yml \
		--vault-pass-file ../vault_password_file'

generate-inventory:
	bash generate-inventory.sh > inventory.ini

run:
	ansible-playbook -i inventory.ini --vault-password-file ../vault_password_file playbook.yml