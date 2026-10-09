ARG BUILD_VERSION
ARG BUILD_ARCH
FROM nousresearch/hermes-agent:v0.21.6

ARG BUILD_VERSION
ARG BUILD_ARCH

RUN apt-get update \
    && apt-get install -y --no-install-recommends curl nginx nano \
    && rm -rf /var/lib/apt/lists/* \
    && arch="$(uname -m)" \
    && curl -fsSL "https://github.com/tsl0922/ttyd/releases/download/1.7.7/ttyd.${arch}" -o /usr/local/bin/ttyd \
    && chmod +x /usr/local/bin/ttyd

ENV HERMES_DASHBOARD=1 \
    HERMES_DASHBOARD_HOST=127.0.0.1 \
    HERMES_DASHBOARD_PORT=9120 \
    API_SERVER_ENABLED=true \
    API_SERVER_HOST=127.0.0.1 \
    HERMES_GATEWAY_BOOTSTRAP_STATE=running

COPY ingress.conf /etc/nginx/hermes-ingress.conf
COPY addon-run.sh /usr/local/bin/hermes-addon-run
COPY hermes.sh /etc/profile.d/hermes.sh
RUN chmod +x /usr/local/bin/hermes-addon-run

LABEL io.hass.version="${BUILD_VERSION}" \
      io.hass.type="addon" \
      io.hass.arch="${BUILD_ARCH}"

# Keep upstream's s6 ENTRYPOINT; its init supervises the gateway and dashboard
# while running this as its main command. HA maps persistent data to /opt/data.
CMD ["/usr/local/bin/hermes-addon-run"]
