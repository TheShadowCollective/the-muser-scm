@echo off
setlocal EnableDelayedExpansion
title Muser - Orchestral Composer
cd /d "%~dp0"

REM ------------------------------------------------------------
REM Make sure the Muser SCM environment exists
REM ------------------------------------------------------------

if not exist ".venv-scm\Scripts\python.exe" (
    echo.
    echo Muser SCM environment is not installed.
    echo Creating Muser environment...
    echo.

    py -3.14 --version >nul 2>&1
    if errorlevel 1 (
        echo [ERROR] Python 3.14 was not found.
        echo.
        echo Python 3.14 x64 is required for the validated Muser SCM stack.
        echo.
        pause
        exit /b 1
    )

    py -3.14 -m venv ".venv-scm"

    if errorlevel 1 (
        echo.
        echo [ERROR] Failed to create Muser .venv-scm.
        pause
        exit /b 1
    )

    echo Installing Muser...
    echo.

    ".venv-scm\Scripts\python.exe" -m pip install --upgrade pip setuptools wheel

    if errorlevel 1 (
        echo.
        echo [ERROR] Failed to prepare Muser packaging tools.
        pause
        exit /b 1
    )

    ".venv-scm\Scripts\python.exe" -m pip install -e .

    if errorlevel 1 (
        echo.
        echo [ERROR] Failed to install Muser.
        pause
        exit /b 1
    )

    echo.
    echo [OK] Muser SCM environment is ready.
    echo.
)

REM ------------------------------------------------------------
REM Make sure Ollama is installed and qwen3:14b is available
REM ------------------------------------------------------------

echo.
echo Checking Ollama...

ollama --version >nul 2>&1

if errorlevel 1 (
    echo.
    echo [ERROR] Ollama is not installed or is not available on PATH.
    echo.
    echo Muser requires Ollama to run the qwen3:14b orchestration model.
    echo.
    echo Please install Ollama, then run Start_Muser.bat again.
    echo.
    pause
    exit /b 1
)

echo [OK] Ollama found.
echo.

echo Checking qwen3:14b...

ollama list | findstr /I /C:"qwen3:14b" >nul 2>&1

if errorlevel 1 (
    echo qwen3:14b is not installed.
    echo.

    set "PULL_QWEN="
    set /p "PULL_QWEN=Download qwen3:14b now? [Y/n] (Recommended): "

    if "!PULL_QWEN!"=="" set "PULL_QWEN=Y"

    if /I not "!PULL_QWEN!"=="Y" (
        echo.
        echo qwen3:14b download skipped.
        echo.
        pause
        exit /b 1
    )

    echo.
    echo Downloading qwen3:14b...
    echo.

    ollama pull qwen3:14b

    if errorlevel 1 (
        echo.
        echo [ERROR] Failed to download qwen3:14b.
        pause
        exit /b 1
    )

    echo.
    echo [OK] qwen3:14b installed.
) else (
    echo [OK] qwen3:14b found.
)

echo.

set "ACESTEP_DIR=%CD%\models\ace-step-v15"

if not exist "%ACESTEP_DIR%\scripts\scm\bootstrap_scm_environment.bat" (
    echo.
    echo ACE-Step SCM is not installed.
    echo.
    echo Running setup...
    echo.

    call "%CD%\Setup_AceStep_SCM.bat"

    if errorlevel 1 (
        echo.
        echo [ERROR] ACE-Step SCM setup failed.
        echo.
        pause
        exit /b 1
    )
)

REM ------------------------------------------------------------
REM Make sure ACE-Step API is running
REM ------------------------------------------------------------

echo.
echo Checking ACE-Step API...

curl --silent --fail --max-time 2 http://127.0.0.1:8001/docs >nul 2>&1

if not errorlevel 1 goto ACESTEP_READY

echo ACE-Step API is not running.
echo Starting ACE-Step SCM...
echo.

start "ACE-Step API" /D "%ACESTEP_DIR%" cmd /k "call scripts\scm\start_api_server_scm.bat"

echo Waiting for ACE-Step API...

:WAIT_FOR_ACESTEP
timeout /t 2 /nobreak >nul

curl --silent --fail --max-time 2 http://127.0.0.1:8001/docs >nul 2>&1

if errorlevel 1 (
    echo   Still starting...
    goto WAIT_FOR_ACESTEP
)

:ACESTEP_READY
echo [OK] ACE-Step API is ready.
echo.


call .venv-scm\Scripts\activate

set MUSER_ACESTEP_API_URL=http://127.0.0.1:8001

echo ============================================================
echo   MUSER
echo   Ollama Model : qwen3:14b
echo   ACE-Step API : http://127.0.0.1:8001
echo ============================================================
echo.

muser --model ollama_chat/qwen3:14b --no-stream

echo.
pause
