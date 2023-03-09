{pkgs, ...}:
with pkgs; let
  onInputplugEvent = writeShellApplication {
    name = "on-inputplug-event";
    text = ''
      shopt -sq nocasematch
      if [[ "$1" == "XIDeviceEnabled" ]] && [[ "$3" == "XISlaveKeyboard" ]] && [[ "$4" == *keyboard* ]]; then
        "${xorg.setxkbmap}/bin/setxkbmap" -option caps:super
      fi
    '';
  };
in {
  home.packages = [inputplug onInputplugEvent xorg.setxkbmap];
  systemd.user.services.inputplug = {
    Install.WantedBy = ["graphical-session.target"];
    Service = {
      ExecStart = "${inputplug}/bin/inputplug -d -0 -c ${onInputplugEvent}/bin/on-inputplug-event";
      Restart = "on-failure";
    };
    Unit = {
      After = ["graphical-session-pre.target"];
      Description = "XInput events monitoring service";
    };
  };
}
