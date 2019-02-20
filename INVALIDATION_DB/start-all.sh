#!/usr/bin/bash

startWFL1(){
  echo ''
  echo '======================================='
  echo "STARTING WFL1"
  echo '======================================='
  gnome-terminal --geometry=140x35 --window --zoom=0.7 --working-directory=$WLF_DIRECTORY/WFL1 --title="WFL1" -- $WLF_DIRECTORY/WFL1/bin/standalone.sh --server-config=standalone-ha.xml -Dprogram.name=WFL1 -Djboss.node.name=WFL1 -Djboss.socket.binding.port-offset=100
}

startWFL2(){
  echo ''
  echo '======================================='
  echo "STARTING WFL2"
  echo '======================================='
  gnome-terminal --geometry=140x35 --window --zoom=0.7 --working-directory=$WLF_DIRECTORY/WFL2 --title="WFL2" -- $WLF_DIRECTORY/WFL2/bin/standalone.sh --server-config=standalone-ha.xml -Dprogram.name=WFL2 -Djboss.node.name=WFL2 -Djboss.socket.binding.port-offset=200
}

startWFL3(){
  echo ''
  echo '======================================='
  echo "STARTING WFL3"
  echo '======================================='
  gnome-terminal --geometry=140x35 --window --zoom=0.7 --working-directory=$WLF_DIRECTORY/WFL3 --title="WFL3" -- $WLF_DIRECTORY/WFL3/bin/standalone.sh --server-config=standalone-ha.xml -Dprogram.name=WFL3 -Djboss.node.name=WFL3 -Djboss.socket.binding.port-offset=300
}

startWFL4(){
  echo ''
  echo '======================================='
  echo "STARTING WFL4"
  echo '======================================='
  gnome-terminal --geometry=140x35 --window --zoom=0.7 --working-directory=$WLF_DIRECTORY/WFL4 --title="WFL4" -- $WLF_DIRECTORY/WFL4/bin/standalone.sh --server-config=standalone-ha.xml -Dprogram.name=WFL4 -Djboss.node.name=WFL4 -Djboss.socket.binding.port-offset=400
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
  echo ''
  echo '======================================='
  echo "DOWNLOADING WILDFLY"
  echo '======================================='
  if [[ ! -f $WIDLFLY_ZIP ]] ; then
    wget -O $WIDLFLY_ZIP https://download.jboss.org/wildfly/16.0.0.Beta1/wildfly-16.0.0.Beta1.zip
  fi
  echo ''
  echo '======================================='
  echo "UNZIP WILDFLY to $WLF_DIRECTORY/WFL1"
  echo '======================================='
  if [[ ! -d "$WLF_DIRECTORY/WFL1" ]] ; then
    unzip -d $WLF_DIRECTORY/tmp-wildfly $WIDLFLY_ZIP > /dev/null
    mv $WLF_DIRECTORY/tmp-wildfly/wildfly* $WLF_DIRECTORY/WFL1
    rm -fdr $WLF_DIRECTORY/tmp-wildfly
  fi
  echo ''
  echo '======================================='
  echo "UNZIP WILDFLY to $WLF_DIRECTORY/WFL2"
  echo '======================================='
  if [[ ! -d "$WLF_DIRECTORY/WFL2" ]] ; then
    unzip -d $WLF_DIRECTORY/tmp-wildfly $WIDLFLY_ZIP > /dev/null
    mv $WLF_DIRECTORY/tmp-wildfly/wildfly* $WLF_DIRECTORY/WFL2
    rm -fdr $WLF_DIRECTORY/tmp-wildfly
  fi
  echo ''
  echo '======================================='
  echo "UNZIP WILDFLY to $WLF_DIRECTORY/WFL3"
  echo '======================================='
  if [[ ! -d "$WLF_DIRECTORY/WFL3" ]] ; then
    unzip -d $WLF_DIRECTORY/tmp-wildfly $WIDLFLY_ZIP > /dev/null
    mv $WLF_DIRECTORY/tmp-wildfly/wildfly* $WLF_DIRECTORY/WFL3
    rm -fdr $WLF_DIRECTORY/tmp-wildfly
  fi
  echo ''
  echo '======================================='
  echo "UNZIP WILDFLY to $WLF_DIRECTORY/WFL4"
  echo '======================================='
  if [[ ! -d "$WLF_DIRECTORY/WFL4" ]] ; then
    unzip -d $WLF_DIRECTORY/tmp-wildfly $WIDLFLY_ZIP > /dev/null
    mv $WLF_DIRECTORY/tmp-wildfly/wildfly* $WLF_DIRECTORY/WFL4
    rm -fdr $WLF_DIRECTORY/tmp-wildfly
  fi
}

deployJdbcDriver(){
  echo ''
  echo '======================================='
  echo "COPY JDBC JAR TO WILDFLY"
  echo '======================================='
  if [[ ! -f $JDBC_DRIVER_JAR ]] ; then
    wget -O $JDBC_DRIVER_JAR $JDBC_DRIVER_DOWNLOAD_URL
  fi
  cp -f $JDBC_DRIVER_JAR $WLF_DIRECTORY/WFL1/standalone/deployments/
  cp -f $JDBC_DRIVER_JAR $WLF_DIRECTORY/WFL2/standalone/deployments/
  cp -f $JDBC_DRIVER_JAR $WLF_DIRECTORY/WFL3/standalone/deployments/
  cp -f $JDBC_DRIVER_JAR $WLF_DIRECTORY/WFL4/standalone/deployments/
}

configureWildFly(){
  echo ''
  echo '======================================='
  echo "CONFIGURE WILDFLY"
  echo '======================================='
  $WLF_DIRECTORY/WFL1/bin/jboss-cli.sh --file=configuration.cli
  sleep 2
  $WLF_DIRECTORY/WFL2/bin/jboss-cli.sh --file=configuration.cli
  sleep 2
  $WLF_DIRECTORY/WFL3/bin/jboss-cli.sh --file=configuration.cli
  sleep 2
  $WLF_DIRECTORY/WFL4/bin/jboss-cli.sh --file=configuration.cli
  sleep 2
}

deployToWildFly(){
  cd distributed-webapp
  mvn clean install
  cd -
  cp -f distributed-webapp/target/distributed-webapp.war $WLF_DIRECTORY/WFL1/standalone/deployments/
  sleep 5
  cp -f distributed-webapp/target/distributed-webapp.war $WLF_DIRECTORY/WFL2/standalone/deployments/
  sleep 5
  cp -f distributed-webapp/target/distributed-webapp.war $WLF_DIRECTORY/WFL3/standalone/deployments/
  sleep 5
  cp -f distributed-webapp/target/distributed-webapp.war $WLF_DIRECTORY/WFL4/standalone/deployments/
  sleep 5
}

startPostgres(){
  echo ''
  echo '======================================='
  echo "STARTING PROMETHEUS"
  echo '======================================='
  gnome-terminal --geometry=140x35 --window --zoom=0.7 --title="Postgres" -- docker run --name=postgres --rm --network host -e POSTGRES_USER=$POSTGRES_USER -e POSTGRES_PASSWORD=$POSTGRES_PASSWORD -e POSTGRES_DB=$POSTGRES_DB postgres
}

# ================
# START
# ================

export WIDLFLY_ZIP=/tmp/METRICS/wildfly.zip
export POSTGRES_PASSWORD=postgres
export POSTGRES_USER=postgres
export POSTGRES_DB=postgres
export JDBC_DRIVER_DOWNLOAD_URL=http://www.qa.jboss.com/jdbc-drivers-products/EAP/7.3.0/postgresql101/jdbc4/postgresql-42.2.2.jar
export JDBC_DRIVER_JAR=postgresql-connector.jar
export WLF_DIRECTORY=/tmp/INVALIDATION_DB
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

startPostgres
sleep 10

downloadWildFly
sleep 3

addUsers

deployJdbcDriver

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
  echo -n -e "\rSESSION DATA: "
  curl -b /tmp/cookies1 -c /tmp/cookies1 http://localhost:8180/distributed-webapp/session
  sleep 1
  echo -n " "
  curl -b /tmp/cookies2 -c /tmp/cookies2 http://localhost:8280/distributed-webapp/session
  sleep 1
  echo -n " "
  curl -b /tmp/cookies3 -c /tmp/cookies3 http://localhost:8380/distributed-webapp/session
  sleep 1
  echo -n " "
  curl -b /tmp/cookies4 -c /tmp/cookies4 http://localhost:8480/distributed-webapp/session
  sleep 1
  echo -n " "
  curl -b /tmp/cookies4 -c /tmp/cookies4 http://localhost:8180/distributed-webapp/session
  sleep 1
  echo -n " "
  curl -b /tmp/cookies3 -c /tmp/cookies3 http://localhost:8280/distributed-webapp/session
  sleep 1
  echo -n " "
  curl -b /tmp/cookies2 -c /tmp/cookies2 http://localhost:8380/distributed-webapp/session
  sleep 1
  echo -n " "
  curl -b /tmp/cookies1 -c /tmp/cookies1 http://localhost:8480/distributed-webapp/session
  sleep 1
  if [[ "$first_print" = true ]] ; then
        echo -n -e "\t\t\t(press CTRL+C to exit)"
        first_print=false
  fi
done

