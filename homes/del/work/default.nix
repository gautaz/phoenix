{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      aws-sam-cli
      awscli2
      docker-compose
      firefox # needed by zap for manual explore
      jira-cli-go
      mark
      zap
    ];

    sessionVariables = {
      BROWSER = "qutebrowser";
    };
  };

  xdg.mimeApps = {
    defaultApplications = {
      "model/3mf" = "f3d-plugin-assimp.desktop";
      "text/html" = "org.qutebrowser.qutebrowser.desktop";
      "x-scheme-handler/http" = "org.qutebrowser.qutebrowser.desktop";
      "x-scheme-handler/https" = "org.qutebrowser.qutebrowser.desktop";
      "x-scheme-handler/about" = "org.qutebrowser.qutebrowser.desktop";
      "x-scheme-handler/unknown" = "org.qutebrowser.qutebrowser.desktop";
    };
    enable = true;
  };
}
