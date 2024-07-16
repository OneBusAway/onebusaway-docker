FROM tomcat:8.5.98-jdk11-temurin

ARG OBA_VERSION=2.5.12-cs
ENV OBA_VERSION_ENV=$OBA_VERSION

# Start configuring OBA
WORKDIR /oba/libs

# OBA WAR and JAR files
RUN wget "https://repo.camsys-apps.com/releases/org/onebusaway/onebusaway-transit-data-federation-builder/${OBA_VERSION}/onebusaway-transit-data-federation-builder-${OBA_VERSION}-withAllDependencies.jar"

WORKDIR /oba/bin

COPY ./build_bundle.sh .

CMD /oba/bin/build_bundle.sh ${OBA_VERSION_ENV}

# for debugging
# CMD ["tail", "-f", "/dev/null"]