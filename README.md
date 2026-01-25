# AIEE Team

AI Enhanced Engineer development team agents for Claude Code.

## Skills

This plugin includes 11 skills:

### Complete Skills (Full Documentation)

| Skill | Purpose |
|-------|---------|
| `dev-standards` | Development standards for code style, git conventions, and validation |
| `unit-test-standards` | Test naming conventions, coverage requirements, and behavioral testing |

### Lite Skills (Concepts Only)

| Skill | Purpose |
|-------|---------|
| `arch-ddd` | Domain-Driven Design patterns and concepts |
| `arch-events` | Event-driven architecture patterns |
| `arch-decision-records` | Architecture Decision Records (ADRs) |
| `arch-diagrams` | System visualization and diagrams |
| `arch-mvp-roadmap` | MVP definition and phased delivery |
| `arch-python-modern` | Modern Python 3.10+ development standards |
| `compliance-frameworks` | SOC 2, GDPR compliance concepts |
| `frontend-accessibility` | WCAG accessibility concepts |
| `infra-terraform` | Infrastructure as Code concepts |

## Installation

### Via Plugin System (Recommended)

1. Clone this repository:
   ```bash
   git clone <repository-url> ~/.claude/plugins/aiee-team
   ```

2. Restart Claude Code to discover the plugin.

### Via Setup Script (Development)

1. Clone this repository to your preferred location:
   ```bash
   git clone <repository-url> ~/projects/aiee-team
   ```

2. Run the setup script:
   ```bash
   ./scripts/setup.sh
   ```

3. Restart Claude Code.

## Team Members

| Agent | Role |
|-------|------|
| `aiee-backend-engineer` | Python backend engineer for API design, database modeling, and system integration |
| `aiee-devops-engineer` | DevOps engineer for CI/CD pipelines, IaC, and container orchestration |
| `aiee-frontend-engineer` | Frontend engineer for Svelte/SvelteKit and Angular applications |
| `aiee-security-engineer` | Security specialist for threat modeling and compliance (SOC 2, GDPR, OWASP) |
| `aiee-systems-architect` | Full-stack systems architect for architecture reviews and service design |

## Usage

Invoke agents via the Task tool:

```
Task(subagent_type="aiee-backend-engineer", prompt="Design the API for user authentication")
```

Or reference them in your orchestration workflows.

## Directory Structure

```
aiee-team/
├── .claude-plugin/
│   └── plugin.json       # Plugin metadata
├── agents/               # Agent definitions
├── commands/             # Team-specific slash commands (future)
├── skills/               # Team-specific skills (future)
├── workflows/            # Team-specific workflows (future)
├── scripts/
│   └── setup.sh          # Symlink installer
└── README.md
```

## Contributing

To add a new agent:

1. Create `agents/<agent-name>.md` following the existing format
2. Update this README's Team Members table
3. Submit a pull request

## License

MIT
