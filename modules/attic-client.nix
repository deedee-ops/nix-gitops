{ config, pkgs, ... }:
{
  sops = {
    secrets = {
      "attic/client/jwt" = { };
    };
  };

  systemd.services = {
    "attic-client" = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.attic-client}/bin/attic login homelab https://attic.${config.remoteDomain} \"$(cat ${config.sops.secrets."attic/client/jwt".path})\" --set-default'";
      };
    };
  };

  system.activationScripts = {
    # "bind-zones" is alphabetically before "etc" script
    push-to-attic.text = ''
      ${pkgs.attic-client}/bin/attic push homelab $(ls -d /nix/store/*/ | grep -v fake_nixpkgs)
    '';
  };

  environment.systemPackages = [
    pkgs.attic-client
  ];
}
