@title %~nx0
@setlocal
@cd /d %~dp0
@rem 100 MBit/sec
@rem --progress=dot:default (  1 KByte per line)
@rem --progress=dot:binary  (384 KByte per line)
@rem --progress=dot:mega    (  3 MByte per line)

@rem @echo Start: %DATE%  %TIME% >> wget.start.stop.log
D:\tools\cygwin\bin\wget.exe -S --limit-rate=20m --progress=dot:mega ^
	--header "User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:44.0) Gecko/20100101 Firefox/44.0" ^
	--header "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" ^
	--header "Accept-Language: ru-RU,ru;q=0.8,en-US;q=0.5,en;q=0.3" ^
	--header "Accept-Encoding: gzip, deflate" ^
	--output-document=- %1 | %~dp0head\bin\head.exe -c 1234 | %~dp0head\bin\gzip.exe -d -c -
@rem @echo Stop : %DATE%  %TIME% >> wget.start.stop.log