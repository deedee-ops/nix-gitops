{ pkgs, config, lib, ... }: {
  home.packages = [ pkgs.aichat ];
  programs.zsh.shellAliases.ai = "aichat";

  xdg.configFile = {
    "aichat/config.yaml".text = ''
      ---
      model: openai
      clients:
        - type: openai
    '';
    "zsh/extra/ai.zsh".text = ''
      export OPENAI_API_KEY="$(cat ${config.sops.secrets."openai/apikey".path} | tr -d '\n')"
      _aichat_zsh() {
          if [[ -n "$BUFFER" ]]; then
              local _old=$BUFFER
              BUFFER+="⌛"
              zle -I && zle redisplay
              BUFFER=$(aichat -e "$_old")
              zle end-of-line
          fi
      }
      zle -N _aichat_zsh
      bindkey '^E' _aichat_zsh
    '';
  };
}

