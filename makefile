download:
	# this is required for the google cloud platform
	pip3 install --user requests google-auth
	ansible-galaxy collection install -r requirements.yml
	ansible-galaxy role install -r requirements.yml

cloudflare:
	ansible-playbook cloudflare.yml

gcp:
	ANSIBLE_SSH_EXECUTABLE=./gcp-ssh-wrapper.sh ANSIBLE_SCP_EXECUTABLE=./gcp-scp-wrapper.sh ansible-playbook -i hosts -i hosts.gcp.yml gcp.yml

gcp_provision:
	ANSIBLE_SSH_EXECUTABLE=./gcp-ssh-wrapper.sh ANSIBLE_SCP_EXECUTABLE=./gcp-scp-wrapper.sh ansible-playbook -i hosts -i hosts.gcp.yml gcp_provision.yml

gcloud:
ifneq ($(shell test -e ./google-cloud-sdk && echo -n yes), yes)
	curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-337.0.0-linux-x86_64.tar.gz
	tar xvf google-cloud*.tar.gz
	rm google-cloud*.tar.gz
	./google-cloud-sdk/bin/gcloud auth activate-service-account ansible@wireguard-server-309914.iam.gserviceaccount.com --key-file=./service_account.json
endif

do:
	ansible-playbook --ask-become-pass do.yml