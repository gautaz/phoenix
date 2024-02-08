{pkgs, ...}: {
  imports = [../_/development.nix ../_/hw/dell-p117f.nix ../_/workstation.nix];
  networking.hostName = "dante";
  nixpkgs.overlays = [
    (final: prev: let
      config-toml = prev.pkgs.writeText "config.toml" ''
        disable-require = false
        #swarm-resource = "DOCKER_RESOURCE_GPU"

        [nvidia-container-cli]
        #root = "/run/nvidia/driver"
        #path = "/usr/bin/nvidia-container-cli"
        environment = []
        #debug = "/var/log/nvidia-container-runtime-hook.log"
        ldcache = "/tmp/ld.so.cache"
        load-kmods = true
        no-cgroups = true
        #user = "root:video"
        ldconfig = "@@glibcbin@/bin/ldconfig"
      '';
    in {
      nvidia-docker = prev.pkgs.mkNvidiaContainerPkg {
        name = "nvidia-docker";
        containerRuntimePath = "runc";
        configTemplate = config-toml;
        additionalPaths = [(prev.pkgs.callPackage <nixpkgs/pkgs/applications/virtualization/nvidia-docker> {})];
      };
    })
  ];
  virtualisation.multipass.enable = true;
  virtualisation.docker.enableNvidia = true;
  virtualisation.docker.rootless.daemon.settings = {
    default-runtime = "nvidia";
    runtimes.nvidia.path = "${pkgs.nvidia-docker}/bin/nvidia-container-runtime";
    exec-opts = ["native.cgroupdriver=cgroupfs"];
  };
}
