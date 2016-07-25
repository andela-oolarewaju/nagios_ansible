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
hostfilename: ""
monitored_server_address: ""
```

This file **SHOULD NOT** be public

Replace the IP and Path to private key in the `inventory.ini` file with the public ip and path to your private key of your nagios server

**RUN** `ansible-playbook -i inventory.ini --private-key=PATH/TO/NAGIOS/SERVER/PRIVATE/KEY -u ubuntu playbook.main.yml` to run the scripts 

**TO TEST**

Create a `vars.rb file in the `features/step_definitions/ directory and add the variables that our tests will need:

```
PATHTOPRIVATEKEY = ""
CONTACTEMAIL = ""
AWSPUBDNS = ""
```

Then run `cucumber features/install.feature`


# Monitor a Host with NRPE

Repeat this section for each server you wish to monitor.

On a server that you want to monitor, update apt-get:

`sudo apt-get update`

Now install Nagios Plugins and NRPE:

`sudo apt-get install nagios-plugins nagios-nrpe-server`

# Configure Allowed Hosts

Now, let's update the NRPE configuration file. Open it in your favorite editor 

`sudo vi /etc/nagios/nrpe.cfg`

Find the allowed_hosts directive, and add the private IP address of your Nagios server to the comma-delimited list (substitute it in place of the highlighted example):

`allowed_hosts=127.0.0.1, <NAGIOS_SERVER_IP> `

Save and exit. This configures NRPE to accept requests from your Nagios server, via its private IP address.

# Configure Allowed NRPE Commands

Look up the name of your root filesystem (because it is one of the items we want to monitor):

`df -h /`

We will be using the filesystem name in the NRPE configuration to monitor your disk usage (it is probably /dev/vda). Now open nrpe.cfg for editing:

`sudo vi /etc/nagios/nrpe.cfg`

The NRPE configuration file is very long and full of comments. There are a few lines that you will need to find and modify:

**server_address**: Set to the private IP address of this host
**allowed_hosts**: Set to the private IP address of your Nagios server
**command[check_hda1]**: Change /dev/hda1 to whatever your root filesystem is called.

The three aforementioned lines should look like this (substitute the appropriate values):

```
server_address=client_private_IP
allowed_hosts=nagios_server_private_IP
command[check_hda1]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/vda
```

Note that there are several other "commands" defined in this file that will run if the Nagios server is configured to use them. Also note that NRPE will be listening on port 5666 because server_port=5666 is set. If you have any firewalls blocking that port, be sure to open it to your Nagios server.

Save and quit.

# Restart NRPE

Restart NRPE to put the change into effect:

`sudo service nagios-nrpe-server restart`

Once you are done installing and configuring NRPE on the hosts that you want to monitor, you will have to add these hosts to your Nagios server configuration before it will start monitoring them.

# Add Host to Nagios Configuration

On your Nagios server, open your /usr/local/nagios/etc/nagios.cfg file and add a path to a file where we will define our host config. Change `yourhost` to the name of your host

`cfg_dir=/usr/local/nagios/etc/objects/yourhost.cfg`

On your Nagios server, create a new configuration file for each of the remote hosts that you want to monitor in /usr/local/nagios/etc/objects/. Replace the highlighted word, "yourhost", with the name of your host:

`sudo vi /usr/local/nagios/etc/servers/yourhost.cfg`

Add in the following host definition, replacing the host_name value with your remote hostname ("web-1" in the example), the alias value with a description of the host, and the address value with the private IP address of the remote host:

```
define host {

        use                             linux-server
        host_name                       yourhost
        alias                           My first Apache server
        address                         10.132.234.52
        max_check_attempts              5
        check_period                    24x7
        notification_interval           30
        notification_period             24x7
}

```

With the configuration file above, Nagios will only monitor if the host is up or down. If this is sufficient for you, save and exit then restart Nagios. If you want to monitor particular services, read on.

Add any of these service blocks for services you want to monitor. Note that the value of check_command determines what will be monitored, including status threshold values. Here are some examples that you can add to your host's configuration file:

Ping:

```
define service {
        use                             generic-service
        host_name                       yourhost
        service_description             PING
        check_command                   check_ping!100.0,20%!500.0,60%
}
```

SSH (notifications_enabled set to 0 disables notifications for a service):

```
define service {
        use                             generic-service
        host_name                       yourhost
        service_description             SSH
        check_command                   check_ssh
        notifications_enabled           0
}
```

If you're not sure what use generic-service means, it is simply inheriting the values of a service template called "generic-service" that is defined by default.

Now save and quit. Reload your Nagios configuration to put any changes into effect:

`sudo service nagios reload`

Once you are done configuring Nagios to monitor all of your remote hosts, you should be set. Be sure to access your Nagios web interface, and check out the Services page to see all of your monitored hosts and services.

# Conclusion

Now that you monitoring your hosts and some of their services, you might want to spend some time to figure out which services are critical to you, so you can start monitoring those. You may also want to set up notifications so, for example, you receive an email when your disk utilization reaches a warning or critical threshold or your main website is down, so you can resolve the situation promptly or before a problem even occurs.

Good luck!

Note: some of this readme is gotten from Digital Ocean.
