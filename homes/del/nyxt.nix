{
  config,
  pkgs,
  ...
}: let
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
in {
  home = {
    file = {
      ".config/nyxt/config.lisp".source = mkSymlink ./nyxt.lisp;
    };
    packages = with pkgs; [
      nyxt
    ];
  };
}
