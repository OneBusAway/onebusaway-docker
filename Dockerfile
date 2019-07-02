# Maven fails to build the OBA modules under JDK 9
FROM maven:3-jdk-8 AS build

RUN git clone \
	--depth 1 \
	https://github.com/OneBusAway/onebusaway-application-modules.git \
	/app
WORKDIR /app
RUN mvn install \
	--quiet \
	-D license.skip=true \
	-D maven.test.skip=true

FROM tomcat:8

ENV JAVA_OPTS="-Xss4m"

RUN mkdir /app

RUN wget \
	--directory-prefix /usr/local/tomcat/lib \
	https://jdbc.postgresql.org/download/postgresql-42.2.6.jar

COPY --from=build /app/onebusaway-transit-data-federation-builder/target/onebusaway-transit-data-federation-builder-2.0.0-SNAPSHOT-withAllDependencies.jar /app

COPY --from=build /app/onebusaway-transit-data-federation-webapp/target/onebusaway-transit-data-federation-webapp.war /tmp
RUN unzip \
	-q \
	/tmp/onebusaway-transit-data-federation-webapp.war \
	-d /usr/local/tomcat/webapps/onebusaway-transit-data-federation-webapp
COPY ./config/onebusaway-transit-data-federation-webapp-data-sources.xml /usr/local/tomcat/webapps/onebusaway-transit-data-federation-webapp/WEB-INF/classes/data-sources.xml

COPY --from=build /app/onebusaway-api-webapp/target/onebusaway-api-webapp.war /tmp
RUN unzip \
	-q \
	/tmp/onebusaway-api-webapp.war \
	-d /usr/local/tomcat/webapps/onebusaway-api-webapp
COPY ./config/onebusaway-api-webapp-data-sources.xml /usr/local/tomcat/webapps/onebusaway-api-webapp/WEB-INF/classes/data-sources.xml

RUN rm -rf /usr/local/tomcat/webapps/ROOT
COPY --from=build /app/onebusaway-enterprise-acta-webapp/target/onebusaway-enterprise-acta-webapp.war /tmp
RUN unzip \
	-q \
	/tmp/onebusaway-enterprise-acta-webapp.war \
	-d /usr/local/tomcat/webapps/ROOT
COPY ./config/onebusaway-enterprise-acta-webapp-data-sources.xml /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/data-sources.xml
