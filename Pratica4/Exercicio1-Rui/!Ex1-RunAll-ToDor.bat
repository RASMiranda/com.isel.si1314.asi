REM Ex1.a
@echo off

REM Set SQL Server Instances Names from configuration file
for /f "delims=" %%x in (..\00.config_inst.txt) do (set "%%x")

call Ex1.a.Run.CREATE-DB-TBL.bat

REM Ex1.b

REM call ...

REM call ...Ex1Cliente.a...exe

REM Ex1.c.0

REM call ...Ex1Cliente.c...exe

REM Ex1.c.1

REM kill ...Ex1...exe

REM call ...Ex1.c...exe

REM call ...Ex1Cliente.c...exe
