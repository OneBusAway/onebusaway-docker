#########
# Maven #
#########

FROM tomcat:8.5.100-jdk11-temurin AS builder

ARG OBA_VERSION=2.5.13-otsf
ENV OBA_VERSION=${OBA_VERSION}

RUN apt-get update && apt-get install -y maven

# Start configuring OBA
WORKDIR /oba
COPY ./pom.xml ./pom.xml
COPY ./settings.xml /root/.m2/settings.xml

RUN mvn org.apache.maven.plugins:maven-dependency-plugin:3.2.0:get \
    --batch-mode \
    -Dartifact=org.onebusaway:onebusaway-transit-data-federation-builder:${OBA_VERSION}:jar:withAllDependencies && \
    cp /root/.m2/repository/org/onebusaway/onebusaway-transit-data-federation-builder/${OBA_VERSION}/onebusaway-transit-data-federation-builder-${OBA_VERSION}-withAllDependencies.jar \
       ./onebusaway-transit-data-federation-builder-withAllDependencies.jar

###########
# Bundler #
###########

FROM tomcat:8.5.100-jdk11-temurin

ARG OBA_VERSION=2.5.13-otsf
ENV OBA_VERSION_ENV=$OBA_VERSION

# Start configuring OBA
WORKDIR /oba

COPY --from=builder /oba/onebusaway-transit-data-federation-builder-withAllDependencies.jar .
COPY ./build_bundle.sh .

CMD /oba/build_bundle.sh

# for debugging
# CMD ["tail", "-f", "/dev/null"]