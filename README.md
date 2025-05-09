### Hexlet tests and linter status:
[![Actions Status](https://github.com/tomirisarman/devops-for-programmers-project-77/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/tomirisarman/devops-for-programmers-project-77/actions)

Requirements:
- Docker
- Ansible
- Terraform


Prepare a file with vault password:
```
make prepare-vault-file VAULT_PASSWORD={type_password_here}
```

Run deploy (terraform and ansible):
```
make run
```

<h4>Additional commands:</h4>

Edit ansible secrets use:
```
make ansible-edit-secrets
```

Apply only terraform:
```
make run-terraform
```

Apply only ansible:
```
make run-ansible
```

Project link: http://redmine76.space/
