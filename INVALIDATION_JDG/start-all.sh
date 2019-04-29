#!/usr/bin/bash

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

startJDG1(){
  echo ''
  echo '======================================='
  echo "STARTING JDG1"
  echo $WLF_DIRECTORY/JDG1/bin/standalone.sh --server-config=clustered.xml -Dprogram.name=JDG1 -Djboss.node.name=JDG1 -Djboss.socket.binding.port-offset=300
  echo '======================================='
  gnome-terminal --geometry=140x35 --window --zoom=0.8 --working-directory=$WLF_DIRECTORY/JDG1 --title="JDG1" -- $WLF_DIRECTORY/JDG1/bin/standalone.sh --server-config=clustered.xml -Dprogram.name=JDG1 -Djboss.node.name=JDG1 -Djboss.socket.binding.port-offset=300
}

startJDG2(){
  echo ''
  echo '======================================='
  echo "STARTING JDG2"
  echo $WLF_DIRECTORY/JDG2/bin/standalone.sh --server-config=clustered.xml -Dprogram.name=JDG2 -Djboss.node.name=JDG2 -Djboss.socket.binding.port-offset=400
  echo '======================================='
  gnome-terminal --geometry=140x35 --window --zoom=0.8 --working-directory=$WLF_DIRECTORY/JDG2 --title="JDG2" -- $WLF_DIRECTORY/JDG2/bin/standalone.sh --server-config=clustered.xml -Dprogram.name=JDG2 -Djboss.node.name=JDG2 -Djboss.socket.binding.port-offset=400
}

addUsersJdg(){
  echo ''
  echo '======================================='
  echo 'ADDING USERS TO WILDFLY'
  echo '======================================='
  $WLF_DIRECTORY/JDG1/bin/add-user.sh -a -g users -u joe -p joeIsAwesome2013!
  $WLF_DIRECTORY/JDG2/bin/add-user.sh -a -g users -u joe -p joeIsAwesome2013!
  $WLF_DIRECTORY/JDG1/bin/add-user.sh -u admin -p admin123+
  $WLF_DIRECTORY/JDG2/bin/add-user.sh -u admin -p admin123+
  $WLF_DIRECTORY/JDG1/bin/add-user.sh -a -u ejb -p test
  $WLF_DIRECTORY/JDG2/bin/add-user.sh -a -u ejb -p test
}

addUsersWildFly(){
  echo ''
  echo '======================================='
  echo 'ADDING USERS TO JDG'
  echo '======================================='
  $WLF_DIRECTORY/WFL1/bin/add-user.sh -a -g users -u joe -p joeIsAwesome2013!
  $WLF_DIRECTORY/WFL2/bin/add-user.sh -a -g users -u joe -p joeIsAwesome2013!
  $WLF_DIRECTORY/WFL1/bin/add-user.sh -u admin -p admin123+
  $WLF_DIRECTORY/WFL2/bin/add-user.sh -u admin -p admin123+
  $WLF_DIRECTORY/WFL1/bin/add-user.sh -a -u ejb -p test
  $WLF_DIRECTORY/WFL2/bin/add-user.sh -a -u ejb -p test
}

downloadJdg() {
  if [[ ! -f $JDG_ZIP ]] ; then
    echo -e "${RED}\nWARNING!\nFile $JDG_ZIP does not exist: downloading $JDG_ZIP_DOWNLOAD_URL\n${NC}"
    echo ''
    echo '======================================='
    echo "DOWNLOADING JDG FROM $JDG_ZIP_DOWNLOAD_URL"
    echo '======================================='
    wget -O $JDG_ZIP $JDG_ZIP_DOWNLOAD_URL
  fi
  if [[ ! -d "$JDG_DIRECTORY/JDG1" ]] ; then
    echo ''
    echo '======================================='
    echo "UNZIP JDG to $JDG_DIRECTORY/JDG1"
    echo '======================================='
    unzip -d $JDG_DIRECTORY/tmp-jdg $JDG_ZIP > /dev/null
    mv $JDG_DIRECTORY/tmp-jdg/*-server* $JDG_DIRECTORY/JDG1
    rm -fdr $JDG_DIRECTORY/tmp-jdg
  fi
  if [[ ! -d "$JDG_DIRECTORY/JDG2" ]] ; then
    echo ''
    echo '======================================='
    echo "UNZIP JDG to $JDG_DIRECTORY/JDG2"
    echo '======================================='
    unzip -d $JDG_DIRECTORY/tmp-jdg $JDG_ZIP > /dev/null
    mv $JDG_DIRECTORY/tmp-jdg/*-server* $JDG_DIRECTORY/JDG2
    rm -fdr $JDG_DIRECTORY/tmp-jdg
  fi
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
}

configureJdg(){
  echo ''
  echo '======================================='
  echo "CONFIGURE JDG"
  echo '======================================='
  $JDG_DIRECTORY/JDG1/bin/ispn-cli.sh --file=$JDG_CLI_SCRIPT
  sleep 2
  $JDG_DIRECTORY/JDG2/bin/ispn-cli.sh --file=$JDG_CLI_SCRIPT
  sleep 2
}

configureWildFly(){
  echo ''
  echo '======================================='
  echo "CONFIGURE WILDFLY"
  echo '======================================='
  $WLF_DIRECTORY/WFL1/bin/jboss-cli.sh --file=$WLF_CLI_SCRIPT
  sleep 2
  $WLF_DIRECTORY/WFL2/bin/jboss-cli.sh --file=$WLF_CLI_SCRIPT
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
  cp -fv distributed-webapp/target/$WAR_FINAL_NAME $WLF_DIRECTORY/WFL1/standalone/deployments/
  sleep 5
  cp -fv distributed-webapp/target/$WAR_FINAL_NAME $WLF_DIRECTORY/WFL2/standalone/deployments/
  sleep 5
}

exitWithMsg(){
    echo "$1"
    echo "e.g.: $0 [--distributable-web-1|--distributable-web-2|--default]"
    echo "NOTE: set "
    exit -1
}

# ================
# START
# ================
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
export WLF_DIRECTORY=/tmp/INVALIDATION_JDG
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
# JDG
# ========================
if [[ "x$JDG_ZIP" = "x" ]]; then
    export JDG_ZIP=$JDG_DIRECTORY/jboss-datagrid-server.zip
    echo -e "${RED}\nWARNING!\nEnvironment variable JDG_ZIP not set: default is $JDG_ZIP\n${NC}"
else
    echo -e "${GREEN}\n=======================================\nUsing JDG_ZIP $JDG_ZIP\n=======================================\n${NC}"
fi
if [[ "x$JDG_ZIP_DOWNLOAD_URL" = "x" ]]; then
    export JDG_ZIP_DOWNLOAD_URL=http://downloads.jboss.org/infinispan/9.4.6.Final/infinispan-server-9.4.6.Final.zip
    echo -e "${RED}\nWARNING!\nEnvironment variable JDG_ZIP_DOWNLOAD_URL not set: default is $JDG_ZIP_DOWNLOAD_URL\n${NC}"
  else
      echo -e "${GREEN}\n=======================================\nUsing JDG_ZIP_DOWNLOAD_URL $JDG_ZIP_DOWNLOAD_URL\n=======================================\n${NC}"
fi

# ========================
# Profile
# ========================
if [[ "x$1" = "x--distributable-web-1" ]]; then
    export WLF_CLI_SCRIPT=configuration-wfl-distributable-web-1.cli
    export MVN_PROFILE="-q -P distributable-web-1"
    export WAR_FINAL_NAME=distributed-webapp-distributable-web-1.war
    export WAR_CONTEXT_PATH=distributed-webapp-distributable-web-1
    export JDG_CLI_SCRIPT=configuration-jdg.cli
elif [[ "x$1" = "x--distributable-web-2" ]]; then
    export WLF_CLI_SCRIPT=configuration-wfl-distributable-web-2.cli
    export MVN_PROFILE="-q -P distributable-web-2"
    export WAR_FINAL_NAME=distributed-webapp-distributable-web-2.war
    export WAR_CONTEXT_PATH=distributed-webapp-distributable-web-2
    export JDG_CLI_SCRIPT=configuration-jdg.cli
elif [[ "x$1" = "x--default" ]]; then
    export WLF_CLI_SCRIPT=configuration-wfl.cli
    export MVN_PROFILE="-q"
    export WAR_FINAL_NAME=distributed-webapp.war
    export WAR_CONTEXT_PATH=distributed-webapp
    export JDG_CLI_SCRIPT=configuration-jdg.cli
else
    exitWithMsg "Invalid first argument"
fi
echo -e "${GREEN}\n=======================================\nUsing WLF_CLI_SCRIPT $WLF_CLI_SCRIPT\nUsing WAR_FINAL_NAME $WAR_FINAL_NAME\nUsing WAR_CONTEXT_PATH $WAR_CONTEXT_PATH\nUsing JDG_CLI_SCRIPT $JDG_CLI_SCRIPT\n=======================================\n${NC}"

mkdir -p $WLF_DIRECTORY

echo ''
echo '======================================='
echo "REMOVE PREVIOUS WILDFLY AND JDG INSTALLATIONS"
echo '======================================='
rm -rfd $WLF_DIRECTORY/WFL1
rm -rfd $WLF_DIRECTORY/WFL2
rm -rfd $WLF_DIRECTORY/JDG1
rm -rfd $WLF_DIRECTORY/JDG2
rm -f /tmp/cookies1
rm -f /tmp/cookies2
rm -f /tmp/cookies3
rm -f /tmp/cookies4
sleep 1

downloadJdg
sleep 1

downloadWildFly
sleep 1

addUsersJdg
sleep 1

addUsersWildFly
sleep 1

configureJdg
sleep 1

configureWildFly
sleep 1

startJDG1
sleep 5

startJDG2
sleep 20

startWFL1
sleep 5

startWFL2
sleep 25

deployToWildFly
sleep 25

echo ''
first_print=true
while true; do
  echo -n -e "\rSESSION DATA: "
  curl -b /tmp/cookies1 -c /tmp/cookies1 http://localhost:8180/$WAR_CONTEXT_PATH/session
  sleep 1
  echo -n " "
  curl -b /tmp/cookies2 -c /tmp/cookies2 http://localhost:8280/$WAR_CONTEXT_PATH/session
  sleep 1
  echo -n " "
  curl -b /tmp/cookies3 -c /tmp/cookies3 http://localhost:8180/$WAR_CONTEXT_PATH/session
  sleep 1
  echo -n " "
  curl -b /tmp/cookies4 -c /tmp/cookies4 http://localhost:8280/$WAR_CONTEXT_PATH/session
  sleep 1
  echo -n " "
  curl -b /tmp/cookies4 -c /tmp/cookies4 http://localhost:8180/$WAR_CONTEXT_PATH/session
  sleep 1
  echo -n " "
  curl -b /tmp/cookies3 -c /tmp/cookies3 http://localhost:8280/$WAR_CONTEXT_PATH/session
  sleep 1
  echo -n " "
  curl -b /tmp/cookies2 -c /tmp/cookies2 http://localhost:8180/$WAR_CONTEXT_PATH/session
  sleep 1
  echo -n " "
  curl -b /tmp/cookies1 -c /tmp/cookies1 http://localhost:8280/$WAR_CONTEXT_PATH/session
  sleep 1
  if [[ "$first_print" = true ]] ; then
        echo -n -e "\t\t\t(press CTRL+C to exit)"
        first_print=false
  fi
done
