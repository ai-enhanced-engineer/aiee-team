# Unit Test Standards - Reference

Detailed patterns for writing and reviewing Python tests.

## Naming Convention Deep Dive

### Unit Tests: `test__<what>__<expected>`

| Component | Purpose | Example |
|-----------|---------|---------|
| `<what>` | Function/method/behavior being tested | `batch_allocation`, `user_creation` |
| `<expected>` | Expected outcome or state change | `reduces_available_quantity`, `returns_user_id` |

**Good names:**
- `test__allocate_line__reduces_batch_quantity`
- `test__parse_date__returns_none_for_invalid_format`
- `test__calculate_total__includes_tax_when_applicable`

**Bad names:**
- `test_something` - What is being tested?
- `test_it_works` - What is "it"? What is "works"?
- `test_1`, `test_function` - No information

### Integration Tests: `test__<component>__<behavior>`

Tests that cross boundaries (database, network, filesystem):
- `test__repository__persists_aggregate_with_events`
- `test__api_client__retries_on_transient_failure`
- `test__cache__expires_after_ttl`

### E2E Tests: `test__<use_case>__<scenario>`

Full workflow tests:
- `test__checkout_flow__completes_with_valid_payment`
- `test__user_registration__sends_confirmation_email`
- `test__order_allocation__handles_out_of_stock`

## Tautological Test Detection

### Pattern 1: Testing Mock Return Values

```python
# BAD - Tests nothing, mock returns what you configured
def test__get_user__returns_user():
    mock_repo = Mock()
    mock_repo.get.return_value = User(id=1, name="Test")
    service = UserService(mock_repo)

    result = service.get_user(1)

    assert result.name == "Test"  # Tautology! Just asserting mock config
```

**Detection:** Look for `Mock()` + `return_value` + assertion on that same value.

### Pattern 2: Testing Assignment

```python
# BAD - Tests Python's assignment operator
def test__user__has_name():
    user = User(name="Alice")
    assert user.name == "Alice"  # Tautology! Tests nothing
```

**Detection:** Constructor arg directly asserted without transformation.

### Pattern 3: No Meaningful Assertions

```python
# BAD - No assertion
def test__process__runs():
    processor = Processor()
    processor.process()  # Just runs, asserts nothing

# BAD - Trivial assertion
def test__list__is_list():
    result = get_items()
    assert isinstance(result, list)  # Doesn't test content
```

**Detection:** Missing `assert`, or only type/truthy checks.

### Pattern 4: Testing Implementation Details

```python
# BAD - Tests HOW not WHAT
def test__save_user__calls_repository():
    mock_repo = Mock()
    service = UserService(mock_repo)

    service.save(User(name="Test"))

    mock_repo.save.assert_called_once()  # Tests wiring, not behavior
```

**Detection:** `assert_called*` without verifying observable outcomes.

### Pattern 5: Hardcoded Expected Values (Tautological Assertions)

```python
# BAD - Hardcoded expectation always passes
def test__get_conversation_count__returns_count():
    result = await analytics_service.get_summary(db, customer_id)
    assert result["conversation_count"] == 47  # ❌ Hardcoded value!
```

**Why This Fails:**
- Test always passes as long as implementation returns 47
- Doesn't validate actual business logic (counting conversations)
- If implementation has a bug that always returns 47, test still passes
- Provides false confidence in correctness

**Real-World Example:**

```python
# Implementation (WRONG but test passes)
async def get_summary(db, customer_id):
    # Bug: Hardcoded return value
    return {"conversation_count": 47, "visitor_count": 23}

# Test (passes despite implementation bug)
def test__get_summary__returns_data():
    result = await service.get_summary(db, "cust-123")
    assert result["conversation_count"] == 47  # ✅ Passes!
    assert result["visitor_count"] == 23  # ✅ Passes!
```

**GOOD - Behavioral Assertions:**

Test structure and types, not specific values:

```python
def test__get_summary__returns_conversation_count():
    # Arrange: Create test data
    await create_test_conversations(db, customer_id, count=5)

    # Act
    result = await analytics_service.get_summary(db, customer_id)

    # Assert: Verify structure and reasonable bounds
    assert isinstance(result["conversation_count"], int)
    assert result["conversation_count"] >= 0  # Validate non-negative
    # Or validate against known test data:
    assert result["conversation_count"] == 5  # ✅ Based on test setup
```

**When Specific Values Are OK:**

1. **Test Data Setup** - When you control the preconditions:
   ```python
   # Create 3 conversations
   await create_conversations(db, count=3)
   result = await service.get_summary(db, customer_id)
   assert result["conversation_count"] == 3  # ✅ Based on setup
   ```

2. **Domain Invariants** - Testing business rules with known inputs:
   ```python
   order = Order(items=[Item(price=100), Item(price=50)])
   assert order.total == 150  # ✅ Validates calculation
   ```

3. **Fixed Reference Data** - Constants or configuration:
   ```python
   assert config.MAX_RETRIES == 3  # ✅ Validates config value
   ```

**Detection Checklist:**

- [ ] Does the assertion use a magic number not derived from test setup?
- [ ] If I change the hardcoded value, does the test still conceptually make sense?
- [ ] Is the test validating behavior or just documenting current output?

**Related Anti-Pattern:** JWT token fixtures missing required fields (e.g., `customer_id`) cause integration tests to fail with authentication errors even though unit tests pass.

## Behavioral Test Patterns

### Arrange-Act-Assert (AAA)

```python
def test__batch_allocation__reduces_available_quantity():
    # Arrange - Set up preconditions
    batch = Batch(sku="LAMP", qty=100)
    line = OrderLine(sku="LAMP", qty=10)

    # Act - Perform the action
    batch.allocate(line)

    # Assert - Verify outcomes
    assert batch.available_quantity == 90
```

### Testing State Changes

```python
def test__order__transitions_to_paid_on_payment():
    # Arrange
    order = Order(items=[Item(price=100)])

    # Act
    order.mark_paid(payment_ref="PAY-123")

    # Assert - Verify state changed
    assert order.status == OrderStatus.PAID
    assert order.payment_reference == "PAY-123"
    assert order.paid_at is not None
```

### Testing Exceptions

```python
def test__withdraw__raises_on_insufficient_funds():
    account = Account(balance=100)

    with pytest.raises(InsufficientFunds) as exc_info:
        account.withdraw(150)

    assert exc_info.value.available == 100
    assert exc_info.value.requested == 150
```

### Testing Invariants

```python
def test__batch_allocation__cannot_exceed_quantity():
    batch = Batch(sku="LAMP", qty=10)
    line = OrderLine(sku="LAMP", qty=15)

    with pytest.raises(OutOfStock):
        batch.allocate(line)

    # Invariant: quantity unchanged on failure
    assert batch.available_quantity == 10
```

## Coverage Guidelines

### What 80% Coverage Means

- 80% of **lines** executed during tests
- Does NOT mean 80% of **behaviors** tested
- Coverage is necessary but not sufficient

### What to Exclude

```ini
# pyproject.toml or .coveragerc
[tool.coverage.run]
omit = [
    "*/migrations/*",
    "*/__init__.py",
    "*/conftest.py",
    "*_test.py",
    "tests/*",
]
```

### pytest-cov Configuration

```ini
[tool.pytest.ini_options]
addopts = "--cov=src --cov-report=term-missing --cov-fail-under=80"
```

### Coverage for New Code Only

```bash
# Compare coverage between branches
diff-cover coverage.xml --compare-branch=main --fail-under=80
```

## File Structure Standards

### Mirror Source Structure

```
src/
├── domain/
│   ├── model.py
│   └── services.py
├── adapters/
│   └── repository.py
└── entrypoints/
    └── api.py

tests/
├── unit/
│   ├── domain/
│   │   ├── test_model.py
│   │   └── test_services.py
│   └── adapters/
│       └── test_repository.py
├── integration/
│   └── test_api.py
└── conftest.py
```

### conftest.py Best Practices

```python
# tests/conftest.py - Shared fixtures
import pytest

@pytest.fixture
def sample_user():
    """Reusable test user."""
    return User(id=1, name="Test User", email="test@example.com")

@pytest.fixture
def in_memory_repo():
    """In-memory repository for integration tests."""
    return InMemoryRepository()
```

## Test Independence

Each test must:
1. Set up its own state (Arrange)
2. Not depend on test execution order
3. Clean up after itself (or use fixtures with cleanup)
4. Not share mutable state with other tests

```python
# BAD - Tests depend on shared state
class TestUser:
    user = None  # Shared mutable state!

    def test_create(self):
        self.user = User(name="Test")

    def test_update(self):
        self.user.name = "Updated"  # Depends on test_create running first!
```

```python
# GOOD - Each test is independent
class TestUser:
    def test_create(self):
        user = User(name="Test")
        assert user.name == "Test"

    def test_update(self):
        user = User(name="Test")
        user.name = "Updated"
        assert user.name == "Updated"
```

---

## Test Data Factories (Builder Pattern)

Fluent chainable factories reduce test setup from 15 lines to 2-3 lines:

```python
class UserFactory:
    def __init__(self) -> None:
        self._id = uuid4()
        self._email = f"user-{uuid4().hex[:8]}@example.com"
        self._role = UserRole.VIEWER

    def with_email(self, email: str) -> "UserFactory":
        self._email = email
        return self

    def as_admin(self) -> "UserFactory":
        self._role = UserRole.ADMIN
        return self

    def build_entity(self) -> UserEntity:
        return UserEntity(id=self._id, email=self._email, role=self._role, ...)

    async def create(self, db: FakeDatabaseSession) -> User:
        user = self.build_model()
        db.add(user)
        await db.flush()
        return user

# Usage
admin = await UserFactory().with_email("admin@co.com").as_admin().create(db)
```

### Factory Anti-Pattern: func.lower() Detection

When implementing fakes for SQLAlchemy:

```python
# WRONG attribute check
if hasattr(left, "fn"):  # ❌ Function objects don't have .fn

# RIGHT attribute check
if hasattr(left, "name") and left.name == "lower":  # ✅
```

**Prevention:** Verify third-party library attributes with `dir()` or debugger.

---

## Fresh Clone Test Setup

Always sync dependencies before running tests on fresh clones:

```bash
# WRONG: Tests fail with "pytest not found"
git clone repo && cd repo && just test  # ❌

# RIGHT: Sync dependencies first
git clone repo && cd repo && just sync && just test  # ✅
```
