{ ... }: {
  programs.bat = {
    enable = true;

    config = {
      pager = "never";
      style = "plain";
      theme = "catppuccin-mocha";
    };
  };

  xdg.configFile.bat = {
    source = ./bat;
    recursive = true;
  };
}
