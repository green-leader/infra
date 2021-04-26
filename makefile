download:
	ansible-galaxy collection install -r requirements.yml
	ansible-galaxy role install -r requirements.yml

cloudflare:
	ansible-playbook cloudflare.yml