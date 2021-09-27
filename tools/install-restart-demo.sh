#!/bin/bash

# Install restart-demo.sh into user's crontab

USERNAME="$1"
CRON_SCHEDULE="$2"

if [ -z "$USERNAME" ]
then
  echo "Missing username, install-restart-demo.sh username cron_schedule (install-restart-demo.sh root \"* * * * *\")"
  exit 1
fi

if [ -z "$CRON_SCHEDULE" ]
then
  echo "Missing cron_schedule, install-restart-demo.sh username cron_schedule (install-restart-demo.sh root \"* * * * *\")"
  exit 1
fi

mkdir -p /etc/cron.d

JOB_FILE="/etc/cron.d/restart-demo-job"

if test -f "$JOB_FILE"; then
    rm $JOB_FILE
fi

touch /etc/cron.d/restart-demo-job
echo "SHELL=/bin/sh" >> /etc/cron.d/restart-demo-job
echo "$CRON_SCHEDULE $USERNAME $(pwd)/restart-demo.sh >> $(pwd)/restart-demo.log" >> /etc/cron.d/restart-demo-job
echo "@reboot $USERNAME $(pwd)/restart-demo.sh >> $(pwd)/restart-demo.log" >> /etc/cron.d/restart-demo-job
