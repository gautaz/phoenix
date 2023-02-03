_: {
  programs.bash = {
    enable = true;
    enableVteIntegration = true;
    bashrcExtra = ''
      ns() {
        local cwd='~'
        [ "$PWD" != "$HOME" ] && cwd="''${PWD/#$HOME\//\~\/}"
        local sessionname="$(tac -s / <<< "$cwd" | tr -s '/\n' '@')"
        tmux new-session -Ad -s "$sessionname"
        echo "$sessionname"
      }

      na() {
        local sessionname="$(ns)"
        tmux new-session -A -s "$sessionname"
      }
    '';
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
