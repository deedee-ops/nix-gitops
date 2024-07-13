{ pkgs, ... }: {
  programs.ssh = {
    enable = true;
    package = pkgs.openssh;

    addKeysToAgent = "8h";
  };

  services.ssh-agent = {
    enable = true;
  };
}
