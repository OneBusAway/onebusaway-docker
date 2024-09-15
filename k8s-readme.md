### Running in Kubernetes

#### Creating the docker images

1. Build the bundler image:

```bash
docker build ./bundler -t oba/bundler:test
```

2. Build the app image:

```bash
docker build ./oba -t oba/app:test
```

#### Creating the Kubernetes resources:

Apply the Kubernetes resources in oba.yaml

```bash
kubectl apply -f oba.yaml
```

The YAML file deploys the OneBusAway application and a MySQL database within a dedicated oba namespace in Kubernetes. It also sets up a secret for sensitive data and a ConfigMap for GTFS data URL, while exposing the database as a service for other pods to access.

You can portforward the oba app to your localhost using:

```bash
kubectl port-forward deploy/oba-app-deployment -n oba 8080:8080
```

#### Inspecting the database

You can portforward the service to your localhost using:

```bash
kubectl port-forward service/oba-database -n oba 3306:3306
```

Then you can connect to it programmatically using `mysql`:

```bash
mysql -u oba_user -p -h localhost:3306
```

#### Google Maps


If deployed in Kubernetes environment:

1. Use the kubectl set env command to set new environment variables,
make sure you replace deployment/oba-app with the actual name of your deployment:

```bash
kubectl set env deployment/oba-app GOOGLE_MAPS_API_KEY=<YOUR_KEY_HERE> \
    GOOGLE_MAPS_CHANNEL_ID=<YOUR_CHANNEL_ID_HERE> \
    GOOGLE_MAPS_CLIENT_ID=<YOUR_CLIENT_ID_HERE>
```

2. Use the following command to rebuild and start the oba app service:

```bash
kubectl rollout restart deployment/oba-app
```
