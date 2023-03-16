{pkgs}:
with pkgs;
  writeShellApplication {
    name = "xlocker";
    runtimeInputs = [
      xsecurelock
    ];
    text = ''
      export XSECURELOCK_PASSWORD_PROMPT=time_hex
      "${xsecurelock}/bin/xsecurelock" "$@"
    '';
  }
