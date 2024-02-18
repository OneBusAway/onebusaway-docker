# OneBusAway v2 Docker Packaging

This repository contains scripts and configuration for building version 2 of the
[OneBusAway Application Suite](https://github.com/OneBusAway/onebusaway-application-modules)
for use with [Docker](https://www.docker.com/).

## BROKEN: CI and functionality demonstration

A demonstration of the functionality using only basic Docker can be seen by executing the `./bin/ci` script. This demo runs with a GTFS feed from Halifax, Nova Scotia.

## Running locally

To build bundles and run the webapp server with your own GTFS feed, use the [Docker Compose](https://docs.docker.com/compose/) services in this repository.

### Building bundles

To build a bundle, use the `oba_bundler` service:

```bash
GTFS_URL=https://www.soundtransit.org/GTFS-rail/40_gtfs.zip docker-compose up oba_bundler
```

This process will create all necessary bundle files and metadata, and all will be accessible in your local repo's `./bundle` directory.

When the GTFS_URL is unspecified, `oba_bundler` will download and use the GTFS data for Davis, CA's Unitrans service. This can be used with the `bin/validate.sh` script to verify that the stack is working correctly.

```bash
docker-compose up oba_bundler
```

### Running the OneBusAway server

Once you have a built OBA bundle inside `./bundle`, you can run the OBA server and make it accessible on your host machine with:

```bash
docker-compose up oba_app
```

You will then have three webapps available:

- API, hosted at `http://localhost:8888/onebusaway-api-webapp/api?key=TEST`
  - an example call could be to `http://localhost:8888/onebusaway-api-webapp/api/where/agencies-with-coverage.json?key=TEST`, which should show metadata about the agency you loaded
  - the test/demo API key is set in `./config/onebusaway-api-webapp-data-sources.xml`; this can be changed as needed, and should be deleted before use in production
- Transit Data Federation, hosted at `http://localhost:8888/onebusaway-transit-data-federation-webapp/`
- Enterprise Interface, hosted at `http://localhost:8888/routes/index`

When done using this web server, you can use the shell-standard `^C` to exit out and turn it off. If issues persist across runs, you can try using `docker-compose down -v` and then `docker-compose up oba` to refresh the Docker containers and services.

### Inspecting the database

The MySQL database Docker Compose service should remain up after a call of `docker-compose up oba_app`. Otherwise, you can always invoke it using `docker-compose up oba_database`.

A database port is open to your host machine, so you can connect to it programmatically using `mysql`:

```bash
mysql -u oba_user -p -h localhost:3306
```