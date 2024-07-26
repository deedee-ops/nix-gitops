{ pkgs, ... }:
{
  powerManagement.resumeCommands = ''
    ${pkgs.systemd}/bin/systemctl restart network-setup
  '';
  services.logind.extraConfig = ''
    HandlePowerKey=suspend
    IdleAction=suspend
    IdleActionSec=5m
  '';
}
