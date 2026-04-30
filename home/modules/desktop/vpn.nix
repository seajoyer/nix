{ config, lib, ... }:

lib.mkIf config.my.desktop.vpn.enable {
  sops.secrets.wireguard_private_key = {
    path = "${config.home.homeDirectory}/.config/wireguard/private.key";
    mode = "0400";
  };

  home.file.".config/wireguard/wg0.conf".text = ''
    [Interface]
    PostUp  = wg set %i private-key ${config.sops.secrets.wireguard_private_key.path}
    Address = 10.2.0.2/32, 2a07:b944::2:2/128
    DNS     = 10.2.0.1, 2a07:b944::2:1

    [Peer]
    PublicKey  = U54ozdeZUU4q6cD6qmFCqaA4rNefeArKFnCIUk+g+Fk=
    AllowedIPs = 0.0.0.0/0, ::/0
    Endpoint   = 89.38.97.138:51820
  '';
}
