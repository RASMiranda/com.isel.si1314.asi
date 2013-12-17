@echo off

REM Set SQL Server Instances Names from configuration file
for /f "delims=" %%x in (..\00.config_inst.txt) do (set "%%x")

start profiler /S%PrincipalDB% /Dbd3_1 /TStandard /O./teste.trc

goto end

profiler /Slocalhost\one /Dbd3_1 /TStandard

profiler /Slocalhost\one /Dbd3_1 /TStandard /M

profiler /Slocalhost\one /Dbd3_1 /TStandard /M10

taskkill /im "profiler"
ERROR: The process "profiler" not found.

taskkill /im "profiler*"
SUCCESS: Sent termination signal to the process "PROFILER.EXE" with PID 1248.
SUCCESS: Sent termination signal to the process "PROFILER.EXE" with PID 3284.

profiler /Slocalhost\one /Dbd3_1 /TStandard /OC:\Users\ALUNO_SIAD\Desktop\teste.bin


taskkill /im "profiler.exe"
SUCCESS: Sent termination signal to the process "PROFILER.EXE" with PID 3788.

:end
