# home.nix configuration
{ config, pkgs, ... }:

{
  # Install required packages
  home.packages = with pkgs; [ wireguard-tools dnsmasq dig ];

  # Create the Wireguard configuration directory
  home.file.".config/wireguard/wg0.conf".text = ''
    [Interface]
    # Bouncing = 1
    # NAT-PMP (Port Forwarding) = off
    # VPN Accelerator = on
    PrivateKey = cB9DWbhQy2O3/tUq+Kv1qoFslX/2kZuwLE0/ziOEMEU=
    Address = 10.2.0.2/32
    DNS = 10.2.0.1

    [Peer]
    # US-FREE#89
    PublicKey = A1lZjTXsjqmvmehp9i0zV+jzl89Vf2y2fXxeMRSjp18=
    AllowedIPs = 0.0.0.0/0
    Endpoint = 138.199.50.129:51820
  '';

  home.file.".local/bin/vpn-route".text = ''
    #!/usr/bin/env bash
    set -e  # Exit on error

    # Configuration
    VPN_INTERFACE="wg0"
    REAL_USER="$(who am i | awk '{print $1}')"
    CONFIG_PATH="/home/$REAL_USER/.config/wireguard/wg0.conf"
    DOMAINS="example1.com example2.com"

    # Check if running as root
    if [ "$(id -u)" -ne 0 ]; then
        echo "This script must be run as root (use sudo)"
        exit 1
    fi

    # Function to parse WireGuard config
    parse_config() {
        local config_file="$1"
        # Use awk with regex that allows leading whitespace and spaces around '='
        PRIVATE_KEY=$(awk -F '=' '/^[[:space:]]*PrivateKey[[:space:]]*=/ {gsub(/[[:space:]]/, "", $2); print $2}' "$config_file")
        ADDRESS=$(awk -F '=' '/^[[:space:]]*Address[[:space:]]*=/ {gsub(/[[:space:]]/, "", $2); print $2}' "$config_file")
        PEER_PUBKEY=$(awk -F '=' '/^[[:space:]]*PublicKey[[:space:]]*=/ {gsub(/[[:space:]]/, "", $2); print $2}' "$config_file")
        ENDPOINT=$(awk -F '=' '/^[[:space:]]*Endpoint[[:space:]]*=/ {gsub(/[[:space:]]/, "", $2); print $2}' "$config_file")
        ALLOWED_IPS=$(awk -F '=' '/^[[:space:]]*AllowedIPs[[:space:]]*=/ {gsub(/[[:space:]]/, "", $2); print $2}' "$config_file")

        # Validate parsed values
        if [ -z "$PRIVATE_KEY" ] || [ -z "$ADDRESS" ] || [ -z "$PEER_PUBKEY" ] || [ -z "$ENDPOINT" ] || [ -z "$ALLOWED_IPS" ]; then
            echo "Error: Failed to parse required values from config file"
            exit 1
        fi
    }

    cleanup_interface() {
        # Remove existing interface if it exists
        if ip link show "$VPN_INTERFACE" >/dev/null 2>&1; then
            echo "Removing existing interface..."
            ip link delete dev "$VPN_INTERFACE" || true
        fi

        # Remove any existing routes
        for domain in $DOMAINS; do
            for ip in $(${pkgs.dig}/bin/dig +short "$domain"); do
                ip route del "$ip/32" dev "$VPN_INTERFACE" 2>/dev/null || true
            done
        done
    }

    setup_interface() {
        # Create WireGuard interface
        echo "Creating WireGuard interface..."
        ip link add dev "$VPN_INTERFACE" type wireguard

        echo "Setting interface address..."
        ip address add "$ADDRESS" dev "$VPN_INTERFACE"

        echo "Configuring WireGuard..."
        echo "$PRIVATE_KEY" | wg set "$VPN_INTERFACE" \
            private-key /dev/stdin \
            peer "$PEER_PUBKEY" \
            endpoint "$ENDPOINT" \
            persistent-keepalive 25 \
            allowed-ips "$ALLOWED_IPS"

        echo "Bringing up interface..."
        ip link set up dev "$VPN_INTERFACE"
    }

    case "$1" in
        up)
            # Check if config exists
            if [ ! -f "$CONFIG_PATH" ]; then
                echo "Error: Config file not found at $CONFIG_PATH"
                exit 1
            fi

            # Clean up first
            cleanup_interface

            # Parse config
            parse_config "$CONFIG_PATH"

            # Setup interface
            setup_interface

            echo "Setting up routes for domains..."
            for domain in $DOMAINS; do
                echo "Processing domain: $domain"
                for ip in $(${pkgs.dig}/bin/dig +short "$domain"); do
                    if [ -n "$ip" ]; then
                        echo "Adding route for $ip"
                        ip route add "$ip/32" dev "$VPN_INTERFACE"
                    fi
                done
            done

            echo "VPN setup complete."
            ;;

        down)
            echo "Shutting down VPN..."
            cleanup_interface
            echo "VPN shutdown complete."
            ;;

        status)
            if ip link show "$VPN_INTERFACE" >/dev/null 2>&1; then
                echo "Interface $VPN_INTERFACE exists"
                wg show "$VPN_INTERFACE"
                ip -brief link show "$VPN_INTERFACE"
                ip route show dev "$VPN_INTERFACE"
            else
                echo "Interface $VPN_INTERFACE does not exist"
            fi
            ;;

        *)
            echo "Usage: $0 {up|down|status}"
            exit 1
            ;;
    esac
  '';

  # Make the script executable
  home.file.".local/bin/vpn-route".executable = true;

  # Create a systemd user service for automatic startup
  systemd.user.services.vpn-route = {
    Unit = {
      Description = "Domain-specific VPN routing";
      After = "network-online.target";
    };

    Service = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "sudo ${config.home.homeDirectory}/.local/bin/vpn-route up";
      ExecStop = "sudo ${config.home.homeDirectory}/.local/bin/vpn-route down";
    };

    Install = { WantedBy = [ "default.target" ]; };
  };
}
