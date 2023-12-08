#!/bin/bash
while [ : ]
do
Version=$(curl --silent "https://github.com/DataDog/datadog-agent/releases" | grep -iE "DataDog/datadog-agent/tree/" | awk '{print $2}' | cut -c "35-40" | head -n1)

# Curl command
curl -X POST "https://http-intake.logs.datadoghq.com/api/v2/logs" -H "Accept: application/json" -H "Content-Type: application/json" -H "DD-API-KEY: ${DD_API_KEY}" -d @- << EOF
  {
    "ddtags": "env:Dev,version:1.0,source:bash",
    "host": "<hostname>",
    "ddsource": "Bash",
    "message": "Current Dataddog Agent version: $Version",
    "version": "$Version",
    "service": "agentChecker"
  }
EOF
sleep 3600
done
