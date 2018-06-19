FROM mhart/alpine-node-auto:10

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

# Add Configuration File:
ADD settings.json /opt/etherpad/settings.json

WORKDIR /opt/etherpad/src/node_modules/ep_etherpad-lite/node/

# Expose Port:
EXPOSE 9001

ENTRYPOINT ["/opt/etherpad/bin/run.sh","--root"]