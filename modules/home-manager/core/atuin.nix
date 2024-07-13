{ pkgs, osConfig, ... }: {
  programs.atuin = {
    enable = true;

    enableZshIntegration = true;
    settings = {
      auto_sync = "true";
      enter_accept = "true";
      exit_mode = "return-query";
      filter_mode = "global";
      inline_height = "10";
      search_mode = "fuzzy";
      show_preview = "true";
      style = "compact";
      sync_address = "https://atuin.${osConfig.remoteDomain}";
      sync_frequency = "0";
    };
  };

  xdg.configFile = {
    "zsh/extra/atuin.zsh".text = ''
      if ! ${pkgs.atuin}/bin/atuin sync > /dev/null 2>&1; then
        echo ATUIN IS NOT SYNCING PROPERLY!
      fi
    '';
  };
}
