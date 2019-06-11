#!/usr/bin/bash

echo ''
echo '======================================='
echo 'STOPPING CLUSTER'
echo '======================================='

pgrep -n -f "java -D\[Standalone\]" | xargs kill -15
sleep 2
pgrep -n -f "java -D\[Standalone\]" | xargs kill -15
sleep 2
pgrep -n -f "java -D\[Standalone\]" | xargs kill -15
sleep 2
pgrep -n -f "java -D\[Standalone\]" | xargs kill -15
sleep 2

echo ''
echo '======================================='
echo 'END'
echo '======================================='
