#!/bin/bash
set -eux

# Your custom commands here
echo "ABXOXO Running custom startup commands..."

# onebusaway-transit-data-federation-webapp

sed -i \
    "s|#JDBC_DRIVER#|${JDBC_DRIVER}|g" \
    /usr/local/tomcat/webapps/onebusaway-transit-data-federation-webapp/WEB-INF/classes/data-sources.xml

sed -i \
    "s|#JDBC_URL#|${JDBC_URL}|g" \
    /usr/local/tomcat/webapps/onebusaway-transit-data-federation-webapp/WEB-INF/classes/data-sources.xml

sed -i \
    "s|#JDBC_USERNAME#|${JDBC_USERNAME}|g" \
    /usr/local/tomcat/webapps/onebusaway-transit-data-federation-webapp/WEB-INF/classes/data-sources.xml

sed -i \
    "s|#JDBC_PASSWORD#|${JDBC_PASSWORD}|g" \
    /usr/local/tomcat/webapps/onebusaway-transit-data-federation-webapp/WEB-INF/classes/data-sources.xml

# onebusaway-api-webapp

sed -i \
    "s|#JDBC_DRIVER#|${JDBC_DRIVER}|g" \
    /usr/local/tomcat/webapps/onebusaway-api-webapp/WEB-INF/classes/data-sources.xml

sed -i \
    "s|#JDBC_URL#|${JDBC_URL}|g" \
    /usr/local/tomcat/webapps/onebusaway-api-webapp/WEB-INF/classes/data-sources.xml

sed -i \
    "s|#JDBC_USERNAME#|${JDBC_USERNAME}|g" \
    /usr/local/tomcat/webapps/onebusaway-api-webapp/WEB-INF/classes/data-sources.xml

sed -i \
    "s|#JDBC_PASSWORD#|${JDBC_PASSWORD}|g" \
    /usr/local/tomcat/webapps/onebusaway-api-webapp/WEB-INF/classes/data-sources.xml

exec /usr/local/tomcat/bin/catalina.sh run