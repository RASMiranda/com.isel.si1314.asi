-- ****** Begin: Script to be run at Primary: [SERVER_INST_A] ******

--TODO COMMENT WHEN RUNNING FROM BATCH, AND PASS VARIABLES FROM COMMAND
--:setvar InstanciaA "MIRANDA-LAPTOP\SQL2012DEINST1"
--:setvar backupFile C:\ASITemp\BDLSbackup.bin

--:connect $(InstanciaA)

USE [master]
GO

print 'Backup to file ''$(backupFile)'''

BACKUP DATABASE [BDLS]
TO DISK = '$(backupFile)'	
WITH INIT --overwrite existing
GO



-- ****** End: Script to be run at Primary: [SERVER_INST_A]  ******