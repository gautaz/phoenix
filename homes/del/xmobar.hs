Config
  { overrideRedirect = False
  , font = "xft:iosevka-9"
  , bgColor = "#000000"
  , fgColor = "#f8f8f2"
  , position = TopW L 100
  , commands =
      [ Run Cpu ["-L", "3", "-H", "50", "--high", "red", "--normal", "green"] 10
      , Run Memory ["--template", "Mem: <usedratio>%"] 10
      , Run Swap [] 10
      , Run Date "%a %Y-%m-%d <fc=#8be9fd>%H:%M</fc>" "date" 10
      , Run XMonadLog
      ]
  , sepChar = "%"
  , alignSep = "}{"
  , template = "%XMonadLog% }{ %cpu% | %memory% * %swap% | %date% "
  }
