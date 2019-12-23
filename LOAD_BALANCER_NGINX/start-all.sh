#!/usr/bin/bash

startNGINX(){
  echo ''
  echo '======================================='
  echo "STARTING NGINX"
  echo '======================================='
  dbus-launch gnome-terminal --geometry=140x35 --window --zoom=0.8 --title="NGINX" -- \
    podman run --name=nginx --rm --network host \
    -v $(pwd)/nginx.conf:/etc/nginx/nginx.conf:ro \
    nginx
  sleep 3
}

startWFL1(){
  echo ''
  echo '======================================='
  echo "STARTING WFL1"
  echo $WLF_DIRECTORY/WFL1/bin/standalone.sh --server-config=standalone-ha.xml -Dprogram.name=WFL1 -Djboss.node.name=WFL1 -Djboss.socket.binding.port-offset=100
  echo '======================================='
  dbus-launch gnome-terminal --geometry=140x35 --window --zoom=0.8 --working-directory=$WLF_DIRECTORY/WFL1 --title="WFL1" -- $WLF_DIRECTORY/WFL1/bin/standalone.sh --server-config=standalone-ha.xml -Dprogram.name=WFL1 -Djboss.node.name=WFL1 -Djboss.socket.binding.port-offset=100
  sleep 10
}

startWFL2(){
  echo ''
  echo '======================================='
  echo "STARTING WFL2"
  echo $WLF_DIRECTORY/WFL2/bin/standalone.sh --server-config=standalone-ha.xml -Dprogram.name=WFL2 -Djboss.node.name=WFL2 -Djboss.socket.binding.port-offset=200
  echo '======================================='
  dbus-launch gnome-terminal --geometry=140x35 --window --zoom=0.8 --working-directory=$WLF_DIRECTORY/WFL2 --title="WFL2" -- $WLF_DIRECTORY/WFL2/bin/standalone.sh --server-config=standalone-ha.xml -Dprogram.name=WFL2 -Djboss.node.name=WFL2 -Djboss.socket.binding.port-offset=200
  sleep 10
}

addUsersWildFly(){
  echo ''
  echo '======================================='
  echo 'ADDING USERS TO WILDFLY'
  echo '======================================='
  #$WLF_DIRECTORY/WFL1/bin/add-user.sh -a -g users -u joe -p joeIsAwesome2013!
  #$WLF_DIRECTORY/WFL2/bin/add-user.sh -a -g users -u joe -p joeIsAwesome2013!
  $WLF_DIRECTORY/WFL1/bin/add-user.sh --silent -u admin -p admin123+
  $WLF_DIRECTORY/WFL2/bin/add-user.sh --silent -u admin -p admin123+
}

installWildFly(){
  if [[ ! -f $WLF_ZIP ]] ; then
   exitWithMsg "ERROR!\nFile $WLF_ZIP does not exist!"
  fi
  if [[ ! -d "$WLF_DIRECTORY/WFL1" ]] ; then
    echo ''
    echo '======================================='
    echo "UNZIP WILDFLY to $WLF_DIRECTORY/WFL1"
    echo '======================================='
    unzip -d $WLF_DIRECTORY/tmp-wildfly $WLF_ZIP > /dev/null
    mv $WLF_DIRECTORY/tmp-wildfly/wildfly* $WLF_DIRECTORY/WFL1 || mv $WLF_DIRECTORY/tmp-wildfly/jboss-eap-* $WLF_DIRECTORY/WFL1
    rm -fdr $WLF_DIRECTORY/tmp-wildfly
  fi
  if [[ ! -d "$WLF_DIRECTORY/WFL2" ]] ; then
    echo ''
    echo '======================================='
    echo "UNZIP WILDFLY to $WLF_DIRECTORY/WFL2"
    echo '======================================='
    unzip -d $WLF_DIRECTORY/tmp-wildfly $WLF_ZIP > /dev/null
    mv $WLF_DIRECTORY/tmp-wildfly/wildfly* $WLF_DIRECTORY/WFL2 || mv $WLF_DIRECTORY/tmp-wildfly/jboss-eap-* $WLF_DIRECTORY/WFL2
    rm -fdr $WLF_DIRECTORY/tmp-wildfly
  fi
}

configureWildFly(){
  echo ''
  echo '======================================='
  echo "CONFIGURE WILDFLY"
  WLF_CLI_SCRIPT_TMP_1=$WLF_DIRECTORY/1_$(basename $WLF_CLI_SCRIPT)
  WLF_CLI_SCRIPT_TMP_2=$WLF_DIRECTORY/2_$(basename $WLF_CLI_SCRIPT)
  cp  $WLF_CLI_SCRIPT $WLF_CLI_SCRIPT_TMP_1
  cp  $WLF_CLI_SCRIPT $WLF_CLI_SCRIPT_TMP_2
  sed -i "s/_NODE_IDENTIFIER_/WFL1/g" $WLF_CLI_SCRIPT_TMP_1
  sed -i "s/_NODE_IDENTIFIER_/WFL2/g" $WLF_CLI_SCRIPT_TMP_2
  echo '======================================='
  cp -f $WLF_DIRECTORY/WFL1/standalone/configuration/standalone-ha.xml $WLF_DIRECTORY/WFL1/standalone/configuration/standalone-ha.xml.ORIG
  cat $WLF_CLI_SCRIPT_TMP_1
  $WLF_DIRECTORY/WFL1/bin/jboss-cli.sh --file=$WLF_CLI_SCRIPT_TMP_1
  cp -f $WLF_DIRECTORY/WFL2/standalone/configuration/standalone-ha.xml $WLF_DIRECTORY/WFL2/standalone/configuration/standalone-ha.xml.ORIG
  cat $WLF_CLI_SCRIPT_TMP_2
  $WLF_DIRECTORY/WFL2/bin/jboss-cli.sh --file=$WLF_CLI_SCRIPT_TMP_2
}

deployToWildFly(){
  echo ''
  echo '======================================='
  echo "DEPLOY TO WILDFLY"
  echo '======================================='
  cp -fv ./$EAR_FINAL_NAME $WLF_DIRECTORY/WFL1/standalone/deployments/
  sleep 10
  cp -fv ./$EAR_FINAL_NAME $WLF_DIRECTORY/WFL2/standalone/deployments/
  sleep 10
}

exitWithMsg(){
    echo -e "${RED}$1"
    echo "e.g.: $0"
    echo "NOTE: point WLF_ZIP env variable to your wildfly distribution e.g. \"export WLF_ZIP=/path/wildfly.zip\""
    exit -1
}

# ================
# START
# ================
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
export WLF_DIRECTORY=/tmp/LOAD_BALANCER_NGINX
export EAR_FINAL_NAME=cbnc.ear

echo ''
echo '======================================='
echo "REMOVE PREVIOUS WILDFLY INSTALLATIONS"
echo '======================================='
rm -rfd $WLF_DIRECTORY/WFL1
rm -rfd $WLF_DIRECTORY/WFL2
sleep 1

export WLF_CLI_SCRIPT=wildfly.cli

mkdir -p $WLF_DIRECTORY

installWildFly

addUsersWildFly

configureWildFly

startWFL1

startWFL2

deployToWildFly

sleep 20

startNGINX

rm -f /tmp/cookies*
while true; do
  for cookieNum in {1..100}
  do
    echo -n "curl  -b /tmp/cookies$cookieNum -c /tmp/cookies$cookieNum http://127.0.0.1/clusterbench/session: "
    curl  -b /tmp/cookies$cookieNum -c /tmp/cookies$cookieNum http://127.0.0.1/clusterbench/session
    echo " "
  done
  sleep 1
done