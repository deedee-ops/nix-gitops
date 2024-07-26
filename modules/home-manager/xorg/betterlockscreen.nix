{ ... }:
{
  services.betterlockscreen = {
    enable = true;
    inactiveInterval = 3;
    arguments = [ "dimpixel" "--off" "30" ];
  };
}
