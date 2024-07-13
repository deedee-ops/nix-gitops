{ pkgs, ... }: {
  home.packages = [
    pkgs.lazygit
  ];

  programs.git = {
    enable = true;
    aliases = {
      pf = "push --force-with-lease --force-if-includes";
      tags = "tag -l";
      branches = "branch -a";
      remotes = "remote -v";
      reb = "!r() { git rebase -i HEAD~$1; }; r";
      ci = "commit";
      cins = "commit --no-gpg-sign";
      co = "checkout";
      st = "status";
      br = "branch";
      sh = "show --stat --oneline";
      lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      ls = "log --show-signature";
      lf = "log --pretty=fuller";
      sign-rebase = "!GIT_SEQUENCE_EDITOR='sed -i -re s/^pick/e/' sh -c 'git rebase -i $1 && while test -f .git/rebase-merge/interactive; do git commit --amend -S --no-edit && git rebase --continue; done' -";
      wip = "!git add -A && git commit -m \"WIP\" -an --no-gpg-sign";
      amend = "commit --amend -an --no-edit";
    };

    delta = {
      enable = true;
      options = {
        side-by-side = true;
        line-numbers = true;
        features = "catppuccin-mocha";
        catppuccin-mocha = {
          blame-palette = "#1e1e2e #181825 #11111b #313244 #45475a";
          commit-decoration-style = "box ul";
          dark = true;
          file-decoration-style = "#cdd6f4";
          file-style = "#cdd6f4";
          hunk-header-decoration-style = "box ul";
          hunk-header-file-style = "bold";
          hunk-header-line-number-style = "bold #a6adc8";
          hunk-header-style = "file line-number syntax";
          line-numbers = true;
          line-numbers-left-style = "#6c7086";
          line-numbers-minus-style = "bold #f38ba8";
          line-numbers-plus-style = "bold #a6e3a1";
          line-numbers-right-style = "#6c7086";
          line-numbers-zero-style = "#6c7086";
          minus-emph-style = "bold syntax #53394c";
          minus-style = "syntax #35293b";
          plus-emph-style = "bold syntax #40504b";
          plus-style = "syntax #2c333a";
          syntax-theme = "catppuccin-mocha";
        };
      };
    };

    ignores = [
      "*.pyc"
      "*.sublime-workspace"
      "*.swo"
      "*.swp"
      "*~"
      ".DS_Store"
      ".Spotlight-V100"
      ".Trashes"
      "._*"
      ".idea"
      "Desktop.ini"
      "Thumbs.db"
      "gems.tags"
      "tags"
    ];

    extraConfig = {
      color = {
        ui = "auto";
        branch = {
          current = "yellow reverse";
          local = "yellow";
          remote = "green";
        };
        diff = {
          meta = "yellow bold";
          frag = "magenta bold";
          old = "red bold";
          new = "green bold";
        };
        status = {
          added = "yellow";
          changed = "green";
          untracked = "cyan";
        };
      };
      core = {
        editor = "vim";
      };
      init = {
        defaultBranch = "master";
      };
      pull = {
        rebase = true;
      };
      push = {
        default = "simple";
        followTags = true;
      };
      rerere = {
        enabled = true;
      };
      transfer = {
        fsckobjects = true;
      };
    };
  };
}
