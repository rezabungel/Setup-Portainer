PYTHON = python3.10
VENV = venv
ANSIBLE_PATH = ansible
ANSIBLE_CONFIG = $(ANSIBLE_PATH)/ansible.cfg
PLAYBOOK = $(ANSIBLE_PATH)/playbook.yaml
PRIVATE_KEY ?= ~/.ssh/ansible_key
ANSIBLE_OPTS ?=

.PHONY: setup ping run clean

setup:
	$(PYTHON) -m venv $(VENV)
	$(VENV)/bin/pip install --upgrade pip
	$(VENV)/bin/pip install -r requirements.txt

ping:
ifndef GROUP
	$(error "Please specify GROUP, e.g., make ping GROUP=all")
endif
	ANSIBLE_CONFIG=$(ANSIBLE_CONFIG) \
	$(VENV)/bin/ansible $(GROUP) -m ping --private-key $(PRIVATE_KEY) $(ANSIBLE_OPTS)

run:
ifndef GROUP
	$(error "Please specify GROUP, e.g., make run GROUP=dev")
endif
	ANSIBLE_CONFIG=$(ANSIBLE_CONFIG) \
	$(VENV)/bin/ansible-playbook $(PLAYBOOK) \
	-e "target_group=$(GROUP)" \
	--private-key $(PRIVATE_KEY) \
	$(ANSIBLE_OPTS)

clean:
	rm -rf $(VENV)
