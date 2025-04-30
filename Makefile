run:
	cd terraform && terraform apply
	cd ansible && bash generate-inventory.sh > inventory.ini
	cd ansible && ansible-playbook -i inventory.ini playbook.yml