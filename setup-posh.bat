@echo off

Rem Evaluate Privilege Level Ask for UAC

:: BatchGotAdmin

:-------------------------------------

REM  --> Check for permissions

>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.

if '%errorlevel%' NEQ '0' (

    echo Requesting administrative privileges...

    goto UACPrompt

) else ( goto gotAdmin )

:UACPrompt

    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"

    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"

    exit /B

:gotAdmin

    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )

    pushd "%CD%"

    CD /D "%~dp0"

:--------------------------------------

Rem Check the SymboLink Exist

if not exist "%USERPROFILE%\.config\" (
    md "%USERPROFILE%\.config"
)

if not exist "%USERPROFILE%\.config\powershell\" (
    echo "Creating Symbolic Link for PowerShell"
    echo "Link %USERPROFILE%\.config\powershell\ to %cd%\.config\powershell"
    mklink /d "%USERPROFILE%\.config\powershell\" %cd%\.config\powershell
)

if not exist "%USERPROFILE%\Documents\WindowsPowerShell" (
    echo "Creating Directory for PowerShell Profile"
    md "%USERPROFILE%\Documents\WindowsPowerShell"
)

echo "Creating Symbolic Link for PowerShell Profile"
mklink "%USERPROFILE%\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1" %cd%\.config\powershell\Microsoft.PowerShell_profile.ps1
