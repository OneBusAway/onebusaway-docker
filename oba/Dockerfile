###########
# Builder #
###########

FROM tomcat:8.5.100-jdk11-temurin AS builder

ARG OBA_VERSION=2.5.13-otsf
ENV OBA_VERSION=${OBA_VERSION}

ARG MYSQL_CONNECTOR_VERSION=8.4.0
ENV MYSQL_CONNECTOR_VERSION=${MYSQL_CONNECTOR_VERSION}
ARG PAT_USERNAME_FOR_GH
ARG PAT_TOKEN_FOR_GH

RUN apt-get update && apt-get install -y maven

# Start configuring OBA
WORKDIR /oba/libs
COPY ./config/pom.xml ./pom.xml
COPY ./config/settings.xml /root/.m2/settings.xml

# Download and install dependencies - this must be run here because
# secure args are not available in the next stage
RUN mvn -f pom.xml \
    install \
    --batch-mode \
    -DskipTests

COPY ./retrieve_maven_artifacts.sh .
RUN chmod +x ./retrieve_maven_artifacts.sh
RUN ./retrieve_maven_artifacts.sh

##########
# Server #
##########

FROM tomcat:8.5.100-jdk11-temurin AS server

ENV CATALINA_HOME=/usr/local/tomcat
ENV TZ=America/New_York

ARG GID=1000
ARG UID=1000
ARG GROUP=oba_group
ARG USER=oba_user

RUN apt-get update && apt-get install -y \
    jq \
    python3-pip \
    supervisor \
    tzdata \
    unzip \
    xmlstarlet \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN pip install supervisord-dependent-startup
RUN apt remove -y python3-pip

# Set the configured time zone
RUN ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && dpkg-reconfigure -f noninteractive tzdata

# Create a non-root user and assign them ownership of tomcat
RUN groupadd -g $GID $GROUP && \
    useradd -d /home/$USER -u $UID -m -s /bin/bash -g $GROUP $USER && \
    chown -R $USER:$GROUP $CATALINA_HOME && \
    mkdir -p /var/log/tomcat8 && \
    chown -R $USER:$GROUP /var/log/tomcat8

##########
# Configure OBA Bundle Builder
##########

WORKDIR /oba/libs
COPY --from=builder \
    --chown=oba_user:oba_group \
    /oba/libs/onebusaway-transit-data-federation-builder-withAllDependencies.jar .

##########
# Configure OBA Server
##########

WORKDIR $CATALINA_HOME/webapps

##########
# Configure onebusaway-api-webapp
##########

COPY --from=builder \
     --chown=oba_user:oba_group \
     /oba/libs/onebusaway-api-webapp.war .
RUN mkdir onebusaway-api-webapp && \
    cd onebusaway-api-webapp && \
    jar xvf ../onebusaway-api-webapp.war && \
    rm ../onebusaway-api-webapp.war
COPY --from=builder \
     --chown=oba_user:oba_group \
     /oba/libs/mysql-connector-j.jar onebusaway-api-webapp/WEB-INF/lib/
COPY ./config/onebusaway-api-webapp-data-sources.xml \
     $CATALINA_HOME/webapps/onebusaway-api-webapp/WEB-INF/classes/data-sources.xml.bak

##########
# Configure onebusaway-enterprise-acta-webapp as ROOT (i.e. the path `/`)
##########

COPY --from=builder \
     --chown=oba_user:oba_group \
     /oba/libs/onebusaway-enterprise-acta-webapp.war .

RUN mkdir ROOT && \
    cd ROOT && \
    jar xvf ../onebusaway-enterprise-acta-webapp.war && \
    rm ../onebusaway-enterprise-acta-webapp.war

COPY --from=builder \
     --chown=oba_user:oba_group \
     /oba/libs/mysql-connector-j.jar \
     $CATALINA_HOME/webapps/ROOT/WEB-INF/lib/

COPY ./config/onebusaway-enterprise-acta-webapp-data-sources.xml \
     $CATALINA_HOME/webapps/ROOT/WEB-INF/classes/data-sources.xml.bak


# TODO: when/where/why is this needed?
RUN mkdir -p /opt/oba/logs
RUN chown -R oba_user:oba_group /opt/oba/logs
RUN chmod 755 /opt/oba/logs

##########
# Configure onebusaway-transit-data-federation-webapp
##########

COPY --from=builder \
    --chown=oba_user:oba_group \
    /oba/libs/onebusaway-transit-data-federation-webapp.war .
RUN mkdir onebusaway-transit-data-federation-webapp && \
    cd onebusaway-transit-data-federation-webapp && \
    jar xvf ../onebusaway-transit-data-federation-webapp.war && \
    rm ../onebusaway-transit-data-federation-webapp.war
COPY --from=builder \
    --chown=oba_user:oba_group \
    /oba/libs/mysql-connector-j.jar \
    onebusaway-transit-data-federation-webapp/WEB-INF/lib/
COPY ./config/onebusaway-transit-data-federation-webapp-data-sources.xml \
     $CATALINA_HOME/webapps/onebusaway-transit-data-federation-webapp/WEB-INF/classes/data-sources.xml.bak

##########
# Tomcat Configuration
##########

WORKDIR $CATALINA_HOME
COPY --chown=oba_user:oba_group ./config/context.xml ./conf/

##########
# Clean up
##########

RUN apt-get autoremove -y && apt-get clean
RUN rm -rf /oba/webapps

##########
# Bootstrapper and Supervisor
##########

COPY bootstrap.sh /oba/bootstrap.sh
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN chmod +x /oba/bootstrap.sh

CMD ["supervisord", "-n"]
