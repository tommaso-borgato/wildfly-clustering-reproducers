#!/usr/bin/bash

echo ''
echo '======================================='
echo 'STOPPING CLUSTER'
echo '======================================='

pgrep -n -f "java -D\[Standalone\]" | xargs kill -15
sleep 3
pgrep -n -f "java -D\[Standalone\]" | xargs kill -15
sleep 3
pgrep -n -f "java -D\[Standalone\]" | xargs kill -15
sleep 3
pgrep -n -f "java -D\[Standalone\]" | xargs kill -15
sleep 3
pgrep -n -f "java -D\[Standalone\]" | xargs kill -9
sleep 3
pgrep -n -f "java -D\[Standalone\]" | xargs kill -9

echo ''
echo '======================================='
echo 'END'
echo '======================================='


