{pkgs}:
with pkgs.lib; (trivial.pipe (builtins.readDir ./.) [
  (attrsets.filterAttrs (name: value: name != "default.nix" && value == "regular"))
  (attrsets.mapAttrs' (name: value:
    attrsets.nameValuePair (strings.removeSuffix ".nix" name) (import (./. + "/${name}") {
      inherit pkgs;
      plugins = pkgs.vimPlugins;
    })))
])
