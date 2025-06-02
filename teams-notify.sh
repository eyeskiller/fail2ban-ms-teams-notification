#!/bin/bash

# Fail2Ban vars
JAIL="$1"
IP="$2"
FAILURES="$3"

# Server name
HOSTNAME=$(hostname)

# Lookup IP info
INFO=$(curl -s "https://ipinfo.io/${IP}/json")

COUNTRY=$(echo "$INFO" | jq -r '.country // "Unknown"')
CITY=$(echo "$INFO" | jq -r '.city // "Unknown"')
ORG=$(echo "$INFO" | jq -r '.org // "Unknown"')

# Webhook
WEBHOOK="<webhook>"  # <-- Replace with your webhook

curl -X POST -H "Content-Type: application/json" -d "{
  \"@type\": \"MessageCard\",
  \"@context\": \"http://schema.org/extensions\",
  \"themeColor\": \"0078D7\",
  \"summary\": \"Fail2Ban Alert\",
  \"sections\": [{
    \"activityTitle\": \"🚨 **Fail2Ban Alert**\",
    \"activitySubtitle\": \"🔐 Server: **${HOSTNAME}** | Jail: **${JAIL}**\",
    \"facts\": [
      {\"name\": \"🔒 Banned IP:\", \"value\": \"${IP}\"},
      {\"name\": \"📊 Attempts:\", \"value\": \"${FAILURES}\"},
      {\"name\": \"🌍 Location:\", \"value\": \"${CITY}, ${COUNTRY}\"},
      {\"name\": \"🏢 ISP:\", \"value\": \"${ORG}\"}
    ],
    \"markdown\": true
  }]
}" "$WEBHOOK"
