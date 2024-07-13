{ ... }: {
  services.comin = {
    enable = true;
    remotes = [{
      name = "origin";
      url = "https://github.com/deedee-ops/nix-gitops.git";
      branches = {
        main.name = "master";
        testing.name = "";
      };
      poller.period = 120; # 2 minutes
    }];
  };
}
