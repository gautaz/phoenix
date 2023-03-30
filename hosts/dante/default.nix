{pkgs, ...}: {
  imports = [../_/development.nix ../_/hw/dell-p117f.nix ../_/workstation.nix];
  networking.hostName = "dante";
  virtualisation.multipass.enable = true;
  virtualisation.docker.enableNvidia = true;
  virtualisation.docker.rootless.daemon.settings = {
    default-runtime = "nvidia";
    runtimes.nvidia.path = "${pkgs.nvidia-docker}/bin/nvidia-container-runtime";
  };
}
