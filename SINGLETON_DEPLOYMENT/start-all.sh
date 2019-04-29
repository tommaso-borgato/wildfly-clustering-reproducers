#!/usr/bin/bash

startWFL1(){
  echo ''
  echo '======================================='
  echo "STARTING WFL1"
  echo '======================================='
  echo "$WLF_DIRECTORY/WFL1/bin/standalone.sh --server-config=standalone-ha.xml -Dprogram.name=WFL1 -Djboss.node.name=WFL1 -Djboss.socket.binding.port-offset=100"
  gnome-terminal --geometry=140x35 --window --zoom=0.8 --working-directory=$WLF_DIRECTORY/WFL1 --title="WFL1" -- $WLF_DIRECTORY/WFL1/bin/standalone.sh --server-config=standalone-ha.xml -Dprogram.name=WFL1 -Djboss.node.name=WFL1 -Djboss.socket.binding.port-offset=100
}

startWFL2(){
  echo ''
  echo '======================================='
  echo "STARTING WFL2"
  echo '======================================='
  echo "$WLF_DIRECTORY/WFL2/bin/standalone.sh --server-config=standalone-ha.xml -Dprogram.name=WFL2 -Djboss.node.name=WFL2 -Djboss.socket.binding.port-offset=200"
  gnome-terminal --geometry=140x35 --window --zoom=0.8 --working-directory=$WLF_DIRECTORY/WFL2 --title="WFL2" -- $WLF_DIRECTORY/WFL2/bin/standalone.sh --server-config=standalone-ha.xml -Dprogram.name=WFL2 -Djboss.node.name=WFL2 -Djboss.socket.binding.port-offset=200
}

startWFL3(){
  echo ''
  echo '======================================='
  echo "STARTING WFL3"
  echo '======================================='
  echo "$WLF_DIRECTORY/WFL3/bin/standalone.sh --server-config=standalone-ha.xml -Dprogram.name=WFL3 -Djboss.node.name=WFL3 -Djboss.socket.binding.port-offset=300"
  gnome-terminal --geometry=140x35 --window --zoom=0.8 --working-directory=$WLF_DIRECTORY/WFL3 --title="WFL3" -- $WLF_DIRECTORY/WFL3/bin/standalone.sh --server-config=standalone-ha.xml -Dprogram.name=WFL3 -Djboss.node.name=WFL3 -Djboss.socket.binding.port-offset=300
}

startWFL4(){
  echo ''
  echo '======================================='
  echo "STARTING WFL4"
  echo '======================================='
  echo "$WLF_DIRECTORY/WFL4/bin/standalone.sh --server-config=standalone-ha.xml -Dprogram.name=WFL4 -Djboss.node.name=WFL4 -Djboss.socket.binding.port-offset=400"
  gnome-terminal --geometry=140x35 --window --zoom=0.8 --working-directory=$WLF_DIRECTORY/WFL4 --title="WFL4" -- $WLF_DIRECTORY/WFL4/bin/standalone.sh --server-config=standalone-ha.xml -Dprogram.name=WFL4 -Djboss.node.name=WFL4 -Djboss.socket.binding.port-offset=400
}

addUsers(){
  echo ''
  echo '======================================='
  echo 'ADDING USERS'
  echo '======================================='
  $WLF_DIRECTORY/WFL1/bin/add-user.sh -a -g users -u joe -p joeIsAwesome2013!
  $WLF_DIRECTORY/WFL2/bin/add-user.sh -a -g users -u joe -p joeIsAwesome2013!
  $WLF_DIRECTORY/WFL3/bin/add-user.sh -a -g users -u joe -p joeIsAwesome2013!
  $WLF_DIRECTORY/WFL4/bin/add-user.sh -a -g users -u joe -p joeIsAwesome2013!
  $WLF_DIRECTORY/WFL1/bin/add-user.sh -u admin -p admin123+
  $WLF_DIRECTORY/WFL2/bin/add-user.sh -u admin -p admin123+
  $WLF_DIRECTORY/WFL3/bin/add-user.sh -u admin -p admin123+
  $WLF_DIRECTORY/WFL4/bin/add-user.sh -u admin -p admin123+
  $WLF_DIRECTORY/WFL1/bin/add-user.sh -a -u ejb -p test
  $WLF_DIRECTORY/WFL2/bin/add-user.sh -a -u ejb -p test
  $WLF_DIRECTORY/WFL3/bin/add-user.sh -a -u ejb -p test
  $WLF_DIRECTORY/WFL4/bin/add-user.sh -a -u ejb -p test
}

downloadWildFly(){
  if [[ ! -f $WLF_ZIP ]] ; then
    echo -e "${RED}\nWARNING!\nFile $WLF_ZIP does not exist: downloading $WLF_ZIP_DOWNLOAD_URL\n${NC}"
    echo ''
    echo '======================================='
    echo "DOWNLOADING WILDFLY FROM $WLF_ZIP_DOWNLOAD_URL"
    echo '======================================='
    wget -O $WLF_ZIP $WLF_ZIP_DOWNLOAD_URL
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
  if [[ ! -d "$WLF_DIRECTORY/WFL3" ]] ; then
    echo ''
    echo '======================================='
    echo "UNZIP WILDFLY to $WLF_DIRECTORY/WFL3"
    echo '======================================='
    unzip -d $WLF_DIRECTORY/tmp-wildfly $WLF_ZIP > /dev/null
    mv $WLF_DIRECTORY/tmp-wildfly/wildfly* $WLF_DIRECTORY/WFL3
    rm -fdr $WLF_DIRECTORY/tmp-wildfly
  fi
  if [[ ! -d "$WLF_DIRECTORY/WFL4" ]] ; then
    echo ''
    echo '======================================='
    echo "UNZIP WILDFLY to $WLF_DIRECTORY/WFL4"
    echo '======================================='
    unzip -d $WLF_DIRECTORY/tmp-wildfly $WLF_ZIP > /dev/null
    mv $WLF_DIRECTORY/tmp-wildfly/wildfly* $WLF_DIRECTORY/WFL4
    rm -fdr $WLF_DIRECTORY/tmp-wildfly
  fi
}

configureWildFly(){
  echo ''
  echo '======================================='
  echo "CONFIGURE WILDFLY WITH $WLF_CLI_SCRIPT"
  echo '======================================='
  $WLF_DIRECTORY/WFL1/bin/jboss-cli.sh --file=$WLF_CLI_SCRIPT
  sleep 2
  $WLF_DIRECTORY/WFL2/bin/jboss-cli.sh --file=$WLF_CLI_SCRIPT
  sleep 2
  $WLF_DIRECTORY/WFL3/bin/jboss-cli.sh --file=$WLF_CLI_SCRIPT
  sleep 2
  $WLF_DIRECTORY/WFL4/bin/jboss-cli.sh --file=$WLF_CLI_SCRIPT
  sleep 2
}

deployToWildFly(){
  echo ''
  echo '======================================='
  echo "DEPLOY TO WILDFLY"
  echo '======================================='
  cd distributed-webapp
  echo "mvn $MVN_PROFILE clean install"
  mvn $MVN_PROFILE clean install
  cd -
  cp -f distributed-webapp/target/$WAR_FINAL_NAME $WLF_DIRECTORY/WFL1/standalone/deployments/
  sleep 5
  cp -f distributed-webapp/target/$WAR_FINAL_NAME $WLF_DIRECTORY/WFL2/standalone/deployments/
  sleep 5
  cp -f distributed-webapp/target/$WAR_FINAL_NAME $WLF_DIRECTORY/WFL3/standalone/deployments/
  sleep 5
  cp -f distributed-webapp/target/$WAR_FINAL_NAME $WLF_DIRECTORY/WFL4/standalone/deployments/
  sleep 5
}

exitWithMsg(){
    echo -e "${RED}ERROR: $1 !${NC}"
    echo -e "${GREEN}e.g.: $0 --election-policy [quorum|random|preferences] --descriptor [jboss-all|singleton-deployment]${NC}"
    echo -e "${GREEN}NOTE: set environment variable WLF_ZIP=/path/wildfly.zip${NC}"
    exit -1
}

# ================
# START
# ================

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
export MVN_PROFILE="-q"
export WLF_DIRECTORY=/tmp/SINGLETON_DEPLOYMENT

if [[ "x$WLF_ZIP" = "x" ]]; then
    export WLF_ZIP=$WLF_DIRECTORY/wildfly.zip
    echo -e "${RED}\nWARNING!\nEnvironment variable WLF_ZIP not set: default is $WLF_ZIP\n${NC}"
else
    echo -e "${GREEN}\nWARNING!\nUsing WildFly distribution $WLF_ZIP\n${NC}"
fi
if [[ "x$WLF_ZIP_DOWNLOAD_URL" = "x" ]]; then
    export WLF_ZIP_DOWNLOAD_URL=https://download.jboss.org/wildfly/16.0.0.Beta1/wildfly-16.0.0.Final.zip
    echo -e "${RED}\nWARNING!\nEnvironment variable WLF_ZIP_DOWNLOAD_URL not set: default is $WLF_ZIP_DOWNLOAD_URL\n${NC}"
fi

# ========================
# Profile
# ========================
if [[ "x$1" = "x--election-policy" ]]; then
    echo "election policy: $2"
    if [[ "x$2" = "xquorum" ]]; then
        export WLF_CLI_SCRIPT=configuration-wfl-quorum.cli
    elif [[ "x$2" = "xrandom" ]]; then
        export WLF_CLI_SCRIPT=configuration-wfl-random.cli
    elif [[ "x$2" = "xpreferences" ]]; then
        export WLF_CLI_SCRIPT=configuration-wfl-preferences.cli
    else
        exitWithMsg "Invalid second argument"
    fi
else
    exitWithMsg "Invalid first argument"
fi

if [[ "x$3" = "x--descriptor" ]]; then
    echo "deployment descriptor: $4.xml"
    if [[ "x$4" = "xjboss-all" ]]; then
        export MVN_PROFILE="-q -P jboss-all"
        export WAR_FINAL_NAME=distributed-webapp.war
        export WAR_CONTEXT_PATH=distributed-webapp
    elif [[ "x$4" = "xsingleton-deployment" ]]; then
        export MVN_PROFILE="-q -P singleton-deployment"
        export WAR_FINAL_NAME=distributed-webapp.war
        export WAR_CONTEXT_PATH=distributed-webapp
    else
        exitWithMsg "Invalid fourth argument"
    fi
else
    exitWithMsg "Invalid third argument"
fi

mkdir -p $WLF_DIRECTORY

echo ''
echo '======================================='
echo "REMOVE PREVIOUS WILDFLY INSTALLATIONS"
echo '======================================='
rm -rfd $WLF_DIRECTORY/WFL1
rm -rfd $WLF_DIRECTORY/WFL2
rm -rfd $WLF_DIRECTORY/WFL3
rm -rfd $WLF_DIRECTORY/WFL4
rm -f /tmp/cookies1
rm -f /tmp/cookies2
rm -f /tmp/cookies3
rm -f /tmp/cookies4
sleep 3

downloadWildFly
sleep 3

addUsers

configureWildFly

startWFL1
sleep 5

startWFL2
sleep 5

startWFL3
sleep 5

startWFL4
sleep 5

deployToWildFly
sleep 5

echo ''
first_print=true
while true; do
  for WFL_PORT in 8180 8280 8380 8480
  do
    wget -q --spider http://localhost:$WFL_PORT/$WAR_CONTEXT_PATH/
    RETVAL=$?
    if [[ $RETVAL -ne 0 ]]; then
        echo -e "${RED}SERVICE DOWN ON http://localhost:$WFL_PORT/$WAR_CONTEXT_PATH/${NC}"
    else
        echo -e "${GREEN}SERVICE UP ON http://localhost:$WFL_PORT/$WAR_CONTEXT_PATH/${NC}"
        export WFL_ACTIVE_NODE=http://localhost:$WFL_PORT/$WAR_CONTEXT_PATH/session
    fi
    sleep 1
  done

  echo -n -e "\rSESSION DATA: "
  curl -b /tmp/cookies1 -c /tmp/cookies1 $WFL_ACTIVE_NODE
  echo ""
  sleep 1

  if [[ "$first_print" = true ]] ; then
        echo -n -e "\t\t\t(press CTRL+C to exit)"
        first_print=false
  fi
done
