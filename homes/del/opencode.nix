{
  pkgs,
  inputs,
  ...
}: let
  ovim = inputs.opencode-vim;
  pkgs' = import inputs.nixpkgs {
    inherit (pkgs.stdenv.hostPlatform) system;
    overlays = [ovim.overlays.default];
  };
in {
  programs.opencode = {
    enable = true;
    package = pkgs'.opencode.overrideAttrs (old: {
      # Relax bun version check to a warning instead of an error
      postPatch =
        (old.postPatch or "")
        + ''
          substituteInPlace packages/script/src/index.ts \
            --replace-fail 'throw new Error(`This script requires bun@''${expectedBunVersionRange}' \
                           'console.warn(`Warning: This script requires bun@''${expectedBunVersionRange}'
        '';
    });
    settings = {
      autoupdate = false;
      permission.external_directory."/nix/store/**" = "allow";
    };
  };
}
