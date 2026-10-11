#!/bin/bash
set -euo pipefail

config_path="/opt/data/.config/himalaya/config.toml"

options_path() {
  local path
  for path in /data/options.json /opt/data/options.json; do
    if [[ -f "$path" ]]; then
      printf '%s\n' "$path"
      return 0
    fi
  done
  return 1
}

sync_config() {
  local options="$1"

  python3 - "$options" "$config_path" <<'PY'
import json
import os
import sys
import tempfile
from pathlib import Path

options_path = Path(sys.argv[1])
config_path = Path(sys.argv[2])
config = json.loads(options_path.read_text()).get("himalaya_config", "")

# An empty add-on option does not take ownership of a file created from the
# terminal or Himalaya's setup wizard.
if not config:
    raise SystemExit(0)

config_path.parent.mkdir(mode=0o700, parents=True, exist_ok=True)
fd, temporary_path = tempfile.mkstemp(prefix=".config.toml.", dir=config_path.parent)
try:
    with os.fdopen(fd, "w", encoding="utf-8") as temporary:
        temporary.write(config)
    os.chmod(temporary_path, 0o600)
    os.replace(temporary_path, config_path)
finally:
    if os.path.exists(temporary_path):
        os.unlink(temporary_path)
PY
}

last_checksum=""
while true; do
  if options="$(options_path)"; then
    checksum="$(sha256sum "$options" | awk '{print $1}')"
    if [[ "$checksum" != "$last_checksum" ]]; then
      if sync_config "$options"; then
        last_checksum="$checksum"
      else
        printf 'Unable to update Himalaya configuration from %s\n' "$options" >&2
      fi
    fi
  fi
  sleep 1
done
