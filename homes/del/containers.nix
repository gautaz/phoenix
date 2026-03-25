{pkgs, ...}: {
  home.packages = with pkgs; [
    regctl
    skopeo
  ];
}
