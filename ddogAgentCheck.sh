#!/bin/bash
Version=$(curl --silent "https://github.com/DataDog/datadog-agent/releases" | grep -iE "DataDog/datadog-agent/tree/" | awk '{print $2}' | cut -c "35-40" | head -n1)

curl -X POST "https://api.datadoghq.com/api/v1/events" -H "Accept: application/json" -H "Content-Type: application/json" -H "DD-API-KEY: ${DD_API_KEY}" -d @- << EOF
{
  "title": "Latest Agent release",
  "text": "Current agent release: $Version",
  "tags": [
    "env:KRDev",
    "service:agentChecker",
    "source:bash"
  ]
}
EOF
