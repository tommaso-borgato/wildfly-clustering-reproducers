#!/usr/bin/bash

startMYSQL(){
  echo ''
  echo '======================================='
  echo "STARTING MYSQL"
  echo '======================================='
  gnome-terminal --geometry=140x35 --window --zoom=0.8 --title="MYSQL" -- \
    podman run --name=mysql --rm --network host \
    -e MYSQL_ROOT_PASSWORD=123pippobaudo \
    -e MYSQL_DATABASE=clustering \
    -e MYSQL_USER=pippo.baudo \
    -e MYSQL_PASSWORD=123pippobaudo \
    mysql
    echo "JDBC_URL=jdbc:mysql://localhost:3306/clustering USER=pippo.baudo PASSWORD=123pippobaudo"
}

startWFL1(){
  echo ''
  echo '======================================='
  echo "STARTING WFL1"
  echo $WLF_DIRECTORY/WFL1/bin/standalone.sh --server-config=standalone-ha.xml -Dprogram.name=WFL1 -Djboss.node.name=WFL1 -Djboss.socket.binding.port-offset=100
  echo '======================================='
  gnome-terminal --geometry=140x35 --window --zoom=0.8 --working-directory=$WLF_DIRECTORY/WFL1 --title="WFL1" -- $WLF_DIRECTORY/WFL1/bin/standalone.sh --server-config=standalone-ha.xml -Dprogram.name=WFL1 -Djboss.node.name=WFL1 -Djboss.socket.binding.port-offset=100
}

startWFL2(){
  echo ''
  echo '======================================='
  echo "STARTING WFL2"
  echo $WLF_DIRECTORY/WFL2/bin/standalone.sh --server-config=standalone-ha.xml -Dprogram.name=WFL2 -Djboss.node.name=WFL2 -Djboss.socket.binding.port-offset=200
  echo '======================================='
  gnome-terminal --geometry=140x35 --window --zoom=0.8 --working-directory=$WLF_DIRECTORY/WFL2 --title="WFL2" -- $WLF_DIRECTORY/WFL2/bin/standalone.sh --server-config=standalone-ha.xml -Dprogram.name=WFL2 -Djboss.node.name=WFL2 -Djboss.socket.binding.port-offset=200
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
    mv $WLF_DIRECTORY/tmp-wildfly/wildfly* $WLF_DIRECTORY/WFL1
    rm -fdr $WLF_DIRECTORY/tmp-wildfly
  fi
  if [[ ! -d "$WLF_DIRECTORY/WFL2" ]] ; then
    echo ''
    echo '======================================='
    echo "UNZIP WILDFLY to $WLF_DIRECTORY/WFL2"
    echo '======================================='
    unzip -d $WLF_DIRECTORY/tmp-wildfly $WLF_ZIP > /dev/null
    mv $WLF_DIRECTORY/tmp-wildfly/wildfly* $WLF_DIRECTORY/WFL2
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
  sleep 2
  cp -f $WLF_DIRECTORY/WFL2/standalone/configuration/standalone-ha.xml $WLF_DIRECTORY/WFL2/standalone/configuration/standalone-ha.xml.ORIG
  cat $WLF_CLI_SCRIPT_TMP_2
  $WLF_DIRECTORY/WFL2/bin/jboss-cli.sh --file=$WLF_CLI_SCRIPT_TMP_2
  sleep 2
}

deployToWildFly(){
  echo ''
  echo '======================================='
  echo "DEPLOY TO WILDFLY"
  echo '======================================='
  cp -fv ./mysql-connector-java-8.0.18.jar $WLF_DIRECTORY/WFL1/standalone/deployments/mysql-connector.jar
  cp -fv ./mysql-connector-java-8.0.18.jar $WLF_DIRECTORY/WFL2/standalone/deployments/mysql-connector.jar
  sleep 20
  cp -fv ./$EAR_FINAL_NAME $WLF_DIRECTORY/WFL1/standalone/deployments/
  sleep 5
  cp -fv ./$EAR_FINAL_NAME $WLF_DIRECTORY/WFL2/standalone/deployments/
  sleep 5
}

exitWithMsg(){
    echo -e "${RED}$1"
    echo "e.g.: $0"
    echo "NOTE: set ...."
    exit -1
}

# ================
# START
# ================
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
export WLF_DIRECTORY=/tmp/DB_INVALIDATION_CACHE
export EAR_FINAL_NAME=cbnc.ear
export WLF_CLI_SCRIPT=database.cli

mkdir -p $WLF_DIRECTORY

echo ''
echo '======================================='
echo "REMOVE PREVIOUS WILDFLY INSTALLATIONS"
echo '======================================='
rm -rfd $WLF_DIRECTORY/WFL1
rm -rfd $WLF_DIRECTORY/WFL2
rm -f /tmp/cookies1
rm -f /tmp/cookies2
rm -f /tmp/cookies3
rm -f /tmp/cookies4
sleep 1

startMYSQL

installWildFly

addUsersWildFly

configureWildFly

startWFL1

startWFL2

deployToWildFly

sleep 20

curl http://localhost:8180/clusterbench/session
curl http://localhost:8280/clusterbench/session