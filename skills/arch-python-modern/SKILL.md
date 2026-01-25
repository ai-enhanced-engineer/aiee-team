---
name: arch-python-modern
description: Modern Python 3.10+ development standards including type hints, async patterns, pathlib, dataclasses, and recommended tooling (uv, Ruff, pytest). Use for Python code review, new feature implementation, refactoring legacy code, or making architecture decisions about Python projects.
allowed-tools: Read, Grep, Glob
---

# Modern Python Standards

Development practices for Python 3.10+ focusing on type safety, modern idioms, and efficient tooling.

## Core Defaults

```python
# Always use modern patterns
from pathlib import Path
from typing import Any
from dataclasses import dataclass

def process(items: list[dict[str, Any]]) -> dict[str, int] | None:
    config_path = Path("config.json")
    return {"count": len(items)} if items else None
```

## Recommended Stack

| Category | Tool |
|----------|------|
| Package Management | uv (preferred) or Poetry |
| Linting/Formatting | Ruff |
| Type Checking | mypy (strict mode) |
| Testing | pytest with coverage |
| Web APIs | FastAPI |
| Data Processing | Polars or Pandas |

## Key Patterns

### Type Hints
- All public functions must have type hints
- Use `X | None` for nullable values (3.10+)
- Prefer `list[X]` over `List[X]` (3.9+)
- Use `TypeVar` for generic functions

### Async
- Use `asyncio` with modern patterns
- Avoid blocking in async contexts
- `asyncio.gather()` for concurrent operations
- `asyncio.TaskGroup` for structured concurrency (3.11+)

### Path Handling
- Always `pathlib.Path` over `os.path`
- Use `.read_text()`, `.write_text()`
- Proper path resolution, no hardcoding

### Error Handling
- Specific exceptions, never bare `except:`
- Context managers for resources
- Proper logging with structlog

## Anti-Patterns to Avoid

| Bad | Good |
|-----|------|
| `os.path.join()` | `Path() / "file"` |
| `%` formatting | f-strings |
| `pip install` | `uv add` |
| `flake8` | `Ruff` |
| `List[str]` | `list[str]` |
| `Optional[X]` | `X \| None` |
| Mutable default args | `field(default_factory=list)` |

See `reference.md` for detailed patterns and `examples.md` for code samples.
