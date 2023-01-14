_: {
  programs.ssh = {
    enable = true;
    includes = ["/run/secrets/ssh/config/*"];
  };
}
