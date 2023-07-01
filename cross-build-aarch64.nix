_: {
  nixpkgs = {
    buildPlatform.system = "x86_64-linux";
    config.allowUnsupportedSystem = true;
    hostPlatform.system = "aarch64-linux";
  };
}
