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

After that, you should be able to access etherpad at http://127.0.0.1 or http://localhost

**NOTES:**

- If you already have a web server running on your Docker Host, change -p 80:9001 to an available port such as 82 like this: -p 82:9001
- A persistent volume named etherpad gets created using the command line shown above to store the data file

## Change Log

Version 1.0

- Simple Alpine container running etherpad using development db type "dirty"
- Container currently runs as root

### To Do

- Further consolidate image using multi-stage build (current size is 362MB vs debian-etherpad at 667MB)
- Re-configure to run as a regular user instead of root
- Provide options to use alternate db's
- Provide options to use SSL
- Write docker-compose.yaml