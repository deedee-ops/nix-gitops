{ config, ... }:
{
  hardware.pulseaudio.enable = true;
  nixpkgs.config.pulseaudio = true;
  users.users."${config.primaryUser}".extraGroups = [ "audio" ];
}
