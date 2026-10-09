# Hermes release automation

`check-hermes-release.yml` checks the latest stable Hermes Agent GitHub release daily and on manual dispatch. When the upstream tag differs, `bump-hermes.sh` updates the Dockerfile pin, add-on version, and changelog; the workflow commits the change and creates a GitHub Release. The add-on version is based on the upstream release date, with a revision suffix for multiple releases on the same day. Publishing that release triggers `publish-image.yml`, which builds one amd64/aarch64 image and pushes it to GHCR. Home Assistant pulls the published image instead of building the multi-gigabyte upstream image on-device.

The GHCR package must be public for unauthenticated Home Assistant pulls. After the first package publication, set package visibility to **Public** in GitHub Packages. The workflow uses the repository's `GITHUB_TOKEN`; grant it `contents: write` and `packages: write` (configured in each workflow).

Run **Check Hermes release** manually to check for an upstream bump. For an initial/manual image publish, run **Publish add-on image** with the version in `hermes/config.yaml`.
