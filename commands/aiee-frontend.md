---
description: AIEE frontend services - implementation + 2-phase gated review
argument-hint: <fix:|feat:|refactor:> [task description]
tags: [frontend, quality-gate, angular, accessibility, security, web-components]
requires-plugins: []
min-claude-code-version: 1.0.33
examples:
  - "/aiee-frontend fix: Resolve accessibility issue in navigation menu"
  - "/aiee-frontend feat: Add dark mode toggle component"
  - "/aiee-frontend refactor: Extract form validation to composable"
---

# AIEE Frontend Cycle

Frontend implementation with two-phase gated review for Angular 21+ and Web Components projects.

## Target Projects

Supports modern frontend frameworks:

| Framework | Key Characteristics |
|-----------|---------------------|
| Angular 21+ | Signals, standalone components, zoneless change detection, Vitest |
| Web Components | Shadow DOM, custom elements, framework-agnostic embedding |

## Context

Task: $ARGUMENTS

Current cycle: **1 of 3**

## Task Type Parsing

Parse the prefix from `$ARGUMENTS` to determine task type:

| Prefix | Task Type | Primary Agent Focus | Reviewer Focus |
|--------|-----------|---------------------|----------------|
| `fix:` | Bug Fix | Root cause analysis, minimal change, regression prevention | Side effects, regression risk, test covers specific bug |
| `feat:` | Feature | Design, component composition, extensibility | Architecture fit, component design, comprehensive test coverage |
| `refactor:` | Refactor | Code quality, maintainability, no behavior change | No regression, same behavior, improved structure |
| *(none)* | Generic | Infer from description | Standard review |

## Workflow

### Phase 1: Primary Implementation

Summon **@agent-aiee-frontend-engineer** to implement the changes.

**Adjust focus based on task type:**

- **fix:** Find root cause first. Implement minimal fix. Avoid unrelated changes. Add regression test.
- **feat:** Consider component design before coding. Ensure composability. Follow framework patterns. Add comprehensive tests.
- **refactor:** Preserve existing behavior exactly. Improve structure/readability. No functional changes. Maintain test coverage.

**Framework-specific guidance:**

- **Angular 21+:** Use signals, standalone components, zoneless change detection, modern control flow (@if, @for)
- **Web Components:** Shadow DOM considerations, custom element lifecycle, framework-agnostic patterns

Wait for completion before proceeding to Phase 2.

### Phase 2: Architecture, Accessibility & Security Review (Parallel)

Launch 2 reviewers **in parallel** (single message, multiple Task tool calls):

**How parallel execution works:**
When you summon multiple agents in one orchestrator message, Claude Code runs them concurrently:

```
Orchestrator invokes both agents simultaneously:
├─ Task 1: aiee-frontend-engineer (starts immediately)
└─ Task 2: aiee-security-engineer (starts immediately)

Both complete independently, then orchestrator proceeds to Phase 3
```

**Critical:** Use multiple Task tool calls in a SINGLE message. Do NOT send separate messages or wait between agents.

1. **@agent-aiee-frontend-engineer** (Frontend Architecture, Patterns & Accessibility)
   - Focus: Framework patterns, component architecture, state management, accessibility
   - Review for Angular 21+: Signals, standalone components, zoneless patterns, modern control flow
   - Accessibility: ARIA attributes, keyboard navigation, screen reader support, focus management
   - Visual: Responsive design, cross-browser compatibility, user flows
   - **fix:** Is the fix idiomatic? Accessible? Any visual regression?
   - **feat:** Component design composable? Framework patterns followed? WCAG compliant?
   - **refactor:** Cleaner structure? No UX/accessibility regression?
   - Output: Recommendations, optimizations, accessibility issues

2. **@agent-aiee-security-engineer** (Security & Compliance)
   - Focus: Frontend security, auth flows, compliance (SOC 2, GDPR)
   - Review: XSS prevention, CSRF protection, secure cookie handling, token refresh
   - Angular-specific: Sanitization, template security, HTTP interceptor patterns
   - Web Components: Shadow DOM security boundaries, script injection prevention
   - **fix:** Does fix close the vulnerability completely?
   - **feat:** What's the attack surface of new functionality?
   - **refactor:** No security regression from restructure?
   - Output: Security issues and compliance gaps

Wait for both reviewers to complete before proceeding to Phase 3.

### Phase 3: Test Enforcement Gate (Sequential)

Only after Phase 2 completes, summon:

3. **@agent-test-enforcement-reviewer**
   - Focus: Quality gate - 80% coverage, naming conventions, behavioral tests
   - Review: Test coverage, `test__<what>__<expected>` naming, tautological tests
   - E2E validation: Critical user paths covered (Playwright/Vitest for component testing)
   - **fix:** Test must reproduce the bug and verify the fix
   - **feat:** Comprehensive coverage of new functionality (happy path + edge cases)
   - **refactor:** Existing tests still pass, no coverage regression
   - Output: PASS/CONDITIONAL PASS/FAIL

**This is a quality gate. Must achieve PASS or CONDITIONAL PASS to proceed.**

### Phase 4: Consolidation

After all 3 reviewers complete, collect feedback into:

**✅ Approved:**
- [Items that passed all reviews]

**⚠️ Issues Found:**
- **Frontend Architecture & Accessibility:** [Framework patterns, component composition, ARIA violations, responsive issues]
- **Security:** [XSS risks, auth issues, compliance requirements]
- **Test Enforcement:** [Coverage gaps, naming violations, test quality]

**🚫 Blockers:**
- [Critical security vulnerabilities - must fix]
- [Critical accessibility violations (WCAG A) - must fix]
- [Test gate FAIL - must fix before proceeding]
- [Other problems requiring user decision]

### Phase 5: Iteration Decision

**If test enforcement = FAIL or critical security/accessibility issues:**
- Must address blockers before continuing
- Return to Phase 1 automatically with critical issues prioritized

**If test enforcement = PASS or CONDITIONAL PASS and no critical blockers:**
Ask user: **"Continue to cycle 2?"** (max 3 cycles)

**If YES:**
- Update cycle counter
- Return to Phase 1 with consolidated feedback
- aiee-frontend-engineer addresses remaining issues

**If NO or max cycles reached:**
- Export final summary
- Mark approved items
- Document any unresolved recommendations (non-blocking)

## Notes

- **Task type prefix**: Adjusts agent focus (fix/feat/refactor)
- **Two-phase gating**: Architecture + accessibility + security first, then test enforcement
- **Combined frontend review**: aiee-frontend-engineer handles both framework patterns AND accessibility (leverages frontend-accessibility skill)
- **Test reviewer is final gate**: Must pass before iteration approval
- **Security can block**: Critical security issues prevent progression
- **Accessibility can block**: WCAG A violations are critical blockers
- **Parallel execution** in Phase 2: Use single message with 2 Task tool calls
- **Sequential execution** in Phase 3: Wait for Phase 2 completion
- **Manual cycle tracking**: User confirms each iteration (unless blockers found)
- **Context threading**: Each cycle includes previous feedback from all 3 reviewers
- **Early exit**: Stop if test gate passes, no security issues, and no new issues found
- **Bundle size awareness**: Monitor impact on bundle size for production deployments
