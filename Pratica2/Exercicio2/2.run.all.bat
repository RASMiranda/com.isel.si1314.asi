@echo off

REM Pratica 2 Exercicio 2----------------------------------------------------------------------------------------

call 2.0-run.setup.bat

call 2.4-run.setup.LogShiping.bat

cls
Echo Realizar 2 testes de Log Shipping com 3 instancias (A, B e C)...
call 2.a-run.test.bat
call 2.a-run.test.bat
pause

cls
call 2.b.0-setup.LogShiping.CenarioDesastre.bat

cls
Echo Realizar 2 testes de Log Shipping com 2 instancias (B e C)...
call 2.b.5-run.test.bat
call 2.b.5-run.test.bat

rd /s C:\ASITemp
