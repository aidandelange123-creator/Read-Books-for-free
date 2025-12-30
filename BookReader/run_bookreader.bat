@echo off
echo === Multilingual Book Reader ===

REM Check if .NET 8 is installed
echo Checking .NET installation...
dotnet --version >nul 2>&1
if %errorlevel% neq 0 (
    echo .NET SDK not found. Installing .NET 8...
    goto install_dotnet
) else (
    echo .NET SDK found. Checking version...
    for /f "tokens=1,2 delims=." %%a in ('dotnet --version') do set DOTNET_VERSION_MAJOR=%%a
    if %DOTNET_VERSION_MAJOR% lss 8 (
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
powershell -Command "& .\dotnet-install.ps1 -Channel 8.0 -InstallDir 'C:\Program Files\dotnet'"
del dotnet-install.ps1
if %errorlevel% neq 0 (
    echo Failed to install .NET 8
    pause
    exit /b 1
)
echo .NET 8 installed successfully.

:run_app
echo Building and running the Book Reader application...
cd src
dotnet build
if %errorlevel% neq 0 (
    echo Build failed
    pause
    exit /b 1
)
dotnet run
pause