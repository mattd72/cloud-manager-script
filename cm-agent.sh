#!/bin/bash

curl -OL https://cloud.mongodb.com/download/agent/automation/mongodb-mms-automation-agent-13.23.0.9131-1.amazon2023_x86_64.tar.gz
tar -xvf mongodb-mms-automation-agent-13.23.0.9131-1.amazon2023_x86_64.tar.gz
cd mongodb-mms-automation-agent-13.23.0.9131-1.amazon2023_x86_64

# Create automation-agent.config

sudo cat << EOF sudo local.config
#
# REQUIRED
# Enter your Project ID - It can be found at https://cloud.mongodb.com/settings/group
#
mmsGroupId=


#
# REQUIRED
# Enter your API key - It can be found at https://cloud.mongodb.com/settings/group
#
mmsApiKey=


#
# Base url of the MMS web server.
#
mmsBaseUrl=https://api-agents.mongodb.com

#
# Path to log file
#
logFile=/var/log/mongodb-mms-automation/automation-agent.log

#
# Path to backup cluster config to
#
mmsConfigBackup=/var/lib/mongodb-mms-automation/mms-cluster-config-backup.json

#
# Lowest log level to log.  Can be (in order): DEBUG, ROUTINE, INFO, WARN, ERROR, DOOM
#
logLevel=INFO

#
# Maximum number of rotated log files
#
maxLogFiles=10

#
# Maximum size in bytes of a log file (before rotating)
#
maxLogFileSize=268435456

#
# URL to proxy all HTTP requests through
#
#httpProxy=

# For additional optional settings, please see
# https://docs.cloudmanager.mongodb.com/reference/mongodb-agent-settings/index.html
EOF

sudo mkdir /var/lib/mongodb-mms-automation
sudo mkdir /var/log/mongodb-mms-automation
sudo mkdir -p /data
sudo chown `whoami` /var/lib/mongodb-mms-automation
sudo chown `whoami` /var/log/mongodb-mms-automation
sudo chown `whoami` /data

sudo yum -y install cyrus-sasl cyrus-sasl-gssapi \
     cyrus-sasl-plain krb5-libs libcurl net-snmp \
     net-snmp-libs openldap openssl xz-libs --skip-broken

nohup /bin/bash -c "./mongodb-mms-automation-agent --config=local.config 2>&1 | ./fatallogger -logfile /var/log/mongodb-mms-automation/automation-agent-fatal.log" 2>&1 > /dev/null &
