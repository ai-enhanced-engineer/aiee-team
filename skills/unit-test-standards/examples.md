# Unit Test Standards - Examples

Before/after comparisons demonstrating good vs bad testing patterns.

## Example 1: Domain Logic Testing

### BAD: Tautological Test

```python
def test__order__has_items():
    """Tests nothing - just verifies assignment works."""
    items = [Item(sku="LAMP", qty=2)]
    order = Order(items=items)

    assert order.items == items  # Tautology!
    assert len(order.items) == 1  # Still tautology!
```

### GOOD: Behavioral Test

```python
def test__order_total__sums_item_prices_with_quantity():
    """Tests actual business logic - price calculation."""
    items = [
        Item(sku="LAMP", price=100, qty=2),
        Item(sku="DESK", price=250, qty=1),
    ]
    order = Order(items=items)

    assert order.total == 450  # 100*2 + 250*1

def test__order_total__applies_discount_when_over_threshold():
    """Tests conditional business rule."""
    items = [Item(sku="LAMP", price=600, qty=1)]
    order = Order(items=items, discount_threshold=500, discount_pct=10)

    assert order.total == 540  # 600 - 10%
```

## Example 2: Service Layer Testing

### BAD: Mock Assertion (Testing Wiring)

```python
def test__user_service__creates_user():
    """Tests that methods are called, not that behavior is correct."""
    mock_repo = Mock()
    mock_repo.save.return_value = User(id=1, name="Test")
    service = UserService(mock_repo)

    result = service.create_user("Test", "test@example.com")

    mock_repo.save.assert_called_once()  # So what?
    assert result.name == "Test"  # Tautology - just mock return
```

### GOOD: Behavior Test with Fake

```python
def test__user_service__persists_user_with_generated_id():
    """Tests actual persistence behavior using a fake."""
    fake_repo = InMemoryUserRepository()
    service = UserService(fake_repo)

    result = service.create_user("Test", "test@example.com")

    # Verify the user was actually persisted
    assert result.id is not None
    persisted = fake_repo.get(result.id)
    assert persisted.name == "Test"
    assert persisted.email == "test@example.com"

def test__user_service__rejects_duplicate_email():
    """Tests business rule enforcement."""
    fake_repo = InMemoryUserRepository()
    fake_repo.add(User(id=1, name="Existing", email="test@example.com"))
    service = UserService(fake_repo)

    with pytest.raises(DuplicateEmail) as exc:
        service.create_user("New", "test@example.com")

    assert exc.value.email == "test@example.com"
```

## Example 3: Error Handling Testing

### BAD: No Assertion

```python
def test__parse_date__handles_invalid():
    """Runs code but doesn't verify behavior."""
    try:
        parse_date("not-a-date")
    except:
        pass  # Catches exception but doesn't verify it!
```

### GOOD: Explicit Exception Testing

```python
def test__parse_date__raises_value_error_for_invalid_format():
    """Explicitly tests exception type and message."""
    with pytest.raises(ValueError) as exc_info:
        parse_date("not-a-date")

    assert "Invalid date format" in str(exc_info.value)
    assert "not-a-date" in str(exc_info.value)

def test__parse_date__returns_none_for_empty_string():
    """Tests graceful handling of empty input."""
    result = parse_date("")

    assert result is None

def test__parse_date__parses_iso_format():
    """Tests happy path with specific format."""
    result = parse_date("2024-03-15")

    assert result.year == 2024
    assert result.month == 3
    assert result.day == 15
```

## Test Report Template

When reviewing tests, use this format:

```markdown
## Test Review: [module_name]

### Coverage
- Lines: X%
- Branches: Y%
- New code: Z%

### Naming Compliance
- [ ] Follows `test__<what>__<expected>` pattern
- [ ] Names describe behavior, not implementation

### Quality Assessment
| Check | Status | Notes |
|-------|--------|-------|
| No tautological tests | PASS/FAIL | |
| Meaningful assertions | PASS/FAIL | |
| AAA structure | PASS/FAIL | |
| Edge cases covered | PASS/FAIL | |
| Error paths tested | PASS/FAIL | |

### Issues Found
1. [Issue description with line reference]
2. [Issue description with line reference]

### Recommendations
- [Specific improvement suggestion]
```
