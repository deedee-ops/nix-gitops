{ pkgs, ... }: {
  home.packages = [
    pkgs.nodejs_20 # copilot
    pkgs.luajitPackages.luarocks # mason
    pkgs.unzip # mason
    pkgs.cargo # mason
    pkgs.python3 # mason
    pkgs.wget # mason
    pkgs.sshfs # remote-sshfs
    pkgs.sops # vim-sops
    pkgs.fd # telescope-filebrowser
    pkgs.gnumake # telescope-fzf
    pkgs.fd # telescope
    pkgs.ripgrep # telescope
    pkgs.gcc # tree-sitter
    pkgs.tree-sitter # tree-sitter
  ];

  programs.neovim = {
    enable = true;

    coc.enable = false;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  xdg.configFile.nvim = {
    source = ./nvim;
    recursive = true;
  };
}
