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
    REM Ollama may be installed but not visible to this CMD session.
    if exist "%LOCALAPPDATA%\Programs\Ollama\ollama.exe" (
        set "PATH=%LOCALAPPDATA%\Programs\Ollama;%PATH%"
    )
)

ollama --version >nul 2>&1

if errorlevel 1 (
    echo.
    echo Ollama is not installed.
    echo.
    echo Muser requires Ollama to run the qwen3:14b orchestration model.
    echo.

echo.
echo ============================================================
echo                    DISK SPACE NOTICE
echo ============================================================
echo.
echo Muser requires several large components for first-time setup.
echo.
echo   Ollama installer download : approximately 1.5 GB
echo   qwen3:14b model            : approximately 9.3 GB
echo   ACE-Step SCM               : additional space required
echo.
echo The complete Muser environment requires significantly more
echo disk space than the Muser application itself.
echo.
echo Please make sure you have sufficient free disk space before
echo continuing with the installation.
echo.
echo ============================================================
echo.

    set "INSTALL_OLLAMA="
    set /p "INSTALL_OLLAMA=Install Ollama now? [Y/n] (Recommended): "

    if "!INSTALL_OLLAMA!"=="" set "INSTALL_OLLAMA=Y"

    if /I not "!INSTALL_OLLAMA!"=="Y" (
        echo.
        echo Ollama installation skipped.
        echo.
        pause
        exit /b 1
    )

    echo.
    echo Installing Ollama...
    echo.

    winget --version >nul 2>&1

    if not errorlevel 1 (
        echo [INFO] Installing Ollama with WinGet...
        echo.

        winget install ^
            --id Ollama.Ollama ^
            --exact ^
            --accept-source-agreements ^
            --accept-package-agreements

        if errorlevel 1 (
            echo.
            echo [WARNING] WinGet installation failed.
            echo [INFO] Trying the official Ollama installer...
            echo.

            powershell -NoProfile -ExecutionPolicy Bypass -Command ^
                "irm https://ollama.com/install.ps1 | iex"

            if errorlevel 1 (
                echo.
                echo [ERROR] Ollama installation failed.
                echo.
                pause
                exit /b 1
            )
        )
    ) else (
        echo [INFO] WinGet was not found.
        echo [INFO] Using the official Ollama installer...
        echo.

        powershell -NoProfile -ExecutionPolicy Bypass -Command ^
            "irm https://ollama.com/install.ps1 | iex"

        if errorlevel 1 (
            echo.
            echo [ERROR] Ollama installation failed.
            echo.
            pause
            exit /b 1
        )
    )

    REM A newly installed application may not yet be visible
    REM in the PATH inherited by this CMD process.
    if exist "%LOCALAPPDATA%\Programs\Ollama\ollama.exe" (
        set "PATH=%LOCALAPPDATA%\Programs\Ollama;%PATH%"
    )

    echo.
    echo Verifying Ollama installation...
    echo.

    ollama --version >nul 2>&1

    if errorlevel 1 (
        echo.
        echo [ERROR] Ollama was installed but could not be started from this terminal.
        echo.
        echo Expected location:
        echo   %LOCALAPPDATA%\Programs\Ollama\ollama.exe
        echo.
        pause
        exit /b 1
    )

    echo [OK] Ollama installed successfully.
) else (
    echo [OK] Ollama found.
)

echo.



echo Checking Ollama service...

ollama list >nul 2>&1

if errorlevel 1 (
    echo [INFO] Ollama service is not responding. Starting Ollama...

    start "" /B ollama serve >nul 2>&1

    REM Give the Ollama server a few seconds to initialize.
    timeout /t 3 /nobreak >nul

    ollama list >nul 2>&1

    if errorlevel 1 (
        echo.
        echo [ERROR] Ollama is installed but its service could not be started.
        echo.
        pause
        exit /b 1
    )
)

echo [OK] Ollama service is running.
echo.



echo Checking qwen3:14b...

ollama list | findstr /I /C:"qwen3:14b" >nul 2>&1

if errorlevel 1 (
    echo qwen3:14b is not installed.
    echo.

echo ============================================================
echo                    DISK SPACE NOTICE
echo ============================================================
echo.
echo qwen3:14b requires approximately 9.3 GB of disk space.
echo.
echo Make sure you have enough free space before downloading.
echo.
echo ============================================================
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
REM Detect ACE-Step hardware profile
REM ------------------------------------------------------------

echo.
echo Detecting ACE-Step GPU configuration...

set "GPU_INFO_FILE=%TEMP%\muser_gpu_info.txt"

"%ACESTEP_DIR%\.venv-scm\Scripts\python.exe" -c "from acestep.gpu_config import get_gpu_config; c=get_gpu_config(); print(c.tier); print(round(c.gpu_memory_gb,1)); print(c.recommended_lm_model); print(','.join(c.available_lm_models))" > "%GPU_INFO_FILE%" 2>nul

if errorlevel 1 (
    echo.
    echo [ERROR] Could not determine ACE-Step GPU configuration.
    echo.
    pause
    exit /b 1
)

set /p GPU_TIER=<"%GPU_INFO_FILE%"

for /f "skip=1 tokens=*" %%A in (%GPU_INFO_FILE%) do (
    if not defined GPU_VRAM (
        set "GPU_VRAM=%%A"
    ) else if not defined GPU_RECOMMENDED_LM (
        set "GPU_RECOMMENDED_LM=%%A"
    ) else if not defined GPU_AVAILABLE_LM (
        set "GPU_AVAILABLE_LM=%%A"
    )
)

del "%GPU_INFO_FILE%" >nul 2>&1

if not defined GPU_TIER (
    echo.
    echo [ERROR] Could not determine ACE-Step GPU configuration.
    echo.
    pause
    exit /b 1
)

echo [OK] GPU profile detected.
echo.
echo   VRAM          : !GPU_VRAM! GB
echo   ACE-Step tier : !GPU_TIER!
echo   Recommended LM: !GPU_RECOMMENDED_LM!
echo   Supported LMs : !GPU_AVAILABLE_LM!
echo.

REM ------------------------------------------------------------
REM Choose ACE-Step quality profile
REM ------------------------------------------------------------

echo.
echo ============================================================
echo ACE-Step Quality Profile
echo ============================================================
echo.
echo   [1] Fast
echo       Turbo model, 8 steps, 0.6B LM
echo.
echo   [2] Balanced
echo       XL-Turbo, 20 steps, recommended LM
echo.
echo   [3] High Quality
echo       XL-SFT, 50 steps, recommended LM
echo.
echo   [4] Maximum Quality
echo       XL-SFT, 50 steps, 4B LM
echo       May exceed the recommended LM for this GPU.
echo.
echo   [5] Auto Detect [Recommended]
echo       XL-SFT, 50 steps, ACE-Step recommended LM
echo.

set "QUALITY_CHOICE="
set /p "QUALITY_CHOICE=Choose quality [1-5, default 5]: "

if "!QUALITY_CHOICE!"=="" set "QUALITY_CHOICE=5"

if "!QUALITY_CHOICE!"=="1" (
    set "MUSER_ACESTEP_DIT_MODEL=acestep-v15-turbo"
    set "MUSER_ACESTEP_LM_MODEL=acestep-5Hz-lm-0.6B"
    set "MUSER_ACESTEP_INFER_STEP=8"
) else if "!QUALITY_CHOICE!"=="2" (
    set "MUSER_ACESTEP_DIT_MODEL=acestep-v15-xl-turbo"
    set "MUSER_ACESTEP_LM_MODEL=!GPU_RECOMMENDED_LM!"
    set "MUSER_ACESTEP_INFER_STEP=20"
) else if "!QUALITY_CHOICE!"=="3" (
    set "MUSER_ACESTEP_DIT_MODEL=acestep-v15-xl-sft"
    set "MUSER_ACESTEP_LM_MODEL=!GPU_RECOMMENDED_LM!"
    set "MUSER_ACESTEP_INFER_STEP=50"
) else if "!QUALITY_CHOICE!"=="4" (
    set "MUSER_ACESTEP_DIT_MODEL=acestep-v15-xl-sft"
    set "MUSER_ACESTEP_LM_MODEL=acestep-5Hz-lm-4B"
    set "MUSER_ACESTEP_INFER_STEP=50"
) else (
    set "MUSER_ACESTEP_DIT_MODEL=acestep-v15-xl-sft"
    set "MUSER_ACESTEP_LM_MODEL=!GPU_RECOMMENDED_LM!"
    set "MUSER_ACESTEP_INFER_STEP=50"
)

set "ACESTEP_CONFIG_PATH=!MUSER_ACESTEP_DIT_MODEL!"
set "ACESTEP_LM_MODEL_PATH=!MUSER_ACESTEP_LM_MODEL!"

echo.
echo Selected ACE-Step profile:
echo   DiT model : !MUSER_ACESTEP_DIT_MODEL!
echo   LM model  : !MUSER_ACESTEP_LM_MODEL!
echo   Steps     : !MUSER_ACESTEP_INFER_STEP!
echo.


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
