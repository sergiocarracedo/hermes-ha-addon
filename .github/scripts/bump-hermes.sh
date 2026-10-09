#!/usr/bin/env bash
set -euo pipefail

root="$(git rev-parse --show-toplevel)"
dockerfile="$root/hermes/Dockerfile"
config="$root/hermes/config.yaml"
changelog="$root/CHANGELOG.md"
release_json="$(mktemp)"
trap 'rm -f "$release_json"' EXIT

curl -fsSL \
  -H 'Accept: application/vnd.github+json' \
  -H 'X-GitHub-Api-Version: 2022-11-28' \
  https://api.github.com/repos/NousResearch/hermes-agent/releases/latest \
  -o "$release_json"

tag="$(jq -r '.tag_name // empty' "$release_json")"
published_at="$(jq -r '.published_at // empty' "$release_json")"
if [[ ! "$tag" =~ ^v[0-9]+(\.[0-9]+){2}$ ]]; then
  printf 'Unexpected Hermes stable release tag: %s\n' "$tag" >&2
  exit 1
fi
if [[ -z "$published_at" ]]; then
  printf 'Hermes stable release %s has no publication date.\n' "$tag" >&2
  exit 1
fi

current="$(sed -n -E 's/^FROM nousresearch\/hermes-agent:(v[^[:space:]]+)$/\1/p' "$dockerfile")"
if [[ -z "$current" ]]; then
  printf 'Unable to read Hermes pin from %s\n' "$dockerfile" >&2
  exit 1
fi
if [[ "$current" == "$tag" ]]; then
  printf 'Hermes is already pinned to %s.\n' "$tag"
  exit 0
fi

release_date="$(date -u -d "$published_at" +'%Y.%-m.%-d')"
current_addon_version="$(sed -n -E 's/^version: "([^"]+)"$/\1/p' "$config")"
revision=1
if [[ "$current_addon_version" =~ ^${release_date//./\.}-([0-9]+)$ ]]; then
  revision=$((BASH_REMATCH[1] + 1))
fi
addon_version="${release_date}-${revision}"
sed -i -E "s|^FROM nousresearch/hermes-agent:v[0-9]+\\.[0-9]+\\.[0-9]+$|FROM nousresearch/hermes-agent:${tag}|" "$dockerfile"
sed -i -E "s/^version: .*/version: \"${addon_version}\"/" "$config"

temporary="$(mktemp)"
{
  printf '# Changelog\n\n## %s\n\n- Update Hermes Agent to [%s](https://github.com/NousResearch/hermes-agent/releases/tag/%s).\n\n' \
    "$addon_version" "$tag" "$tag"
  sed '1,3d' "$changelog"
} > "$temporary"
mv "$temporary" "$changelog"

printf 'Updated Hermes from %s to %s; add-on version is %s.\n' "$current" "$tag" "$addon_version"
