##
## —————————————— NOVA - system-base ——————————————————————————————————————————————
##
SHELL=/bin/sh

.PHONY: help
help:
	@	echo  'Preparation:'
	@	echo  '   install-python      - Easy way to install python on a Debian system'
	@	echo  '   reload          		- Easy way to install python on a Debian system'
	@	echo  '   env                 - Easy way to prepare everything (venv, ssh keys, links)'
	@	echo  'Tests:'
	@	echo  '   tests-docker        - Easy way to test the role inside a Vagrant Docker'
	@	echo  '   tests-virtualbox 		- Easy way to test the role inside a Vagrant VirtualBox'
	@	echo  'Cleaning Up:'
	@	echo  '   clean               - Easy way to clean everything, like VM, cache, venv'

##
## —————————————— ENVIRONMENTS CONFIGURATION ——————————————————————————————————————
##
.PHONY: install-python
install-python:
	@ 	echo ""
	@ 	echo "******************************* PYTHON INSTALL ********************************"
	@	apt install -y python3 python3-pip python3-dev &&\
		echo "[  ${Green}OK${Color_Off}  ] ${Yellow}PYTHON${Color_Off}" || \
		echo "[${Red}FAILED${Color_Off}] ${Yellow}PYHTON${Color_Off}"

.PHONY: env
env:
	@echo "${BLUE}==> Setup local environment${COLOR_OFF}"
	@echo "******************************** ENV REQUIREMENTS ******************************"

	@[ -d "${PWD}/.direnv" ] || (echo "Venv not found: ${PWD}/.direnv" && exit 1)

	@pip3 install -U pip --no-cache-dir --quiet &&\
	echo "[  ${GREEN}OK${COLOR_OFF}  ] ${YELLOW}INSTALL${COLOR_OFF} pip3" || \
	echo "[${RED}FAILED${COLOR_OFF}] ${YELLOW}INSTALL${COLOR_OFF} pip3"

	@pip3 install -U wheel --no-cache-dir --quiet &&\
	echo "[  ${GREEN}OK${COLOR_OFF}  ] ${YELLOW}INSTALL${COLOR_OFF} wheel" || \
	echo "[${RED}FAILED${COLOR_OFF}] ${YELLOW}INSTALL${COLOR_OFF} wheel"

	@pip3 install -U setuptools --no-cache-dir --quiet && \
	echo "[  ${GREEN}OK${COLOR_OFF}  ] ${YELLOW}INSTALL${COLOR_OFF} setuptools" || \
	echo "[${RED}FAILED${COLOR_OFF}] ${YELLOW}INSTALL${COLOR_OFF} setuptools"

	@pip3 install -U --no-cache-dir -r "${PWD}/requirements.txt" --quiet && \
	echo "[  ${GREEN}OK${COLOR_OFF}  ] ${YELLOW}PIP REQUIREMENTS${COLOR_OFF}" || \
	echo "[${RED}FAILED${COLOR_OFF}] PIP REQUIREMENTS"

	@echo "***************************** ANSIBLE REQUIREMENTS *****************************"
	@ansible-galaxy install -fr ${PWD}/requirements.yml && \
	echo "[  ${GREEN}OK${COLOR_OFF}  ] ${YELLOW}ANSIBLE-GALAXY REQUIREMENTS${COLOR_OFF}" || \
	echo "[${RED}FAILED${COLOR_OFF}] ${YELLOW}ANSIBLE-GALAXY REQUIREMENTS${COLOR_OFF}"

.PHONY: header
header:
	@echo "******************************* ONEDEV MAKEFILE ********************************"
	@echo "HOSTNAME	`uname -n`"
	@echo "KERNEL RELEASE 	`uname -r`"
	@echo "KERNEL VERSION 	`uname -v`"
	@echo "PROCESSOR	`uname -m`"
	@echo "********************************************************************************"

##
## —————————————— ANSIBLE VBOX TESTS ——————————————————————————————————————————————
##
.PHONY: tests-virtualbox-install
tests-virtualbox-install: header
	@echo "${BLUE}Tests in VirtualBox environment${COLOR_OFF}"
	@export ANSIBLE_TAGS="onedev_install" &&\
	cd $(TEST_VIRTUALBOX_DIRECTORY) && vagrant up && vagrant provision

.PHONY: tests-virtualbox-uninstall
tests-virtualbox-uninstall: header
	@echo "${BLUE}Tests in VirtualBox environment${COLOR_OFF}"
	@export ANSIBLE_TAGS="onedev_uninstall" &&\
	cd $(TEST_VIRTUALBOX_DIRECTORY) && vagrant up && vagrant provision

##
## —————————————— CLEAN ENVIRONMENT ———————————————————————————————————————————————
##

.PHONY: clean
clean: header
	@	echo ""
	@	echo "*********************************** CLEAN UP ***********************************"
	@	if test -d $(TEST_DOCKER_DIRECTORY)/.vagrant; \
			then cd $(TEST_DOCKER_DIRECTORY) && vagrant destroy -f && vagrant global-status --prune; \
			rm -rf $(TEST_DOCKER_DIRECTORY)/.vagrant; \
		fi
	@ 	if test -d $(TEST_VIRTUALBOX_DIRECTORY)/.vagrant; \
			then cd $(TEST_VIRTUALBOX_DIRECTORY) && vagrant destroy -f && vagrant global-status --prune; \
			rm -rf $(TEST_VIRTUALBOX_DIRECTORY)/.vagrant; \
		fi
	@ 	if test -d $(TEST_DOCKER_DIRECTORY)/secrets; \
			then rm -rf $(TEST_DOCKER_DIRECTORY)/secrets; \
		fi
	@ 	if test -d $(TEST_VIRTUALBOX_DIRECTORY)/secrets; \
			then rm -rf $(TEST_VIRTUALBOX_DIRECTORY)/secrets; \
		fi
	rm -rf .direnv
	