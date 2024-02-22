FROM tomcat:8.5.98-jdk11-temurin

# Create a non-root user
RUN groupadd -r oba && useradd --no-log-init -r -g oba oba

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

# ... (rest of the Dockerfile)

# Switch to non-root user
USER oba

# Continue with the rest of the Dockerfile as the non-root user
