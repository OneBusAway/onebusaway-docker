#!/bin/bash

WEBAPP_API_XML_FILE="./config/onebusaway-api-webapp-data-sources.xml"
NAMESPACE_PREFIX="x"
NAMESPACE_URI="http://www.springframework.org/schema/beans"
BEAN_ID="testAPIKey"

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

DATA_FEDERATION_XML_FILE="./config/onebusaway-transit-data-federation-webapp-data-sources.xml"
BEAN_ID="gtfsRT"
# Check if GTFS-Rt related environment variables are set
if [ -z "$TRIP_UPDATES_URL" ] && [ -z "$VEHICLE_POSITIONS_URL" ] && [ -z "$ALERTS_URL" ]; then
    echo "No GTFS-RT related environment variables are set. Removing element from data-sources.xml"
    xmlstarlet ed -L -N ${NAMESPACE_PREFIX}=${NAMESPACE_URI} \
        -d "//${NAMESPACE_PREFIX}:bean[@class=${DATA_SOURCE_CLASS}]" \
        ${DATA_FEDERATION_XML_FILE}
    exit 0
fi

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


