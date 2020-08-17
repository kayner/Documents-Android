#!/bin/bash

# Unicode-emoji message status
t="\033[1mStatus:\033[0m \U1F7E2 \033[1mMessage:\033[0m"
f="\033[1mStatus:\033[0m \U1F534\033[1m Message:\033[0m"

# Project directory
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Stop adb server to free up tcp:127.0.0.1:5037
server_status=$(adb kill-server 2>&1)

# Check tcp:127.0.0.1:5037 status
if [[ -z $server_status ]]; then
  echo -e "$t Adb server on \033[4mtcp:127.0.0.1:5037\033[0m has been stopped"
else 
  if [[ $server_status == "cannot connect to daemon at tcp:5037: Connection refused" ]]; then
    echo -e "$t Address \033[4mtcp:127.0.0.1:5037\033[0m is already empty"
  else
    echo -e "$f $server_status"; exit 1
  fi
fi

# Stop docker-compose
docker_compose="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && docker-compose down)"
echo -e "$t Done"
