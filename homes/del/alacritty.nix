{pkgs, ...}: {
  home.packages = with pkgs; [
    (nerdfonts.override {fonts = ["UbuntuMono"];})
  ];

  fonts.fontconfig.enable = true;

  programs.alacritty = {
    enable = true;
    settings = {
      dynamic_title = true;
      font = {
        normal = {
          family = "UbuntuMono Nerd Font";
          style = "Regular";
        };
        size = 10.0;
      };
    };
  };
}
