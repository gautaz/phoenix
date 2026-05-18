{lib, ...}: let
  spacedINI = lib.generators.toINI {
    mkKeyValue = lib.generators.mkKeyValueDefault {} " = ";
  };
in {
  programs.imv.enable = true;

  xdg.configFile."imv/config" = {
    text = spacedINI {
      binds = {
        "<Ctrl+p>" = "pan 500 0";
        "<Ctrl+n>" = "pan -500 0";
        "<Ctrl+u>" = "pan 0 500";
        "<Ctrl+d>" = "pan 0 -500";

        "<Shift+less>" = "rotate by -90";
        "<Shift+greater>" = "rotate by 90";
        "<Shift+underscore>" = "flip vertical";
        "<Shift+bar>" = "flip horizontal";

        "<equal>" = "scaling full";
        "0" = "zoom actual";
      };
    };
  };

  xdg.mimeApps = {
    defaultApplications = {
      "image/jpeg" = "imv.desktop";
      "image/png" = "imv.desktop";
      "image/gif" = "imv.desktop";
      "image/bmp" = "imv.desktop";
      "image/x-bmp" = "imv.desktop";
      "image/x-pcx" = "imv.desktop";
      "image/x-portable-bitmap" = "imv.desktop";
      "image/x-portable-graymap" = "imv.desktop";
      "image/x-portable-pixmap" = "imv.desktop";
      "image/tiff" = "imv.desktop";
      "image/x-tga" = "imv.desktop";
      "image/x-xwindowdump" = "imv.desktop";
      "image/x-icon" = "imv.desktop";
      "image/svg+xml" = "imv.desktop";
      "image/webp" = "imv.desktop";
      "image/heif" = "imv.desktop";
      "image/avif" = "imv.desktop";
    };
    enable = true;
  };
}
