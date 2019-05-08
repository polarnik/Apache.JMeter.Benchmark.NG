@title %~nx0
@setlocal
@cd /d %~dp0
@ECHO OFF
@ECHO Starting PHP FastCGI...
@set PATH=%~dp0php;%PATH%
%~dp0php\php-cgi.exe -b 127.0.0.1:9123 -c php.20m.ini