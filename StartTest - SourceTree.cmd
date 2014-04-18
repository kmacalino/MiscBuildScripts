@echo off
setlocal

cls

echo Starting "Pull"...

CD\"cbs software\qa\posi"

git clean -fdx

git checkout master -f

git fetch origin --prune

git reset --hard origin/master


echo Starting test script...

"C:\Program Files (x86)\Seapine\QA Wizard Pro\QAWRunscript.exe" ^
	"C:\CBS Software\QA\POSi\Positerm.qawwspace" ^
	"C:\CBS Software\QA\POSi\POSi Test Script\RegressionTest.qawscript" 

pause