# Hermes Agent for Home Assistant

<p align="center">
  <img src="hermes/logo.png" alt="Hermes Agent logo" width="240">
</p>

Run [Hermes Agent](https://github.com/NousResearch/hermes-agent) in Home Assistant. The add-on provides the Hermes dashboard and a writable terminal through Home Assistant ingress, so neither service is exposed directly to your network.

## Install

1. In Home Assistant, go to **Settings → Add-ons → Add-on Store**.
2. Select the three-dot menu in the upper-right corner, then choose **Repositories**.
3. Add this repository URL:

   ```text
   https://github.com/sergiocarracedo/hermes-ha-addon
   ```

4. Close the repository dialog and search the Add-on Store for **Hermes Agent**.
5. Open **Hermes Agent**, select **Install**, then wait for the download to finish.
6. Select **Start**.
7. Optionally enable **Show in sidebar**, then select **Open Web UI** to open the Hermes dashboard.

## First setup

1. Open the Hermes dashboard from the add-on page or the Home Assistant sidebar.
2. Select a model provider and add its credentials in **Models** or **Keys**.
3. Start a new chat to confirm Hermes can answer requests.

Use the floating **>_** button in the dashboard to open a terminal when you need to run Hermes commands directly. Hermes stores its configuration, credentials, chats, skills, and other persistent data in the add-on data directory (`/opt/data`).

Installing this add-on does not migrate data from another Hermes installation.

## Updates

New add-on releases appear in Home Assistant's add-on page. Select **Update**, then restart Hermes when Home Assistant prompts you. Published releases include amd64 and aarch64 images, so Home Assistant downloads the image instead of building Hermes on the device.

## Development

Build and smoke-test the add-on locally:

```bash
docker build \
  --build-arg BUILD_VERSION=2026.9.24-11 \
  --build-arg BUILD_ARCH=amd64 \
  -t hermes-ha-addon:test hermes
bash tests/smoke.sh
```
