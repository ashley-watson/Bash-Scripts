#!/bin/bash
~
# Begin ~30 minute loop
while [ : ]
do
~
# Setting the version
StartTime=$(date +%s)
Version=$(curl --silent "https://github.com/DataDog/datadog-agent/releases" | grep -iE "DataDog/datadog-agent/tree/" | awk '{print $2}' | cut -c "35-40" | head -n1)
armSha=$(curl -s https://apt.datadoghq.com/dists/stable/7/binary-arm64/Packages | sed -n '/^Package: datadog-agent$/,/SHA256:*/p' | grep -vwi "dbg\|heroku\|iot\|license\|dogstatsd\|architecture\|recommends\|section\|priority\|filename\|installed-size\|size\|sha1\|maintainer\|homepage\|vendor" | tail -n 1 | awk '{print $2}')
amdSha=$(curl -s https://apt.datadoghq.com/dists/stable/7/binary-amd64/Packages | sed -n '/^Package: datadog-agent$/,/SHA256:*/p' | grep -vwi "dbg\|heroku\|iot\|license\|dogstatsd\|architecture\|recommends\|section\|priority\|filename\|installed-size\|size\|sha1\|maintainer\|homepage\|vendor" | tail -n 1 | awk '{print $2}')shley:

# Curl command to send in version to Datadog as log
curl -X POST "https://http-intake.logs.datadoghq.com/api/v2/logs" -H "Accept: application/json" -H "Content-Type: application/json" -H "DD-API-KEY: ${DD_API_KEY}" -d @- << EOF
  {
    "ddtags": "env:KRDev,source:bash",
    "host": "Upheaval",
    "ddsource": "Bash",
    "message": "\\\\\\\\Current Datadog Agent Release\/\/\nVersion: $Version \n\nSha256 Hashes\nAMD: $amdSha\nARM: $armSha",
    "version": "$Version",
    "service": "agentChecker"
  }
EOF

# Setting end time to allow duration calculation
EndTime=$(date +%s)

# Tracing the script to send to Datadog
duration=$(($EndTime-$StartTime))
spanId=$(date +%s)
traceId=$(date +%s)

curl -X PUT "http://localhost:8126/v0.3/traces" \
-H "Content-Type: application/json" \
-d @- << EOF
[
  [
    {
      "duration": $duration,
      "name": "versionCheck",
      "resource": "/agentChecker",
      "service": "agent_checker",
      "span_id": $spanId,
      "trace_id": $traceId,
      "type": "custom"
    }
  ]
]
EOF

# Wait ~30 minutes
sleep 1750
done
