
@echo off
setlocal 

set /P BUILDNAME=Please enter a build name:

cls

echo Starting "Get Latest Installer from Installshield

echo Starting "GET"...

cd\"CBS Software\NorthStar.Desktop\Installer"

git clean -fdx

git checkout master -f

git fetch origin --prune

git reset --hard origin/master


ECHO BUILDING INSTALLER

"C:\Program Files (x86)\InstallShield\2013\System\iscmdbld.exe" ^
	-p "C:\CBS Software\NorthStar.Desktop\Installer\DesktopInstaller.ism" ^
	-r "NorthStarDesktop" ^
	-c COMP ^
	-y "%BUILDNAME%" ^
	-a "NorthStarDesktop" 


xcopy "C:\CBS Software\NorthStar.Desktop\Installer\DesktopInstaller\NorthStarDesktop\NorthStarDesktop\DiskImages\DISK1\*" "c:\cbs software\BuildInstalls\" /h /e /y

pause