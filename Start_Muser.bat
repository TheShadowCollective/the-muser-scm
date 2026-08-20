@echo off
title Muser - Orchestral Composer
cd /d "%~dp0"

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


call .venv\Scripts\activate

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
