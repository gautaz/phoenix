{pkgs, ...}: {
  home.packages = with pkgs; [
    awscli2
    docker-compose
  ];
}
