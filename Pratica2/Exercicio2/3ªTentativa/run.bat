
set BackupDirA="C:\Program Files\Microsoft SQL Server\MSSQL11.SQL2012DEINST1\MSSQL\Backup\"
set SecondaryDataDir_B="C:\Program Files\Microsoft SQL Server\MSSQL11.SQL2012DEINST2\MSSQL\DATA\"
set SecondaryDataDir_C="C:\Program Files\Microsoft SQL Server\MSSQL11.SQL2012DEINST2\MSSQL\DATA\"

icacls %BackupDirA% /grant:r everyone:f

icacls %SecondaryDataDir_B% /grant:r everyone:f

icacls %SecondaryDataDir_C% /grant:r everyone:f

net share sharename="c:\path\to\share" /UNLIMITED

