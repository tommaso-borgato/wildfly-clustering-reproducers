./stop-all.sh

export JAVA_HOME_8=/usr/Java/oracle/jdk1.8.0_181
export JAVA_HOME_11=/usr/Java/openjdk/jdk-11.0.2

export WLF_ZIP=/home/tborgato/projects/RFE/EAP7-1109/wildfly-remote.zip
# https://github.com/infinispan/infinispan/pull/6838
#export JDG_ZIP=/home/tborgato/projects/RFE/EAP7-1072/infinispan-server-9.4.6.Final.zip
#export JDG_ZIP=/home/tborgato/projects/RFE/EAP7-1072/jboss-datagrid-7.2.0-server.zip
export JDG_ZIP=/home/tborgato/projects/RFE/EAP7-1072/jboss-datagrid-7.3.0-server.zip
#export JDG_ZIP=/home/tborgato/projects/RFE/EAP7-1109/infinispan-server-10.0.0.Beta3.zip

./start-all.sh