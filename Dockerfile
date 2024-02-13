FROM tomcat:8.5.98-jdk11-temurin

ARG OBA_VERSION=2.4.18-cs
ENV GTFS_URL "https://unitrans.ucdavis.edu/media/gtfs/Unitrans_GTFS.zip"
ENV CATALINA_HOME /usr/local/tomcat

RUN mkdir /oba
WORKDIR /oba

# OBA WAR and JAR files
RUN wget "https://repo.camsys-apps.com/releases/org/onebusaway/onebusaway-transit-data-federation-builder/${OBA_VERSION}/onebusaway-transit-data-federation-builder-${OBA_VERSION}-withAllDependencies.jar"
RUN wget "https://repo.camsys-apps.com/releases/org/onebusaway/onebusaway-transit-data-federation-webapp/${OBA_VERSION}/onebusaway-transit-data-federation-webapp-${OBA_VERSION}.war"
RUN wget "https://repo.camsys-apps.com/releases/org/onebusaway/onebusaway-api-webapp/${OBA_VERSION}/onebusaway-api-webapp-${OBA_VERSION}.war"

# MySQL Connector
RUN mkdir -p $CATALINA_HOME/lib
WORKDIR $CATALINA_HOME/lib
RUN wget "https://cdn.mysql.com/Downloads/Connector-J/mysql-connector-j-8.3.0.tar.gz"
RUN tar -zxvf mysql-connector-j-8.3.0.tar.gz
RUN mv mysql-connector-j-8.3.0/mysql-connector-j-8.3.0.jar .

# Build Bundle from GTFS Data
RUN mkdir /oba/gtfs
WORKDIR /oba/gtfs

RUN wget -O gtfs.zip ${GTFS_URL}

RUN java -jar -Xss1g -Xmx2g /oba/onebusaway-transit-data-federation-builder-${OBA_VERSION}-withAllDependencies.jar /oba/gtfs/gtfs.zip /oba/gtfs

# Tomcat Configuration

RUN mkdir $CATALINA_HOME/webapps/onebusaway-transit-data-federation-webapp
WORKDIR $CATALINA_HOME/webapps/onebusaway-transit-data-federation-webapp
RUN mv /oba/onebusaway-transit-data-federation-webapp-${OBA_VERSION}.war .
RUN jar xvf onebusaway-transit-data-federation-webapp-${OBA_VERSION}.war
COPY /oba_config/onebusaway-transit-data-federation-webapp-data-sources.xml ./WEB-INF/classes/data-sources.xml
RUN cp $CATALINA_HOME/lib/mysql-connector-j-8.3.0.jar ./WEB-INF/lib

RUN mkdir $CATALINA_HOME/webapps/onebusaway-api-webapp
WORKDIR $CATALINA_HOME/webapps/onebusaway-api-webapp
RUN mv /oba/onebusaway-api-webapp-${OBA_VERSION}.war .
RUN jar xvf onebusaway-api-webapp-${OBA_VERSION}.war
COPY ./oba_config/onebusaway-api-webapp-data-sources.xml ./WEB-INF/classes/data-sources.xml
RUN cp $CATALINA_HOME/lib/mysql-connector-j-8.3.0.jar ./WEB-INF/lib
