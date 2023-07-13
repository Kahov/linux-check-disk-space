#!/bin/bash

# Set the threshold for disk space usage (in percentage)
THRESHOLD=90
THRESHOLD_LOW=90
THRESHOLD_HIGH=95
# Get the disk space usage (in percentage) for the root filesystem
DISK_USAGE=$(df -h / | awk 'NR==2{print $5}' | cut -d'%' -f1)

# Check if the disk space usage is between 90% and 95%
if [ $DISK_USAGE -gt $THRESHOLD_LOW ] && [ $DISK_USAGE -le $THRESHOLD_HIGH ]; then
  # Send a message to Slack using webhook URL
  SLACK_WEBHOOK_URL="https://hooks.slack.com/services/xxx/xxx/xxxx"
  SLACK_MESSAGE="<@user> https://example.com a Disk space usage is at  ${DISK_USAGE}%."
  curl -k -X POST -H 'Content-type: application/json' --data "{\"text\":\"$SLACK_MESSAGE\"}" $SLACK_WEBHOOK_URL
fi

# Check if the disk space usage is above the threshold high
if [ $DISK_USAGE -gt $THRESHOLD_HIGH ]; then
  # Send a message to Slack using webhook URL
  SLACK_WEBHOOK_URL="https://hooks.slack.com/services/xxx/xxx/xxx"
  SLACK_MESSAGE="<@user> https://example.com Disk space usage is at ${DISK_USAGE}%"
  curl -k -X POST -H 'Content-type: application/json' --data "{\"text\":\"$SLACK_MESSAGE\"}" $SLACK_WEBHOOK_URL
   # Send an email using Mailgun
  MAILGUN_API_KEY="xxxx"
  MAILGUN_DOMAIN="example.com"
  EMAIL_SENDER="diskspace-bot@example.com"
  EMAIL_RECIPIENT="support@example.com"
  EMAIL_SUBJECT="Disk Space Alert for example.com"
  EMAIL_MESSAGE="Disk space usage is above 95%. Current usage is at ${DISK_USAGE}%. Please review server."
  curl -s --user "api:$MAILGUN_API_KEY" \
    https://api.mailgun.net/v3/$MAILGUN_DOMAIN/messages \
    -F from="$EMAIL_SENDER" \
    -F to="$EMAIL_RECIPIENT" \
    -F subject="$EMAIL_SUBJECT" \
    -F text="$EMAIL_MESSAGE"
fi
