#!/usr/bin/bash

startWFL1(){
  echo ''
  echo '======================================='
  echo "STARTING WFL1"
  echo $BASE_DIRECTORY/WFL1/bin/standalone.sh --server-config=standalone-ha.xml -Dprogram.name=WFL1 -Djboss.node.name=WFL1 -Djboss.socket.binding.port-offset=100
  echo '======================================='
  gnome-terminal --geometry=140x35 --window --zoom=0.8 --working-directory=$BASE_DIRECTORY/WFL1 --title="WFL1" -- $BASE_DIRECTORY/WFL1/bin/standalone.sh --server-config=standalone-ha.xml -Dprogram.name=WFL1 -Djboss.node.name=WFL1 -Djboss.socket.binding.port-offset=100
}

startWFL2(){
  echo ''
  echo '======================================='
  echo "STARTING WFL2"
  echo $BASE_DIRECTORY/WFL2/bin/standalone.sh --server-config=standalone-ha.xml -Dprogram.name=WFL2 -Djboss.node.name=WFL2 -Djboss.socket.binding.port-offset=200
  echo '======================================='
  gnome-terminal --geometry=140x35 --window --zoom=0.8 --working-directory=$BASE_DIRECTORY/WFL2 --title="WFL2" -- $BASE_DIRECTORY/WFL2/bin/standalone.sh --server-config=standalone-ha.xml -Dprogram.name=WFL2 -Djboss.node.name=WFL2 -Djboss.socket.binding.port-offset=200
}

startJDG1(){
  echo ''
  echo '======================================='
  echo "STARTING JDG1"
  echo $BASE_DIRECTORY/JDG1/bin/standalone.sh --server-config=clustered.xml -Dprogram.name=JDG1 -Djboss.node.name=JDG1 -Djboss.socket.binding.port-offset=300
  echo '======================================='
  gnome-terminal --geometry=140x35 --window --zoom=0.8 --working-directory=$BASE_DIRECTORY/JDG1 --title="JDG1" -- $BASE_DIRECTORY/JDG1/bin/standalone.sh --server-config=clustered.xml -Dprogram.name=JDG1 -Djboss.node.name=JDG1 -Djboss.socket.binding.port-offset=300
}

startJDG2(){
  echo ''
  echo '======================================='
  echo "STARTING JDG2"
  echo $BASE_DIRECTORY/JDG2/bin/standalone.sh --server-config=clustered.xml -Dprogram.name=JDG2 -Djboss.node.name=JDG2 -Djboss.socket.binding.port-offset=400
  echo '======================================='
  gnome-terminal --geometry=140x35 --window --zoom=0.8 --working-directory=$BASE_DIRECTORY/JDG2 --title="JDG2" -- $BASE_DIRECTORY/JDG2/bin/standalone.sh --server-config=clustered.xml -Dprogram.name=JDG2 -Djboss.node.name=JDG2 -Djboss.socket.binding.port-offset=400
}

addUsersJdg(){
  echo ''
  echo '======================================='
  echo 'ADDING USERS TO JDG'
  echo '======================================='
  $BASE_DIRECTORY/JDG1/bin/add-user.sh -a -g users -u joe -p joeIsAwesome2013!
  $BASE_DIRECTORY/JDG2/bin/add-user.sh -a -g users -u joe -p joeIsAwesome2013!
  $BASE_DIRECTORY/JDG1/bin/add-user.sh -u admin -p admin123+
  $BASE_DIRECTORY/JDG2/bin/add-user.sh -u admin -p admin123+
  $BASE_DIRECTORY/JDG1/bin/add-user.sh -a -u ejb -p test
  $BASE_DIRECTORY/JDG2/bin/add-user.sh -a -u ejb -p test
}

addUsersWildFly(){
  echo ''
  echo '======================================='
  echo 'ADDING USERS TO WILDFLY'
  echo '======================================='
  $BASE_DIRECTORY/WFL1/bin/add-user.sh -a -g users -u joe -p joeIsAwesome2013!
  $BASE_DIRECTORY/WFL2/bin/add-user.sh -a -g users -u joe -p joeIsAwesome2013!
  $BASE_DIRECTORY/WFL1/bin/add-user.sh -u admin -p admin123+
  $BASE_DIRECTORY/WFL2/bin/add-user.sh -u admin -p admin123+
  $BASE_DIRECTORY/WFL1/bin/add-user.sh -a -u ejb -p test
  $BASE_DIRECTORY/WFL2/bin/add-user.sh -a -u ejb -p test
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
  if [[ ! -d "$BASE_DIRECTORY/JDG1" ]] ; then
    echo ''
    echo '======================================='
    echo "UNZIP JDG to $BASE_DIRECTORY/JDG1"
    echo '======================================='
    unzip -d $BASE_DIRECTORY/tmp-jdg $JDG_ZIP > /dev/null
    mv $BASE_DIRECTORY/tmp-jdg/*-server* $BASE_DIRECTORY/JDG1
    rm -fdr $BASE_DIRECTORY/tmp-jdg
  fi
  if [[ ! -d "$BASE_DIRECTORY/JDG2" ]] ; then
    echo ''
    echo '======================================='
    echo "UNZIP JDG to $BASE_DIRECTORY/JDG2"
    echo '======================================='
    unzip -d $BASE_DIRECTORY/tmp-jdg $JDG_ZIP > /dev/null
    mv $BASE_DIRECTORY/tmp-jdg/*-server* $BASE_DIRECTORY/JDG2
    rm -fdr $BASE_DIRECTORY/tmp-jdg
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
  if [[ ! -d "$BASE_DIRECTORY/WFL1" ]] ; then
    echo ''
    echo '======================================='
    echo "UNZIP WILDFLY to $BASE_DIRECTORY/WFL1"
    echo '======================================='
    unzip -d $BASE_DIRECTORY/tmp-wildfly $WLF_ZIP > /dev/null
    mv $BASE_DIRECTORY/tmp-wildfly/wildfly* $BASE_DIRECTORY/WFL1
    rm -fdr $BASE_DIRECTORY/tmp-wildfly
  fi
  if [[ ! -d "$BASE_DIRECTORY/WFL2" ]] ; then
    echo ''
    echo '======================================='
    echo "UNZIP WILDFLY to $BASE_DIRECTORY/WFL2"
    echo '======================================='
    unzip -d $BASE_DIRECTORY/tmp-wildfly $WLF_ZIP > /dev/null
    mv $BASE_DIRECTORY/tmp-wildfly/wildfly* $BASE_DIRECTORY/WFL2
    rm -fdr $BASE_DIRECTORY/tmp-wildfly
  fi
}

configureJdg(){
  echo ''
  echo '======================================='
  echo "CONFIGURE JDG"
  JDG_CLI_SCRIPT_TMP_1=$BASE_DIRECTORY/1_$(basename $JDG_CLI_SCRIPT)
  JDG_CLI_SCRIPT_TMP_2=$BASE_DIRECTORY/2_$(basename $JDG_CLI_SCRIPT)
  cp  $JDG_CLI_SCRIPT $JDG_CLI_SCRIPT_TMP_1
  cp  $JDG_CLI_SCRIPT $JDG_CLI_SCRIPT_TMP_2
  sed -i "s/_NODE_IDENTIFIER_/JDG1/g" $JDG_CLI_SCRIPT_TMP_1
  sed -i "s/_NODE_IDENTIFIER_/JDG2/g" $JDG_CLI_SCRIPT_TMP_2
  echo '======================================='
  cat $JDG_CLI_SCRIPT_TMP_1
  $BASE_DIRECTORY/JDG1/bin/ispn-cli.sh --file=$JDG_CLI_SCRIPT_TMP_1
  sleep 2
  cat $JDG_CLI_SCRIPT_TMP_2
  $BASE_DIRECTORY/JDG2/bin/ispn-cli.sh --file=$JDG_CLI_SCRIPT_TMP_2
  sleep 2
}

configureSshKeys(){
  rm -f $BASE_DIRECTORY/*.jks
  rm -f $BASE_DIRECTORY/*.cer
  # Enable Two-way SSL/TLS for Applications Using the Elytron Subsystem
  ## client keystore
  keytool -genkeypair -alias wfl-client -keyalg RSA -keysize 1024 -validity 365 -keystore $BASE_DIRECTORY/wfl.keystore.jks -dname "CN=wfl.client" -keypass secret -storepass secret

  ## export the client certificates
  keytool -exportcert -keystore $BASE_DIRECTORY/wfl.keystore.jks -alias wfl-client -keypass secret -storepass secret -file $BASE_DIRECTORY/wfl.cer

  ## import the server certificate into the client truststore
  keytool -importcert -keystore $BASE_DIRECTORY/wfl.truststore.jks -storepass secret -alias localhost -trustcacerts -file $BASE_DIRECTORY/wfl.cer -noprompt

  cp $BASE_DIRECTORY/wfl.keystore.jks $BASE_DIRECTORY/WFL1/standalone/configuration/wfl.keystore.jks
  cp $BASE_DIRECTORY/wfl.keystore.jks $BASE_DIRECTORY/WFL2/standalone/configuration/wfl.keystore.jks
  cp $BASE_DIRECTORY/wfl.truststore.jks $BASE_DIRECTORY/WFL1/standalone/configuration/wfl.truststore.jks
  cp $BASE_DIRECTORY/wfl.truststore.jks $BASE_DIRECTORY/WFL2/standalone/configuration/wfl.truststore.jks

  cp $BASE_DIRECTORY/wfl.keystore.jks $BASE_DIRECTORY/JDG1/standalone/configuration/wfl.keystore.jks
  cp $BASE_DIRECTORY/wfl.keystore.jks $BASE_DIRECTORY/JDG2/standalone/configuration/wfl.keystore.jks
}

configureWildFly(){
  echo ''
  echo '======================================='
  echo "CONFIGURE WILDFLY"
  WLF_CLI_SCRIPT_TMP_1=$BASE_DIRECTORY/1_$(basename $WLF_CLI_SCRIPT)
  WLF_CLI_SCRIPT_TMP_2=$BASE_DIRECTORY/2_$(basename $WLF_CLI_SCRIPT)
  cp $WLF_CLI_SCRIPT $WLF_CLI_SCRIPT_TMP_1
  cp $WLF_CLI_SCRIPT $WLF_CLI_SCRIPT_TMP_2
  sed -i "s/_NODE_IDENTIFIER_/WFL1/g" $WLF_CLI_SCRIPT_TMP_1
  sed -i "s/_NODE_IDENTIFIER_/WFL2/g" $WLF_CLI_SCRIPT_TMP_2
  echo '======================================='
  cp -f $BASE_DIRECTORY/WFL1/standalone/configuration/standalone-ha.xml $BASE_DIRECTORY/WFL1/standalone/configuration/standalone-ha.xml.ORIG
  cat $WLF_CLI_SCRIPT_TMP_1
  $BASE_DIRECTORY/WFL1/bin/jboss-cli.sh --file=$WLF_CLI_SCRIPT_TMP_1
  sleep 2
  cp -f $BASE_DIRECTORY/WFL2/standalone/configuration/standalone-ha.xml $BASE_DIRECTORY/WFL2/standalone/configuration/standalone-ha.xml.ORIG
  cat $WLF_CLI_SCRIPT_TMP_2
  $BASE_DIRECTORY/WFL2/bin/jboss-cli.sh --file=$WLF_CLI_SCRIPT_TMP_2
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
  cp -fv distributed-webapp/target/$WAR_FINAL_NAME $BASE_DIRECTORY/WFL1/standalone/deployments/
  sleep 5
  cp -fv distributed-webapp/target/$WAR_FINAL_NAME $BASE_DIRECTORY/WFL2/standalone/deployments/
  sleep 5
}

exitWithMsg(){
    echo "$1"
    echo "e.g.: $0 [--secure]"
    echo "NOTE: set ...."
    exit -1
}

# ================
# START
# ================
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
export BASE_DIRECTORY=/tmp/JDG
export BASE_DIRECTORY=$BASE_DIRECTORY

# ========================
# WildFly bits
# ========================
if [[ "x$WLF_ZIP" = "x" ]]; then
    export WLF_ZIP=$BASE_DIRECTORY/wildfly.zip
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
    export JDG_ZIP=$BASE_DIRECTORY/jboss-datagrid-server.zip
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
if [[ "x$1" = "x" ]]; then
    export WLF_CLI_SCRIPT=configuration-wfl.cli
    export MVN_PROFILE="-q -P"
    export WAR_FINAL_NAME=distributed-webapp.war
    export WAR_CONTEXT_PATH=distributed-webapp
    export JDG_CLI_SCRIPT=configuration-jdg.cli
elif [[ "x$1" = "x--secure" ]]; then
    echo -e "${GREEN}\n=======================================\nUsing secured JDG connection\n=======================================\n${NC}"
    export WLF_CLI_SCRIPT=configuration-wfl-SECURED.cli
    export MVN_PROFILE="-q -P"
    export WAR_FINAL_NAME=distributed-webapp.war
    export WAR_CONTEXT_PATH=distributed-webapp
    export JDG_CLI_SCRIPT=configuration-jdg-SECURED.cli
    sleep 5
else
    exitWithMsg "Invalid first argument"
fi
echo -e "${GREEN}\n=======================================\nUsing WLF_CLI_SCRIPT $WLF_CLI_SCRIPT\nUsing WAR_FINAL_NAME $WAR_FINAL_NAME\nUsing WAR_CONTEXT_PATH $WAR_CONTEXT_PATH\nUsing JDG_CLI_SCRIPT $JDG_CLI_SCRIPT\n=======================================\n${NC}"

mkdir -p $BASE_DIRECTORY

echo ''
echo '======================================='
echo "REMOVE PREVIOUS WILDFLY AND JDG INSTALLATIONS"
echo '======================================='
rm -rfd $BASE_DIRECTORY/WFL1
rm -rfd $BASE_DIRECTORY/WFL2
rm -rfd $BASE_DIRECTORY/JDG1
rm -rfd $BASE_DIRECTORY/JDG2
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

configureSshKeys
sleep 2

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
sleep 10

deployToWildFly
sleep 10

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
