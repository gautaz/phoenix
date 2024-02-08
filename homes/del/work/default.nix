{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      aws-sam-cli
      awscli2
    ];
  };

  programs.chromium.enable = true;
}
