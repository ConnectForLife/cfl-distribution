# Description
Run CFL OpenMRS distribution. In the scope of this distribution can be highlighted the following services:
* openmrscfldemodistro - main service which will host the web app
* mysql - [**optional**] the database service which can be used to host Database on the local environment

## Requirements
  - Docker engine
  - Docker compose

## Development

**Note**: you are able to use a prepared bash script (`runInDevMode.sh` ) in order to run the environment in development mode.

To start the production environment (only web app) you need to make sure that environment variables are configured properly (in .env file) and then execute the following command:
```
$ docker-compose -f docker-compose.yml -f docker-compose.override.yml -f docker-compose.db.yml -f docker-compose.module-reload.yml -f docker-compose.dev.yml up -d
```

**Note**: `-d` is optional and is used to run distro in detached mode and then in order to show the server logs run the following command:
```
$ docker-compose logs -f --tail 100
```

Application will be accessible on http://localhost:8080/openmrs.

**Note**: if you are using Docker Toolbox you need to replace `localhost` with the IP address of your docker machine, which you can get by running:

```
$ docker-machine url
```

Use _CTRL + C_ to stop all containers.

If you made any changes (modified modules/owas/war) to the distro you need to run distro with build argument, example:
```
$ docker-compose -f docker-compose.yml -f docker-compose.override.yml -f docker-compose.db.yml -f docker-compose.module-reload.yml -f docker-compose.dev.yml up --build  -d
```

If you want to destroy containers and delete any left over volumes and data when doing changes to the docker
configuration and images run:
```
$ docker-compose down -v
```

In the development mode the OpenMRS server is run in a debug mode and exposed at port 1044. You can change the port by
setting the DEBUG_PORT environment property or by editing the `.evn` file before starting up containers.

Similarly MySQL is exposed at port 3306 and can be customized by setting the MYSQL_PORT property.
**Note**: MySQL database is host only when `docker-compose.db.yml` profile was used.

### Development mode - script
In order to use the UI framework development mode you should set the following environment variable (in `/cfl/.env`), where value should point to the local directory where you contains all the OpenMRS modules:
```
...
DEV_MODE_DIR=/home/user/cfl
...
```

next you have to specify (also in `/cfl/.env/`) module's id which you want to watch (comma separated list od module ids)
```
...
DEV_MODE_MODULES=messages
...
```

and then run the following script
```
$ ./runInDevMode.sh
```

### Note:
* The development mode will work only if you have your code checked out into a directory named either <moduleId> or openmrs-module-<moduleId>
* The development mode (and changes of DEV_MODE_MODULES prop) will work only after second run of the environment

More info:
<https://wiki.openmrs.org/display/docs/Using+the+UI+Framework+in+Your+Module>

## Production

To start containers in production:
```
$ docker-compose -f docker-compose.yml -f docker-compose.prod.yml -f docker-compose.module-reload.yml up
```

Application will be accessible on http://localhost/openmrs.

Note that in contrary to the development mode the OpenMRS server is exposed on port 80 instead of 8080.
No other ports are exposed in the production mode.

## Volumes

After starting the development server two volumes are created.

Volume for modules:

```
~/.cfl-dev/modules
```

Volume for OWA:
```
~/.cfl-dev/owa
```

CFL modules such as SMS, ETL or CallFlows are not overwritten by the container on restarts, since we use hot reloading. In other words, modules from this repository will not overwrite the modules in your volume during development.

In order to force such an update, run `docker-compose` with dedicated profile `-f docker-compose.module-reload.yml`. For instance: 

```
$ docker-compose -f docker-compose.yml -f docker-compose.prod.yml -f docker-compose.module-reload.yml up --build -d
```

This will overwrite the modules in your volumes with the modules from the repository.

## Deploying openmrscfldemodistro to dockerhub

The image in 'openmrscfldemodistro' can be built and pushed to dockerhub, to be used in test environments or production:

```
$ cd openmrscfldemodistro
$ docker build -t <username>/openmrs-openmrscfldemodistro:latest .
$ docker push <username>/openmrs-openmrscfldemodistro:latest
```

If the image is pushed to dockerhub, `docker-compose.yml` can be modified to use that image
instead of building the new image.

## Other similar docker images and relevant links
- <https://wiki.openmrs.org/display/RES/Demo+Data>
- <https://wiki.openmrs.org/display/docs/Installing+OpenMRS+on+Docker>
- <https://github.com/tusharsoni/OpenMRS-Docker/blob/master/Dockerfile>
- <https://github.com/chaityabshah/openmrs-core-docker/blob/master/Dockerfile>
- <https://github.com/bmamlin/openmrs-core-docker/blob/master/Dockerfile>
- <https://wiki.openmrs.org/display/docs/Using+the+UI+Framework+in+Your+Module>