FROM alpine:latest as builder
# Append Test API Key dynamically
ARG TEST_API_KEY
ENV TEST_API_KEY=${TEST_API_KEY}

# GTFS Realtime URLs
ARG TRIP_UPDATES_URL
ENV TRIP_UPDATES_URL=${TRIP_UPDATES_URL}

ARG VEHICLE_POSITIONS_URL
ENV VEHICLE_POSITIONS_URL=${VEHICLE_POSITIONS_URL}

ARG ALERTS_URL
ENV ALERTS_URL=${ALERTS_URL}

ARG REFRESH_INTERVAL
ENV REFRESH_INTERVAL=${REFRESH_INTERVAL}

ARG AGENCY_ID
ENV AGENCY_ID=${AGENCY_ID}

ARG FEED_API_KEY
ENV FEED_API_KEY=${FEED_API_KEY}

ARG FEED_API_VALUE
ENV FEED_API_VALUE=${FEED_API_VALUE}

# Google Maps related variables
ARG GOOGLE_MAPS_API_KEY
ENV GOOGLE_MAPS_API_KEY=${GOOGLE_MAPS_API_KEY}

ARG GOOGLE_MAPS_CHANNEL_ID
ENV GOOGLE_MAPS_CHANNEL_ID=${GOOGLE_MAPS_CHANNEL_ID}

ARG GOOGLE_MAPS_CLIENT_ID
ENV GOOGLE_MAPS_CLIENT_ID=${GOOGLE_MAPS_CLIENT_ID}

WORKDIR /oba
COPY bootstrap.sh .
COPY ./config ./config
RUN chmod +x bootstrap.sh
RUN apk update && apk add --no-cache bash jq && apk add --no-cache xmlstarlet
RUN ./bootstrap.sh


FROM tomcat:8.5.98-jdk11-temurin

ENV CATALINA_HOME /usr/local/tomcat
ARG OBA_VERSION=2.4.18-cs

ARG GID=1000
ARG UID=1000
ARG GROUP=oba_group
ARG USER=oba_user

RUN groupadd -g $GID $GROUP && \
    useradd -d /home/$USER -u $UID -m -s /bin/bash -g $GROUP $USER && \
    chown -R $USER:$GROUP $CATALINA_HOME && \
    mkdir -p /var/log/tomcat8 && \
    chown -R $USER:$GROUP /var/log/tomcat8

USER $USER

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
WORKDIR /oba/webapps/onebusaway-transit-data-federation-webapp
RUN cp /oba/libs/onebusaway-transit-data-federation-webapp-${OBA_VERSION}.war .
RUN jar xvf onebusaway-transit-data-federation-webapp-${OBA_VERSION}.war
RUN rm onebusaway-transit-data-federation-webapp-${OBA_VERSION}.war
COPY --from=builder /oba/config/onebusaway-transit-data-federation-webapp-data-sources.xml ./WEB-INF/classes/data-sources.xml
RUN cp $CATALINA_HOME/lib/mysql-connector-j-8.3.0.jar ./WEB-INF/lib
RUN mv /oba/webapps/onebusaway-transit-data-federation-webapp $CATALINA_HOME/webapps

WORKDIR /oba/webapps/onebusaway-api-webapp
RUN cp /oba/libs/onebusaway-api-webapp-${OBA_VERSION}.war .
RUN jar xvf onebusaway-api-webapp-${OBA_VERSION}.war
RUN rm onebusaway-api-webapp-${OBA_VERSION}.war
COPY --from=builder /oba/config/onebusaway-api-webapp-data-sources.xml ./WEB-INF/classes/data-sources.xml
RUN cp $CATALINA_HOME/lib/mysql-connector-j-8.3.0.jar ./WEB-INF/lib
RUN mv /oba/webapps/onebusaway-api-webapp $CATALINA_HOME/webapps

WORKDIR /oba/webapps/onebusaway-enterprise-acta-webapp
RUN cp /oba/libs/onebusaway-enterprise-acta-webapp-${OBA_VERSION}.war .
RUN jar xvf onebusaway-enterprise-acta-webapp-${OBA_VERSION}.war
RUN rm onebusaway-enterprise-acta-webapp-${OBA_VERSION}.war
COPY --from=builder /oba/config/onebusaway-enterprise-acta-webapp-data-sources.xml ./WEB-INF/classes/data-sources.xml
RUN cp $CATALINA_HOME/lib/mysql-connector-j-8.3.0.jar ./WEB-INF/lib
RUN mv /oba/webapps/onebusaway-enterprise-acta-webapp $CATALINA_HOME/webapps
COPY --from=builder /oba/tmp/ /var/lib/oba/
