_: {
  programs.bash = {
    enable = true;
    enableVteIntegration = true;
    bashrcExtra = ''
      ns() {
      local cwd='~'
      [ "$PWD" != "$HOME" ] && cwd="''${PWD/#$HOME\//\~\/}"
      local sessionname="$(tac -s / <<< "$cwd" | tr -s '/\n' '@')"
      screen -d -m -S "$sessionname"
      echo "$sessionname"
      }

      na() {
      local sessionname="$(ns)"
      screen -r "$sessionname"
      }

      hs() {
      screen -r -d '~@' || (cd && na)
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
