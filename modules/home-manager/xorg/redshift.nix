{ ... }: {
  services.redshift = {
    enable = true;

    latitude = 50.061389;
    longitude = 19.938333;
    provider = "manual";
    tray = true;
  };
}
