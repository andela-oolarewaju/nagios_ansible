# Ansible script for Nagios on Ubuntu 14

Clone this repo: 

```git clone https://github.com/andela-oolarewaju/nagios_ansible.git ```

Then:

```$ cd nagios_ansible```

Create a ```vars.yml``` file and put the following variables like:
```
nagios_source_code_url: ""
nagios_plugin_url: ""
nrpe_url: ""
nagios_private_ip: ""
nagios_version: ""
nagios_plugin_version: ""
nrpe_version: ""
email: ""
nagios_password: ""
```

This file **SHOULD NOT** be public

Replace the IP in the `inventory.ini` file with the public ip of your nagios server

**RUN** `ansible-playbook -i inventory.ini --private-key=PATH/TO/NAGIOS/SERVER/PRIVATE/KEY -u ubuntu playbook.main.yml` to run the scripts 

**TO TEST**

Create a `vars.rb file in the `features/step_definitions/ directory and add the variables that our tests will need:

```
PATHTOPRIVATEKEY: ""
CONTACTEMAIL: ""
AWSPUBDNS: ""
```

Then run `cucumber features/install.feature`
