#!/bin/bash
# Discord Thread Reply Script
# Usage: ./scripts/discord-thread-reply.sh "channel_id" "message_id" "thread_name" "reply_message"

set -e

CHANNEL_ID="$1"
MESSAGE_ID="$2"
THREAD_NAME="$3"
REPLY_MESSAGE="$4"

# Load secrets
source /Users/ludi/clawd/scripts/load-secrets.sh

# Create thread
THREAD_RESPONSE=$(curl -s -X POST \
  -H "Authorization: Bot $DISCORD_BOT_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"name\":\"$THREAD_NAME\",\"auto_archive_duration\":1440}" \
  "https://discord.com/api/v10/channels/$CHANNEL_ID/messages/$MESSAGE_ID/threads")

THREAD_ID=$(echo $THREAD_RESPONSE | jq -r '.id')

if [ "$THREAD_ID" = "null" ]; then
    echo "Error: Failed to create thread"
    echo $THREAD_RESPONSE
    exit 1
fi

# Send reply in thread
curl -s -X POST \
  -H "Authorization: Bot $DISCORD_BOT_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"content\":\"$REPLY_MESSAGE\"}" \
  "https://discord.com/api/v10/channels/$THREAD_ID/messages" > /dev/null

echo "Thread created and reply sent: https://discord.com/channels/1475490746474696819/$CHANNEL_ID/$THREAD_ID"
