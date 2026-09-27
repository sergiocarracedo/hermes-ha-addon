# Changelog

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
