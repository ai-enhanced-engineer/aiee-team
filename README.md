<h1 align="center">The AI Enhanced Engineer's Team</h1>

<p align="center">
  <img src="assets/images/cover.jpeg" alt="AIEE Team - Domain specialists for production workflows" width="450" />
</p>

<p align="center">
  <a href="https://github.com/ai-enhanced-engineer/aiee-team/releases"><img src="https://img.shields.io/github/v/release/ai-enhanced-engineer/aiee-team" alt="Version" /></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="License" /></a>
  <a href="https://github.com/ai-enhanced-engineer/aiee-team/actions"><img src="https://img.shields.io/github/actions/workflow/status/ai-enhanced-engineer/aiee-team/release.yml?branch=main" alt="Build Status" /></a>
</p>

<p align="center">
  🌐 <a href="https://aiee.io">Website</a> | 📧 <a href="https://aienhancedengineer.substack.com/">Subscribe</a>
</p>

Multi-agent orchestration with domain specialists for production software development workflows.

---

## Table of Contents

- [Why This Exists](#why-this-exists)
- [🚀 Quick Start](#-quick-start)
- [👥 Team Members](#-team-members)
- [🛠️ Skills](#%EF%B8%8F-skills)
- [📂 Directory Structure](#-directory-structure)
- [🤝 Contributing](#-contributing)
- [📜 License](#-license)

---

## Why This Exists

You ask Claude to build an API. It writes 500 lines of FastAPI in 30 seconds. No tests. No migration rollback. No SQL injection protection.

The problem isn't that Claude can't code. It's that production software requires **domain expertise**:

- A backend engineer knows to add database indexes for common queries
- A security engineer validates JWT signatures before protected routes
- A DevOps engineer versions Terraform state and locks deployments

This plugin gives you specialist agents with that knowledge built in.

**What you get:**

- **Domain specialists** - Backend engineer designs your schema. Security engineer audits for vulnerabilities.
- **Encoded patterns** - "Always use RLS for multi-tenant databases", "Test error codes, not just happy paths"
- **Orchestrated workflows** - Architecture review before implementation. Security audit before deployment.

---

## 🚀 Quick Start

### Via Plugin Marketplace (Recommended)

1. Add the AIEE Team marketplace to Claude Code:
   ```shell
   /plugin marketplace add ai-enhanced-engineer/aiee-team
   ```

2. Install the plugin:
   ```shell
   /plugin install aiee-team@aiee-team
   ```

3. Verify installation:
   ```shell
   /agents
   ```
   You should see AIEE agents listed.

### Via Local Development

For contributors or local testing:

1. Clone the repository:
   ```bash
   git clone https://github.com/ai-enhanced-engineer/aiee-team.git ~/projects/aiee-team
   ```

2. Start Claude Code with the plugin loaded:
   ```bash
   claude --plugin-dir ~/projects/aiee-team
   ```

### Usage

Claude automatically delegates to specialist agents based on task context. You can also explicitly request an agent:

```
Use the aiee-backend-engineer agent to design the API for user authentication
```

View all available agents with `/agents`.

---

## 👥 Team Members

| Agent | Role |
|-------|------|
| `aiee-backend-engineer` | Python backend engineer for API design, database modeling, and system integration |
| `aiee-data-engineer` | Data engineer for PostgreSQL/MySQL schema design, migration management, and multi-tenant isolation |
| `aiee-devops-engineer` | DevOps engineer for CI/CD pipelines, IaC, and container orchestration |
| `aiee-frontend-engineer` | Frontend engineer for Svelte/SvelteKit and Angular 21+ applications |
| `aiee-python-expert-engineer` | Modern Python expert for architecture decisions, async patterns, and performance optimization |
| `aiee-security-engineer` | Security specialist for threat modeling and compliance (SOC 2, GDPR, OWASP) |
| `aiee-systems-architect` | Full-stack systems architect for architecture reviews and service design |

---

## 🛠️ Skills

This plugin includes **12 skills** organized by access tier:

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
| `gcp-cloudsql-infrastructure` | Cloud SQL PostgreSQL infrastructure concepts |
| `infra-terraform` | Infrastructure as Code concepts |

---

## 📂 Directory Structure

```
aiee-team/
├── .claude-plugin/
│   ├── plugin.json       # Plugin metadata
│   └── marketplace.json  # Marketplace distribution
├── agents/               # Agent definitions
├── assets/
│   └── images/           # Cover image and visuals
├── commands/             # Team-specific slash commands
├── skills/               # Team-specific skills
├── workflows/            # Team-specific workflows
├── scripts/
│   └── setup.sh          # Local development helper
└── README.md
```

---

## 🤝 Contributing

We welcome contributions that improve the team's capabilities:

**To add a new agent:**

1. Create `agents/<agent-name>.md` following the existing format
2. Update this README's Team Members table
3. Submit a pull request

**To add a new skill:**

1. Create `skills/<skill-name>.md` following the skill format
2. Update this README's Skills table
3. Submit a pull request

---

## 📜 License

MIT - See [LICENSE](LICENSE) file for details.

---

🚀 **Ready to supercharge your development workflow?** Clone the plugin and start delegating to specialist agents today.

*Domain expertise on demand. For developers building real systems.*

📬 [Subscribe](https://aienhancedengineer.substack.com/) for practical guides on AI-enhanced engineering.
