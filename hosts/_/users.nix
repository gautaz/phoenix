{pkgs, ...}: {
  users.users.del = {
    extraGroups = ["keys" "networkmanager" "video" "wheel"];
    initialPassword = "password";
    isNormalUser = true;
    packages = with pkgs; [home-manager];
  };
}
