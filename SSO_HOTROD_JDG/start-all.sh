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
  echo 'ADDING USERS TO JDG'
  echo '======================================='
  $WLF_DIRECTORY/JDG1/bin/add-user.sh --silent -a -g users -u joe -p joeIsAwesome2013!
  $WLF_DIRECTORY/JDG2/bin/add-user.sh --silent -a -g users -u joe -p joeIsAwesome2013!
  $WLF_DIRECTORY/JDG1/bin/add-user.sh --silent -u admin -p admin123+
  $WLF_DIRECTORY/JDG2/bin/add-user.sh --silent -u admin -p admin123+
  $WLF_DIRECTORY/JDG1/bin/add-user.sh --silent -a -u ejb -p test
  $WLF_DIRECTORY/JDG2/bin/add-user.sh --silent -a -u ejb -p test
}

addUsersWildFly(){
  echo ''
  echo '======================================='
  echo 'ADDING USERS TO WILDFLY'
  echo '======================================='
  $WLF_DIRECTORY/WFL1/bin/add-user.sh --silent -a -g users -u joe -p joeIsAwesome2013!
  $WLF_DIRECTORY/WFL2/bin/add-user.sh --silent -a -g users -u joe -p joeIsAwesome2013!
  $WLF_DIRECTORY/WFL1/bin/add-user.sh --silent -u admin -p admin123+
  $WLF_DIRECTORY/WFL2/bin/add-user.sh --silent -u admin -p admin123+
  $WLF_DIRECTORY/WFL1/bin/add-user.sh --silent -a -u ejb -p test
  $WLF_DIRECTORY/WFL2/bin/add-user.sh --silent -a -u ejb -p test
  #$WLF_DIRECTORY/WFL1/bin/add-user.sh -a -u alice -p alice -r ApplicationRealm -ro user -g user
  #$WLF_DIRECTORY/WFL2/bin/add-user.sh -a -u alice -p alice -r ApplicationRealm -ro user -g user
  #$WLF_DIRECTORY/WFL1/bin/add-user.sh -a -u ssoUser -p ssoPassw -r ApplicationRealm -ro user
  #$WLF_DIRECTORY/WFL2/bin/add-user.sh -a -u ssoUser -p ssoPassw -r ApplicationRealm -ro user
  echo ''
  echo '======================================='
  echo 'SSO USER alice / alice'
  echo 'SSO USER ssoUser / ssoPassw'
  echo '======================================='
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
  JDG_CLI_SCRIPT_TMP_1=$JDG_DIRECTORY/1_$(basename $JDG_CLI_SCRIPT)
  JDG_CLI_SCRIPT_TMP_2=$JDG_DIRECTORY/2_$(basename $JDG_CLI_SCRIPT)
  cp  $JDG_CLI_SCRIPT $JDG_CLI_SCRIPT_TMP_1
  cp  $JDG_CLI_SCRIPT $JDG_CLI_SCRIPT_TMP_2
  sed -i "s/_NODE_IDENTIFIER_/JDG1/g" $JDG_CLI_SCRIPT_TMP_1
  sed -i "s/_NODE_IDENTIFIER_/JDG2/g" $JDG_CLI_SCRIPT_TMP_2
  echo '======================================='
  cat $JDG_CLI_SCRIPT_TMP_1
  $JDG_DIRECTORY/JDG1/bin/ispn-cli.sh --file=$JDG_CLI_SCRIPT_TMP_1
  cat $JDG_CLI_SCRIPT_TMP_2
  $JDG_DIRECTORY/JDG2/bin/ispn-cli.sh --file=$JDG_CLI_SCRIPT_TMP_2
}

configureWildFly(){
  echo ''
  echo '======================================='
  echo "CONFIGURE WILDFLY"
  WLF_CLI_SCRIPT_TMP_1=$WLF_DIRECTORY/1_$(basename $WLF_CLI_SCRIPT1)
  WLF_CLI_SCRIPT_TMP_2=$WLF_DIRECTORY/2_$(basename $WLF_CLI_SCRIPT2)
  cp  $WLF_CLI_SCRIPT1 $WLF_CLI_SCRIPT_TMP_1
  cp  $WLF_CLI_SCRIPT2 $WLF_CLI_SCRIPT_TMP_2
  sed -i "s/_NODE_IDENTIFIER_/WFL1/g" $WLF_CLI_SCRIPT_TMP_1
  sed -i "s/_NODE_IDENTIFIER_/WFL2/g" $WLF_CLI_SCRIPT_TMP_2
  echo '======================================='
  keytool -genkeypair -alias localhost -keyalg RSA -keysize 1024 -validity 365 -keystore $WLF_DIRECTORY/WFL1/standalone/configuration/keystore.jks -dname "CN=localhost" -keypass secret -storepass secret
  keytool -genkeypair -alias localhost -keyalg RSA -keysize 1024 -validity 365 -keystore $WLF_DIRECTORY/WFL2/standalone/configuration/keystore.jks -dname "CN=localhost" -keypass secret -storepass secret
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
  cd distributed-webapp-sso
  mvn $MVN_PROFILE clean install
  cd -
  cp -fv distributed-webapp-sso/target/$WAR_FINAL_NAME $WLF_DIRECTORY/WFL1/standalone/deployments/clusterbench1.war
  cp -fv distributed-webapp-sso/target/$WAR_FINAL_NAME $WLF_DIRECTORY/WFL1/standalone/deployments/clusterbench2.war
  sleep 2
  cp -fv distributed-webapp-sso/target/$WAR_FINAL_NAME $WLF_DIRECTORY/WFL2/standalone/deployments/clusterbench1.war
  cp -fv distributed-webapp-sso/target/$WAR_FINAL_NAME $WLF_DIRECTORY/WFL2/standalone/deployments/clusterbench2.war
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
export WLF_DIRECTORY=/tmp/SSO_HOTROD_JDG
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
export WLF_CLI_SCRIPT1=configuration1.cli
export WLF_CLI_SCRIPT2=configuration2.cli
export JDG_CLI_SCRIPT=configuration-jdg.cli
export MVN_PROFILE="-q"
export WAR_FINAL_NAME=clusterbench.war
export WAR_CONTEXT_PATH=clusterbench1
echo -e "${GREEN}\n=======================================\nUsing WLF_CLI_SCRIPT $WLF_CLI_SCRIPT1 and $WLF_CLI_SCRIPT2\nUsing WAR_FINAL_NAME $WAR_FINAL_NAME\nUsing WAR_CONTEXT_PATH $WAR_CONTEXT_PATH\nUsing JDG_CLI_SCRIPT $JDG_CLI_SCRIPT\n=======================================\n${NC}"

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
rm -rfd /tmp/clustering-filesystem-realm-node1
rm -rfd /tmp/clustering-filesystem-realm-node2
sleep 1

downloadJdg

downloadWildFly

addUsersJdg

addUsersWildFly

configureJdg

configureWildFly

startJDG1
sleep 2

startJDG2
sleep 5

startWFL1
sleep 2

startWFL2
sleep 5

deployToWildFly

exitWithMsg "paste \"http://localhost:8180/$WAR_CONTEXT_PATH/session\" or \"http://localhost:8280/$WAR_CONTEXT_PATH/session\" in your browser ..."
