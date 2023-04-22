{
  config,
  pkgs,
  ...
}: let
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
  passageBootstrap = pkgs.writeShellApplication {
    name = "passage-bootstrap";
    text = builtins.readFile ./passage-bootstrap.bash;
  };
in {
  home = {
    file = {
      # passage is used instead of pass as the password manager
      ".local/bin/pass".source = "${pkgs.passage}/bin/passage";
      ".passage/identities".source = mkSymlink "/run/secrets/passage/identities";
    };
    packages = with pkgs; [
      passage
      passageBootstrap # ensure passage has access to the password store
      tree # used by passage to list secrets
    ];
  };

  programs.bash.initExtra = ''
    _completion_loader passage
    complete -o filenames -F _pass pass
  '';
}
