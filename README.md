# Hermes Agent for Home Assistant

Runs [Hermes Agent](https://github.com/NousResearch/hermes-agent) `v2026.9.24` as a Home Assistant add-on. The add-on page opens the Hermes dashboard; the floating **>_** link opens a writable terminal in a new tab. Both are available only through Home Assistant ingress. Home Assistant maps the add-on's persistent data directory to Hermes's `/opt/data`. GitHub Actions publishes a multi-architecture image to GHCR; the Pi pulls the image rather than building Hermes locally.

## Install

In Home Assistant, open **Settings → Add-ons → Add-on Store → ⋮ → Repositories**, add `https://github.com/sergiocarracedo/hermes-ha-addon`, install **Hermes Agent**, and start it. Open its page or enable **Show in sidebar**. Configure your model and credentials in the dashboard or terminal. Installing this separate add-on does not migrate the old add-on's data.

For OpenCode Go, select its built-in provider in Hermes and add your OpenCode credentials in the dashboard or terminal. This Hermes release sends `x-opencode-session` to OpenCode Go. If you select a custom endpoint, make sure it resolves to an OpenCode target; otherwise Hermes will not attach the header automatically.

The upstream image supervises the gateway and dashboard. This add-on preserves that entrypoint, adding only nginx for ingress and ttyd for terminal access. Neither dashboard nor terminal has a public host port. The GHCR package must be public so Home Assistant can pull it without registry credentials.

## Verify locally

For local tests, build with `docker build --build-arg BUILD_VERSION=2026.9.24-1 --build-arg BUILD_ARCH=amd64 -t hermes-ha-addon:test hermes` and run `bash tests/smoke.sh`. The published Home Assistant app pulls the multi-arch GHCR image instead of building on the Pi.
