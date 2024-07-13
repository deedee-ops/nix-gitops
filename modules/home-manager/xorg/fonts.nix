{ pkgs, ... }: {
  fonts.fontconfig.enable = true;
  home.packages = [
    (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    pkgs.corefonts
    pkgs.helvetica-neue-lt-std
    pkgs.noto-fonts
    pkgs.noto-fonts-emoji
  ];

  xdg.configFile."fontconfig/conf.d/99-default.conf".text = ''
    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
    <fontconfig>
      <alias>
        <family>serif</family>
        <prefer><family>Noto Serif</family></prefer>
      </alias>
      <alias>
        <family>sans-serif</family>
        <prefer><family>Noto Sans</family></prefer>
      </alias>
      <alias>
        <family>monospace</family>
        <prefer><family>JetBrainsMono Nerd Font Mono</family></prefer>
      </alias>
      <alias>
        <family>emoji</family>
        <prefer><family>Noto Color Emoji</family></prefer>
      </alias>
    </fontconfig>
  '';
}

