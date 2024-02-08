@echo off

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

if not exist %USERPROFILE%\.config (
    mkdir %USERPROFILE%\.config
)

if not exist %USERPROFILE%\.config\cmd (
    mklink /d %USERPROFILE%\.config\cmd %cd%\.config\cmd
)

echo "Adding Registry..."

:: Add Registry Key for Command Prompt
reg add "HKCU\Software\Microsoft\Command Processor" /v AutoRun /t REG_SZ /d "doskey /macrofile="%USERPROFILE%\.config\cmd\alias.doskey"" /f

echo "Alias Cmd is added to HKCU\Software\Microsoft\Command Processor"
pause

REM Check LSD installed
.\.config\cmd\alias.cmd

