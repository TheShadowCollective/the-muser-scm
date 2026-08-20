# Changelog

All notable changes to The Muser are documented in this file.
Format follows [Keep a Changelog](https://keepachangelog.com/).





\## \[1.1.0] - 2026-08-20



\## SCM Modernization



\### Added



\- Windows-first automated startup and installation through `Start\_Muser.bat`

\- Automated Ollama detection and installation

\- Automated `qwen3:14b` detection and download

\- Automated Ollama service startup and health checking

\- Automated ACE-Step SCM environment setup

\- NVIDIA GPU and VRAM detection

\- Hardware-aware ACE-Step quality profiles:

&#x20; - Fast

&#x20; - Balanced

&#x20; - High Quality

&#x20; - Maximum Quality

&#x20; - Auto Detect

\- Automatic ACE-Step API startup and readiness checking

\- First-time storage requirements warning based on measured fresh-install testing

\- Windows SCM setup scripts and compatibility tooling



\### Changed



\- Updated the validated Muser orchestration model to `qwen3:14b`

\- Modernized the Muser SCM environment around Python 3.14

\- Modernized the ACE-Step SCM environment around the CUDA 13-compatible PyTorch stack

\- Updated ACE-Step integration for the modern Transformers and dependency stack

\- Added hardware-aware ACE-Step model and language-model selection

\- Simplified the Windows user workflow around a single `Start\_Muser.bat` entry point



\### Compatibility



The SCM modernization includes compatibility work required by the modern dependency stack, including fixes for ACE-Step dependencies such as `torchao`, `vector-quantize-pytorch`, and `pytorch-wavelets`.



\### Validation



The current SCM workflow has been developed and tested on:



\- Windows

\- NVIDIA GeForce RTX 5060 Ti

\- 16 GB VRAM

\- Python 3.14

\- CUDA 13-compatible PyTorch stack



A clean installation from the SCM GitHub branch has been tested from initial clone through first-time setup, ACE-Step startup, and the interactive Muser `You:` prompt.



Measured fresh-install storage after required generation components were installed was approximately \*\*43 GB\*\*. At least \*\*60 GB of free disk space\*\* is recommended.



\---



\## Upstream History



The following changelog entries were created by the original Muser project and are retained for attribution and historical reference.



## \[1.0.0] - 2026-05-26

### Added

* 46-tool composition vocabulary covering generation, validation, rendering, voice, effects, mixing, and curation
* LLM agent loop with provider-agnostic backend (Ollama, Groq, Cerebras, Gemini, Anthropic)
* Streaming LLM responses with token-by-token CLI display
* ACE-Step v1.0 and v1.5 audio generation with best-of-N candidate selection
* NotaGen symbolic music generation (ABC → MusicXML)
* DiffSinger singing voice synthesis with license-safe vocoder defaults
* RVC/Applio voice conversion with 5 feminization presets
* Demucs stem separation and Seed-VC zero-shot voice conversion
* 4-level hierarchical composition planner with zoom navigation
* Musical Memory Document for cross-session composition state
* 12-dimension audio curation pipeline (6 hard gates + 6 soft scores)
* Audio-to-MIDI extraction bridge (basic-pitch + librosa fallback)
* Individual audio effects: EQ, reverb, compression, volume
* N-track audio mixer with per-track volume, pan, and delay
* Audio playback tool for inline CLI listening
* Voice LoRA training with status monitoring and auto-registration
* Post-production mastering with genre presets and 5-stage vocal chain
* Gradio web interface with chat, audio player, and composition status
* Docker support (CPU and GPU images) with docker-compose
* CI/CD via GitHub Actions (test matrix, lint, coverage)
* Comprehensive legal documentation and license tracking
* 258+ tests with 100% tool coverage

### Legal

* All default generation paths produce commercially-safe output (Apache 2.0 / MIT)
* GPL tools (LilyPond, MuseScore) isolated to subprocess calls
* CC-BY-NC-SA vocoder (NSF-HiFiGAN) requires explicit opt-in
* parselmouth (GPL v3) isolated behind MUSER\_FEMINIZE\_BACKEND flag

