{pkgs, ...}: {
  users.users.del = {
    extraGroups = ["networkmanager" "wheel"];
    initialPassword = "password";
    isNormalUser = true;
    packages = with pkgs; [home-manager];
  };
}
