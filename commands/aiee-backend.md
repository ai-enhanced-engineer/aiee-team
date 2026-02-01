---
description: AIEE backend services - implementation + 2-phase gated review
argument-hint: <fix:|feat:|refactor:> [task description]
tags: [backend, quality-gate, python, security, fastapi, django, sqlalchemy]
requires-plugins: []
min-claude-code-version: 1.0.33
examples:
  - "/aiee-backend fix: Resolve N+1 query in user profile endpoint"
  - "/aiee-backend feat: Add pagination to user list API"
  - "/aiee-backend refactor: Extract email validation to service layer"
---

# AIEE Team Backend Cycle

Backend implementation with two-phase gated review for Python backend services.

## Context

Task: $ARGUMENTS

Current cycle: **1 of 3**

## Task Type Parsing

Parse the prefix from `$ARGUMENTS` to determine task type:

| Prefix | Task Type | Primary Agent Focus | Reviewer Focus |
|--------|-----------|---------------------|----------------|
| `fix:` | Bug Fix | Root cause analysis, minimal change, regression prevention | Side effects, regression risk, test covers specific bug |
| `feat:` | Feature | Design, implementation, integration, extensibility | Architecture fit, API design, comprehensive test coverage |
| `refactor:` | Refactor | Code quality, maintainability, no behavior change | No regression, same behavior, improved structure |
| *(none)* | Generic | Infer from description | Standard review |

## Workflow

### Phase 1: Primary Implementation

Summon **@agent-aiee-backend-engineer** to implement the changes.

**Adjust focus based on task type:**

- **fix:** Find root cause first. Implement minimal fix. Avoid unrelated changes. Add regression test.
- **feat:** Consider design before coding. Ensure extensibility. Follow existing patterns. Add comprehensive tests.
- **refactor:** Preserve existing behavior exactly. Improve structure/readability. No functional changes. Maintain test coverage.

Wait for completion before proceeding to Phase 2.

### Phase 2: Code Quality, Patterns & Security Review (Parallel)

Launch 3 reviewers **in parallel** (single message, multiple Task tool calls):

**How parallel execution works:**
When you summon multiple agents in one orchestrator message, Claude Code runs them concurrently:

```
Orchestrator invokes all 3 agents simultaneously:
├─ Task 1: python-code-quality-auditor (starts immediately)
├─ Task 2: aiee-python-expert-engineer (starts immediately)
└─ Task 3: aiee-security-engineer (starts immediately)

All three complete independently, then orchestrator proceeds to Phase 3
```

**Critical:** Use multiple Task tool calls in a SINGLE message. Do NOT send separate messages or wait between agents.

1. **@agent-python-code-quality-auditor**
   - Focus: Safety net - blocks hallucinated packages, tautological tests, code-level security
   - Review: Import validation, test quality, anti-patterns, OWASP vulnerabilities
   - **fix:** Verify fix doesn't introduce new vulnerabilities
   - **feat:** Check for security implications of new functionality
   - **refactor:** Ensure no accidental behavior changes
   - Output: PASS/FAIL with specific issues

2. **@agent-aiee-python-expert-engineer**
   - Focus: Modern Python craftsmanship - async patterns, performance, architecture
   - Review: Code quality, idioms, async/await usage, dataclasses vs Pydantic
   - **fix:** Is the fix idiomatic? Could it be simpler?
   - **feat:** Is the design extensible? Are patterns followed?
   - **refactor:** Is the new structure cleaner? Worth the churn?
   - Output: Recommendations and optimizations

3. **@agent-aiee-security-engineer**
   - Focus: Threat modeling, architecture security, compliance (SOC 2, GDPR)
   - Review: Auth/permissions, data access patterns, API security, compliance requirements
   - **fix:** Does fix close the vulnerability completely?
   - **feat:** What's the attack surface of new functionality?
   - **refactor:** No security regression from restructure?
   - Output: Security issues and compliance gaps

Wait for all 3 reviewers to complete before proceeding to Phase 3.

### Phase 3: Test Enforcement Gate (Sequential)

Only after Phase 2 completes, summon:

4. **@agent-test-enforcement-reviewer**
   - Focus: Quality gate - 80% coverage, naming conventions, behavioral tests
   - Review: Test coverage, `test__<what>__<expected>` naming, tautological tests
   - **fix:** Test must reproduce the bug and verify the fix
   - **feat:** Comprehensive coverage of new functionality (happy path + edge cases)
   - **refactor:** Existing tests still pass, no coverage regression
   - Output: PASS/CONDITIONAL PASS/FAIL

**This is a quality gate. Must achieve PASS or CONDITIONAL PASS to proceed.**

### Phase 4: Consolidation

After all 4 reviewers complete, collect feedback into:

**✅ Approved:**
- [Items that passed all reviews]

**⚠️ Issues Found:**
- **Code Quality (Auditor):** [Safety issues, hallucinated packages, OWASP vulns]
- **Python Patterns (Expert):** [Craftsmanship improvements, async patterns, performance]
- **Security (Security Engineer):** [Threat model gaps, auth issues, compliance requirements]
- **Test Enforcement:** [Coverage gaps, naming violations, test quality]

**🚫 Blockers:**
- [Critical security vulnerabilities - must fix]
- [Critical code quality issues - must fix]
- [Test gate FAIL - must fix before proceeding]
- [Other problems requiring user decision]

### Phase 5: Iteration Decision

**If test enforcement = FAIL or critical security/quality issues:**
- Must address blockers before continuing
- Return to Phase 1 automatically with critical issues prioritized

**If test enforcement = PASS or CONDITIONAL PASS and no critical blockers:**
Ask user: **"Continue to cycle 2?"** (max 3 cycles)

**If YES:**
- Update cycle counter
- Return to Phase 1 with consolidated feedback
- aiee-backend-engineer addresses remaining issues

**If NO or max cycles reached:**
- Export final summary
- Mark approved items
- Document any unresolved recommendations (non-blocking)

## Notes

- **Task type prefix**: Adjusts agent focus (fix/feat/refactor)
- **Two-phase gating**: Quality + patterns + security first, then test enforcement
- **Test reviewer is final gate**: Must pass before iteration approval
- **Security can block**: Critical security issues prevent progression
- **Parallel execution** in Phase 2: Use single message with 3 Task tool calls
- **Sequential execution** in Phase 3: Wait for Phase 2 completion
- **Manual cycle tracking**: User confirms each iteration (unless blockers found)
- **Context threading**: Each cycle includes previous feedback from all 4 reviewers
- **Early exit**: Stop if test gate passes, no security issues, and no new issues found
