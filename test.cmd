@echo off

echo before
call :whatever
echo after



exit /b

:whatever
echo during
goto :EOF

:whateveragain
echo OH NO
goto :EOF