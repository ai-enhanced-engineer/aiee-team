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
- [🎯 Commands](#-commands)
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

## 🧪 Development & Testing

### Testing Locally

To test the plugin during development:

1. **Load the plugin from your local directory:**
   ```bash
   cd /path/to/aiee-team
   claude --plugin-dir ./
   ```

2. **Verify plugin loaded:**
   ```bash
   /plugins
   # Should show: aiee-team (local)
   ```

3. **Test commands are available:**
   ```bash
   /commands
   # Should show: aiee-backend, aiee-frontend
   ```

4. **Test a command:**
   ```bash
   /aiee-backend fix: Test command loading
   ```

5. **Verify agents are accessible:**
   ```bash
   /agents
   # Should list: aiee-backend-engineer, aiee-frontend-engineer, etc.
   ```

### Before Committing

Always run validation checks:

```bash
# Validate JSON files
cat .claude-plugin/plugin.json | jq empty
cat .claude-plugin/marketplace.json | jq empty

# Check for required files
test -f .claude-plugin/plugin.json && echo "✅ Manifest exists"
test -f .claude-plugin/marketplace.json && echo "✅ Marketplace config exists"
test -f commands/aiee-backend.md && echo "✅ Backend command exists"
test -f commands/aiee-frontend.md && echo "✅ Frontend command exists"

# Verify agent references use aiee-* prefix
grep -r "@agent-" commands/ | grep -v "aiee-" | grep -v "test-enforcement-reviewer" | grep -v "python-code-quality-auditor" && echo "⚠️ Non-aiee agents found" || echo "✅ Agent references correct"
```

### Plugin Installation Scopes

When installing the plugin, choose the appropriate scope:

| Scope | Use Case | Location | Sharing |
|-------|----------|----------|---------|
| `--scope project` | **Team development** (recommended) | Committed to git | Everyone on team uses same version |
| `--scope user` | Personal use across projects | `~/.claude/plugins/` | Only you |
| `--scope local` | Project-specific testing | `.claude/` (gitignored) | Development only |

**Recommended for teams:** `--scope project`

```bash
# Install for team
/plugin install aiee-team@aiee-team --scope project
```

---

## 🎯 Commands

| Command | Purpose |
|---------|---------|
| `aiee-backend` | Backend implementation with 2-phase gated review (quality + security → tests) |
| `aiee-frontend` | Frontend implementation with 2-phase gated review (architecture + security → tests) |

### Backend Development Workflow

The `/aiee-backend` command orchestrates a quality-gated implementation cycle:

```bash
# Bug fix
/aiee-backend fix: Resolve N+1 query in user profile endpoint

# New feature
/aiee-backend feat: Add pagination to user list API

# Refactoring
/aiee-backend refactor: Extract email validation to service layer
```

**Workflow phases**:
1. Implementation by `aiee-backend-engineer`
2. Parallel reviews (code quality, Python patterns, security)
3. Test enforcement gate (80% coverage, proper naming)
4. Consolidation and iteration (max 3 cycles)

See `commands/aiee-backend.md` for detailed workflow documentation.

### Frontend Development Workflow

The `/aiee-frontend` command orchestrates a quality-gated implementation cycle for Angular 21+ projects:

```bash
# Bug fix
/aiee-frontend fix: Resolve accessibility issue in navigation menu

# New feature
/aiee-frontend feat: Add dark mode toggle component

# Refactoring
/aiee-frontend refactor: Extract form validation to composable
```

**Workflow phases**:
1. Implementation by `aiee-frontend-engineer`
2. Parallel reviews (frontend architecture + accessibility, security)
3. Test enforcement gate (80% coverage, E2E tests)
4. Consolidation and iteration (max 3 cycles)

See `commands/aiee-frontend.md` for detailed workflow documentation.

---

## 👥 Team Members

| Agent | Role |
|-------|------|
| `aiee-backend-engineer` | Python backend engineer for API design, database modeling, and system integration |
| `aiee-data-engineer` | Data engineer for PostgreSQL/MySQL schema design, migration management, and multi-tenant isolation |
| `aiee-devops-engineer` | DevOps engineer for CI/CD pipelines, IaC, and container orchestration |
| `aiee-frontend-engineer` | Frontend engineer for Angular 21+ applications and Web Components |
| `aiee-python-expert-engineer` | Modern Python expert for architecture decisions, async patterns, and performance optimization |
| `aiee-security-engineer` | Security specialist for threat modeling and compliance (SOC 2, GDPR, OWASP) |
| `aiee-systems-architect` | Full-stack systems architect for architecture reviews and service design |

---

## 🛠️ Skills

This plugin includes **15 skills** that provide domain knowledge to agents:

| Skill | Purpose |
|-------|---------|
| `arch-ddd` | Domain-Driven Design patterns and concepts |
| `arch-decision-records` | Architecture Decision Records (ADRs) |
| `arch-diagrams` | System visualization and diagrams |
| `arch-events` | Event-driven architecture patterns |
| `arch-mvp-roadmap` | MVP definition and phased delivery |
| `arch-python-modern` | Modern Python 3.10+ development standards |
| `compliance-frameworks` | SOC 2, GDPR compliance concepts |
| `dev-standards` | Development standards for code style, git conventions, and validation |
| `frontend-accessibility` | WCAG accessibility concepts |
| `frontend-angular` | Angular 21+ signals, standalone components, and zoneless patterns |
| `frontend-angular-ai` | AI integration for Angular with Genkit, Firebase AI Logic, Gemini API |
| `gcp-cloudsql-infrastructure` | Cloud SQL PostgreSQL infrastructure concepts |
| `infra-terraform` | Infrastructure as Code concepts |
| `testing-angular` | Angular testing with Vitest, signal testing, and Playwright E2E |
| `unit-test-standards` | Test naming conventions, coverage requirements, and behavioral testing |

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

We welcome contributions that improve the team's capabilities.

| I want to... | Guide |
|--------------|-------|
| Add or modify an **agent** | See [`agents/README.md`](agents/README.md) |
| Add or modify a **skill** | See [`skills/README.md`](skills/README.md) |

After changes, update the tables in this README to keep the overview current.

---

## 📜 License

MIT - See [LICENSE](LICENSE) file for details.

---

🚀 **Ready to supercharge your development workflow?** Clone the plugin and start delegating to specialist agents today.

*Domain expertise on demand. For developers building real systems.*

📬 [Subscribe](https://aienhancedengineer.substack.com/) for practical guides on AI-enhanced engineering.
