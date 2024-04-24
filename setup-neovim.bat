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

cls

Rem Check Link Exists
if not exist %LOCALAPPDATA%\nvim\ (
    echo "Configuring Neovim"
    echo "Creating Symbolic Link"
    echo "Linking %LOCALAPPDATA%\nvim to %cd%\.config\nvim"
    mklink /d %LOCALAPPDATA%\nvim %cd%\.config\nvim

    echo "Neovim Configured"
) else (
    echo "Link already exists"
)

