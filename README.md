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

Home Assistant app backups preserve that state, but exclude `/opt/data/installs/`: Hermes execution environments contain regenerable tool downloads such as Chromium and FFmpeg, which can otherwise make backups several gigabytes larger. Hermes recreates an environment when it needs one after a restore.

Installing this add-on does not migrate data from another Hermes installation.

## Himalaya email CLI

The add-on includes [Himalaya](https://pimalaya.org/), a command-line email client. In the add-on's **Configuration** tab, paste your TOML configuration into **Himalaya configuration**. Saved changes are written immediately to:

```text
/opt/data/.config/himalaya/config.toml
```

That path is Hermes's `$HOME/.config/himalaya/config.toml` and persists across add-on updates. Leave the field empty to retain a configuration created from the terminal or Himalaya's setup wizard. The configuration can contain mail credentials, so use app passwords where available and restrict access to Home Assistant administrators.

See the [Himalaya configuration guide](https://github.com/pimalaya/himalaya#configuration) for the TOML format and account examples.

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
