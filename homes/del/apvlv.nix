{pkgs, ...}: {
  home.file.".apvlvrc".text = ''
    set autoscrolldoc=no
    set zoom=fitwidth
  '';

  home.packages = with pkgs; [
    apvlv # PDF/EPUB viewer with a vim like behaviour
  ];
}
