{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    enableExtensionUpdateCheck = false;
    enableUpdateCheck = false;
    extensions = with pkgs.vscode-extensions; [
      ms-vsliveshare.vsliveshare
      vscodevim.vim
    ];
    mutableExtensionsDir = false;
  };
}
