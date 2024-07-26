{ config, ... }:
{
  networking = {
    useDHCP = true;
    enableIPv6 = false;
    hostName = "piecyk";
    domain = "${config.localDomain}";
    vlans = {
      mgmt0 = { id = 42; interface = "enp5s0"; };
      trst0 = { id = 100; interface = "enp5s0"; };
      iot0 = { id = 210; interface = "enp5s0"; };
    };

    interfaces.enp5s0 = {
      useDHCP = true;
      mtu = 9000;
    };

    interfaces.mgmt0 = {
      useDHCP = true;
    };

    interfaces.trst0 = {
      useDHCP = true;
      mtu = 9000;
    };

    interfaces.iot0 = {
      ipv4.addresses = [{
        address = "10.210.50.50";
        prefixLength = 16;
      }];
    };
  };
}
