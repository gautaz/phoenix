_: {
  hardware.bluetooth = {
    enable = true;
    # https://wiki.nixos.org/wiki/Bluetooth#Enabling_A2DP_Sink
    settings.General.Enable = "Source,Sink,Media,Socket";
  };
}
