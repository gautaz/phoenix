{pkgs, ...}: {
  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };
  users.users.del.extraGroups = ["wireshark"];
}
