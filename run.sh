#!/bin/bash

# Unicode-emoji message status
t="\033[1mStatus:\033[0m \U1F7E2 \033[1mMessage:\033[0m"
f="\033[1mStatus:\033[0m \U1F534\033[1m Message:\033[0m"

# Project directory
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Adb logger path
adb_log_dir="$dir/logs/adb"
adb_log_file="adb_$(date +'%H_%M_%S_%d_%m_%Y').log"
adb_log_path="$adb_log_dir/$adb_log_file"
`mkdir -p $adb_log_dir`

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

# Run adb server in nodaemon mode and listen all interfaces
echo -e "$t Running adb server in nodaemon mode. Logs: \033[4m$adb_log_path\033[0m"
server=$(adb -a -P 5037 nodaemon server > $adb_log_path 2>&1 &)
echo -e "$t To stop the server, stop all emulators and run \033[1madb -P 5037 kill-server\033[0m"

# Deploy Selenium Grid with nodes using docker-compose
echo -e "$t Deploy Selenium Grid with nodes using docker-compose"
docker_compose="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && docker-compose --log-level CRITICAL up -d)"
