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

startPrometheus(){
  echo ''
  echo '======================================='
  echo "STARTING PROMETHEUS"
  echo '======================================='
  gnome-terminal --geometry=140x35 --window --zoom=0.7 --title="Prometheus" -- docker run --name=prometheus --rm --network host --mount type=bind,source=$WLF_DIRECTORY,target=/etc/prometheus/ prom/prometheus
}

startGrafana(){
  echo ''
  echo '======================================='
  echo "STARTING GRAFANA"
  echo '======================================='
  gnome-terminal --geometry=140x35 --window --zoom=0.7 --title="Grafana" -- docker run --name=grafana --rm --network host grafana/grafana
}

downloadWildFly(){
  echo ''
  echo '======================================='
  echo "DOWNLOADING WILDFLY"
  echo '======================================='
  export WIDLFLY_ZIP=wildfly.zip
  if [[ ! -f "$WLF_DIRECTORY/$WIDLFLY_ZIP" ]] ; then
    wget -O $WLF_DIRECTORY/$WIDLFLY_ZIP https://download.jboss.org/wildfly/16.0.0.Beta1/wildfly-16.0.0.Beta1.zip
  fi
  echo ''
  echo '======================================='
  echo "UNZIP WILDFLY to $WLF_DIRECTORY/WFL1"
  echo '======================================='
  if [[ ! -d "$WLF_DIRECTORY/WFL1" ]] ; then
    unzip -d $WLF_DIRECTORY/tmp-wildfly $WLF_DIRECTORY/$WIDLFLY_ZIP > /dev/null
    mv $WLF_DIRECTORY/tmp-wildfly/wildfly* $WLF_DIRECTORY/WFL1
    rm -fdr $WLF_DIRECTORY/tmp-wildfly
  fi
  echo ''
  echo '======================================='
  echo "UNZIP WILDFLY to $WLF_DIRECTORY/WFL2"
  echo '======================================='
  if [[ ! -d "$WLF_DIRECTORY/WFL2" ]] ; then
    unzip -d $WLF_DIRECTORY/tmp-wildfly $WLF_DIRECTORY/$WIDLFLY_ZIP > /dev/null
    mv $WLF_DIRECTORY/tmp-wildfly/wildfly* $WLF_DIRECTORY/WFL2
    rm -fdr $WLF_DIRECTORY/tmp-wildfly
  fi
  echo ''
  echo '======================================='
  echo "UNZIP WILDFLY to $WLF_DIRECTORY/WFL3"
  echo '======================================='
  if [[ ! -d "$WLF_DIRECTORY/WFL3" ]] ; then
    unzip -d $WLF_DIRECTORY/tmp-wildfly $WLF_DIRECTORY/$WIDLFLY_ZIP > /dev/null
    mv $WLF_DIRECTORY/tmp-wildfly/wildfly* $WLF_DIRECTORY/WFL3
    rm -fdr $WLF_DIRECTORY/tmp-wildfly
  fi
  echo ''
  echo '======================================='
  echo "UNZIP WILDFLY to $WLF_DIRECTORY/WFL4"
  echo '======================================='
  if [[ ! -d "$WLF_DIRECTORY/WFL4" ]] ; then
    unzip -d $WLF_DIRECTORY/tmp-wildfly $WLF_DIRECTORY/$WIDLFLY_ZIP > /dev/null
    mv $WLF_DIRECTORY/tmp-wildfly/wildfly* $WLF_DIRECTORY/WFL4
    rm -fdr $WLF_DIRECTORY/tmp-wildfly
  fi
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

# ================
# START
# ================

export WLF_DIRECTORY=/tmp/METRICS
mkdir -p $WLF_DIRECTORY
cp -f prometheus.yml $WLF_DIRECTORY

downloadWildFly
sleep 3

startWFL1 &
sleep 5

startWFL2 &
sleep 5

startWFL3 &
sleep 5

startWFL4 &
sleep 5

startPrometheus &
sleep 10

startGrafana &
sleep 20

deployToWildFly

echo ''
echo '======================================='
echo "CREATING GRAFANA DATASOURCE TO PROMETHEUS"
echo '======================================='
curl --user admin:admin --request POST --header "Content-Type: application/json" --data '{"name":"prometheus_datasource","type":"prometheus","url":"http://localhost:9090","access":"direct","basicAuth":false}' http://localhost:3000/api/datasources
sleep 10

echo ''
echo ''
echo '======================================='
echo "CREATING GRAFANA DASHBOARD"
echo '======================================='
curl --user admin:admin --request POST --header "Content-Type: application/json" --data @dashboard.json http://localhost:3000/api/dashboards/db
sleep 10

echo ''
echo ''
echo ''
echo "---------------------------------------------------------------------------------------------"
echo "Now access Grafana at 'http://localhost:3000/' with username 'admin' and password 'admin'"
echo "Now access Prometheus at 'http://localhost:9090'"
echo "---------------------------------------------------------------------------------------------"
echo ''

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
