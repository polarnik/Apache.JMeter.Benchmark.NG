@title %~nx0
@setlocal
@cd /d %~dp0
@rem 100 MBit/sec
@rem --progress=dot:default (  1 KByte per line)
@rem --progress=dot:binary  (384 KByte per line)
@rem --progress=dot:mega    (  3 MByte per line)

@rem @echo Start: %DATE%  %TIME% >> wget.start.stop.log
%~dp0wget/bin/wget.exe -S --limit-rate=20m --progress=dot:mega --output-document=- %1 1>NUL
@rem @echo Stop : %DATE%  %TIME% >> wget.start.stop.log