{ ... }:
{
  # nixos fw messes up custom nftables config
  networking.firewall.enable = false;

  # enable NAT
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

  networking.nftables = {
    enable = true;
    flushRuleset = false;
    ruleset = ''
      table ip filter {
        chain INPUT {
          type filter hook input priority filter; policy accept;
          udp dport 53 accept
          ip saddr 10.42.0.0/24 accept
          ip saddr 10.100.0.0/24 tcp dport 443 accept
          ip saddr 10.100.0.0/24 udp dport 53 accept
        }
      }
    '';
  };
}
