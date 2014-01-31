@echo off

rem dir c:\gacutil.exe /s /a /b

set gacutil_exe="c:\Program Files\Microsoft SDKs\Windows\v8.0A\bin\NETFX 4.0 Tools\gacutil.exe"

%gacutil_exe% -i .\EntityFramework.6.0.0\lib\net40\EntityFramework.dll
%gacutil_exe% -i .\EntityFramework.6.0.0\lib\net40\EntityFramework.SqlServer.dll
%gacutil_exe% -i .\EntityFramework.6.0.0\lib\net45\EntityFramework.dll
%gacutil_exe% -i .\EntityFramework.6.0.0\lib\net45\EntityFramework.SqlServer.dll

pause