# ansible-role-onedev

This role has goal to install & configure onedev bare-metal server  

what the role permit ?  
- Install one-dev server  
- Uninstall one-dev server  

## Variables (defaults)

* ``onedev_required_apt_packages``: required APT packages 

* ``onedev_required_jar_modules``: list of additionnal jar modules to add  

* ``onedev_db_method``: set the type of database for Onedev installation; can be "*hsqldb*" or "*mariadb*"  
* ``onedev_db_name``: name of the database  
* ``onedev_db_username``: username of the database  
* ``onedev_db_password``: password of the database  
* ``onedev_db_host``: host of the database (not required for *hsqldb* db type)  

* ``onedev_build``: build version of the onedev package  
* ``onedev_version``: tag of the onedev package  
* ``onedev_package_url``: url to download onedev package  
* ``onedev_destination_directory``: destination where the package will be unarchive  
* ``onedev_installation_directory``: destination of the onedev install directory (after unarchive)     
* ``onedev_bin_server_app_long_name``: application long name
* ``onedev_bin_server_pass_to_wrapper``: pass APPNAME & APPLONGNAME variables to the wrapper   
* ``onedev_bin_server_wrapper_cmd``: path to the wrapper  
* ``onedev_bin_server_wrapper_conf``: path to the wrapper conf
* ``onedev_bin_server_priority``: priority at which to run the wrapper  
* ``onedev_bin_server_piddir``: location of the pid file  
* ``onedev_bin_server_pidfile_check_pid``: tells the script to double check whether the pid in the pid file actually exists and belongs to this application  
* ``onedev_bin_server_ignore_signals``: causes the Wrapper to be (or not) shutdown using an anchor file  
* ``onedev_bin_server_wait_after_startup``: wait for the wrapper to report that the daemon has started   
* ``onedev_bin_server_wait_for_started_timeout``: time to wait before sending timeout error    
* ``onedev_bin_server_detail_status``: print status detail from wrapper and java processes  
* ``onedev_bin_server_pausable``: enable pause and resume command ; Make it possible to pause JVM or Java application without completely stopping the Wrapper  
* ``onedev_bin_server_pausable_mode``: set the mode used to 'pause' or 'resume' the Wrapper  
* ``onedev_bin_server_run_as_user``: if set, the Wrapper will be run as the specified user  
* ``onedev_bin_server_su_opts``: when RUN_AS_USER is set, the 'runuser' command will be used to substitute the user
* ``onedev_bin_server_brief_usage``: by default we show a detailed usage block.  Uncomment to show brief usage
* ``onedev_bin_server_service_management_tool``: set which service management tool to use  
* ``onedev_bin_server_systemd_killmode``: specify how the Wrapper daemon and its child processes should be killed
* ``onedev_bin_server_plist_domain``: when installing on Mac OSX platforms, the following domain will be used to prefix the plist file name
* ``onedev_bin_server_macosx_keep_running``: When installing on Mac OSX platforms, this parameter controls whether the daemon is to be kept continuously running
* ``onedev_bin_server_run_level``: Set run level to use when installing the application to start and stop on system startup and shutdown

## Variables (vars)
* ``__onedev_bin_server_app_name``: application name  
* ``__onedev_systemd_service_file``: systemd service file  

## Execution testing

You can find an example of database configuration in tests/virtualbox directory  

### Prepare environment
```
sudo apt-get update && sudo apt-get install -y direnv make zip tar mkdir curl chmod rm  
if [ ! "$(grep -ir "direnv hook bash" ~/.bashrc)" ]; then echo 'eval "$(direnv hook bash)"' >> ~/.bashrc; fi && direnv allow . && source ~/.bashrc  
make install-python  
make env  
```

/!\ You have to install virtual box to be able to execute vargant virtual box testing /!\  

Vagrant docker testing will coming soon   

### Virtual box environment
```
make tests-vbox-install  
make tests-vbox-uninstall  
```
## Clean up environment

``make clean``  

## Display help
``make help``
