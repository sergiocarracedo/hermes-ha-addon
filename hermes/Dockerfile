ARG BUILD_VERSION
ARG BUILD_ARCH
ARG HIMALAYA_VERSION=2.2.1
FROM nousresearch/hermes-agent:v0.21.6

ARG BUILD_VERSION
ARG BUILD_ARCH
ARG HIMALAYA_VERSION

RUN apt-get update \
    && apt-get install -y --no-install-recommends curl nginx nano \
    && rm -rf /var/lib/apt/lists/* \
    && arch="$(uname -m)" \
    && case "$arch" in \
        x86_64) himalaya_arch=x86_64 ;; \
        aarch64) himalaya_arch=aarch64 ;; \
        *) echo "Unsupported Himalaya architecture: $arch" >&2; exit 1 ;; \
    esac \
    && curl -fsSL "https://github.com/pimalaya/himalaya/releases/download/v${HIMALAYA_VERSION}/himalaya.${himalaya_arch}-linux.tgz" -o /tmp/himalaya.tgz \
    && tar -xzf /tmp/himalaya.tgz -C /usr/local/bin himalaya \
    && rm /tmp/himalaya.tgz \
    && himalaya --version \
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
COPY himalaya-config-sync.sh /usr/local/bin/himalaya-config-sync
RUN chmod +x /usr/local/bin/hermes-addon-run /usr/local/bin/himalaya-config-sync

LABEL io.hass.version="${BUILD_VERSION}" \
      io.hass.type="addon" \
      io.hass.arch="${BUILD_ARCH}"

# Keep upstream's s6 ENTRYPOINT; its init supervises the gateway and dashboard
# while running this as its main command. HA maps persistent data to /opt/data.
CMD ["/usr/local/bin/hermes-addon-run"]
