#### Variables ####

export ROOT_DIR ?= $(PWD)
export AETHER_ROOT_DIR ?= $(ROOT_DIR)

export 5GC_ROOT_DIR ?= $(AETHER_ROOT_DIR)/deps/5gc
export AMP_ROOT_DIR ?= $(AETHER_ROOT_DIR)/deps/amp
export GNBSIM_ROOT_DIR ?= $(AETHER_ROOT_DIR)/deps/gnbsim
export K8S_ROOT_DIR ?= $(5GC_ROOT_DIR)/deps/k8s

export ANSIBLE_NAME ?= ansible-aether
export ANSIBLE_CONFIG ?= $(AETHER_ROOT_DIR)/ansible.cfg
export HOSTS_INI_FILE ?= $(AETHER_ROOT_DIR)/hosts.ini

export EXTRA_VARS ?= "@$(AETHER_ROOT_DIR)/vars/main.yml"


#### Start Ansible docker ####

ansible:
	export ANSIBLE_NAME=$(ANSIBLE_NAME); \
	sh $(AETHER_ROOT_DIR)/scripts/ansible ssh-agent bash

aether-pingall:
	echo $(AETHER_ROOT_DIR)
	ansible-playbook -i $(HOSTS_INI_FILE) $(AETHER_ROOT_DIR)/pingall.yml \
		--extra-vars "ROOT_DIR=$(ROOT_DIR)" --extra-vars $(EXTRA_VARS)

#### Provision AETHER ####

aether-install:
	$(MAKE) 5gc-install;
	$(MAKE) gnbsim-simulator-setup-install

aether-uninstall: monitor-uninstall roc-uninstall gnbsim-simulator-setup-uninstall 5gc-uninstall

resetcore: 
	$(MAKE) 5gc-core-uninstall;
	sleep 5.0;
	$(MAKE) 5gc-core-install;

# Rules:

#	5gc-install: k8s-install 5gc-router-install 5gc-core-install
#	5gc-uninstall: 5gc-core-uninstall 5gc-router-uninstall k8s-uninstall

##   run gnbsim-docker-install before running setup
# 	gnbsim-simulator-setup-install: gnbsim-docker-router-install gnbsim-docker-start 
# 	gnbsim-simulator-setup-uninstall:  gnbsim-docker-stop gnbsim-docker-router-uninstall

###  Provision k8s ####
#	k8s-install
#	k8s-uninstall

### Provision router ####
#	5gc-router-install
#	5gc-router-uninstall

### Provision core ####
#	5gc-core-install
#	5gc-core-uninstall


### Provision  AMP ####
# amp-install: k8s-install roc-install 5g-roc-install monitor-install 
# amp-uninstall: monitor-uninstall roc-uninstall k8s-uninstall

### Provision ROC ###
# roc-install
# roc-uninstall

### Provision 5G-ROC ###
# 5g-roc-install
# 5g-roc-uninstall

### Provision Monitoring ###
# monitor-install
# monitor-uninstall

### Provision gnbsim ###
# 	gnbsim-docker-install
# 	gnbsim-docker-uninstall

# 	gnbsim-docker-router-install:
# 	gnbsim-docker-router-uninstall:

# 	gnbsim-docker-start
# 	gnbsim-docker-stop

### Simulation ###
# 	gnbsim-simulator-start


#include at the end so rules are not overwritten
include $(K8S_ROOT_DIR)/Makefile
include $(GNBSIM_ROOT_DIR)/Makefile
include $(5GC_ROOT_DIR)/Makefile
include $(AMP_ROOT_DIR)/Makefile