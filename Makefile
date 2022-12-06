##
## —————————————— ONEDEV ——————————————————————————————————————————————————————————
##
SHELL=/bin/sh

.PHONY: help
help: ## Display help
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | sed -e 's/Makefile://' | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-22s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

##
## —————————————— ENVIRONMENTS CONFIGURATION ——————————————————————————————————————
##
.PHONY: install-python
install-python: ## Easy way to install python
	@ 	echo ""
	@ 	echo "******************************* PYTHON INSTALL ********************************"
	@	apt install -y python3 python3-pip python3-dev &&\
		echo "[  ${Green}OK${Color_Off}  ] ${Yellow}PYTHON${Color_Off}" || \
		echo "[${Red}FAILED${Color_Off}] ${Yellow}PYHTON${Color_Off}"

.PHONY: env
env: ## Easy way to configure which direnv can't
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
header: ## Display some machine kernel informations
	@echo "******************************* ONEDEV MAKEFILE ********************************"
	@echo "HOSTNAME	`uname -n`"
	@echo "KERNEL RELEASE 	`uname -r`"
	@echo "KERNEL VERSION 	`uname -v`"
	@echo "PROCESSOR	`uname -m`"
	@echo "********************************************************************************"

##
## —————————————— ANSIBLE VBOX TESTS ——————————————————————————————————————————————
##
.PHONY: tests-vbox-install
tests-vbox-install: header ## Testing onedev baremetal install task in virtualbox environments
	@echo "${BLUE}Tests in vbox environment${COLOR_OFF}"
	@export ANSIBLE_TAGS="onedev_install" &&\
	cd $(TEST_VBOX_DIRECTORY) && vagrant up && vagrant provision

.PHONY: tests-vbox-uninstall
tests-vbox-uninstall: header ## Testing onedev baremetal uninstall task in virtualbox environments
	@echo "${BLUE}Tests in vbox environment${COLOR_OFF}"
	@export ANSIBLE_TAGS="onedev_uninstall" &&\
	cd $(TEST_VBOX_DIRECTORY) && vagrant up && vagrant provision

##
## —————————————— CLEAN ENVIRONMENT ———————————————————————————————————————————————
##

.PHONY: clean
clean: header ## Clean environment
	@	echo ""
	@	echo "*********************************** CLEAN UP ***********************************"
	@	if test -d $(TEST_DOCKER_DIRECTORY)/.vagrant; \
			then cd $(TEST_DOCKER_DIRECTORY) && vagrant destroy -f && vagrant global-status --prune; \
			rm -rf $(TEST_DOCKER_DIRECTORY)/.vagrant; \
		fi
	@ 	if test -d $(TEST_VBOX_DIRECTORY)/.vagrant; \
			then cd $(TEST_VBOX_DIRECTORY) && vagrant destroy -f && vagrant global-status --prune; \
			rm -rf $(TEST_VBOX_DIRECTORY)/.vagrant; \
			rm -rf *.log;  \
		fi
	@ 	if test -d $(TEST_DOCKER_DIRECTORY)/secrets; \
			then rm -rf $(TEST_DOCKER_DIRECTORY)/secrets; \
		fi
	@ 	if test -d $(TEST_VBOX_DIRECTORY)/secrets; \
			then rm -rf $(TEST_VBOX_DIRECTORY)/secrets; \
		fi
