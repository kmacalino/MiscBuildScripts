@echo off
setlocal 

echo Starting "Pull"...

CD\"cbs software\NorthStar.recipeviewer\"

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
cls

echo GUID3=%GUID3%
FOR /F "delims=" %%A in ('powershell -command "$([guid]::NewGuid().ToString())"') DO set GUID3={%%A}
echo GUID3=%GUID3%
cls

echo GUID4=%GUID4%
FOR /F "delims=" %%A in ('powershell -command "$([guid]::NewGuid().ToString())"') DO set GUID4={%%A}
echo GUID4=%GUID4%
cls

set /P BUILDNAME=Please enter a Version Number:
REM set /P MajorUpgrade=Major Upgrade Y/N:
set MajorUpgrade=Y

set mycurrentfolder=%~dp0
set rootPath=%mycurrentfolder%..\NorthStar.RecipeViewer

cls

ECHO BUILDING THE INSTALLER

if /I %MajorUpgrade% EQU Y (
	
	echo THIS IS DOING THE UPGRADE

	CALL :BUILDPRODUCT
	CALL :INSTALLUPGRADE
	CALL :END
	GOTO :EOF
	
) else (

	ECHO NOT AN UPGRADE
	
	CALL :BUILDPRODUCT
	CALL :INSTALLNOUPGRADE
	CALL :END
	GOTO :EOF
	
)

CLS

:BUILDPRODUCT
echo COPYING IMAGES TO FOLDER
xcopy "%rootPath%\Recipe\Testing\Common2\Images\*" /h /e /y "%rootPath%\testing\common2\images\"
xcopy "%rootPath%\Recipe\Installer\CBSImages\CBS_Theme\NSRV2.ico" "%rootPath%\Desktop\Code\NorthStar.Desktop.Application\NS.ico" /h /e /y

echo EDIT VERSION NUMBER IN CONFIG
xmlstarlet.exe edit --inplace --update /release/version --value "%BUILDNAME%" "%rootPath%\Recipe\Testing\NorthStar.Desktop.ReleaseLine.xml"
xmlstarlet.exe edit --inplace --update /release/version --value "%BUILDNAME%" "%rootPath%\Recipe\Code\NorthStar.Portal\NorthStar.Portal.ReleaseLine.xml"

echo COPYING VERSION XML TO FOLDER
xcopy "%rootPath%\Recipe\Testing\NorthStar.Desktop.ReleaseLine.xml" /h /e /y "%rootPath%\testing\"
del "%rootPath%\Testing\Modules\NorthStar.ECM.dll"

ECHO BUILDING THE SOFTWARE

"C:\Windows\Microsoft.NET\Framework\v4.0.30319\msbuild.exe" ^
	"%rootPath%\Desktop\Code\NorthStar.Desktop.Application\NorthStar.Desktop.vbproj" ^
	/t:rebuild

"C:\Windows\Microsoft.NET\Framework\v4.0.30319\msbuild.exe" ^
	"%rootPath%\Recipe\Recipe.sln" ^
	/t:rebuild

goto :EOF
	
:INSTALLUPGRADE	
ECHO BUILDING INSTALLER

"C:\Program Files (x86)\InstallShield\2013\System\iscmdbld.exe" ^
	-z ProductCode=%GUID1% ^
	-p "%rootPath%\RecipeViewerPortalFullInstall.ism" ^
	-r "Recipe Portal Server" ^
	-c COMP ^
	-y "%BUILDNAME%" ^
	-a "Recipe Portal Server"
	
"C:\Program Files (x86)\InstallShield\2013\System\iscmdbld.exe" ^
	-z ProductCode=%GUID2% ^
	-p "%rootPath%\RecipeViewerEditor_PreReqs.ism" ^
	-r "RecipeViewerEditor" ^
	-c COMP ^
	-y "%BUILDNAME%" ^
	-a "RecipeViewerEditor"

"C:\Program Files (x86)\InstallShield\2013\System\iscmdbld.exe" ^
	-z ProductCode=%GUID3% ^
	-p "%rootPath%\RecipeViewerEditor_ClientOnly.ism" ^
	-r "RecipeViewerEditorClient" ^
	-c COMP ^
	-y "%BUILDNAME%" ^
	-a "RecipeViewerEditorClient"

"C:\Program Files (x86)\InstallShield\2013\System\iscmdbld.exe" ^
	-z ProductCode=%GUID4% ^
	-p "%rootPath%\RecipeViewerPortalUpdate.ism" ^
	-r "Recipe Viewer Portal Update" ^
	-c COMP ^
	-y "%BUILDNAME%" ^
	-a "Recipe Viewer Portal Update"
	
GOTO :EOF


:INSTALLNOUPGRADE
"C:\Program Files (x86)\InstallShield\2013\System\iscmdbld.exe" ^
	-p "%rootPath%\RecipeViewerPortalFullInstall.ism" ^
	-r "Recipe Portal Server" ^
	-c COMP ^
	-y "%BUILDNAME%" ^
	-a "Recipe Portal Server"
	
"C:\Program Files (x86)\InstallShield\2013\System\iscmdbld.exe" ^
	-p "%rootPath%\RecipeViewerEditor_PreReqs.ism" ^
	-r "RecipeViewerEditor" ^
	-c COMP ^
	-y "%BUILDNAME%" ^
	-a "RecipeViewerEditor"

"C:\Program Files (x86)\InstallShield\2013\System\iscmdbld.exe" ^
	-p "%rootPath%\RecipeViewerEditor_ClientOnly.ism" ^
	-r "RecipeViewerEditorClient" ^
	-c COMP ^
	-y "%BUILDNAME%" ^
	-a "RecipeViewerEditorClient"

"C:\Program Files (x86)\InstallShield\2013\System\iscmdbld.exe" ^
	-p "%rootPath%\RecipeViewerPortalUpdate.ism" ^
	-r "Recipe Viewer Portal Update" ^
	-c COMP ^
	-y "%BUILDNAME%" ^
	-a "Recipe Viewer Portal Update"
	
GOTO :EOF
		
:END

CD\"cbs software\BuildInstalls\"

xcopy "%rootPath%\RecipeViewerEditor_ClientOnly\RecipeViewerEditorClient\RecipeViewerEditorClient\DiskImages\DISK1\*" /h /e /y
xcopy "%rootPath%\RecipeViewerEditor_PreReqs\RecipeViewerEditor\RecipeViewerEditor\DiskImages\DISK1\*" /h /e /y
xcopy "%rootPath%\RecipeViewerPortalFullInstall\Recipe Portal Server\Recipe Portal Server\DiskImages\DISK1\*" /h /e /y
xcopy "%rootPath%\RecipeViewerPortalUpdate\Recipe Viewer Portal Update\Recipe Viewer Portal Update\DiskImages\DISK1\*" /h /e /y
GOTO :EOF

pause