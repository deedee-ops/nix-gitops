{ config, lib, pkgs, ... }: {
  imports = [
    ../../modules/home-manager/core
  ];

  sops = {
    defaultSopsFile = ./personal.sops.yaml;
    secrets = {
      "atuin/key" = { };
      "everdo/apikey" = { };
      "kubectl/config" = { };
      "openai/apikey" = { };
      "ssh/personal/key" = { };
      "ssh/personal/config" = { };
      "talosctl/config" = { };
      "zsh/scripts" = { };
    };
  };

  home = {
    activation = {
      kubeconfig = lib.hm.dag.entryAfter [ "sopsNix" ] ''
        $DRY_RUN_CMD mkdir -p ${config.xdg.configHome}/kube
        $DRY_RUN_CMD sh -c 'rm ${config.xdg.configHome}/kube/config 2> /dev/null; ln -s ${config.sops.secrets."kubectl/config".path} ${config.xdg.configHome}/kube/config || true'
        $DRY_RUN_CMD sh -c 'PATH=${pkgs.git}/bin:$PATH ${pkgs.krew}/bin/krew install virt'
      '';
      talosconfig = lib.hm.dag.entryAfter [ "sopsNix" ] ''
        $DRY_RUN_CMD mkdir -p ${config.xdg.configHome}/talos
        $DRY_RUN_CMD sh -c 'rm ${config.xdg.configHome}/talos/config 2> /dev/null; ln -s ${config.sops.secrets."talosctl/config".path} ${config.xdg.configHome}/talos/config || true'
      '';
    };

    packages = [
      pkgs.dnsutils
      pkgs.pwgen
      pkgs.talosctl
    ];

    sessionVariables = {
      PROMPT_HOSTNAME_COLOR = "magenta";
    };
  };
  programs = {
    atuin = {
      settings = {
        key = config.sops.secrets."atuin/key".path;
      };
    };

    git = {
      userName = "Igor Rzegocki";
      userEmail = "igor@rzegocki.pl";
      signing = {
        key = "igor@rzegocki.pl";
        signByDefault = true;
      };
    };

    gpg = {
      publicKeys = [
        {
          source = ./public.gpg;
          trust = "ultimate";
        }
      ];
      settings = {
        no-autostart = true;
      };
    };

    msmtp = {
      enable = true;
    };
  };

  services.gpg-agent.enable = lib.mkOverride 100 false;
  systemd.user.services.gnupg-create-socketdir = {
    Install = {
      WantedBy = [ "default.target" ];
    };
    Unit = {
      Description = "Create GnuPG socket directory";
    };
    Service = {
      Type = "oneshot";
      Environment = [
        "GNUPGHOME=${config.xdg.dataHome}/gnupg"
      ];
      ExecStart = "${pkgs.gnupg}/bin/gpgconf --create-socketdir";
    };
  };

  xdg.configFile = {
    "zsh/extra/personal.zsh" = {
      text = "source ${config.sops.secrets."zsh/scripts".path}";
    };
  };
}
