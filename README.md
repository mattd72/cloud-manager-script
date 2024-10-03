# cloud-manager-script
#!/bin/bash

curl -OL https://cloud.mongodb.com/download/agent/automation/mongodb-mms-automation-agent-manager-13.22.1.9104-1.x86_64.rpm
sudo rpm -U mongodb-mms-automation-agent-manager-13.22.1.9104-1.x86_64.rpm

# Create automation-agent.config

cat << EOF sudo tee /etc/mongodb-mms/automation-agent.config
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

sudo mkdir -p /data
sudo chown mongod:mongod /data
sudo service mongodb-mms-automation-agent start
