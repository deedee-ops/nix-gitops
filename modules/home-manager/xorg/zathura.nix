{ ... }: {
  programs.zathura = {
    enable = true;
    extraConfig = ''
      include catppuccin-mocha
    '';
  };

  xdg.configFile = {
    zathura = {
      source = ./zathura;
      recursive = true;
    };
  };
}
