@echo off
echo === Multilingual Book Reader ===
echo.

REM Check if .NET 8 is installed
echo Checking .NET installation...
dotnet --info >nul 2>&1
if %errorlevel% neq 0 (
    echo .NET SDK not found. Installing .NET 8...
    goto install_dotnet
) else (
    echo .NET SDK found. Checking version...
    for /f "tokens=1 delims=." %%a in ('dotnet --version') do set DOTNET_VERSION_MAJOR=%%a
    REM Handle cases where version might start with "8", "9", etc.
    set /a "version_check=%DOTNET_VERSION_MAJOR% >= 8"
    if !version_check! neq 1 (
        echo .NET 8 or higher required. Installing .NET 8...
        goto install_dotnet
    ) else (
        echo .NET version is compatible.
        goto run_app
    )
)

:install_dotnet
echo Downloading and installing .NET 8...
powershell -Command "Invoke-WebRequest -Uri https://dotnet.microsoft.com/download/dotnet/scripts/v1/dotnet-install.ps1 -OutFile dotnet-install.ps1"
if exist dotnet-install.ps1 (
    echo Installing .NET 8...
    powershell -Command "& .\dotnet-install.ps1 -Channel LTS -InstallDir '%LocalAppData%\Microsoft\dotnet'"
    del dotnet-install.ps1
) else (
    echo Failed to download .NET installer
    pause
    exit /b 1
)
if %errorlevel% neq 0 (
    echo Failed to install .NET 8
    pause
    exit /b 1
)
echo .NET 8 installed successfully.

REM Refresh the environment to recognize the new .NET installation
call "%LocalAppData%\Microsoft\dotnet\dotnet.exe" --info >nul 2>&1
if %errorlevel% neq 0 (
    REM If .NET still not recognized, try adding to PATH temporarily
    set "PATH=%PATH%;%LocalAppData%\Microsoft\dotnet"
)

:run_app
echo Building and running the Book Reader application...
cd /d "%~dp0\src"
dotnet build --nologo --no-restore
if %errorlevel% neq 0 (
    echo Build failed
    pause
    exit /b 1
)
echo.
echo Starting the Book Reader application...
echo.
dotnet run --no-build
if %errorlevel% neq 0 (
    echo Application encountered an error
    pause
)
echo.
echo Press any key to exit...
pause >nul