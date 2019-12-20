#!/usr/bin/bash

echo ''
echo '======================================='
echo 'STOPPING CLUSTER'
echo '======================================='

pgrep -n -f "java -D\[Standalone\]" | xargs kill -15
pgrep -n -f "java -D\[Standalone\]" | xargs kill -15
pgrep -n -f "java -D\[Standalone\]" | xargs kill -15
pgrep -n -f "java -D\[Standalone\]" | xargs kill -15
sleep 3
pgrep -n -f "java -D\[Standalone\]" | xargs kill -9
pgrep -n -f "java -D\[Standalone\]" | xargs kill -9
pgrep -n -f "java -D\[Standalone\]" | xargs kill -9
pgrep -n -f "java -D\[Standalone\]" | xargs kill -9

echo ''
echo '======================================='
echo 'STOPPING DB'
echo '======================================='
podman stop mysql
podman stop sybase

echo ''
echo '======================================='
echo 'END'
echo '======================================='


