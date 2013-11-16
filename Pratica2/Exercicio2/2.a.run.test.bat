@echo off

echo.
echo seting variables...
for /f "delims=" %%x in (2.0.config_vars.txt) do (set "%%x")
REM pause

echo.
echo Running "2.a-INSERT-A-SELECT-C.sql"...
sqlcmd -H localhost -S "%primary_server%" -i "2.a-INSERT-A-SELECT-C.sql" -v primary_server="%primary_server%" -v secondary_server_C="%secondary_server_C%"
REM pause

echo.
echo.
echo Test OK on primary_server: "%primary_server%", and secondary_server_C: "%secondary_server_C%"
pause