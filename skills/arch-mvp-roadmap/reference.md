# MVP & Roadmap Reference

Detailed patterns for effective MVP definition and phased delivery.

## MVP Anti-Patterns

### 1. Feature Creep

**Symptom**: Scope grows without corresponding value validation.

**Example**: "While we're building auth, let's add social login, MFA, and password recovery."

**Fix**: Each feature must tie to a validated assumption. Ask: "Does this prove or disprove our core hypothesis?"

### 2. Premature Optimization

**Symptom**: Investing in scale before proving value.

**Example**: "We need Kubernetes, Redis caching, and CDN before launch."

**Fix**: Build the simplest thing that works. Optimize when you have evidence of need.

### 3. Horizontal Slices

**Symptom**: Building complete layers without end-to-end flow.

**Example**: "Let's finish the entire API before touching the frontend."

**Fix**: Build vertical slices—complete user journeys across all layers.

```
WRONG (Horizontal):          RIGHT (Vertical):
┌────────────────────┐       ┌─────┐ ┌─────┐ ┌─────┐
│     Frontend       │       │ UI  │ │ UI  │ │ UI  │
├────────────────────┤       │     │ │     │ │     │
│       API          │       │ API │ │ API │ │ API │
├────────────────────┤       │     │ │     │ │     │
│     Database       │       │ DB  │ │ DB  │ │ DB  │
└────────────────────┘       └─────┘ └─────┘ └─────┘
                             Flow 1  Flow 2  Flow 3
```

### 4. Gold Plating

**Symptom**: Adding polish before validating core value.

**Example**: "The UI needs to be perfect before we show users."

**Fix**: "Good enough" for validation beats "perfect" that ships late.

### 5. Parallel Development

**Symptom**: Multiple features built simultaneously without integration.

**Example**: "Team A builds auth, Team B builds billing, we'll integrate later."

**Fix**: Complete one flow before starting another. Integration risks compound.

## Vertical Slice Architecture

A vertical slice delivers value by cutting through all layers:

```
User Story: "As a user, I can create and view my profile"

Slice includes:
├── Frontend: Profile form + display component
├── API: POST /profile, GET /profile endpoints
├── Domain: Profile entity, validation rules
├── Database: profiles table, migrations
└── Tests: Unit, integration, e2e for this flow
```

### Benefits

- **Demonstrable progress**: Each slice is user-visible
- **Early integration**: Catch integration issues immediately
- **Flexible scope**: Easy to add/remove slices based on feedback
- **Clear ownership**: Slice = unit of work for one developer

### Slice Sizing

| Size | Characteristics | Timeline |
|------|-----------------|----------|
| **Too small** | No user-visible value | < 1 day |
| **Right size** | One user story, demonstrable | 1-3 days |
| **Too large** | Multiple stories combined | > 1 week |

## Iterative vs Incremental Delivery

### Incremental Delivery

Build complete pieces, add more pieces.

```
Version 1: [Feature A]
Version 2: [Feature A] [Feature B]
Version 3: [Feature A] [Feature B] [Feature C]
```

**Best for**: Well-understood domains, stable requirements.

### Iterative Refinement

Build rough version, refine progressively.

```
Version 1: [Feature A - basic]
Version 2: [Feature A - improved]
Version 3: [Feature A - polished]
```

**Best for**: Unknown domains, evolving requirements.

### Hybrid Approach (Recommended)

Combine both: increment features, iterate quality.

```
MVP:     [A-basic] [B-basic]
Phase 2: [A-improved] [B-improved] [C-basic]
Phase 3: [A-polished] [B-polished] [C-improved]
```

## Success Criteria Patterns

### SMART Criteria

| Component | Example |
|-----------|---------|
| **Specific** | "Users can create accounts" not "Users can use the system" |
| **Measurable** | "< 3 seconds page load" not "Fast page load" |
| **Achievable** | Based on current team capacity |
| **Relevant** | Ties to business goal |
| **Time-bound** | "By end of Phase 1" |

### Examples by Type

**Functional**: "Users can complete purchase flow end-to-end"
**Performance**: "API responds in < 200ms at p95"
**Quality**: "Zero critical bugs in production for 2 weeks"
**Adoption**: "10 beta users complete onboarding"

## Phase Transition Criteria

### Exit Criteria (When to Move On)

- [ ] All features in phase complete and tested
- [ ] Success criteria met
- [ ] No blocking bugs
- [ ] Stakeholder sign-off
- [ ] Documentation updated

### Entry Criteria (When to Start Next Phase)

- [ ] Previous phase deployed to production
- [ ] Feedback collected and analyzed
- [ ] Next phase scope confirmed
- [ ] Team capacity available
- [ ] Dependencies resolved
