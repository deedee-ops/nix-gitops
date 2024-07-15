{ ... }:
{
  services.xserver.screenSection = ''
    Option         "ForceFullCompositionPipeline" "on"
    Option         "AllowIndirectGLXProtocol" "off"
    Option         "TripleBuffer" "on"
    Option         "UseNvKmsCompositionPipeline" "false"
    Option         "metamodes" "DP-2: 3840x2160_120 +0+0 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}, DP-0: 3840x2160_120 +3840+0 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On, AllowGSYNCCompatible=On}"
  '';
}
