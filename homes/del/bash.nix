_: {
  programs.bash = {
    enable = true;
    enableVteIntegration = true;
    historyControl = ["ignoredups"];
    historyIgnore = ["bg" "cd" "exit" "fg" "history" "ls"];
    sessionVariables = {
      HISTTIMEFORMAT = "%F %T ";
    };
    shellOptions = [
      "checkjobs"
      "checkwinsize"
      "cmdhist"
      "extglob"
      "globstar"
      "histappend"
    ];
  };
}
