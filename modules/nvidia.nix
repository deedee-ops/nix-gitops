{ config, pkgs, ... }:
{
  hardware.opengl.enable = true;
  services.xserver = {
    videoDrivers = [ "nvidia" ];
    screenSection = ''
      Option         "ForceFullCompositionPipeline" "on"
      Option         "AllowIndirectGLXProtocol" "off"
      Option         "TripleBuffer" "on"
      Option         "metamodes" "DP-2: 3840x2160_120 +0+0 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}, DP-0: 3840x2160_120 +3840+0 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On, AllowGSYNCCompatible=On}"
    '';
  };

  hardware.nvidia = {
    modesetting.enable = true;
    open = false; # 3070Ti is compatible, but driver is not stable enough
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  environment.systemPackages = [
    pkgs.nvtopPackages.full
  ];

  allowUnfree = [
    "cuda-merged"
    "cuda_cccl"
    "cuda_cudart"
    "cuda_cuobjdump"
    "cuda_cupti"
    "cuda_cuxxfilt"
    "cuda_gdb"
    "cuda_nvcc"
    "cuda_nvdisasm"
    "cuda_nvml_dev"
    "cuda_nvprune"
    "cuda_nvrtc"
    "cuda_nvtx"
    "cuda_profiler_api"
    "cuda_sanitizer_api"
    "libcublas"
    "libcufft"
    "libcurand"
    "libcusolver"
    "libcusparse"
    "libnpp"
    "libnvjitlink"

    "nvidia-settings"
    "nvidia-x11"
  ];
}
