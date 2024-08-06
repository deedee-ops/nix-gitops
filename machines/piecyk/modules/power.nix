{ pkgs, ... }:
{
  # hack for crappy AQC113CS-based NIC, to make vlan interfaces work again after suspend
  # if ever replaced, it can be removed
  powerManagement.resumeCommands = ''
    ${pkgs.iproute2}/bin/ip link set enp5s0 promisc on
  '';

  services.logind.extraConfig = ''
    HandlePowerKey=suspend
    IdleAction=suspend
    IdleActionSec=5m
  '';
}
