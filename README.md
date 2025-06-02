# CamGrab Tool

A camera grabber tool using Termux + Ngrok + PHP.

## Features

- Starts a PHP server to serve a fake camera page.
- Uses Ngrok to create a public link.
- Captures 3 photos using the device camera.
- Saves photos to `/sdcard/CamGrabs/` on the attacker's phone.

## How to Use

```bash
git clone https://github.com/Mujaheed56/camgrab.git
cd camgrab
chmod +x camgrab.sh
./camgrab.sh
```

Make sure:
- You have `ngrok` installed and authtoken set.
- You have allowed Termux access to internal storage (`termux-setup-storage`).
- Ngrok link is sent to the target device.
