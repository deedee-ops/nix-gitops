{ pkgs, config, osConfig, lib, ... }: {
  imports = [
    # shell
    ./aichat.nix
    ./atuin.nix
    ./bat.nix
    ./direnv.nix
    ./env.nix
    ./gpg.nix
    ./git.nix
    ./go.nix
    ./k8s.nix
    ./mc.nix
    ./nvim.nix
    ./ranger.nix
    ./ssh.nix
    ./tmux.nix
    ./xdg.nix
    ./zsh.nix
  ];

  nix.enable = true;
  nix.package = lib.mkDefault pkgs.nix;
  nix.settings.use-xdg-base-directories = true;

  home = {
    username = "${osConfig.primaryUser}";
    homeDirectory = "/home/${osConfig.primaryUser}";
    stateVersion = "24.05";

    activation = {
      sopsNix = lib.hm.dag.entryAfter [ "reloadSystemd" ] (lib.optionalString (! builtins.hasAttr "system" osConfig) ''
        $DRY_RUN_CMD ${pkgs.systemd}/bin/systemctl start --user sops-nix
      '');
      dirs = ''
        $DRY_RUN_CMD mkdir -p ${config.home.homeDirectory}/Downloads || true
        $DRY_RUN_CMD mkdir -p ${config.home.homeDirectory}/Pictures/Screenshots || true
        $DRY_RUN_CMD mkdir -p ${config.home.homeDirectory}/Projects || true
      '';
    };

    keyboard = {
      layout = "pl";
      options = [ "caps:escape" ];
    };

    packages = [
      pkgs.bzip2
      pkgs.imagemagickBig
      pkgs.qrcp
      pkgs.silver-searcher
      pkgs.sops
    ];
  };

  sops = {
    age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
  } // lib.optionalAttrs (! builtins.hasAttr "system" osConfig) {
    # it's a symlink to actual secrets directory living on tmpfs, so it's safe to use it this way
    defaultSymlinkPath = "/tmp/${config.home.username}-secrets";
  };

  xdg.mimeApps.enable = true;

  programs = {
    home-manager = {
      enable = true;
    };
  };
}
