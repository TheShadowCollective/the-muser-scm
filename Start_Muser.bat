@echo off
title Muser - Orchestral Composer
cd /d D:\AI\Applications\Muser

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