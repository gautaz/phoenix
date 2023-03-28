{pkgs, ...}: {
  users.users.del = {
    extraGroups = ["video" "wheel"];
    initialPassword = "password";
    isNormalUser = true;
    packages = with pkgs; [home-manager];
  };
}
