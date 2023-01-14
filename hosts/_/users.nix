{pkgs, ...}: {
  users.users.del = {
    extraGroups = ["keys" "networkmanager" "wheel"];
    initialPassword = "password";
    isNormalUser = true;
    packages = with pkgs; [home-manager];
  };
}
