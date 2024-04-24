@echo off

REM CHECK LSD PROGRAM IS INSTALLED
FOR /F %%i IN ('where lsd') DO SET "LSD_PATH=%%i"

REM CHECK STARSHIP PROGRAM IS INSTALLED
FOR /F %%i IN ('where starship') DO SET "STARSHIP_PATH=%%i"

REM Check if "lsd" is found in the PATH
IF "%LSD_PATH%"=="" (
    echo "lsd" not found in the PATH.
    echo "Installing lsd..."
    winget install --id lsd-rs.lsd
) ELSE (
    echo "lsd" found in the PATH.
)

REM Check if "clink" is found in the PATH
IF NOT EXIST "%CLINK_DIR%" (
    echo "clink" not found in the PATH.
    echo "Installing clink..."
    winget install clink
) ELSE (
    echo "clink" found in the PATH.
    echo Add Clink autorun
    clink autorun install
)

IF "%STARSHIP_PATH%"=="" (
    echo "starship" not found in the PATH.
    echo "Installing starship..."
    winget install starship
) ELSE (
    echo "starship" found in the PATH.
)

IF NOT EXIST %LOCALAPPDATA%\clink\starship.lua (
    echo "Setting up starship..."
    mklink %LOCALAPPDATA%\clink\starship.lua %cd%\.config\starship.lua
) ELSE (
    echo "starship already setup"
)


IF NOT EXIST "%USERPROFILE%\.config\starship.toml" (
    echo "starship.toml" not found.
    echo "Linking starship.toml..."
    mklink %USERPROFILE%\.config\starship.toml %cd%\.config\starship.toml
    echo "starship.toml" linked on %cd%\.config\starship.toml.
) ELSE (
    echo "starship.toml" found.
)

pause
