#!/usr/bin/bash

startWFL1(){
  echo ''
  echo '======================================='
  echo "STARTING WFL1"
  echo $WLF_DIRECTORY/WFL1/bin/standalone.sh --server-config=standalone-ha.xml -Dprogram.name=WFL1 -Djboss.node.name=WFL1 -Djboss.socket.binding.port-offset=100
  echo '======================================='
  gnome-terminal --geometry=140x35 --window --zoom=0.9 --working-directory=$WLF_DIRECTORY/WFL1 --title="WFL1" -- $WLF_DIRECTORY/WFL1/bin/standalone.sh --server-config=standalone-ha.xml -Dprogram.name=WFL1 -Djboss.node.name=WFL1 -Djboss.socket.binding.port-offset=100
}

startWFL2(){
  echo ''
  echo '======================================='
  echo "STARTING WFL2"
  echo $WLF_DIRECTORY/WFL2/bin/standalone.sh --server-config=standalone-ha.xml -Dprogram.name=WFL2 -Djboss.node.name=WFL2 -Djboss.socket.binding.port-offset=200
  echo '======================================='
  gnome-terminal --geometry=140x35 --window --zoom=0.9 --working-directory=$WLF_DIRECTORY/WFL2 --title="WFL2" -- $WLF_DIRECTORY/WFL2/bin/standalone.sh --server-config=standalone-ha.xml -Dprogram.name=WFL2 -Djboss.node.name=WFL2 -Djboss.socket.binding.port-offset=200
}

startWFL3(){
  echo ''
  echo '======================================='
  echo "STARTING WFL3"
  echo $WLF_DIRECTORY/WFL3/bin/standalone.sh --server-config=standalone-ha.xml -Dprogram.name=WFL3 -Djboss.node.name=WFL3 -Djboss.socket.binding.port-offset=300
  echo '======================================='
  gnome-terminal --geometry=140x35 --window --zoom=0.9 --working-directory=$WLF_DIRECTORY/WFL3 --title="WFL3" -- $WLF_DIRECTORY/WFL3/bin/standalone.sh --server-config=standalone-ha.xml -Dprogram.name=WFL3 -Djboss.node.name=WFL3 -Djboss.socket.binding.port-offset=300
}

startWFL4(){
  echo ''
  echo '======================================='
  echo "STARTING WFL4"
  echo $WLF_DIRECTORY/WFL4/bin/standalone.sh --server-config=standalone-ha.xml -Dprogram.name=WFL4 -Djboss.node.name=WFL4 -Djboss.socket.binding.port-offset=400
  echo '======================================='
  gnome-terminal --geometry=140x35 --window --zoom=0.9 --working-directory=$WLF_DIRECTORY/WFL4 --title="WFL4" -- $WLF_DIRECTORY/WFL4/bin/standalone.sh --server-config=standalone-ha.xml -Dprogram.name=WFL4 -Djboss.node.name=WFL4 -Djboss.socket.binding.port-offset=400
}

startWFLLB(){
  echo ''
  echo '======================================='
  echo "STARTING LOAD BALANCER"
  echo $WLF_DIRECTORY/WFLLB/bin/standalone.sh --server-config=standalone-load-balancer.xml
  echo '======================================='
  gnome-terminal --geometry=140x35 --window --zoom=0.9 --working-directory=$WLF_DIRECTORY/WFLLB --title="LOAD BALANCER" -- $WLF_DIRECTORY/WFLLB/bin/standalone.sh --server-config=standalone-load-balancer.xml
}

addUsersWildFly(){
  echo ''
  echo '======================================='
  echo 'ADDING USERS TO WILDFLY'
  echo '======================================='
  $WLF_DIRECTORY/WFL1/bin/add-user.sh --silent -u admin -p admin123+
  $WLF_DIRECTORY/WFL2/bin/add-user.sh --silent -u admin -p admin123+
  $WLF_DIRECTORY/WFL3/bin/add-user.sh --silent -u admin -p admin123+
  $WLF_DIRECTORY/WFL4/bin/add-user.sh --silent -u admin -p admin123+
  $WLF_DIRECTORY/WFLLB/bin/add-user.sh --silent -u admin -p admin123+
  sleep 2
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
  if [[ ! -d "$WLF_DIRECTORY/WFLLB" ]] ; then
    echo ''
    echo '======================================='
    echo "UNZIP WILDFLY to $WLF_DIRECTORY/WFLLB"
    echo '======================================='
    unzip -d $WLF_DIRECTORY/tmp-wildfly $WLF_ZIP > /dev/null
    mv $WLF_DIRECTORY/tmp-wildfly/wildfly* $WLF_DIRECTORY/WFLLB
    rm -fdr $WLF_DIRECTORY/tmp-wildfly
  fi
}

configureWildFly(){
  echo ''
  echo '======================================='
  echo "CONFIGURE WILDFLY"
  echo '======================================='
  cp -f $WLF_DIRECTORY/WFL1/standalone/configuration/standalone-ha.xml $WLF_DIRECTORY/WFL1/standalone/configuration/standalone-ha.xml.ORIG
  cat $WLF_CLI_SCRIPT1
  $WLF_DIRECTORY/WFL1/bin/jboss-cli.sh --file=$WLF_CLI_SCRIPT1
  cp -f $WLF_DIRECTORY/WFL2/standalone/configuration/standalone-ha.xml $WLF_DIRECTORY/WFL2/standalone/configuration/standalone-ha.xml.ORIG
  cat $WLF_CLI_SCRIPT2
  $WLF_DIRECTORY/WFL2/bin/jboss-cli.sh --file=$WLF_CLI_SCRIPT2
  cp -f $WLF_DIRECTORY/WFL3/standalone/configuration/standalone-ha.xml $WLF_DIRECTORY/WFL3/standalone/configuration/standalone-ha.xml.ORIG
  cat $WLF_CLI_SCRIPT3
  $WLF_DIRECTORY/WFL3/bin/jboss-cli.sh --file=$WLF_CLI_SCRIPT3
  cp -f $WLF_DIRECTORY/WFL4/standalone/configuration/standalone-ha.xml $WLF_DIRECTORY/WFL4/standalone/configuration/standalone-ha.xml.ORIG
  cat $WLF_CLI_SCRIPT4
  $WLF_DIRECTORY/WFL4/bin/jboss-cli.sh --file=$WLF_CLI_SCRIPT4
  echo ''
  echo '======================================='
  echo "CONFIGURE WILDFLY LOAD BALANCER"
  echo '======================================='
  cp -f $WLF_DIRECTORY/WFLLB/standalone/configuration/standalone-load-balancer.xml $WLF_DIRECTORY/WFLLB/standalone/configuration/standalone-load-balancer.xml.ORIG
  cat $WLF_CLI_SCRIPTLB
  $WLF_DIRECTORY/WFLLB/bin/jboss-cli.sh --file=$WLF_CLI_SCRIPTLB
  sleep 2
}

deployToWildFly(){
  echo ''
  echo '======================================='
  echo "DEPLOY TO WILDFLY"
  echo '======================================='
  cd distributed-webapp
  mvn $MVN_PROFILE clean install
  cd -
  cp -fv distributed-webapp/target/$WAR_FINAL_NAME $WLF_DIRECTORY/WFL1/standalone/deployments/distributed-webapp.war
  cp -fv distributed-webapp/target/$WAR_FINAL_NAME $WLF_DIRECTORY/WFL2/standalone/deployments/distributed-webapp.war
  cp -fv distributed-webapp/target/$WAR_FINAL_NAME $WLF_DIRECTORY/WFL3/standalone/deployments/distributed-webapp.war
  cp -fv distributed-webapp/target/$WAR_FINAL_NAME $WLF_DIRECTORY/WFL4/standalone/deployments/distributed-webapp.war
  sleep 2
}

exitWithMsg(){
    echo "$1"
    echo "e.g.: $0 [--coarse|--fine]"
    echo "NOTE: set ...."
    exit -1
}

# ================
# START
# ================
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
export WLF_DIRECTORY=/tmp/LOAD_BALANCER_UNDERTOW
export JDG_DIRECTORY=$WLF_DIRECTORY

# ========================
# WildFly bits
# ========================
if [[ "x$WLF_ZIP" = "x" ]]; then
    export WLF_ZIP=$WLF_DIRECTORY/wildfly.zip
    echo -e "${RED}\nWARNING!\nEnvironment variable WLF_ZIP not set: default is $WLF_ZIP\n${NC}"
else
    echo -e "${GREEN}\n=======================================\nUsing WLF_ZIP $WLF_ZIP\n=======================================\n${NC}"
fi
if [[ "x$WLF_ZIP_DOWNLOAD_URL" = "x" ]]; then
    export WLF_ZIP_DOWNLOAD_URL=https://download.jboss.org/wildfly/16.0.0.Beta1/wildfly-16.0.0.Final.zip
    echo -e "${RED}\nWARNING!\nEnvironment variable WLF_ZIP_DOWNLOAD_URL not set: default is $WLF_ZIP_DOWNLOAD_URL\n${NC}"
  else
      echo -e "${GREEN}\n=======================================\nUsing WLF_ZIP_DOWNLOAD_URL $WLF_ZIP_DOWNLOAD_URL\n=======================================\n${NC}"
fi

# ========================
# Profile
# ========================
export WLF_CLI_SCRIPT1=configuration.cli
export WLF_CLI_SCRIPT2=configuration.cli
export WLF_CLI_SCRIPT3=configuration.cli
export WLF_CLI_SCRIPT4=configuration.cli
export WLF_CLI_SCRIPTLB=configuration-lb.cli
export MVN_PROFILE="-q"
export WAR_FINAL_NAME=distributed-webapp.war
export WAR_CONTEXT_PATH=clusterbench
echo -e "${GREEN}\n=======================================\nUsing WLF_CLI_SCRIPT $WLF_CLI_SCRIPT1 and $WLF_CLI_SCRIPTLB\nUsing WAR_FINAL_NAME $WAR_FINAL_NAME\nUsing WAR_CONTEXT_PATH $WAR_CONTEXT_PATH\n=======================================\n${NC}"

mkdir -p $WLF_DIRECTORY

echo ''
echo '======================================='
echo "REMOVE PREVIOUS WILDFLY AND JDG INSTALLATIONS"
echo '======================================='
rm -rfd $WLF_DIRECTORY/WFL1
rm -rfd $WLF_DIRECTORY/WFL2
rm -rfd $WLF_DIRECTORY/WFL3
rm -rfd $WLF_DIRECTORY/WFL4
rm -rfd $WLF_DIRECTORY/WFLLB
rm -f /tmp/cookies1
rm -f /tmp/cookies2
rm -f /tmp/cookies3
rm -f /tmp/cookies4
sleep 1

downloadWildFly
sleep 1

addUsersWildFly
sleep 1

configureWildFly
sleep 1

startWFLLB
sleep 10

startWFL1
startWFL2
startWFL3
startWFL4
sleep 10

deployToWildFly

exitWithMsg "paste \"http://localhost:8080/distributed-webapp/home.jsp\" or \"http://localhost:8080/distributed-webapp/jboss-node-name\"in your browser ..."
