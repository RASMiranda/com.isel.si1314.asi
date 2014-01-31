@echo off

REM Set SQL Server Instances Names from configuration file
for /f "delims=" %%x in (..\00.config_inst.txt) do (set "%%x")

goto debug

echo\
echo Running "1.a. inserir dados na instancia.sql" @PrincipalDB
sqlcmd -H localhost -S "%PrincipalDB%" -i "1.a. inserir dados na instancia.sql"
if not %errorlevel% == 0 goto end
pause

echo\
echo 1.a. Parar a instancia A.
sqlcmd -H localhost -S "%PrincipalDB%" -Q "shutdown"
if not %errorlevel% == 6006 goto end
REM 6006 == server shutdown (connection lost?)
pause


echo\
echo Running "1.a. inserir dados na instancia.sql" @MirrorDB
sqlcmd -H localhost -S "%MirrorDB%" -i "1.a. inserir dados na instancia.sql"
if not %errorlevel% == 0 goto end
pause

echo\
echo\
echo Inicie a instancia Principal...
pause

echo\
echo Constata-se que a primeira instancia assume o papel de Mirror.
"1.b. a primeira instancia assume o papel de Mirror.png"
pause

echo\
echo Realize failover manual e espere que as instancias troquem de papeis...
pause

echo\
echo Execute em Principal 'select * from t'
sqlcmd -H localhost -S "%PrincipalDB%" -Q "select * from BDMirror..t"
if not %errorlevel% == 0 goto end
pause



echo\
echo 1.c. Pare a instancia A e espere que B assuma o papel de principal
sqlcmd -H localhost -S "%PrincipalDB%" -Q "shutdown"
if not %errorlevel% == 6006 goto end
REM 6006 == server shutdown (connection lost?)
pause

echo\
echo 1.c. Execute em  B um insert e verifique que a operacao sucede.
sqlcmd -H localhost -S "%MirrorDB%" -Q "insert into BDMIRROR.dbo.t values (@@servername, getdate())"
if not %errorlevel% == 0 goto end
pause

echo\
echo 1.c. Pare B.
sqlcmd -H localhost -S "%MirrorDB%" -Q "shutdown"
if not %errorlevel% == 6006 goto end
REM 6006 == server shutdown (connection lost?)
pause

echo\
echo 1.c. Active A e verifique se ela toma o papel de principal. Justifique o que observa.
pause

echo\
echo 1.c. Constata-se que A nao fica online, devido ao facto de ter sido activada depois de se ter desactivado B. Como em B entretanto ja se realizou uma escrita a testemunha nao da 'quorum' a instancia A.
"1.c. a instancia A nao pode proceguir porque nao sincrocronizou com B.png"
pause


echo\
echo 1.d. Pare  A.
sqlcmd -H localhost -S "%PrincipalDB%" -Q "shutdown"
if not %errorlevel% == 6006 goto end
REM 6006 == server shutdown (connection lost?)
pause

echo\
echo 1.d. arranque B e espere que B assuma o papel de principal.
pause


echo\
echo 1.d. Arranque A e espere que A e B se sincronizem.
pause
:debug
echo\
echo 1.d. Pare C.
sqlcmd -H localhost -S "%WitnessDB%" -Q "shutdown"
if not %errorlevel% == 6006 goto end
REM 6006 == server shutdown (connection lost?)
pause

echo\
echo 1.d. Pare B.
sqlcmd -H localhost -S "%MirrorDB%" -Q "shutdown"
if not %errorlevel% == 6006 goto end
REM 6006 == server shutdown (connection lost?)
pause

echo\
echo 1.d. Verifique que nao ha failover automatico. Justifique.
echo      Como a Witness esta parada, o Mirror nao tem forma de saber se ausencia de resposta do Principal e sinal de problemas com o Pricipal ou se e sinal de problemas com ele proprio - o Mirror. Assim sendo, nao assume controlo das operacoes da BD.
"1.d. ausencia de failover automatico.png"
pause

echo\
echo 1.e. Inicie *todas* as instancias. Vai-se iniciar uma aplicacao de consola. Realize failover durante a execucao da aplicacao.
TesteMirror\bin\Debug\TesteMirror.exe
pause


:end
pause
