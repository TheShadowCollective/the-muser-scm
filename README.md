# The Muser

**The open-source alternative to Suno and ElevenLabs Music.**
Run locally. Own everything. No subscriptions, no ToS, no limits.

Describe what you want to hear in natural language, and The Muser orchestrates
AI models to produce scores, audio, and vocal performances — entirely on your
hardware.

## Quick Start — Windows SCM

The Muser SCM edition is designed to handle its own setup. You do not need to manually create Python environments, install Ollama, download the orchestration model, or configure ACE-Step.

### Before You Begin

**Recommended hardware**

- Windows 10 or Windows 11
- NVIDIA GPU
- **16 GB VRAM or more recommended**
- **60 GB or more free disk space recommended**

The current SCM configuration has been developed and tested on an NVIDIA GeForce RTX 5060 Ti with 16 GB VRAM.

### Disk Space

Muser is a small application, but the AI models and supporting environments are not.

A fresh installation measured during testing required approximately **43 GB** after the components and models required for generation were installed.

We recommend having at least **60 GB of free disk space** before beginning. Additional models, updates, caches, and generated music will require additional space.

### Install

Clone the SCM branch:

```bat
git clone -b scm-modernization https://github.com/TheShadowCollective/the-muser-scm.git
cd the-muser-scm
```

Then run:

```bat
Start_Muser.bat
```

On first launch, Muser will guide you through setup and automatically handle the required components, including:

- The Muser Python environment
- Ollama, if it is not already installed
- The `qwen3:14b` orchestration model
- ACE-Step SCM
- Required Python dependencies
- Hardware detection and an appropriate ACE-Step configuration

Some large ACE-Step models are downloaded when they are first required, so the first music generation may take substantially longer than later generations.

Once setup is complete, you will see:

```text
You:
```

Simply describe the music you want to create. For example:

> **You:** Create a slow cinematic orchestral piece with emotional strings, soft piano, and a powerful dramatic ending.

Muser handles the underlying generation tools for you.



## What It Does

Muser lets you describe the music you want in natural language and coordinates the local AI models required to create it.

```text
User
  │
  ▼
Muser
  │
  ├── qwen3:14b via Ollama
  │       Interprets the request
  │       Plans the generation
  │       Controls the available tools
  │
  ▼
ACE-Step SCM
  │
  ├── Hardware-aware configuration
  ├── Music generation
  └── Audio output
  │
  ▼
Your Music
```

The current Windows SCM workflow provides:

- **Natural-language music creation** — describe the music you want instead of manually configuring generation parameters.
- **Local orchestration** — `qwen3:14b` runs locally through Ollama.
- **ACE-Step SCM integration** — Muser communicates with the locally hosted ACE-Step generation backend.
- **Hardware-aware quality profiles** — generation settings are selected according to detected GPU capabilities and available VRAM.
- **Automated first-time setup** — Muser can prepare its Python environment, install Ollama, download `qwen3:14b`, configure ACE-Step SCM, and start the required services.
- **Local generation** — the orchestration and music-generation workflow runs on your own hardware.

## Output and Licensing

Muser SCM runs its orchestration and music-generation workflow locally using open-source software and locally installed AI models.

The Muser framework, ACE-Step, Ollama, AI model weights, and other dependencies are separate components and may be distributed under different licenses and terms.

Users are responsible for reviewing the licenses and usage terms applicable to the software and models they use, particularly when generated material is intended for commercial distribution.

See [THIRD_PARTY_LICENSES.md](THIRD_PARTY_LICENSES.md) and [docs/legal.md](docs/legal.md) for the licensing information currently included with this repository.



## Installation

### Prerequisites

For the Windows SCM edition, most software prerequisites are installed or configured automatically by `Start_Muser.bat`.

**Recommended:**

- Windows 10 or Windows 11
- NVIDIA GPU with **16 GB VRAM or more**
- **60 GB or more free disk space**
- Internet connection for first-time setup and model downloads
- Git, for cloning and updating the repository

The validated SCM setup uses Python 3.14, a CUDA 13-compatible PyTorch stack, Ollama with `qwen3:14b`, and the ACE-Step SCM environment. The startup and setup scripts configure these components where applicable.

You do **not** need to manually install Ollama or download `qwen3:14b` before starting Muser. If they are missing, Muser will offer to install them during first-time setup.

### Full Install — Windows SCM

The Windows SCM edition uses an automated setup process.

Clone the SCM branch:

```bat
git clone -b scm-modernization https://github.com/TheShadowCollective/the-muser-scm.git
cd the-muser-scm
```

Start Muser:

```bat
Start_Muser.bat
```

On a first-time installation, Muser will:

1. Display the expected storage requirements before installation begins.
2. Create and configure the validated Muser Python environment.
3. Detect whether Ollama is installed and offer to install it if necessary.
4. Start the Ollama service if required.
5. Detect whether `qwen3:14b` is installed and offer to download it if necessary.
6. Install and configure ACE-Step SCM.
7. Detect the NVIDIA GPU and available VRAM.
8. Present hardware-aware ACE-Step quality profiles.
9. Start the ACE-Step API.
10. Launch the interactive Muser interface.

No manual Python environment setup or model installation should be necessary during the normal Windows SCM installation process.

#### ACE-Step Quality Profiles

At startup, Muser provides the following generation profiles:

| Profile | ACE-Step Model | Steps | Language Model |
|---|---|---:|---|
| Fast | Turbo | 8 | 0.6B |
| Balanced | XL-Turbo | 20 | GPU-recommended LM |
| High Quality | XL-SFT | 50 | GPU-recommended LM |
| Maximum Quality | XL-SFT | 50 | 4B |
| Auto Detect | XL-SFT | 50 | GPU-recommended LM |

**Auto Detect** is the recommended default. Muser uses ACE-Step's detected GPU tier and available VRAM to select the recommended language model.

> **Note:** Maximum Quality may select a language model beyond the recommended configuration for your GPU. Use it only when sufficient VRAM is available.

## Usage

Start Muser by running:

```bat
Start_Muser.bat
```

After the required services and models are ready, Muser will display the interactive prompt:

```text
You:
```

Describe the music you want in ordinary language.

For example:

> **You:** Create a dark cinematic orchestral piece with low strings, distant percussion, and a slow build into a powerful dramatic climax.

Muser interprets your request and coordinates the underlying AI music-generation tools automatically.

### During Generation

The first generation may take longer because ACE-Step may need to download model files that have not yet been cached locally.

Keep both the **Muser** terminal and the **ACE-Step API** terminal open while using the current command-line version. Closing the ACE-Step API terminal will stop the generation backend and prevent Muser from completing requests.

Generated music is written to Muser's output/export location.

### Orchestration Model

The SCM edition uses the locally hosted:

```text
qwen3:14b
```

model through Ollama for Muser's natural-language orchestration.

Ollama and `qwen3:14b` are checked automatically during startup and can be installed or downloaded by Muser when missing.



## Architecture

The Muser SCM edition keeps natural-language orchestration separate from music generation.

```text
User
 │
 ▼
Muser
 │
 ├── qwen3:14b via Ollama
 │       Natural-language orchestration
 │
 ▼
ACE-Step SCM API
 │
 ├── Hardware-aware model selection
 ├── ACE-Step language model
 └── ACE-Step diffusion model
 │
 ▼
Generated Audio
```

### Component Responsibilities

**Muser**  
Provides the interactive natural-language interface and translates the user's musical request into generation instructions.

**Ollama + qwen3:14b**  
Runs the local language model used by Muser for orchestration and tool selection.

**ACE-Step SCM**  
Provides the music-generation backend. The SCM environment includes compatibility work for the modern Python, PyTorch, CUDA, Transformers, and related dependency stack used by this project.

**Start_Muser.bat**  
Acts as the current Windows launcher and first-time setup manager. It checks the required components, performs installation when necessary, detects available GPU hardware, selects generation settings, starts the required services, and launches Muser.

### Current Interface

The current SCM build uses a command-line interface. Muser and the ACE-Step API run in separate terminal processes during operation.




## Contributing

This repository contains an SCM-modernized version of Muser focused on the Windows NVIDIA/CUDA environment used and validated by The Shadow Collective.

Contributions, testing, bug reports, and compatibility improvements are welcome.

When reporting an issue, please include relevant system information when possible, including:

- Windows version
- NVIDIA GPU model
- Available VRAM
- NVIDIA driver version
- The selected ACE-Step quality profile
- Relevant Muser or ACE-Step error output

The SCM environment intentionally uses a modern dependency stack and includes compatibility changes required to run ACE-Step with that environment. Please avoid replacing or downgrading validated dependencies without first confirming that the complete Muser and ACE-Step generation pipeline continues to work.



## Credits

The Muser SCM edition is based on the original open-source **The Muser** project:

https://github.com/noah-chelednik/the-muser

The Shadow Collective did not create the original Muser framework. This repository contains modifications and modernization work performed for The Shadow Collective's local AI production environment, including the Windows SCM setup workflow, modern dependency compatibility work, ACE-Step SCM integration, hardware-aware generation profiles, and automated local setup.

Muser also relies on other open-source projects and AI models, including **ACE-Step** and **Ollama**. Their respective licenses and attribution requirements remain applicable.

The Shadow Collective gratefully acknowledges the developers and contributors whose open-source work made this project possible.

## License

The original Muser framework and original Muser code are distributed under the **MIT License**.

See [LICENSE](LICENSE) for the license included with this repository.

Third-party components, models, libraries, and dependencies remain subject to their own licenses and terms.

See [THIRD_PARTY_LICENSES.md](THIRD_PARTY_LICENSES.md) for third-party licensing information and [docs/legal.md](docs/legal.md) for additional information regarding components and output ownership.

Modifications contributed by The Shadow Collective do not alter or supersede the licenses of the original Muser project or any third-party components.