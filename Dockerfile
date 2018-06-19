FROM mhart/alpine-node-auto:10 AS build-env

LABEL version="1.1"

ENV NODE_PATH /opt/etherpad/src/node_modules

WORKDIR /opt

RUN info(){ printf '\x1B[32m--\n%s\n--\n\x1B[37m' "$*"; } \
    && info "==> Installing OS tools and dependencies..." \
    && apk --update --no-cache add --update git curl make g++\
    && info "==> Cloning etherpad source..." \
    && git clone https://github.com/ether/etherpad-lite.git etherpad \
    && info "==> Installing etherpad dependencies..." \
    && etherpad/bin/installDeps.sh \
    && cd /opt/etherpad/src \
    && info "==> Running npm audit fix --force to cleanup npm modules" \
    && npm audit fix --force

FROM mhart/alpine-node-auto:10

LABEL version="1.1"

ENV NODE_PATH /opt/etherpad/src/node_modules

WORKDIR /opt

# Add Configuration File:
RUN apk --no-cache add --update curl
ADD settings.json etherpad/settings.json
COPY --from=build-env /opt/etherpad /opt/etherpad

VOLUME /opt/etherpad/data

# Expose Port:
EXPOSE 9001

ENTRYPOINT ["/opt/etherpad/bin/run.sh","--root"]