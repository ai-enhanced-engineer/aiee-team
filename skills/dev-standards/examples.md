# Development Standards Examples

## Pre-Commit Workflow

```bash
# 1. Stage changes
git add -p  # Review each hunk

# 2. Validate before commit
make validate-branch

# 3. If validation passes, commit
git commit -m "feat: add user authentication"

# 4. Push after user approval
git push origin feature-branch
```

## Documentation Organization Example

**Scenario:** Multiple Redis-related analyses over time

```bash
# Before (messy root)
docs/
├── REDIS_ANALYSIS.md
├── REDIS_ALTERNATIVES.md
├── REDIS_COST_INVESTIGATION.md
├── REDIS_UPSTASH_EVAL.md
└── ... 20 other files

# After (organized)
docs/
├── redis/
│   ├── ANALYSIS_REPORT.md
│   ├── COST_INVESTIGATION.md
│   ├── ALTERNATIVES.md
│   └── UPSTASH_EVALUATION.md
└── ... other organized folders
```

## Test Example

```python
import pytest
from myapp.validators import validate_email

class TestValidateEmail:
    """Tests for email validation function."""

    def test__validate_email__returns_true_for_valid_email(self):
        """Test that validate_email returns True for valid format."""
        assert validate_email("user@example.com") is True

    def test__validate_email__returns_false_for_missing_at(self):
        """Test that validate_email returns False when @ is missing."""
        assert validate_email("userexample.com") is False

    def test__validate_email__returns_false_for_empty_string(self):
        """Test that validate_email returns False for empty input."""
        assert validate_email("") is False

    @pytest.mark.parametrize("invalid_email", [
        "not-an-email",
        "@nodomain.com",
        "spaces in@email.com",
    ])
    def test__validate_email__returns_false_for_invalid_formats(self, invalid_email):
        """Test that validate_email returns False for various invalid formats."""
        assert validate_email(invalid_email) is False
```

## Dev Server Restart Script

```bash
#!/bin/bash
# restart-dev.sh - Quick dev server restart

# Kill existing processes
pkill -f "vite" 2>/dev/null
pkill -f "webpack" 2>/dev/null
pkill -f "next dev" 2>/dev/null

# Wait for ports to free
sleep 1

# Restart (adjust for your project)
npm run dev
```
