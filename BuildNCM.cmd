@echo off
setlocal 

echo Starting "Pull"...

CD\"cbs software\NorthStar.NCM\"

git clean -fdx

git checkout master -f

git fetch origin --prune

git reset --hard origin/master

echo GUID1=%GUID1%
FOR /F "delims=" %%A in ('powershell -command "$([guid]::NewGuid().ToString())"') DO set GUID1={%%A}
echo GUID1=%GUID1%

cls

echo GUID2=%GUID2%
FOR /F "delims=" %%A in ('powershell -command "$([guid]::NewGuid().ToString())"') DO set GUID2={%%A}
echo GUID2=%GUID2%

set /P BUILDNAME=Please enter a build version number:
REM set /P MajorUpgrade=Major Upgrade Y/N:
set MajorUpgrade=Y

set mycurrentfolder=%~dp0
set rootPath=%mycurrentfolder%..\NorthStar.NCM

ECHO BUILDING THE INSTALLER

REM SORRY FOR THE SPAGHETTI CODE!!!  ARGGG!!!..... HAAAAAAAAAAAAAAAAAAAAAAAAAAAANNNNNNNNNNNNNDDDDDDDDDDDDDDSSSSSSSS!!!!!!!!!!!!!!!!!
if /I %MajorUpgrade% EQU Y (
ECHO THIS IS DOING THE UPGRADE

call :BUILDPRODUCT
call :2
call :END
goto :EOF

) else (
	echo NOT AN UPGRADE

	call :BUILDPRODUCT
	call :1
	call :END
	goto :EOF
)

cls

:BUILDPRODUCT
echo COPYING IMAGES TO FOLDER
xcopy "%rootPath%\ECM\Testing\Common2\Images\*" "%rootPath%\Testing\common2\images\" /h /e /y
xcopy "%rootPath%\ECM\Installer\CBS_Images\NCM_Theme\NSCMicon.ico" "%rootPath%\Desktop\Code\NorthStar.Desktop.Application\NS.ico" /h /e /y

echo EDIT VERSION NUMBER IN CONFIG
xmlstarlet.exe edit --inplace --update /release/version --value "%BUILDNAME%" "%rootPath%\Testing\NorthStar.Desktop.ReleaseLine.xml"
xmlstarlet.exe edit --inplace --update /release/version --value "%BUILDNAME%" "%rootPath%\ECM\Testing\NorthStar.Desktop.ReleaseLine.xml"

echo Making sure Recipe.dll is not around
del "%rootPath%\ECM\Testing\Modules\NorthStar.Recipe.dll"

ECHO BUILDING THE SOFTWARE

"C:\Windows\Microsoft.NET\Framework\v4.0.30319\msbuild.exe" ^
	"%rootPath%\ECM\ECM.sln" ^
	/t:rebuild
	
ECHO BUILDING THE SOFTWARE

"C:\Windows\Microsoft.NET\Framework\v4.0.30319\msbuild.exe" ^
	"%rootPath%\DeploymentService\NCM.DeploymentService.sln" ^
	/t:rebuild
	
goto :EOF

:1

ECHO BUILDING INSTALLER WITH OUT PRODUCT CODE
"C:\Program Files (x86)\InstallShield\2013\System\iscmdbld.exe" ^
	-p "%rootPath%\NCMServer.ism" ^
	-r "NCMServer" ^
	-c COMP ^
	-y "%BUILDNAME%" ^
	-a "NCMServer"

"C:\Program Files (x86)\InstallShield\2013\System\iscmdbld.exe" ^
	-p "%rootPath%\NCMClient.ism" ^
	-r "NCMClient" ^
	-c COMP ^
	-y "%BUILDNAME%" ^
	-a "NCMClient"

goto :EOF

:2

ECHO BUILDING INSTALLER WITH PRODUCT CODE
"C:\Program Files (x86)\InstallShield\2013\System\iscmdbld.exe" ^
	-z ProductCode=%GUID1% ^
	-p "%rootPath%\NCMServer.ism" ^
	-r "NCMServer" ^
	-c COMP ^
	-y "%BUILDNAME%" ^
	-a "NCMServer" 
	
"C:\Program Files (x86)\InstallShield\2013\System\iscmdbld.exe" ^
	-z ProductCode=%GUID2% ^
	-p "%rootPath%\NCMClient.ism" ^
	-r "NCMClient" ^
	-c COMP ^
	-y "%BUILDNAME%" ^
	-a "NCMClient" 

goto :EOF
	
:end

CD\"cbs software\BuildInstalls\"
xcopy "%rootPath%\NCMClient\NCMClient\DiskImages\DISK1\*" /h /e /y
xcopy "%rootPath%\NCMServer\NCMServer\DiskImages\DISK1\*" /h /e /y
goto :eof

pause