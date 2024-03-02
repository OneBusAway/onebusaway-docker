FROM tomcat:8.5.98-jdk11-temurin

ENV CATALINA_HOME /usr/local/tomcat
ARG OBA_VERSION=2.4.18-cs

ARG GID=1000
ARG UID=1000
ARG GROUP=oba_group
ARG USER=oba_user
ARG MYSQL_JAR_VERSION="8.3.0"
ARG MYSQL_JAR=mysql-connector-j-${MYSQL_JAR_VERSION}.jar
ARG PG_JAR=postgresql-42.7.2.jar

RUN groupadd -g $GID $GROUP && \
    useradd -d /home/$USER -u $UID -m -s /bin/bash -g $GROUP $USER && \
    chown -R $USER:$GROUP $CATALINA_HOME && \
    mkdir -p /var/log/tomcat8 && \
    chown -R $USER:$GROUP /var/log/tomcat8

USER $USER

# JDBC Connectors
WORKDIR $CATALINA_HOME/lib

RUN wget "https://cdn.mysql.com/Downloads/Connector-J/mysql-connector-j-${MYSQL_JAR_VERSION}.tar.gz" \
    && tar -zxvf mysql-connector-j-${MYSQL_JAR_VERSION}.tar.gz \
    && mv mysql-connector-j-${MYSQL_JAR_VERSION}/mysql-connector-j-${MYSQL_JAR_VERSION}.jar . \
    && rm mysql-connector-j-${MYSQL_JAR_VERSION}.tar.gz \
    && rm -rf mysql-connector-j-${MYSQL_JAR_VERSION}

run wget "https://jdbc.postgresql.org/download/${PG_JAR}"

# Start configuring OBA
WORKDIR /oba/libs

# OBA WAR and JAR files
RUN wget "https://repo.camsys-apps.com/releases/org/onebusaway/onebusaway-transit-data-federation-webapp/${OBA_VERSION}/onebusaway-transit-data-federation-webapp-${OBA_VERSION}.war"
RUN wget "https://repo.camsys-apps.com/releases/org/onebusaway/onebusaway-api-webapp/${OBA_VERSION}/onebusaway-api-webapp-${OBA_VERSION}.war"
RUN wget "https://repo.camsys-apps.com/releases/org/onebusaway/onebusaway-enterprise-acta-webapp/${OBA_VERSION}/onebusaway-enterprise-acta-webapp-${OBA_VERSION}.war"

# Tomcat Configuration
WORKDIR /oba/webapps/onebusaway-transit-data-federation-webapp
RUN cp /oba/libs/onebusaway-transit-data-federation-webapp-${OBA_VERSION}.war .
RUN jar xvf onebusaway-transit-data-federation-webapp-${OBA_VERSION}.war
RUN rm onebusaway-transit-data-federation-webapp-${OBA_VERSION}.war
COPY ./config/onebusaway-transit-data-federation-webapp-data-sources.xml ./WEB-INF/classes/data-sources.xml
RUN cp $CATALINA_HOME/lib/${MYSQL_JAR} ./WEB-INF/lib
RUN cp $CATALINA_HOME/lib/${PG_JAR} ./WEB-INF/lib
RUN mv /oba/webapps/onebusaway-transit-data-federation-webapp $CATALINA_HOME/webapps

WORKDIR /oba/webapps/onebusaway-api-webapp
RUN cp /oba/libs/onebusaway-api-webapp-${OBA_VERSION}.war .
RUN jar xvf onebusaway-api-webapp-${OBA_VERSION}.war
RUN rm onebusaway-api-webapp-${OBA_VERSION}.war
COPY ./config/onebusaway-api-webapp-data-sources.xml ./WEB-INF/classes/data-sources.xml
RUN cp $CATALINA_HOME/lib/${MYSQL_JAR} ./WEB-INF/lib
RUN cp $CATALINA_HOME/lib/${PG_JAR} ./WEB-INF/lib
RUN mv /oba/webapps/onebusaway-api-webapp $CATALINA_HOME/webapps

WORKDIR /oba/webapps/onebusaway-enterprise-acta-webapp
RUN cp /oba/libs/onebusaway-enterprise-acta-webapp-${OBA_VERSION}.war .
RUN jar xvf onebusaway-enterprise-acta-webapp-${OBA_VERSION}.war
RUN rm onebusaway-enterprise-acta-webapp-${OBA_VERSION}.war
COPY ./config/onebusaway-enterprise-acta-webapp-data-sources.xml ./WEB-INF/classes/data-sources.xml
RUN cp $CATALINA_HOME/lib/${MYSQL_JAR} ./WEB-INF/lib
RUN cp $CATALINA_HOME/lib/${PG_JAR} ./WEB-INF/lib
RUN mv /oba/webapps/onebusaway-enterprise-acta-webapp $CATALINA_HOME/webapps
