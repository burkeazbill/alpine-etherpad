FROM mhart/alpine-node-auto:10 as livefire-etherpad

ENV NODE_PATH /opt/etherpad/src/node_modules

WORKDIR /opt

RUN info(){ printf '\x1B[32m--\n%s\n--\n\x1B[37m' "$*"; } \
    && info "==> Installing OS tools and dependencies..." \
    && apk --update --no-cache add --update git curl supervisor shadow make g++\
    && info "==> Cloning etherpad source..." \
    && git clone https://github.com/ether/etherpad-lite.git etherpad \
    && useradd -c "Etherpad user" -m -d /home/etherpad -s /bin/false etherpad \
    && info "==> Installing etherpad dependencies..." \
    && etherpad/bin/installDeps.sh \
    && cd /opt/etherpad/src \
    && info "==> Running npm audit fix --force to cleanup npm modules" \
    && npm audit fix --force \
    && chown -R etherpad:etherpad /opt/etherpad

# Add Configuration Files:
ADD supervisor.conf /etc/supervisor/supervisor.conf
ADD settings.json /opt/etherpad/settings.json

# FROM livefire-etherpad

WORKDIR /opt/etherpad/src/node_modules/ep_etherpad-lite/node/

# Expose Port:
EXPOSE 9001

# CMD ["supervisord", "-c", "/etc/supervisor/supervisor.conf", "-n"]
# CMD ["/opt/etherpad/bin/run.sh"]
ENTRYPOINT ["/opt/etherpad/bin/run.sh","--root"]