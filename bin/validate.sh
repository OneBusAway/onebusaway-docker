#!/bin/bash

output=$(curl -s "http://localhost:8080/onebusaway-api-webapp/api/where/current-time.json?key=test" | jq '.data.entry.time')

if [[ ! -z "$output" && "$output" =~ ^[0-9]+$ ]]; then
    echo "current-time.json endpoint works."
else
    echo "Error: current-time.json endpoint is not working."
    exit 1
fi

output=$(curl -s "http://localhost:8080/onebusaway-api-webapp/api/where/agencies-with-coverage.json?key=test" | jq '.data.list[0].agencyId')

if [[ ! -z "$output" && "$output" == "\"unitrans\"" ]]; then
    echo "agencies-with-coverage.json endpoint works."
else
    echo "Error: agencies-with-coverage.json endpoint is not working: $output"
    exit 1
fi

output=$(curl -s "http://localhost:8080/onebusaway-api-webapp/api/where/routes-for-agency/unitrans.json?key=test" | jq '.data.list | length')
if [[ $output -gt 20 ]]; then
    echo "routes-for-agency/unitrans.json endpoint works."
else
    echo "Error: routes-for-agency/unitrans.json is not working: $output"
    exit 1
fi

output=$(curl -s "http://localhost:8080/onebusaway-api-webapp/api/where/stops-for-route/unitrans_C.json?key=test" | jq '.data.entry.routeId')
if [[ ! -z "$output" && "$output" == "\"unitrans_C\"" ]]; then
    echo "stops-for-route/unitrans_C.json endpoint works."
else
    echo "Error: stops-for-route/unitrans_C.json endpoint is not working: $output"
    exit 1
fi

output=$(curl -s "http://localhost:8080/onebusaway-api-webapp/api/where/stop/unitrans_22182.json?key=test" | jq '.data.entry.code')
if [[ ! -z "$output" && "$output" == "\"22182\"" ]]; then
    echo "stop/unitrans_22182.json endpoint works."
else
    echo "Error: stop/unitrans_22182.json endpoint is not working: $output"
    exit 1
fi

# todo: add support for arrivals-and-departures-for-stop endpoint.
# however, it doesn't seem that the unitrans_22182 stop has arrivals and departures on the weekend, so we'll need
# something else to test with. However, for now, this is still a great step forward.