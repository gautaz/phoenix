_: {
  programs.bash = {
    enable = true;
    enableVteIntegration = true;
    bashrcExtra = ''
      ns() {
        local cwd='~'
        [ "$PWD" != "$HOME" ] && cwd="''${PWD/#$HOME\//\~\/}"
        local sessionname="$(tac -s / <<< "$cwd" | tr -s '/\n' '^' | tr '.' '_')"

        if [[ -z "$TMUX" ]]; then
          tmux new-session -A -s "$sessionname"
        else
          if ! tmux has-session -t "$sessionname"; then
            tmux new-session -d -s "$sessionname"
            echo "new session created: $sessionname"
          fi
          tmux switch-client -t "$sessionname"
        fi
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
