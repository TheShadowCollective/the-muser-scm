# Security Policy

\## Supported Versions



The SCM edition currently supports the latest 1.1.x release line.



| Version | Supported |

|---------|-----------|

| 1.1.x   | Yes       |

| 1.0.x   | Upstream / historical |





\## Reporting a Vulnerability



If you discover a security vulnerability in the Muser SCM edition, please report it responsibly.



Please \*\*do not open a public GitHub issue\*\* for a security vulnerability.



Use the private security reporting features provided by this repository when available. Include enough information to reproduce and understand the issue, such as:



\- A description of the vulnerability

\- Steps required to reproduce it

\- The affected Muser SCM version

\- Relevant operating system and environment information

\- Relevant logs or error output, with passwords, tokens, personal information, and other sensitive data removed



If the issue originates in an upstream project or third-party dependency rather than changes made in the Muser SCM edition, please also follow that project's responsible disclosure process where appropriate.



\## Scope



\### In Scope



Security issues in the Muser SCM codebase or its integration layers, including:



\- LLM prompt injection that causes unintended tool execution

\- Path traversal in tool parameters, such as reading or writing files outside intended locations

\- Subprocess or command injection through malformed tool arguments

\- Credential, token, or sensitive-information exposure in logs or error messages

\- Unsafe behavior introduced by the Windows SCM setup or startup scripts

\- Security issues introduced by SCM-specific dependency compatibility changes

\- Unintended network or local-service exposure introduced by Muser SCM integration



\### Out of Scope



\- AI model output quality, accuracy, or bias

\- Performance limitations or resource exhaustion caused by intentionally large local generation requests

\- Vulnerabilities originating entirely within upstream projects, models, libraries, or third-party dependencies that have not been introduced or modified by the Muser SCM edition



Upstream or third-party vulnerabilities should normally be reported to the maintainers of the affected project through their responsible disclosure process.

