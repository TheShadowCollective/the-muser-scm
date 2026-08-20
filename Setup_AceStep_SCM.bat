@echo off
setlocal EnableDelayedExpansion

REM ============================================================
REM Muser - ACE-Step SCM Environment Setup
REM
REM Creates and validates the ACE-Step SCM environment used
REM by Muser.
REM ============================================================

cd /d "%~dp0"

echo.
echo ============================================================
echo Muser - ACE-Step SCM Setup
echo ============================================================
echo.
echo This will create and configure the validated ACE-Step
echo environment used by Muser.
echo.

set "ACESTEP_DIR=%CD%\models\ace-step-v15"

if not exist "%ACESTEP_DIR%\scripts\scm\bootstrap_scm_environment.bat" (
    echo ACE-Step SCM is not currently installed.
    echo.
    echo Expected location:
    echo   %ACESTEP_DIR%
    echo.
    echo ACE-Step SCM is required for Muser music generation.
    echo.

    set "INSTALL_ACESTEP="
    set /p "INSTALL_ACESTEP=Install ACE-Step SCM now? [Y/n] (Recommended): "

    if "!INSTALL_ACESTEP!"=="" set "INSTALL_ACESTEP=Y"

    if /I not "!INSTALL_ACESTEP!"=="Y" (
        echo.
        echo ACE-Step SCM installation skipped.
        echo.
        pause
        exit /b 1
    )

    echo.
    echo Checking Git...
    git --version >nul 2>&1

    if errorlevel 1 (
        echo.
        echo [ERROR] Git was not found on PATH.
        echo.
        echo Please install Git for Windows and run this setup again.
        echo.
        pause
        exit /b 1
    )

    echo [OK] Git found.
    echo.
    echo Cloning ACE-Step SCM...
    echo.

    git clone https://github.com/TheShadowCollective/ACE-Step-1.5-SCM.git "%ACESTEP_DIR%"

    if errorlevel 1 (
        echo.
        echo [ERROR] Failed to clone ACE-Step SCM.
        echo.
        pause
        exit /b 1
    )

    echo.
    echo [OK] ACE-Step SCM cloned successfully.
    echo.
)

echo [OK] ACE-Step installation found.
echo.

pushd "%ACESTEP_DIR%"

call "scripts\scm\bootstrap_scm_environment.bat"

set "EXIT_CODE=%ERRORLEVEL%"

popd

if not "%EXIT_CODE%"=="0" (
    echo.
    echo ============================================================
    echo ACE-Step SCM setup FAILED
    echo ============================================================
    echo.
    echo Exit code: %EXIT_CODE%
    echo.
    pause
    exit /b %EXIT_CODE%
)

echo.
echo ============================================================
echo ACE-Step SCM setup completed successfully!
echo ============================================================
echo.
echo Muser's ACE-Step environment is ready.
echo.
pause

endlocal
exit /b 0
