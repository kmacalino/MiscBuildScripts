
@echo off
setlocal 

set /P BUILDNAME=Please enter a build name:

cls


ECHO BUILDING INSTALLER

"C:\Program Files (x86)\InstallShield\2013\System\iscmdbld.exe" ^
	-p "C:\CBS Software\NorthStar.Desktop\Installer\DesktopInstaller.ism" ^
	-r "NorthStarDesktop" ^
	-c COMP ^
	-y "%BUILDNAME%" ^
	-a "NorthStarDesktop" 


xcopy "C:\CBS Software\NorthStar.Desktop\Installer\DesktopInstaller\NorthStarDesktop\NorthStarDesktop\DiskImages\DISK1\*" "c:\cbs software\BuildInstalls\" /h /e /y

pause