# Contributing to The Muser

Thank you for your interest in contributing! This guide will help you get started.

## Development Setup — Windows SCM

The SCM edition of Muser is currently developed and validated on Windows with NVIDIA hardware.

Clone the SCM branch:

```bat
git clone -b scm-modernization https://github.com/TheShadowCollective/the-muser-scm.git
cd the-muser-scm
```

For a normal installation, run:

```bat
Start_Muser.bat
```

The startup and setup scripts create and configure the validated Muser and ACE-Step SCM environments automatically.

### Validated Development Environment

The current SCM development environment has been validated with:

- Windows
- NVIDIA GeForce RTX 5060 Ti
- 16 GB VRAM
- Python 3.14
- CUDA 13-compatible PyTorch stack
- Ollama with `qwen3:14b`
- ACE-Step SCM

Other configurations may work, but should not be considered validated until they have been tested through the complete Muser and ACE-Step generation pipeline.


## Testing

The original Muser project includes an automated test suite under `tests/`.

The SCM modernization has primarily been validated through clean-install and end-to-end generation testing on the supported Windows/NVIDIA development environment.

Before SCM-specific automated test commands are documented here as validated, the inherited test suite should be run and reviewed against the modern Python 3.14 and dependency stack.

When contributing changes to the SCM environment, please verify the complete user workflow whenever the change affects installation, dependencies, model loading, hardware detection, ACE-Step, or orchestration:

1. Start from a clean installation when appropriate.
2. Run `Start_Muser.bat`.
3. Confirm first-time setup completes successfully.
4. Confirm Ollama and `qwen3:14b` are available.
5. Confirm ACE-Step SCM starts successfully.
6. Confirm Muser reaches the interactive `You:` prompt.
7. Complete an actual music generation when the change could affect generation behavior.


## Code Style

The original Muser project uses **Ruff** for Python linting and formatting.

For SCM contributions:

- Keep existing code style and formatting consistent with the surrounding project.
- Use a line length of 100 characters where practical.
- New SCM code should remain compatible with the validated Python 3.14 environment.
- Avoid unnecessary dependency changes to the validated SCM stack.

If Ruff is installed in your development environment, the inherited project checks can be run with:

```bat
ruff check .
ruff format --check .
```

Changes to dependency versions, environment bootstrap code, or compatibility patches should be tested against the complete Muser and ACE-Step SCM workflow before submission.


## Adding a New Tool

The original Muser architecture uses a structured pattern for adding tools to the orchestration system.

A new tool typically requires changes to:

1. **`src/orchestrator/tool_definitions.py`** — Add the tool schema.
2. **`src/orchestrator/tool_validators.py`** — Add the corresponding Pydantic validation model and register it in `TOOL_VALIDATORS`.
3. **`src/orchestrator/tool_executor.py`** — Add the tool handler and register it in `_HANDLERS`.
4. **`tests/test_new_tools.py`** or an appropriate test file — Add validator and handler tests.

Tool handlers follow the existing Muser result convention:

```python
{"status": "success", ...}
```

or:

```python
{"status": "error", "error": "..."}
```

When adding or modifying tools for the SCM edition, preserve compatibility with the existing orchestration architecture unless the architecture itself is intentionally being changed.


## GPL Isolation Rule

The original Muser project isolates GPL-licensed components from the MIT-licensed Muser framework.

**LilyPond** and **MuseScore** must only be invoked as external processes through `subprocess` and must not be imported as Python libraries.

The same isolation principle applies to **parselmouth** (GPL v3), which is available only through the `MUSER_FEMINIZE_BACKEND` opt-in path.

SCM contributions should preserve these existing licensing boundaries unless a licensing change has been independently reviewed and documented.

For additional third-party licensing information, see [THIRD_PARTY_LICENSES.md](THIRD_PARTY_LICENSES.md).


## Pull Request Process

1. Fork the repository and create a dedicated feature or fix branch.
2. Keep changes focused and document what was changed and why.
3. Add or update tests when modifying behavior that is covered by the existing test suite.
4. Run applicable Ruff checks when available.
5. For SCM environment, installation, dependency, model-loading, or ACE-Step changes, validate the affected workflow on the Windows SCM environment.
6. When generation behavior may be affected, complete an actual music generation before considering the change validated.
7. Open a pull request with a clear description of the change, testing performed, and any known limitations.

Please include relevant hardware and software information when a change or issue may be environment-specific.


## Architecture Overview

The SCM edition retains the broader architecture of the original Muser project. Contributors working outside the SCM-specific setup and ACE-Step integration should refer to the existing source structure and architecture documentation.

See [docs/architecture.md](docs/architecture.md) for the original project's full system design.

Key inherited packages include:

- `src/orchestrator/` — LLM agent loop, tool system, and composition state
- `src/generation/` — AI model wrappers, including NotaGen, ACE-Step, and DiffSinger
- `src/audio/` — Rendering, validation, effects, mixing, and export
- `src/notation/` — Format conversion, theory validation, and score rendering
- `src/voice/` — Voice conversion, stem separation, and related voice tooling
- `src/curation/` — Quality analysis and batch curation
- `src/web/` — Original Gradio web interface

The SCM modernization primarily extends the Windows setup, dependency compatibility, local orchestration, hardware detection, and ACE-Step integration layers. It does not imply that the broader inherited Muser architecture was created or rewritten by The Shadow Collective.