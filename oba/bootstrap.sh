#!/bin/bash

# Build bundle inside the container
if [ -n "$GTFS_URL" ]; then
    echo "GTFS_URL is set, building bundle..."
    echo "OBA Bundle Builder Starting"
    echo "GTFS_URL: $GTFS_URL"
    echo "OBA Version: $OBA_VERSION"
    mkdir -p /bundle
    wget -O /bundle/gtfs.zip "$GTFS_URL"
    cd /bundle \
        && java -Xss4m -Xmx3g \
            -jar /oba/tools/onebusaway-transit-data-federation-builder-${OBA_VERSION}-withAllDependencies.jar \
            ./gtfs.zip \
            .
fi

# For users who want to configure the data-sources.xml file and database themselves
if [ -n "$USER_CONFIGURED" ]; then
    echo "USER_CONFIGURED is set, you should create your own configuration file, Aborting..."
    exit 0
fi

WEBAPP_API_XML_FILE="$CATALINA_HOME/webapps/onebusaway-api-webapp/WEB-INF/classes/data-sources.xml"
NAMESPACE_PREFIX="x"
NAMESPACE_URI="http://www.springframework.org/schema/beans"
BEAN_ID="testAPIKey"
# Idempotence
cp "$WEBAPP_API_XML_FILE.bak" "$WEBAPP_API_XML_FILE"
# Check if the TEST_API_KEY environment variable is set
if [ -n "$TEST_API_KEY" ]; then
  # If it is set, then add the API key to the data-sources.xml file
    echo "TEST_API_KEY set to $TEST_API_KEY, setting API key in data-sources.xml"
    xmlstarlet ed -L -N ${NAMESPACE_PREFIX}=${NAMESPACE_URI} \
        -s "//${NAMESPACE_PREFIX}:bean[@id='${BEAN_ID}']" -t elem -n "property" -v "" \
        -i "//${NAMESPACE_PREFIX}:bean[@id='${BEAN_ID}']/property[not(@name)]" -t attr -n "name" -v "key" \
        -i "//${NAMESPACE_PREFIX}:bean[@id='${BEAN_ID}']/property[@name='key']" -t attr -n "value" -v "${TEST_API_KEY}" \
        ${WEBAPP_API_XML_FILE}
else
  # If it is not set, then remove the element from the data-sources.xml file
    echo "TEST_API_KEY environment variable is not set. Removing element from data-sources.xml"
    xmlstarlet ed -L -N ${NAMESPACE_PREFIX}=${NAMESPACE_URI} \
        -d "//${NAMESPACE_PREFIX}:bean[@id='${BEAN_ID}']" \
        ${WEBAPP_API_XML_FILE}
fi

DATA_FEDERATION_XML_FILE="$CATALINA_HOME/webapps/onebusaway-transit-data-federation-webapp/WEB-INF/classes/data-sources.xml"
DATA_SOURCE_CLASS="org.onebusaway.transit_data_federation.impl.realtime.gtfs_realtime.GtfsRealtimeSource"
BEAN_ID="gtfsRT"
# Idempotence
cp "$DATA_FEDERATION_XML_FILE.bak" "$DATA_FEDERATION_XML_FILE"
# Check if GTFS-Rt related environment variables are set
if [ -z "$TRIP_UPDATES_URL" ] && [ -z "$VEHICLE_POSITIONS_URL" ] && [ -z "$ALERTS_URL" ]; then
    echo "No GTFS-RT related environment variables are set. Removing element from data-sources.xml"
    xmlstarlet ed -L -N ${NAMESPACE_PREFIX}=${NAMESPACE_URI} \
        -d "//${NAMESPACE_PREFIX}:bean[@class=${DATA_SOURCE_CLASS}]" \
        ${DATA_FEDERATION_XML_FILE}

else
    echo "GTFS-RT related environment variables are set. Setting them in data-sources.xml"
    if [ -n "$TRIP_UPDATES_URL" ]; then
        echo "TRIP_UPDATES_URL set to $TRIP_UPDATES_URL, setting trip updates URL in data-sources.xml"
        xmlstarlet ed -L -N ${NAMESPACE_PREFIX}=${NAMESPACE_URI} \
            -s "//${NAMESPACE_PREFIX}:bean[@id='${BEAN_ID}']" -t elem -n "property" -v "" \
            -i "//${NAMESPACE_PREFIX}:bean[@id='${BEAN_ID}']/property[not(@name)]" -t attr -n "name" -v "tripUpdatesUrl" \
            -i "//${NAMESPACE_PREFIX}:bean[@id='${BEAN_ID}']/property[@name='tripUpdatesUrl']" -t attr -n "value" -v "${TRIP_UPDATES_URL}" \
            ${DATA_FEDERATION_XML_FILE}
    fi
    if [ -n "$VEHICLE_POSITIONS_URL" ]; then
        echo "VEHICLE_POSITIONS_URL set to $VEHICLE_POSITIONS_URL, setting vehicle positions URL in data-sources.xml"
        xmlstarlet ed -L -N ${NAMESPACE_PREFIX}=${NAMESPACE_URI} \
            -s "//${NAMESPACE_PREFIX}:bean[@id='${BEAN_ID}']" -t elem -n "property" -v "" \
            -i "//${NAMESPACE_PREFIX}:bean[@id='${BEAN_ID}']/property[not(@name)]" -t attr -n "name" -v "vehiclePositionsUrl" \
            -i "//${NAMESPACE_PREFIX}:bean[@id='${BEAN_ID}']/property[@name='vehiclePositionsUrl']" -t attr -n "value" -v "${VEHICLE_POSITIONS_URL}" \
            ${DATA_FEDERATION_XML_FILE}
    fi
    if [ -n "$ALERTS_URL" ]; then
        echo "ALERTS_URL set to $ALERTS_URL, setting alerts URL in data-sources.xml"
        xmlstarlet ed -L -N ${NAMESPACE_PREFIX}=${NAMESPACE_URI} \
            -s "//${NAMESPACE_PREFIX}:bean[@id='${BEAN_ID}']" -t elem -n "property" -v "" \
            -i "//${NAMESPACE_PREFIX}:bean[@id='${BEAN_ID}']/property[not(@name)]" -t attr -n "name" -v "alertsUrl" \
            -i "//${NAMESPACE_PREFIX}:bean[@id='${BEAN_ID}']/property[@name='alertsUrl']" -t attr -n "value" -v "${ALERTS_URL}" \
            ${DATA_FEDERATION_XML_FILE}
    fi
    if [ -n "$REFRESH_INTERVAL" ]; then
        echo "REFRESH_INTERVAL set to $REFRESH_INTERVAL, setting refresh interval in data-sources.xml"
        xmlstarlet ed -L -N ${NAMESPACE_PREFIX}=${NAMESPACE_URI} \
            -s "//${NAMESPACE_PREFIX}:bean[@id='${BEAN_ID}']" -t elem -n "property" -v "" \
            -i "//${NAMESPACE_PREFIX}:bean[@id='${BEAN_ID}']/property[not(@name)]" -t attr -n "name" -v "refreshInterval" \
            -i "//${NAMESPACE_PREFIX}:bean[@id='${BEAN_ID}']/property[@name='refreshInterval']" -t attr -n "value" -v "${REFRESH_INTERVAL}" \
            ${DATA_FEDERATION_XML_FILE}
    fi
    if [ -n "$AGENCY_ID" ]; then
        echo "AGENCY_ID set to $AGENCY_ID, setting agency ID in data-sources.xml"
        xmlstarlet ed -L -N ${NAMESPACE_PREFIX}=${NAMESPACE_URI} \
            -s "//${NAMESPACE_PREFIX}:bean[@id='${BEAN_ID}']" -t elem -n "property" -v "" \
            -i "//${NAMESPACE_PREFIX}:bean[@id='${BEAN_ID}']/property[not(@name)]" -t attr -n "name" -v "agencyId" \
            -i "//${NAMESPACE_PREFIX}:bean[@id='${BEAN_ID}']/property[@name='agencyId']" -t attr -n "value" -v "${AGENCY_ID}" \
            ${DATA_FEDERATION_XML_FILE}
    fi
    # Check if the GTFS_RT authentication header is set
    if [ -n "$FEED_API_KEY" ] && [ -n "$FEED_API_VALUE" ]; then
        echo "FEED_API_KEY and FEED_API_VALUE set to $FEED_API_KEY and $FEED_API_VALUE, setting auth header in data-sources.xml"
        xmlstarlet ed -L -N ${NAMESPACE_PREFIX}=${NAMESPACE_URI} \
            -s "//${NAMESPACE_PREFIX}:bean[@id='${BEAN_ID}']" -t elem -n "property" -v "" \
            -i "//${NAMESPACE_PREFIX}:bean[@id='${BEAN_ID}']/property[not(@name)]" -t attr -n "name" -v "headersMap" \
            -s "//${NAMESPACE_PREFIX}:bean[@id='${BEAN_ID}']/property[@name='headersMap']" -t elem -n "map" -v "" \
            -s "//${NAMESPACE_PREFIX}:bean[@id='${BEAN_ID}']/property[@name='headersMap']/map" -t elem -n "entry" -v "" \
            -i "//${NAMESPACE_PREFIX}:bean[@id='${BEAN_ID}']/property[@name='headersMap']/map/entry" -t attr -n "key" -v "${FEED_API_KEY}" \
            -i "//${NAMESPACE_PREFIX}:bean[@id='${BEAN_ID}']/property[@name='headersMap']/map/entry" -t attr -n "value" -v "${FEED_API_VALUE}" \
            ${DATA_FEDERATION_XML_FILE}
    fi
fi

# Google map related environment variables
ENTERPRISE_ACTA_WEBAPP_XML_FILE="$CATALINA_HOME/webapps/ROOT/WEB-INF/classes/data-sources.xml"
BEAN_ID="configurationServiceClient"
LOCAL_JSON_FILE="/var/lib/oba/config.json"
# Idempotence
cp "$ENTERPRISE_ACTA_WEBAPP_XML_FILE.bak" "$ENTERPRISE_ACTA_WEBAPP_XML_FILE"
mkdir -p $(dirname "$LOCAL_JSON_FILE")
if [ -z "$GOOGLE_MAPS_API_KEY" ] && [ -z "$GOOGLE_MAPS_CLIENT_ID" ] && [ -z "$GOOGLE_MAPS_CHANNEL_ID" ]; then
    echo "No Google Maps related environment variables are set. Removing element from data-sources.xml"
    xmlstarlet ed -L -N ${NAMESPACE_PREFIX}=${NAMESPACE_URI} \
        -d "//${NAMESPACE_PREFIX}:bean[@id=${BEAN_ID}]" \
        ${ENTERPRISE_ACTA_WEBAPP_XML_FILE}
else
    echo "Google Maps related environment variables are set. Setting them in data-sources.xml"
    # Indempotence
    rm -f "$LOCAL_JSON_FILE"
    touch "$LOCAL_JSON_FILE"
    echo '{"config":[]}' > "$LOCAL_JSON_FILE"
    xmlstarlet ed -L -N ${NAMESPACE_PREFIX}=${NAMESPACE_URI} \
        -s "//${NAMESPACE_PREFIX}:bean[@id='${BEAN_ID}']" -t elem -n "constructor-arg" -v "" \
        -i "//${NAMESPACE_PREFIX}:bean[@id='${BEAN_ID}']/constructor-arg[not(@type)]" -t attr -n "type" -v "java.lang.String" \
        -i "//${NAMESPACE_PREFIX}:bean[@id='${BEAN_ID}']/constructor-arg[@type='java.lang.String']" -t attr -n "value" -v "/var/lib/oba/config.json" \
        ${ENTERPRISE_ACTA_WEBAPP_XML_FILE}

    # Avoid read and write same file in one pipe to avoid race condition
    TMP_JSON_FILE="./tmp.json"
    touch "$TMP_JSON_FILE"
    if [ -n "$GOOGLE_MAPS_API_KEY" ]; then
        cat "$LOCAL_JSON_FILE" | jq '.config += [{"component": "display", "key": "display.googleMapsApiKey", "value": "'"$GOOGLE_MAPS_API_KEY"'"}]' > "$TMP_JSON_FILE"
        mv "$TMP_JSON_FILE" "$LOCAL_JSON_FILE"
    fi
    if [ -n "$GOOGLE_MAPS_CLIENT_ID" ]; then
        cat "$LOCAL_JSON_FILE" | jq '.config += [{"component": "display", "key": "display.googleMapsClientId", "value": "'"$GOOGLE_MAPS_CLIENT_ID"'"}]' > "$TMP_JSON_FILE"
        mv "$TMP_JSON_FILE" "$LOCAL_JSON_FILE"
    fi
    if [ -n "$GOOGLE_MAPS_CHANNEL_ID" ]; then
        cat "$LOCAL_JSON_FILE" | jq '.config += [{"component": "display", "key": "display.googleMapsChannelId", "value": "'"$GOOGLE_MAPS_CHANNEL_ID"'"}]' > "$TMP_JSON_FILE"
        mv "$TMP_JSON_FILE" "$LOCAL_JSON_FILE"
    fi
fi

CONTEXT_XML_FILE="$CATALINA_HOME/conf/context.xml"
# only update the parameters, therefore is impotent
if [ -n "$JDBC_URL" ]; then
    echo "JDBC_URL set to $JDBC_URL, setting in context.xml"
    xmlstarlet ed -L -u "//Resource[@name='jdbc/appDB']/@url" -v "$JDBC_URL" ${CONTEXT_XML_FILE}
fi
if [ -n "$JDBC_USER" ]; then
    echo "JDBC_URL set to $JDBC_USER, setting in context.xml"
    xmlstarlet ed -L -u "//Resource[@name='jdbc/appDB']/@username" -v "$JDBC_USER" ${CONTEXT_XML_FILE}
fi
if [ -n "$JDBC_PASSWORD" ]; then
    echo "JDBC_URL set to $JDBC_PASSWORD, setting in context.xml"
    xmlstarlet ed -L -u "//Resource[@name='jdbc/appDB']/@password" -v "$JDBC_PASSWORD" ${CONTEXT_XML_FILE}
fi
