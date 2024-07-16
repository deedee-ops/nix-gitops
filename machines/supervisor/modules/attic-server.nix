{ config, ... }:
{
  sops = {
    secrets = {
      "attic/server/credentials" = { };
    };
  };

  services.atticd = {
    enable = true;

    credentialsFile = config.sops.secrets."attic/server/credentials".path;

    settings = {
      listen = "0.0.0.0:7777";
      allowed-hosts = [ "attic.${config.remoteDomain}" ];
      api-endpoint = "https://attic.${config.remoteDomain}/";
      soft-delete-caches = false;

      storage = {
        type = "s3";
        region = "us-east-1";
        bucket = "nix";
        endpoint = "https://s3.${config.remoteDomain}";
      };

      chunking = {
        nar-size-threshold = 64 * 1024; # 64 KiB
        min-size = 16 * 1024; # 16 KiB
        avg-size = 64 * 1024; # 64 KiB
        max-size = 256 * 1024; # 256 KiB
      };
    };
  };
}
