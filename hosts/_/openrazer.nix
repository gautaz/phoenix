{
  pkgs,
  config,
  ...
}: let
  nvidia_x11 = config.boot.kernelPackages.nvidia_x11;
in {
  boot = {
    blacklistedKernelModules = ["nouveau" "nvidiafb"];
    extraModulePackages = [nvidia_x11.open];
    kernelModules = ["nvidia" "nvidia_modeset" "nvidia_drm" "nvidia-uvm"];
    kernelParams = [
      "nvidia-drm.modeset=1"
      "nvidia-drm.fbdev=1"
      "nvidia.NVreg_OpenRmEnableUnsupportedGpus=1"
    ];
    extraModprobeConfig = ''
      softdep nvidia post: nvidia-uvm
    '';
  };

  hardware = {
    firmware = [nvidia_x11.firmware];
    graphics = {
      extraPackages = [nvidia_x11.out];
      extraPackages32 = [nvidia_x11.lib32];
    };
    nvidia-container-toolkit = {
      enable = true;
      suppressNvidiaDriverAssertion = true;
    };
    openrazer.enable = true;
  };

  services = {
    hardware.bolt.enable = true;
    udev.extraRules = ''
      KERNEL=="nvidia", RUN+="${pkgs.runtimeShell} -c 'mknod -m 666 /dev/nvidiactl c 195 255'"
      KERNEL=="nvidia", RUN+="${pkgs.runtimeShell} -c 'for i in $$(cat /proc/driver/nvidia/gpus/*/information | grep Minor | cut -d \  -f 4); do mknod -m 666 /dev/nvidia$${i} c 195 $${i}; done'"
      KERNEL=="nvidia_modeset", RUN+="${pkgs.runtimeShell} -c 'mknod -m 666 /dev/nvidia-modeset c 195 254'"
      KERNEL=="nvidia_uvm", RUN+="${pkgs.runtimeShell} -c 'mknod -m 666 /dev/nvidia-uvm c $$(grep nvidia-uvm /proc/devices | cut -d \  -f 1) 0'"
      KERNEL=="nvidia_uvm", RUN+="${pkgs.runtimeShell} -c 'mknod -m 666 /dev/nvidia-uvm-tools c $$(grep nvidia-uvm /proc/devices | cut -d \  -f 1) 1'"
    '';
  };

  virtualisation.containers = {
    enable = true;
    containersConf.settings = {
      engine.cdi_spec_dirs = ["/run/cdi/" "/etc/cdi/"];
    };
  };

  users.users.del.extraGroups = ["openrazer"];

  environment.systemPackages =
    [
      nvidia_x11.bin
    ]
    ++ (with pkgs; [
      openrazer-daemon
      polychromatic
    ]);
}
