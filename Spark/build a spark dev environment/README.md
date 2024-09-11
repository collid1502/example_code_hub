# Building a Development Environment for Spark Locally

This section covers an example of how we can use Docker, to create a local Spark cluster, and perform development in a local environment that can mimic production setups.<br>

### Details

ensure docker-compose is installed:

```
sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```

then:

```
sudo chmod +x /usr/local/bin/docker-compose
```

finally, check its worked:

```
docker-compose --version
```