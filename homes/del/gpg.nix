_: {
  programs.gpg = {
    enable = true;
    mutableKeys = false;
    mutableTrust = false;
    publicKeys = [
      {
        source = ./gautaz.pub;
        trust = "ultimate";
      }
    ];
  };
}
