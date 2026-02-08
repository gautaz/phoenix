{pkgs, ...}: {
  users.users.del = {
    extraGroups = ["video" "wheel"];
    initialPassword = "password";
    isNormalUser = true;
    packages = [pkgs.home-manager];
  };
}
