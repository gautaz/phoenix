_: {
  virtualisation.libvirtd = {
    enable = true;
    qemu.swtpm.enable = true;
  };

  programs.virt-manager.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  users.users.del.extraGroups = ["libvirtd"];
}
