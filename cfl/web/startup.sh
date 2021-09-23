#!/bin/bash -ux

DB_CREATE_TABLES=${DB_CREATE_TABLES:-false}
DB_AUTO_UPDATE=${DB_AUTO_UPDATE:-false}
MODULE_WEB_ADMIN=${MODULE_WEB_ADMIN:-true}
DEBUG=${DEBUG:-false}
DEV_MODE_MODULES=${DEV_MODE_MODULES:-"messages"}

OPENMRS_HOME=/usr/local/tomcat/.OpenMRS

# Move OWA and modules to OpenMRS home

mkdir -p $OPENMRS_HOME/owa
mkdir -p $OPENMRS_HOME/modules

echo 'Copying OpenMRS modules'
cp -r /opt/openmrs-modules/* $OPENMRS_HOME/modules/

echo 'Copying OpenMRS OWA apps'
cp -r /opt/openmrs-owa/* $OPENMRS_HOME/owa/

COPY_CFL_MODULES=${COPY_CFL_MODULES:-"true"}

if [ "$COPY_CFL_MODULES" != "false" ]; then
    echo 'Copying CFL modules'
    cp -r /opt/cfl-modules/* $OPENMRS_HOME/modules/
fi

mkdir -p ~/modules

cat > /usr/local/tomcat/openmrs-server.properties << EOF
install_method=auto
connection.url=jdbc\:mysql\://${DB_HOST}\:3306/${DB_DATABASE}?autoReconnect\=true&sessionVariables\=default_storage_engine\=InnoDB&useUnicode\=true&characterEncoding\=UTF-8
connection.username=${DB_USERNAME}
connection.password=${DB_PASSWORD}
has_current_openmrs_database=true
create_database_user=false
module_web_admin=${MODULE_WEB_ADMIN}
create_tables=${DB_CREATE_TABLES}
auto_update_database=${DB_AUTO_UPDATE}
EOF

echo "------  Starting CFL distribution -----"
cat /root/openmrs-distro.properties
echo "-----------------------------------"

# wait for mysql to initialise
/usr/local/tomcat/wait-for-it.sh --timeout=3600 ${DB_HOST}:3306

if [ $DEBUG ]; then
    export JPDA_ADDRESS="1044"
    export JPDA_TRANSPORT=dt_socket
fi

# popagate SIGTERM to Tomcat for graceful shutdown
trap 'kill $CATALINA_PID' TERM INT

# start tomcat in background
/usr/local/tomcat/bin/catalina.sh jpda run &
CATALINA_PID=$!

# trigger first filter to start data importation
sleep 15
echo "Triggerring data import"
curl -L http://localhost:8080/openmrs/ > /dev/null
echo "Data import triggered"
sleep 15

# add development mode properties
grep -qxF 'uiFramework.developmentFolder=/usr/local/modules' /usr/local/tomcat/.OpenMRS/openmrs-runtime.properties || echo 'uiFramework.developmentFolder=/usr/local/modules' >> /usr/local/tomcat/.OpenMRS/openmrs-runtime.properties
grep -q 'uiFramework.developmentModules' /usr/local/tomcat/.OpenMRS/openmrs-runtime.properties || echo "uiFramework.developmentModules=${DEV_MODE_MODULES}" >> /usr/local/tomcat/.OpenMRS/openmrs-runtime.properties
sed -i "s/uiFramework.developmentModules=.*/uiFramework.developmentModules=${DEV_MODE_MODULES}/g" /usr/local/tomcat/.OpenMRS/openmrs-runtime.properties

# disabling cache properties
grep -qxF "net.sf.ehcache.disabled=true" /usr/local/tomcat/.OpenMRS/openmrs-runtime.properties || echo "net.sf.ehcache.disabled=true" >> /usr/local/tomcat/.OpenMRS/openmrs-runtime.properties
grep -qxF "hibernate.cache.use_second_level_cache=false" /usr/local/tomcat/.OpenMRS/openmrs-runtime.properties || echo "hibernate.cache.use_second_level_cache=false" >> /usr/local/tomcat/.OpenMRS/openmrs-runtime.properties
grep -qxF "hibernate.cache.use_query_cache=false" /usr/local/tomcat/.OpenMRS/openmrs-runtime.properties || echo "hibernate.cache.use_query_cache=false" >> /usr/local/tomcat/.OpenMRS/openmrs-runtime.properties
grep -qxF "hibernate.cache.auto_evict_collection_cache=false" /usr/local/tomcat/.OpenMRS/openmrs-runtime.properties || echo "hibernate.cache.auto_evict_collection_cache=false" >> /usr/local/tomcat/.OpenMRS/openmrs-runtime.properties

# bring tomcat process to foreground again
wait $CATALINA_PID

# 2nd wait for graceful shutown, don't pass signals anymore
trap - TERM INT
wait $CATALINA_PID
# Return exiit code from graceful shutdown
exit $?
