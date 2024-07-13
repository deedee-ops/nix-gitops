{ config, ... }:
{
  networking = {
    useDHCP = true;
    hostName = "piecyk";
    domain = "${config.localDomain}";
    vlans = {
      mgmt0 = { id = 42; interface = "enp5s0"; };
      trst0 = { id = 100; interface = "enp5s0"; };
      untrst0 = { id = 200; interface = "enp5s0"; };
      iot0 = { id = 210; interface = "enp5s0"; };
    };
    interfaces.iot0.ipv4.addresses = [{
      address = "10.210.50.50";
      prefixLength = 16;
    }];
  };
}
