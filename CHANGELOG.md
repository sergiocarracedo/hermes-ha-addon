# Changelog

## 2026.9.24-9

- Export the Hermes virtual environment path from the login shell profile used by the terminal.

## 2026.9.24-8

- Add the Hermes virtual environment to the shell PATH and define the `ll` alias in login shells.

## 2026.9.24-7

- Forward all dashboard proxy headers in the same nginx location; preserve the valid loopback Origin for PTY chat WebSockets.

## 2026.9.24-6

- Forward the dashboard WebSocket Origin as the loopback upstream origin so embedded PTY chat passes Hermes' origin validation.

## 2026.9.24-5

- Avoid protocol-relative `//api/...` URLs in Hermes' lazy chunk preloader.

## 2026.9.24-4

- Inject an ingress-aware base URL so lazy dashboard resources resolve against the Home Assistant origin.

## 2026.9.24-3

- Rewrite lazy-loaded JavaScript chunk paths through the Home Assistant ingress prefix.

## 2026.9.24-2

- Forward each ingress request using its upstream Host header so Hermes accepts the dashboard Host validation.

## 2026.9.24-1

- Initial Home Assistant add-on using Hermes Agent `v2026.9.24`.
- Hermes dashboard ingress with a floating terminal link.
- Multi-architecture image publication through GHCR.
