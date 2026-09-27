#!/bin/bash
set -euo pipefail

name="hermes-ha-smoke-$$"
trap 'docker rm -f "$name" >/dev/null 2>&1 || true' EXIT
docker run -d --rm --name "$name" hermes-ha-addon:test >/dev/null

for attempt in {1..30}; do
  if docker exec "$name" curl -fsS http://127.0.0.1:9120/ -o /dev/null 2>/dev/null; then
    break
  fi
  sleep 2
done

docker exec -i "$name" /opt/hermes/.venv/bin/python - <<'PY'
import re
import urllib.request
from urllib.parse import urljoin

from agent.opencode_affinity import opencode_session_headers

base = "http://127.0.0.1:8099"
prefix = "/api/hassio_ingress/smoke"
headers = {"Host": "homeassistant.local", "X-Ingress-Path": prefix}

def get(path):
    return urllib.request.urlopen(urllib.request.Request(base + path, headers=headers), timeout=10).read()

page = get("/").decode()
assert f'window.__HERMES_BASE_PATH__="{prefix}"' in page
assert f'<base href="{prefix}/">' in page
assert f'href="{prefix}/terminal/"' in page
assert 'aria-label="Open Hermes terminal"' in page
asset = re.search(r'src="' + re.escape(prefix) + r'(/assets/[^"]+)"', page)
assert asset
bundle = get(asset.group(1)).decode()
assert f'"{prefix}/assets/SystemPage-' in bundle
assert f'"{prefix}/assets/xterm-' in bundle
mapped_page = re.search(re.escape(prefix) + r'/assets/(SystemPage-[^" ]+\.js)', bundle)
assert mapped_page and get("/assets/" + mapped_page.group(1))
assert urljoin(f"http://homeassistant.local{prefix}/", "assets/SystemPage.js") == f"http://homeassistant.local{prefix}/assets/SystemPage.js"
assert b"ttyd" in get("/terminal/")
assert opencode_session_headers("opencode-go", "https://opencode.ai/zen/go/v1").get("x-opencode-session")
print("Dashboard ingress and terminal: OK")
PY
