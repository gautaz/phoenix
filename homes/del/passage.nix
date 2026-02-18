{
  config,
  pkgs,
  ...
}: let
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
  passageBootstrap = pkgs.writeShellApplication {
    name = "passage-bootstrap";
    runtimeInputs = [
      pkgs.git
    ];
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
      passage # this is needed so the completion function (_pass) is available
      passageBootstrap # ensure passage has access to the password store
    ];
  };

  programs.bash.initExtra = ''
    _completion_loader passage
    complete -o filenames -F _pass pass
  '';
}
