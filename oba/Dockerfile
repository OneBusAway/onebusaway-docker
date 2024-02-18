FROM tomcat:8.5.98-jdk11-temurin

ENV CATALINA_HOME /usr/local/tomcat
ARG OBA_VERSION=2.4.18-cs

# MySQL Connector
WORKDIR $CATALINA_HOME/lib
RUN wget "https://cdn.mysql.com/Downloads/Connector-J/mysql-connector-j-8.3.0.tar.gz" \
    && tar -zxvf mysql-connector-j-8.3.0.tar.gz \
    && mv mysql-connector-j-8.3.0/mysql-connector-j-8.3.0.jar . \
    && rm mysql-connector-j-8.3.0.tar.gz \
    && rm -rf mysql-connector-j-8.3.0

# Start configuring OBA
WORKDIR /oba/libs

# OBA WAR and JAR files
RUN wget "https://repo.camsys-apps.com/releases/org/onebusaway/onebusaway-transit-data-federation-webapp/${OBA_VERSION}/onebusaway-transit-data-federation-webapp-${OBA_VERSION}.war"
RUN wget "https://repo.camsys-apps.com/releases/org/onebusaway/onebusaway-api-webapp/${OBA_VERSION}/onebusaway-api-webapp-${OBA_VERSION}.war"
RUN wget "https://repo.camsys-apps.com/releases/org/onebusaway/onebusaway-enterprise-acta-webapp/${OBA_VERSION}/onebusaway-enterprise-acta-webapp-${OBA_VERSION}.war"

# Tomcat Configuration

WORKDIR $CATALINA_HOME/webapps/onebusaway-transit-data-federation-webapp
RUN mv /oba/libs/onebusaway-transit-data-federation-webapp-${OBA_VERSION}.war .
RUN jar xvf onebusaway-transit-data-federation-webapp-${OBA_VERSION}.war
COPY ./config/onebusaway-transit-data-federation-webapp-data-sources.xml ./WEB-INF/classes/data-sources.xml
RUN cp $CATALINA_HOME/lib/mysql-connector-j-8.3.0.jar ./WEB-INF/lib

WORKDIR $CATALINA_HOME/webapps/onebusaway-api-webapp
RUN mv /oba/libs/onebusaway-api-webapp-${OBA_VERSION}.war .
RUN jar xvf onebusaway-api-webapp-${OBA_VERSION}.war
COPY ./config/onebusaway-api-webapp-data-sources.xml ./WEB-INF/classes/data-sources.xml
RUN cp $CATALINA_HOME/lib/mysql-connector-j-8.3.0.jar ./WEB-INF/lib

WORKDIR $CATALINA_HOME/webapps/onebusaway-enterprise-acta-webapp
RUN mv /oba/libs/onebusaway-enterprise-acta-webapp-${OBA_VERSION}.war .
RUN jar xvf onebusaway-enterprise-acta-webapp-${OBA_VERSION}.war
COPY ./config/onebusaway-enterprise-acta-webapp-data-sources.xml ./WEB-INF/classes/data-sources.xml
RUN cp $CATALINA_HOME/lib/mysql-connector-j-8.3.0.jar ./WEB-INF/lib