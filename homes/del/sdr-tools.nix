{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      libbladeRF # manage the Nuand bladeRF card
      (gnuradio.override {
        extraPackages = with gnuradioPackages; [
          bladeRF
          osmosdr
        ];
      })
    ];
  };
}
