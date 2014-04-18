@echo off
setlocal 

set /P BUILDNAME=Please enter a Version Number:

cls

ECHO BUILDING INSTALLER

"C:\Program Files (x86)\InstallShield\2013\System\iscmdbld.exe" ^
	-p "C:\CBS Software\NorthStar.SecureBrowser\Installer\SecureBrowser.ism" ^
	-r "SecureBrowser" ^
	-c COMP ^
	-y "%BUILDNAME%" ^
	-a "SecureBrowser"

	
xcopy "C:\CBS Software\NorthStar.SecureBrowser\Installer\SecureBrowser\SecureBrowser\DiskImages\DISK1\*" /h /e /y
pause