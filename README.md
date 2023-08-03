
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Low Disk Space on RabbitMQ
---

This incident type refers to an alert triggered when the available disk space on RabbitMQ is low. This can be caused by an overload of messages or persistent messages that are being mismanaged. It is important to resolve this issue promptly to ensure the proper functioning of RabbitMQ and avoid any potential downtime.

### Parameters
```shell
# Environment Variables

export RABBITMQ_CONFIG_FILE="PLACEHOLDER"

export RABBITMQ_ERROR_LOG="PLACEHOLDER"

export RABBITMQ_HOST="PLACEHOLDER"

export RABBITMQ_PORT="PLACEHOLDER"

export RABBITMQ_USER="PLACEHOLDER"

export RABBITMQ_PASSWORD="PLACEHOLDER"
```

## Debug

### Check disk usage for the partition where RabbitMQ is installed
```shell
df -h 
```

### Check the size of the RabbitMQ data directory
```shell
du -sh /opt/rabbitmq/data
```

### Check the size of the RabbitMQ message queue
```shell
sudo rabbitmqctl list_queues name messages_ready messages_unacknowledged
```

### Check the size of the RabbitMQ log files
```shell
ls -lh /opt/rabbitmq/logs
```

### Check the RabbitMQ configuration file for disk space related settings
```shell
cat ${RABBITMQ_CONFIG_FILE} | grep disk
```

### Check the RabbitMQ process status
```shell
sudo systemctl status rabbitmq-server
```

### Check the RabbitMQ error log for disk space related errors
```shell
sudo cat ${RABBITMQ_ERROR_LOG} | grep disk
```

### Check the system log for disk related errors
```shell
sudo cat /var/log/syslog | grep disk
```

### Check if there are any old or unused files that can be deleted to free up space
```shell
sudo find / -xdev -type f -atime +30 -size +10M -exec ls -lh {} \;
```

## Repair

### Identify any messages or persistent messages that are being mismanaged and take action to resolve the issue (e.g., delete unnecessary messages, optimize message storage).
```shell


#!/bin/bash



# Set variables

RABBITMQ_HOST=${RABBITMQ_HOST}

RABBITMQ_PORT=${RABBITMQ_PORT}

RABBITMQ_USER=${RABBITMQ_USER}

RABBITMQ_PASSWORD=${RABBITMQ_PASSWORD}



# Identify messages or persistent messages that are being mismanaged

rabbitmqctl list_queues | while read line

do

    queue=$(echo $line | awk '{print $1}')

    messages=$(echo $line | awk '{print $2}')

    if [ $messages -gt 1000 ]; then

        echo "Queue $queue has $messages messages"

        # Take action to resolve the issue (e.g., delete unnecessary messages, optimize message storage)

        rabbitmqadmin -H $RABBITMQ_HOST -P $RABBITMQ_PORT -u $RABBITMQ_USER -p $RABBITMQ_PASSWORD delete queue name=$queue

        echo "Deleted queue $queue"

    fi

done


```