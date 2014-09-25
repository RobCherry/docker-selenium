# Docker container for creating a selenium server with Chrome and Firefox

Includes

* Selenium Server (2.43.1)
* Google Chrome (Latest Stable)
* Mozilla Firefox (Latest Stable)
* VNC

## Building the Docker Image

You can build the image by either building from GitHub or cloning the repository.

To build from GitHub:

```
docker build -t "robcherry/docker-selenium:latest" github.com/robcherry/docker-selenium
```

If you choose to clone the repository locally, `cd` in to the repository's root directory and run:

```
docker build -t "robcherry/docker-selenium:local" .
```

You can also pull the final built image from docker:

```
docker pull -t "robcherry/docker-selenium:latest" robcherry/docker-selenium
```

## Usage

The most basic usage is to run the container and expose the Selenium and VNC ports on all interfaces.

```
docker run --name selenium -P -d robcherry/docker-selenium:latest
```

If you want to restrict the ports to your local environment, you can do so using `-p`.

```
docker run --name selenium -p 127.0.0.1::4444 -p 127.0.0.1::5900 robcherry/docker-selenium:latest
```
