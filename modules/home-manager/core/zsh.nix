{ pkgs, config, lib, ... }:

let
  myFunctions = pkgs.stdenvNoCC.mkDerivation rec {
    name = "zsh-functions-${version}";
    version = "0.0.1";
    src = ./zsh;
    phases = [ "installPhase" ];
    installPhase = ''
      mkdir $out

      cp $src/* $out/
    '';
  };
in
{
  home = {
    activation = {
      zsh = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        mkdir -p ${config.xdg.stateHome}/zsh || true
      '';
    };
    packages = [
      pkgs.pdfgrep
      pkgs.xclip
    ];
  };

  programs.zsh = {
    enable = true;

    dotDir = ".config/zsh";
    enableCompletion = true;

    autosuggestion = {
      enable = true;
    };

    completionInit = "autoload -U compinit && compinit -u";

    initExtraBeforeCompInit = ''
      autoload -U colors && colors
    '';

    initExtra = ''
      export GPG_TTY="$(tty)"
      export PATH=./bin:~/.local/bin:~/.local/share/scripts/bin:${config.xdg.configHome}/krew/bin:~/.cargo/bin:$PATH
      export HISTFILE="${config.xdg.stateHome}/zsh/history"
      if [ -d "${config.xdg.configHome}/zsh/extra" ]; then
        for plugin in ${config.xdg.configHome}/zsh/extra/*.zsh; do
          source "$plugin"
        done
      fi
    '';

    shellAliases = {
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";
      "......" = "cd ../../../../..";
      "......." = "cd ../../../../../..";
      "........" = "cd ../../../../../../..";

      cat = "bat";
      gpgkill = "gpgconf --kill gpg-agent";
      grep = "grep --color";
      k = "kubectl";
      r = "ranger";
      ls = "ls --color";
      qr = "qrencode -t ANSI256";
      sops = "EDITOR='nvim -c \"set filetype=secret\"' sops";

      # sudo - pass env
      sudo = "sudo -E";
      # check sync process (usually when unmounting USBs)
      syncstatus = "watch -d grep -e Dirty: -e Writeback: /proc/meminfo";
      pbcopy = "xclip -selection clipboard";
      pbpaste = "xclip -selection clipboard -o";
    };

    plugins = [
      {
        name = "functions";
        src = myFunctions;
      }
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.8.0";
          sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
        };
      }
    ];
  };
}
