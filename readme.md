# Purpose

The intention of this repository is to provide a lightweight container running [etherpad](http://etherpad.org) on alpine.

## Build

In order to build this container, run the following command:

```plain
docker build -t burkeazbill/alpine-etherpad .
```

## Run

Etherpad can be started from the command line of your docker host using the following command:

```plain
docker run -d --restart unless-stopped --name alpine-etherpad -v etherpad:/opt/etherpad/data -p 80:9001 burkeazbill/alpine-etherpad .
```

After that, you should be able to access etherpad at [http://127.0.0.1](http://127.0.0.1) or [http://localhost](http://localhost)

**Admin Login**
[http://127.0.0.1/admin](http://127.0.0.1/admin) or [http://localhost/admin](http://localhost/admin)

- Default Username: admin
- Default Password: changeme1
- Username and passwords can be configured in the settings.json

**NOTES:**

- If you already have a web server running on your Docker Host, change -p 80:9001 to an available port such as 82 like this: -p 82:9001
- A persistent volume named etherpad gets created using the command line shown above to store the data file

**To remove the persistent volume:**

```plain
docker volume rm etherpad
```

**To list persistent volumes:**

```plain
docker volume ls
```

**To view location and options of persistent volume:**

```plain
docker volume inspect etherpad
```


## Change Log

Version 1.2

- Fixed issue that prevented admin login from working properly (incorrect settings.json was being used)
- Updated Dockerfile to create symbolic link from /opt/etherpad/settings.json -> /opt/etherpad/data/settings.json to allow for custom settings to be presisted between containers
- Updated sequence of Dockerfile commands to address issues above
- Added more documentation to this page 

Version 1.1

- Updated Dockerfile to use multi-stage build - image size now 174MB
- Added label for version

Version 1.0

- Simple Alpine container running etherpad using development db type "dirty"
- Container currently runs as root

### To Do

- ~~Further consolidate image using multi-stage build (current size is 362MB vs debian-etherpad at 667MB)~~
- Re-configure to run as a regular user instead of root
- Provide options to use alternate db's
- Provide options to use SSL
- Write docker-compose.yaml