# Development Standards - Reference

Detailed standards for git, testing, validation, and development environment.

## Git Guidelines

### Commit Conventions

| Type | Use For |
|------|---------|
| `feat:` | New features |
| `fix:` | Bug fixes |
| `docs:` | Documentation changes |
| `test:` | Test additions/changes |
| `refactor:` | Code restructuring |

### Commit Practices

- **Atomic commits**: One logical change per commit
- **Meaningful messages**: Explain WHY, not what
- **No claude signatures**: Never add AI attribution to commits or PRs

### Pre-Commit Checklist

**CRITICAL**: Never declare implementation "complete" without passing ALL validation.

#### Python Projects (Makefile-based)
```bash
make validate-branch    # All checks

# Or individually:
make test              # Run test suite
make type-check        # Check type hints
make lint              # Check code style
```

#### TypeScript/Node Projects
```bash
npm run lint && npm run type-check && npm test

# Or individually:
npm run lint           # ESLint
npm run type-check     # tsc --noEmit
npm test               # Vitest/Jest
```

#### The 2-Minute Rule
Before saying "implementation complete":
- 30 sec: Run linter
- 30 sec: Run type check
- 60 sec: Run tests

If all pass, you're done. If not, fix before proceeding.

### Interface Change Protocol

When changing any shared interface/type:

1. **Find All Usages (2 min)**
   ```bash
   # Python
   grep -r "ClassName" src/ tests/

   # TypeScript
   grep -r "InterfaceName" src/ **/*.test.ts
   ```

2. **Update Implementation (5 min)**
   - Change interface definition
   - Update all implementation code
   - Run type-check (MUST pass)

3. **Update Tests (10 min)**
   - Update test fixtures/mocks
   - Update test assertions
   - Run tests (MUST pass)

4. **Final Validation (2 min)**
   - Run full validation before commit

## Test Naming Convention

```python
# Unit tests: test__<what>__<expected>
def test__batch_allocation__reduces_available_quantity():
    pass

# Integration tests: test__<component>__<behavior>
def test__repository__saves_and_retrieves_batch():
    pass

# E2E tests: test__<use_case>__<scenario>
def test__order_allocation__happy_path():
    pass
```

### Test Quality

- Test true functionalities, avoid tautologies
- Run tests BEFORE and AFTER changes
- Don't accumulate changes without validation

## Common Pitfalls to Avoid

| Pitfall | Solution |
|---------|----------|
| Creating duplicate functionality | Search for existing implementations first |
| Ignoring type hints | MyPy errors are failures, not warnings |
| Skipping error handling | Every external call needs try/except |
| Hardcoding values | Use configuration files or env variables |
| Breaking existing tests | Run tests before AND after changes |
| Assuming file locations | Use proper path resolution |
| JavaScript changes not appearing | Dev server (Vite/Webpack) may cache bundles—restart server, not just browser |

## Development Environment

### Python Projects

- Use virtual environments
- Pin dependencies with exact versions
- Use Docker for complex dependencies
- Maintain `.env.example` files

### Tooling Defaults

| Tool | Purpose |
|------|---------|
| `uv` | Package management (over pip) |
| `Ruff` | Linting (over flake8) |
| `mypy` | Type checking |
| `pytest` | Testing |
| `pathlib` | Path handling (over os.path) |

### Timing and Measurement

Use the correct timing function for the use case:

| Function | Use Case | Example |
|----------|----------|---------|
| `time.perf_counter()` | Elapsed time, performance measurement | Request latency, function timing |
| `time.time()` | Wall-clock time, timestamps | Log timestamps, datetime comparisons |
| `time.monotonic()` | Long-running timeouts, uptime | Connection timeouts, retry backoff |

#### Why `perf_counter()` for Elapsed Time

```python
# ❌ WRONG - can produce negative elapsed times due to NTP adjustments
start = time.time()
do_work()
elapsed = time.time() - start  # Can be negative!

# ✅ CORRECT - monotonic clock, always forward, high precision
from time import perf_counter

start = perf_counter()
await do_work()
elapsed_ms = (perf_counter() - start) * 1000
logger.info("Operation complete", elapsed_ms=round(elapsed_ms, 2))
```

**Why `perf_counter()` is correct:**
- Monotonic clock (always moves forward, immune to NTP)
- Higher precision (nanosecond resolution on most platforms)
- Designed specifically for performance measurements

#### Finally Block for Consistent Measurement

Calculate timing once in `finally` block to avoid duplication:

```python
# ✅ Calculate once in finally block (single source of truth)
start_time = perf_counter()
error_occurred = None
result = None

try:
    result = await operation()
except Exception as e:
    error_occurred = str(e)
finally:
    duration_ms = round((perf_counter() - start_time) * 1000, 2)

# Log based on captured state
if error_occurred:
    logger.error("Failed", duration_ms=duration_ms, error=error_occurred)
else:
    logger.info("Success", duration_ms=duration_ms)
```

**Why `finally` block:**
- Runs in all cases (success, exception, early return)
- Single calculation point eliminates duplication
- Captured state variables allow logging after timing is finalized

### Code Style

- Python 3.10+ features
- Type hints on all functions
- f-strings over % formatting
- dataclasses for internal, Pydantic for APIs

## Validation Requirements

### Before ANY Commit

```bash
make validate-branch
```

This runs:
1. Test suite (`make test`)
2. Type checking (`make type-check`)
3. Linting (`make lint`)

### Before ANY PR

- Ensure all checks pass
- Review changes for consistency
- Verify no secrets committed
- Check conventional commit format

---

## Handling Automated PR Review Feedback

When PR bots raise concerns, validate before acting:

### Validation Protocol

1. **Check Line Numbers** - Navigate to exact line. If doesn't match description → likely false positive
2. **Verify Actual Usage** - Bot claims "unused import" → search for import in file
3. **Run Local Validation** - `make validate-branch` passes → bot likely has stale context
4. **Cross-Reference Tests** - Passing tests > bot speculation

### Common False Positive Patterns

| Bot Claim | Likely Cause | Verification |
|-----------|--------------|--------------|
| "Line N has issue" but N is unrelated | Lines shifted after analysis | Check git blame |
| "Import X unused" but X is used | Bot parsed old version | Search file for usage |
| "Function missing" but tests pass | Incomplete context | Run relevant tests |

---

## Safe Large-Scale Deletion

For removing >500 lines of code:

### Pre-Deletion Checklist

- [ ] Find all references: `grep -r "DeletedClass" src/ tests/`
- [ ] Check imports: `from module import deleted_thing`
- [ ] Check route references (API endpoints, docs, integration tests)
- [ ] Check database dependencies (repositories, migrations)

### Deletion Process

1. Run tests BEFORE deletion (record baseline count)
2. Delete code, imports, references
3. Run tests AFTER deletion (should match baseline)
4. Request parallel review for >1000 lines

### Review Scale Guidelines

| Lines Deleted | Review Approach |
|---------------|-----------------|
| <200 lines | Self-review + tests |
| 200-1000 lines | 1-2 reviewers + tests |
| 1000-5000 lines | Parallel review (3-4 reviewers) |
| >5000 lines | Architecture review + staged rollout |

