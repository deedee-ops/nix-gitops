{ config, osConfig, lib, pkgs, ... }: {
  imports = [
    ../../modules/home-manager/local
  ];

  home = {
    activation = {
      gpg = lib.hm.dag.entryAfter [ "sopsNix" ] ''
        export GNUPGHOME="${config.xdg.dataHome}/gnupg"
        $DRY_RUN_CMD ${pkgs.gnupg}/bin/gpg-connect-agent "scd serialno" "learn --force" /bye
      '';
    };
  };

  programs = {
    ssh = {
      includes = [
        config.sops.secrets."ssh/personal/config".path
      ];
      matchBlocks = {
        # private
        router = {
          forwardAgent = true;
          host = "router";
          hostname = "router.${osConfig.localDomain}";
          identitiesOnly = true;
          identityFile = [
            config.sops.secrets."ssh/personal/key".path
          ];
          port = 22;
          user = "ajgon";
        };
        supervisor = {
          forwardAgent = true;
          host = "sv";
          hostname = "supervisor.${osConfig.localDomain}";
          identitiesOnly = true;
          identityFile = [
            config.sops.secrets."ssh/personal/key".path
          ];
          port = 22;
          user = "ajgon";
        };
        dexter = {
          forwardAgent = true;
          host = "dexter";
          hostname = "dexter.${osConfig.localDomain}";
          identitiesOnly = true;
          identityFile = [
            config.sops.secrets."ssh/personal/key".path
          ];
          port = 22;
          user = "ajgon";
        };
        gitea = {
          forwardAgent = false;
          host = "gitea.${osConfig.remoteDomain}";
          hostname = "gitea.${osConfig.remoteDomain}";
          identitiesOnly = true;
          identityFile = [
            config.sops.secrets."ssh/personal/key".path
          ];
          port = 22222;
          user = "git";
        };
        nas = {
          forwardAgent = false;
          host = "nas";
          hostname = "nas.${osConfig.localDomain}";
          identitiesOnly = true;
          identityFile = [
            config.sops.secrets."ssh/personal/key".path
          ];
          port = 51008;
          user = "ajgon";
        };
        pbs = {
          forwardAgent = true;
          host = "pbs";
          hostname = "pbs.${osConfig.localDomain}";
          identitiesOnly = true;
          identityFile = [
            config.sops.secrets."ssh/personal/key".path
          ];
          port = 22;
          user = "ajgon";
        };

        # public
        github = {
          forwardAgent = false;
          host = "github.com";
          hostname = "github.com";
          identitiesOnly = true;
          identityFile = [
            config.sops.secrets."ssh/personal/key".path
          ];
          port = 22;
          user = "git";
        };
      };
    };
  };

  services.gpg-agent.enable = lib.mkForce true;
}
