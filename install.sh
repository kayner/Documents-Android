#!/bin/bash

dir_list=('apk' 'data' 'logs/adb' 'logs/builds' 'logs/reports')

for d in "${dir_list[@]}"; do
  mkdir -p -v $d
done

chmod +x run.sh