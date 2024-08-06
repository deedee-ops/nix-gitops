{ config, ... }:
{
  # for debugging
  # systemd.services."systemd-networkd".environment.SYSTEMD_LOG_LEVEL = "debug";

  systemd.network = {
    enable = true;
    netdevs = {
      "0042-management" = {
        netdevConfig = {
          Kind = "vlan";
          Name = "mgmt0";
          MACAddress = "02:2a:01:00:00:00";
        };
        vlanConfig.Id = 42;
      };
      "0100-trusted" = {
        netdevConfig = {
          Kind = "vlan";
          Name = "trst0";
          MACAddress = "02:2a:01:00:00:01";
        };
        vlanConfig.Id = 100;
      };
      "0210-iot" = {
        netdevConfig = {
          Kind = "vlan";
          Name = "iot0";
          MACAddress = "02:2a:01:00:00:03";
        };
        vlanConfig.Id = 210;
      };
    };

    networks = {
      # systemd is stupid, see: https://volatilesystems.org/implementing-vlans-with-systemd-networkd-on-an-active-physical-interface.html
      "1000-physical-untrusted" = {
        matchConfig.Name = "enp5s0";
        vlan = [
          "mgmt0"
          "trst0"
          "iot0"
        ];
        linkConfig = {
          RequiredForOnline = "routable";
          MTUBytes = "9000";
        };
        networkConfig = {
          DHCP = "ipv4";
          LinkLocalAddressing = "ipv4"; # disable ipv6
        };
      };
      "1042-management" = {
        matchConfig.Name = "mgmt0";
        linkConfig = {
          RequiredForOnline = "routable";
          MTUBytes = "1500";
        };
        networkConfig = {
          LinkLocalAddressing = "no"; # disable fallback IPs
          DHCP = "ipv4";
        };
      };
      "1100-trusted" = {
        matchConfig.Name = "trst0";
        linkConfig = {
          RequiredForOnline = "routable";
          MTUBytes = "9000";
        };
        networkConfig = {
          LinkLocalAddressing = "no"; # disable fallback IPs
          DHCP = "ipv4";
        };
      };
      "1210-iot" = {
        matchConfig.Name = "iot0";
        address = [ "10.210.50.50/16" ];
        linkConfig = {
          RequiredForOnline = "carrier";
          MTUBytes = "1500";
        };
        networkConfig = {
          LinkLocalAddressing = "no"; # disable fallback IPs
        };
      };
    };
  };

  networking = {
    hostName = "piecyk";
    networkmanager.enable = false;
    enableIPv6 = false;
    useDHCP = false;
    domain = "${config.localDomain}";
  };
}
