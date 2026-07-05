{
  config,
  pkgs,
  lib,
  pass-otp-src,
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

  pass-otp = pkgs.stdenv.mkDerivation {
    pname = "pass-otp";
    version = "develop";
    src = pass-otp-src;
    dontBuild = true;
    postPatch = ''
      sed -i 's|OATH=\$(command -v oathtool)|OATH=${lib.getExe pkgs.oath-toolkit}|' otp.bash
    '';
    installFlags = [
      "PREFIX=$(out)"
      "SYSTEM_EXTENSION_DIR=$(out)/lib/passage/extensions"
      "BASHCOMPDIR=$(out)/share/bash-completion/completions"
    ];
    meta = {
      description = "pass/passage extension for managing one-time-password (OTP) tokens";
      homepage = "https://github.com/tadfisher/pass-otp";
      license = lib.licenses.gpl3;
      maintainers = with lib.maintainers; [tadfisher];
      platforms = lib.platforms.unix;
    };
  };

  passage-overridden = pkgs.passage.overrideAttrs (old: {
    postInstall =
      (old.postInstall or "")
      + ''
        wrapProgram $out/bin/passage \
          --set PASSWORD_STORE_ENABLE_EXTENSIONS true \
          --set SYSTEM_EXTENSION_DIR "${pass-otp}/lib/passage/extensions" \
          --set PASSAGE_EXTENSIONS_DIR "${pass-otp}/lib/passage/extensions"
      '';
  });

  passage-with-otp = pkgs.symlinkJoin {
    name = "passage-with-otp";
    paths = [
      passage-overridden
      pass-otp
    ];
  };

  passageOtpImport = pkgs.writeShellApplication {
    name = "passage-otp-import";
    runtimeInputs = [
      passage-with-otp
    ];
    text = builtins.readFile ./passage-otp-import.bash;
  };
in {
  home = {
    file = {
      # passage is used instead of pass as the password manager
      ".local/bin/pass".source = "${passage-with-otp}/bin/passage";
      ".passage/identities".source = mkSymlink "/run/secrets/passage/identities";
      ".passage/extensions/otp.bash".source = "${pass-otp}/lib/passage/extensions/otp.bash";
    };
    packages = [
      passage-with-otp
      passageBootstrap
      passageOtpImport
    ];
  };

  programs.bash.initExtra = ''
    _completion_loader passage
    complete -o filenames -F _pass pass
  '';
}
