#!/bin/bash

# Unicode-emoji message status
t="\033[1mStatus:\033[0m \U1F7E2 \033[1mMessage:\033[0m"
f="\033[1mStatus:\033[0m \U1F534\033[1m Message:\033[0m"

# Project directory
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Adb logger path
adb_log_dir="$dir/logs/adb"
adb_log_file="adb_$(date +'%d_%m_%Y_%H_%M_%S').log"
adb_log_path="$adb_log_dir/$adb_log_file"

# Build logger path
build_log_dir="$dir/logs/builds"
build_log_file="build_$(date +'%d_%m_%Y_%H_%M_%S').log"
build_log_path="$build_log_dir/$build_log_file"

docker_check=$(docker --version 2>&1 | grep version)
docker_compose_check=$(docker-compose --version 2>&1 | grep version)

if [ -z "$docker_check" ]; then
  echo -e "$f Docker is not found in the current environment"
  echo -e "$f Please install docker: https://docs.docker.com/get-docker/"
  exit 1
else
  echo -e "$t Docker found"
fi

if [ -z "$docker_compose_check" ]; then
  echo -e "$f Docker-compose is not found in the current environment"
  echo -e "$f Please install docker-compose: https://docs.docker.com/compose/install/"
  exit 1
else
  echo -e "$t Docker-compose found"
fi

docker_version_major=$(docker --version | cut -c 16-17)

if (( $docker_version_major < 19 )); then
  echo -e "$f Only docker newer version 19 is supported"
  echo -e "$f Please update docker"
  exit 1
else
  echo -e "$t Docker version 19+"
fi

docker_compose_version_major=$(docker-compose --version | cut -c 24-24)
docker_compose_version_minor=$(docker-compose --version | cut -c 26-27)

if (( $docker_compose_version_major < 1 || $docker_compose_version_minor < 26 )); then
  echo -e "$f Only docker-compose newer version 1.26.0 is supported"
  echo -e "$f Please update docker-compose"
  exit 1
else
  echo -e "$t Docker-compose version 1.26.0+"
fi

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

# Build appium image
echo -e "$t Building appium docker image"
build="$(docker build -f $dir/Dockerfile -t appium:local . > $build_log_path 2>&1)"

# Deploy Selenium Grid with nodes using docker-compose
echo -e "$t Deploy Selenium Grid with nodes using docker-compose"
docker_compose="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && docker-compose --log-level CRITICAL up -d)"

echo -e "$t Done"
