#!/bin/bash

XML_FILE="./config/onebusaway-api-webapp-data-sources.xml"
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
        ${XML_FILE}
else
  # If it is not set, then remove the element from the data-sources.xml file
    echo "TEST_API_KEY environment variable is not set. Removing element from data-sources.xml"
    xmlstarlet ed -L -N ${NAMESPACE_PREFIX}=${NAMESPACE_URI} \
        -d "//${NAMESPACE_PREFIX}:bean[@id='${BEAN_ID}']" \
        ${XML_FILE}
fi
