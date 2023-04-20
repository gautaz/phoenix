_: {
  programs.bash = {
    enable = true;
    enableVteIntegration = true;
    historyControl = ["ignoredups"];
    historyIgnore = ["bg" "cd" "exit" "fg" "history" "ls"];
    initExtra = ''
      _completion_loader passage
      complete -o filenames -F _pass pass
    '';
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
