Feature: Setup LAMP as Nagios Prerequisite
  
  Scenario: 
    When I install Apache
    Then it should be successful
    And Apache should be running
    And it should be accepting connections on Port 80

  Scenario:
    When I install MySQL
    Then it should be successful
    And MySQL should be running
    And it should be accepting connections on Port 3306
  
  Scenario:
    When I install PHP
    Then it should be successful

  Scenario:
    When I create a group
    Then it should be successful
    And I add a user to a group
    Then it should be successful

  Scenario:
    When I install nagios dependencies
    Then it should be successful
    When I download  and extract nagios source code
    Then it should be successful

  Scenario:
    When I configure nagios
    Then it should be successful

  Scenario:
    When I compile nagios
    Then it should be successful

  Scenario:
    When I add web server to group
    Then it should be successful

  Scenario:
    When I download and extract nagios plugin file
    Then it should be successful

  Scenario:
    When I configure nagios plugins
    Then it should be successful

  Scenario:
    When I compile and install nagios plugins
    Then it should be successful

  Scenario:
    When I download and extract nrpe file
    Then it should be successful

  Scenario:
    When I configure nrpe
    Then it should be successful

  Scenario:
    When I compile and install nrpe
    Then it should be successful

  Scenario:
    When I add server ip address
    Then it should be successful
    And I restart xinetd service

  Scenario:
    When I set config directory
    Then config directory should be set

  Scenario:
    When I copy host config file
    Then it should be successful

  Scenario:
    When I add email to contacts config
    Then it should be successful
    And email should exist

  Scenario:
    When I add check_nrpe command
    Then it should be successful

  Scenario:
    When I add check_ping command
    Then it should be successful

  Scenario:
    When I add check_http command 
    Then it should be successful

  Scenario:
    When I add check_memory command
    Then it should be successful

  Scenario:
    When I add check_netio command
    Then it should be successful

  Scenario:
    When I create nagios user and password
    Then it should exist in password file
