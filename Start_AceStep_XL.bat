@echo off
title Muser - ACE-Step XL Turbo
cd /d D:\AI\Applications\Muser\models\ace-step-v15

echo ============================================================
echo   MUSER - ACE-Step v1.5
echo   DiT: XL Turbo
echo   LM : 1.7B
echo ============================================================
echo.

REM Start the ACE-Step API server in its own window.
start "ACE-Step API - XL" /D "%~dp0models\ace-step-v15" cmd /k "call scripts\scm\start_api_server_scm.bat"

echo Waiting for ACE-Step API server...
echo.

REM Wait until the API actually responds instead of guessing
REM how many seconds startup will take.
:WAIT_FOR_API
curl -s http://127.0.0.1:8001/v1/models >nul 2>&1
if errorlevel 1 (
    timeout /t 2 /nobreak >nul
    goto WAIT_FOR_API
)

echo ACE-Step API is responding.
echo.
echo Loading XL Turbo + 1.7B LM...
echo.

curl -X POST http://127.0.0.1:8001/v1/init ^
  -H "Content-Type: application/json" ^
  -d "{\"model\":\"acestep-v15-xl-turbo\",\"init_llm\":true,\"lm_model_path\":\"acestep-5Hz-lm-1.7B\"}"

echo.
echo.
echo ============================================================
echo   ACE-Step initialization request completed.
echo ============================================================
echo.
pause