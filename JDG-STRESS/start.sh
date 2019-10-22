export JAVA_HOME=/usr/Java/oracle/jdk1.8.0_181
export JDG_ZIP=$(pwd)/artifacts/jboss-datagrid-7.3.0-server.zip
export WLF_ZIP=$(pwd)/artifacts/jboss-eap-7.2.4.zip
export WLF_PATCH_ZIP=$(pwd)/artifacts/jbeap-17806.zip

./start-all.sh --patch