{ pkgs, ... }: {
  home.packages = [
    pkgs.mc
  ];

  xdg.dataFile = {
    "mc/skins/catppuccin.ini" = {
      source = ./mc/catppuccin.ini;
    };
  };
}

