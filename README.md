# CFL OpenMRS

OpenMRS CFL distribution

## How to run the environment
In order to run environment you need to go to `cfl` directory and execute following (the docker-compose is required):
```
docker-compose up -d --build
```

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

In order to force such an update, run:

```
docker-compose -f docker-compose.yml -f docker-compose.module-reload.yml up -d --build
```

This will overwrite the modules in your volumes with the modules from the repository.

### Production
To start containers in production mode you need to go to `cfl` directory and execute following (the docker-compose is required):
```
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up
```

## Update the distribution configuration
The `clf-openmrs-distro.properties` file contains the initial configuration of CFL OpenMRS distribution. If you made some changes (e.g. add new official OpenMRS module) you can update the distribution by executing following (the OpenMRS SDK maven plug-in is required):
```
mvn openmrs-sdk:build-distro -Ddistro=clf-openmrs-distro.properties -Ddir=cfl
```

## The non-official modules
In order to add non-official module you can put the OpenMRS module (.omod file) into `cfl/web/modules/` and restart the `cfl_web` container.

## Development mode
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
cfl/runInDevMode.sh
```

### Note:
* The development mode will work only if you have your code checked out into a directory named either <moduleId> or openmrs-module-<moduleId>
* The development mode (and changes of DEV_MODE_MODULES prop) will work only after second run of the environment

More info:
https://wiki.openmrs.org/display/docs/Using+the+UI+Framework+in+Your+Module
