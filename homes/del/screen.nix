_: {
  home.file.".screenrc".text = ''
    hardstatus alwayslastline
    hardstatus string '%{= kG}[%{G}%H%? %1`%?%{g}][%= %{= kw}%-w%{+b yk} %n*%t%?(%u)%? %{-}%+w %=%{g}][%{B}%Y-%m-%d %{W}%c%{g}]'

    defscrollback 10000
    startup_message off
    term screen-256color
    maptimeout 5
  '';
}
