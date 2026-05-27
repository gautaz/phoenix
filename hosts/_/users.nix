{pkgs, ...}: {
  users.users.del = {
    extraGroups = ["video" "wheel" "render"];
    initialPassword = "password";
    isNormalUser = true;
    packages = [pkgs.home-manager];
  };
}
