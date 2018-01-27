# jdk-9 doesn't seem to work as of onebusaway-application-modules as of 8062291,
# fails to build bundles
FROM maven:3.5.2-jdk-8 as build

RUN git clone --depth 1 https://github.com/OneBusAway/onebusaway-application-modules.git /app
RUN cd /app && mvn install -Dlicense.skip=true -Dmaven.test.skip=true --quiet

FROM tomcat:8

ENV JAVA_OPTS="-Xss4m"

RUN mkdir /app

ADD https://jdbc.postgresql.org/download/postgresql-42.2.1.jar /usr/local/tomcat/lib

COPY --from=build /app/onebusaway-transit-data-federation-builder/target/onebusaway-transit-data-federation-builder-2.0.0-SNAPSHOT-withAllDependencies.jar /app

COPY --from=build /app/onebusaway-transit-data-federation-webapp/target/onebusaway-transit-data-federation-webapp.war /app
RUN unzip -q /app/onebusaway-transit-data-federation-webapp.war -d /usr/local/tomcat/webapps/onebusaway-transit-data-federation-webapp
ADD config/onebusaway-transit-data-federation-webapp-data-sources.xml /usr/local/tomcat/webapps/onebusaway-transit-data-federation-webapp/WEB-INF/classes/data-sources.xml

COPY --from=build /app/onebusaway-api-webapp/target/onebusaway-api-webapp.war /app
RUN unzip -q /app/onebusaway-api-webapp.war -d /usr/local/tomcat/webapps/onebusaway-api-webapp
ADD config/onebusaway-api-webapp-data-sources.xml /usr/local/tomcat/webapps/onebusaway-api-webapp/WEB-INF/classes/data-sources.xml
