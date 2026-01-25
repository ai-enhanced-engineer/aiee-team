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

---

## Integration Tests for Session Lifecycle

### When Integration Tests Are Required

**CRITICAL**: Any code creating fresh DB sessions for database operations MUST have integration tests with real database.

### Why Unit Tests Fail to Catch Session Issues

Unit tests with mocked `db.commit()` don't catch:
- **MissingGreenlet errors** from cross-session entity usage
- **Greenlet context initialization** issues
- **Lazy-loading relationship** failures
- **RLS context** not being set correctly

**Example of what unit tests miss:**

```python
# Unit test (PASSES but doesn't catch the bug)
async def test__finalize_stream__saves_result(mock_db):
    mock_db.commit = AsyncMock()  # Mocked commit doesn't spawn greenlets

    await finalize_stream(mock_db, session, customer)

    mock_db.commit.assert_called_once()  # ✅ Passes
    # But doesn't catch that 'customer' is bound to wrong session!
```

```python
# Integration test (FAILS - catches the bug)
@pytest.mark.integration
async def test__finalize_stream__with_real_db(real_db_factory):
    async with real_db_factory() as db1:
        customer = await create_test_customer(db1)
        session = await create_test_session(db1)
        await db1.commit()

    # Fresh session (simulates finalization scenario)
    async with real_db_factory() as db2:
        # This raises MissingGreenlet in production but unit test missed it
        await finalize_stream(db2, session, customer)  # ❌ MissingGreenlet!
```

### Integration Test Patterns

#### Pattern 1: Cross-Session Entity Workflow

Test that entities are properly reloaded across sessions:

```python
@pytest.mark.integration
async def test__cross_session_workflow__reloads_entities(real_db_factory):
    """Regression test: Ensure entities are reloaded in fresh sessions."""

    # Session 1: Create entities
    async with real_db_factory() as db1:
        customer = await customer_repo.create(db1, CustomerEntity(...))
        session = await session_repo.create(db1, SessionEntity(...))
        await db1.commit()

    # Session 2: Use entities (must reload)
    async with real_db_factory() as db2:
        # MUST reload - can't reuse from db1
        reloaded_session = await session_repo.get_by_id(db2, session.id)
        reloaded_customer = await customer_repo.get_by_id(db2, customer.id)

        # Test that commit works with properly reloaded entities
        await chat_service.save_stream_result(
            db2, reloaded_session, reloaded_customer, ...
        )
        await db2.commit()  # Should NOT raise MissingGreenlet
```

#### Pattern 2: RLS Context Verification

Test that tenant context is correctly set on fresh sessions (applicable to multi-tenant apps with Row-Level Security):

```python
@pytest.mark.integration
async def test__fresh_session__sets_rls_context(real_db_factory):
    """Verify RLS context is set when creating fresh sessions."""
    async with real_db_factory() as db:
        tenant = await create_test_tenant(db)  # or create_test_customer
        await db.commit()

    # Fresh session for handling requests
    async with real_db_factory() as fresh_db:
        # Set tenant context (e.g., set_tenant_context for RLS)
        await set_tenant_context(fresh_db, str(tenant.id))

        # Verify context is active (query should succeed and return filtered results)
        sessions = await session_repo.list_for_tenant(fresh_db, tenant.id)

        # Should only return this tenant's data
        assert all(s.tenant_id == tenant.id for s in sessions)
```

#### Pattern 3: Streaming Finalization

Test the complete lifecycle of streaming endpoints (WebSocket, SSE, chunked HTTP responses):

```python
@pytest.mark.integration
async def test__websocket_stream__persists_messages_after_streaming(
    real_db_factory,
    mock_stream_client  # Assumes test fixture defined in conftest.py
):
    """Full lifecycle: stream response + finalize with fresh session."""

    # Setup: Create tenant and session in request session
    async with real_db_factory() as request_db:
        tenant = await create_test_tenant(request_db)
        session = await create_test_session(request_db, tenant.id)
        await request_db.commit()

    # Stream response (no DB operations during streaming)
    chunks = []
    async for chunk in stream_response(session.id, "Hello"):
        chunks.append(chunk)

    # Finalize: Fresh session for persistence
    async with real_db_factory() as finalize_db:
        # Reload entities in fresh session (CRITICAL: prevents MissingGreenlet)
        reloaded_session = await session_repo.get_by_id(finalize_db, session.id)
        reloaded_tenant = await tenant_repo.get_by_id(finalize_db, tenant.id)

        # Set tenant context (for multi-tenant apps with RLS)
        await set_tenant_context(finalize_db, str(reloaded_tenant.id))

        # Save accumulated response
        accumulated_content = "".join(c["content"] for c in chunks)
        await save_message(
            finalize_db,
            reloaded_session,
            accumulated_content
        )
        await finalize_db.commit()  # Should succeed

    # Verify: Messages persisted correctly
    async with real_db_factory() as verify_db:
        messages = await message_repo.list_for_session(verify_db, session.id)
        assert len(messages) == 1
        assert messages[0].content == accumulated_content
```

### Fixture Setup for Real Database Tests

```python
# conftest.py
import pytest
from sqlalchemy.ext.asyncio import create_async_engine, async_sessionmaker

@pytest.fixture(scope="session")
async def test_db_engine():
    """Create test database engine (session scope)."""
    engine = create_async_engine(
        "postgresql+asyncpg://test:test@localhost/test_db",
        echo=False
    )

    # Create tables
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)

    yield engine

    # Cleanup
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.drop_all)

    await engine.dispose()

@pytest.fixture
async def real_db_factory(test_db_engine):
    """Factory for creating fresh database sessions."""
    session_factory = async_sessionmaker(
        bind=test_db_engine,
        expire_on_commit=False
    )

    def factory():
        return session_factory()

    return factory
```

### When to Write Integration Tests

| Scenario | Requires Integration Test | Reason |
|----------|---------------------------|--------|
| **Fresh session created** | ✅ Yes | Cross-session entity usage bugs |
| **RLS context setting** | ✅ Yes | Verify tenant isolation works |
| **Streaming endpoints** | ✅ Yes | Session lifecycle complexity |
| **Background tasks** | ✅ Yes | Different process/session context |
| **Simple CRUD** | ⚠️ Optional | Unit tests may be sufficient |
| **Pure business logic** | ❌ No | No database session complexity |

### Test Markers

```python
# pytest.ini or pyproject.toml
[tool.pytest.ini_options]
markers = [
    "unit: Fast isolated tests with mocks",
    "integration: Tests with real database/external services",
    "e2e: Full end-to-end workflow tests"
]
```

Run subsets:

```bash
# Fast unit tests only (CI on every commit)
pytest -m unit

# Integration tests (CI before merge)
pytest -m integration

# Full suite (nightly or pre-release)
pytest
```

### Detection Heuristic

**If your code:**
- Creates a fresh `async with session_factory() as db:` block
- Passes entities between sessions
- Sets RLS context manually
- Handles WebSocket/SSE/streaming with DB persistence

**Then you MUST:**
- Write an integration test with real database
- Test the complete session lifecycle
- Verify entities are reloaded correctly
- Confirm tenant context is set properly

**Prevention:** Integration tests are non-negotiable for preventing production `MissingGreenlet` errors and RLS bypass vulnerabilities.