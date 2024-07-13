{ pkgs, config, ... }: {
  home.packages = [
    pkgs.ffmpegthumbnailer # preview videos first frame
    pkgs.poppler_utils # preview PDFs
  ];

  programs.ranger = {
    enable = true;

    extraConfig = ''
      set preview_images true
      set preview_script ${config.xdg.configHome}/ranger/scope.sh
      set confirm_on_delete multiple
      map dd delete
    '';
  };

  xdg.configFile = {
    "ranger/scope.sh" = {
      executable = true;
      text = ''
        #!${pkgs.coreutils-full}/bin/env ${pkgs.bash}/bin/bash
      '' + (builtins.readFile ./ranger/scope.sh);
    };
  };
}

