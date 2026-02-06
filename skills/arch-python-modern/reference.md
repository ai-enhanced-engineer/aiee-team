# Modern Python Standards - Reference

## Type Hints (Deep Dive)

### Basic Patterns

```python
# Function signatures
def greet(name: str) -> str:
    return f"Hello, {name}"

# Optional/nullable (Python 3.10+)
def find_user(id: int) -> User | None:
    ...

# Collections (Python 3.9+)
def process(items: list[str], mapping: dict[str, int]) -> set[str]:
    ...
```

### Advanced Patterns

```python
from typing import TypeVar, Callable, ParamSpec

T = TypeVar("T")
P = ParamSpec("P")

# Generic functions
def first(items: list[T]) -> T | None:
    return items[0] if items else None

# Callable types
def retry(func: Callable[P, T], *args: P.args, **kwargs: P.kwargs) -> T:
    ...

# TypedDict for structured dicts
from typing import TypedDict

class UserDict(TypedDict):
    name: str
    age: int
    email: str | None
```

### Protocol for Structural Typing

```python
from typing import Protocol

class Readable(Protocol):
    def read(self, n: int = -1) -> str: ...

def process_readable(r: Readable) -> str:
    return r.read()
```

## Dataclasses

### Basic Usage

```python
from dataclasses import dataclass, field

@dataclass
class User:
    name: str
    email: str
    age: int = 0
    tags: list[str] = field(default_factory=list)
```

### Immutable Dataclasses

```python
@dataclass(frozen=True)
class Point:
    x: float
    y: float

    def distance(self, other: "Point") -> float:
        return ((self.x - other.x)**2 + (self.y - other.y)**2)**0.5
```

### Dataclass vs Pydantic

| Use Case | Choice |
|----------|--------|
| Internal data structures | dataclass |
| API validation | Pydantic |
| Configuration | Pydantic |
| Domain entities | dataclass |
| Serialization needed | Pydantic |

## Async Patterns

### Basic Async/Await

```python
import asyncio

async def fetch_data(url: str) -> dict:
    async with aiohttp.ClientSession() as session:
        async with session.get(url) as response:
            return await response.json()
```

### Concurrent Operations

```python
# Gather multiple operations
async def fetch_all(urls: list[str]) -> list[dict]:
    results = await asyncio.gather(
        *[fetch_data(url) for url in urls],
        return_exceptions=True
    )
    return [r for r in results if not isinstance(r, Exception)]
```

### TaskGroup (Python 3.11+)

```python
async def process_items(items: list[str]) -> list[Result]:
    results = []
    async with asyncio.TaskGroup() as tg:
        for item in items:
            tg.create_task(process_item(item, results))
    return results
```

### Async Context Managers

```python
from contextlib import asynccontextmanager

@asynccontextmanager
async def get_connection():
    conn = await create_connection()
    try:
        yield conn
    finally:
        await conn.close()
```

## Path Handling

### pathlib Basics

```python
from pathlib import Path

# Construction
config_dir = Path.home() / ".config" / "myapp"
data_file = Path(__file__).parent / "data" / "config.json"

# Operations
if data_file.exists():
    content = data_file.read_text()
    data_file.write_text(modified_content)

# Iteration
for py_file in Path("src").rglob("*.py"):
    print(py_file.name)
```

### Common Operations

```python
path = Path("/some/path/file.txt")

path.name          # "file.txt"
path.stem          # "file"
path.suffix        # ".txt"
path.parent        # Path("/some/path")
path.is_file()     # True/False
path.is_dir()      # True/False
path.resolve()     # Absolute path
```

## Error Handling

### Specific Exceptions

```python
# Bad
try:
    do_something()
except:  # Catches everything including KeyboardInterrupt
    pass

# Good
try:
    do_something()
except ValueError as e:
    logger.warning(f"Invalid value: {e}")
except FileNotFoundError:
    logger.error("Config file missing")
```

### Custom Exceptions

```python
class DomainError(Exception):
    """Base exception for domain errors."""
    pass

class InvalidOrderError(DomainError):
    """Raised when order validation fails."""
    def __init__(self, order_id: str, reason: str):
        self.order_id = order_id
        self.reason = reason
        super().__init__(f"Order {order_id} invalid: {reason}")
```

### Context Managers

```python
from contextlib import contextmanager

@contextmanager
def transaction(conn):
    try:
        yield conn
        conn.commit()
    except Exception:
        conn.rollback()
        raise
    finally:
        conn.close()
```

## Docstring Guidelines

### Core Principle

Write meaningful, non-redundant docstrings that add value beyond what's clear from code.

### Do NOT Write Docstrings For:
- `__init__` methods with self-explanatory parameters
- Simple getter/setter methods
- Abstract methods that just repeat type annotations
- Functions where name + type hints make purpose obvious

### DO Write Docstrings For:
- Module-level descriptions (file purpose and context)
- Complex business logic or algorithms
- Methods with side effects or special behaviors
- Non-obvious return conditions (e.g., returns None on failure)
- Public APIs that other developers use

### Format Standards

```python
# GOOD - Meaningful module docstring
"""Authentication utilities with JWT token validation and refresh logic."""

# GOOD - Explains non-obvious behavior
def retry_with_backoff(func, max_attempts=3):
    """Execute function with exponential backoff, returning None on permanent failure."""

# BAD - Redundant, restates type signature
def get_user(user_id: int) -> User:
    """Get a user by ID.

    Args:
        user_id: The user ID

    Returns:
        User object
    """

# GOOD - No docstring needed, purpose is clear
def get_user(user_id: int) -> User:
    return database.users.find_by_id(user_id)
```

### Guidelines
- Prefer single-line descriptions when purpose is clear
- Avoid Args/Returns sections that repeat type annotations
- Focus on "why" and "what" rather than "how"
- Use imperative mood ("Validate input" not "Validates input")

## Tooling Configuration

### pyproject.toml

```toml
[project]
name = "myproject"
version = "0.1.0"
requires-python = ">=3.10"

[tool.ruff]
target-version = "py310"
line-length = 88

[tool.ruff.lint]
select = ["E", "F", "I", "N", "W", "UP"]

[tool.mypy]
python_version = "3.10"
strict = true

[tool.pytest.ini_options]
testpaths = ["tests"]
addopts = "-v --cov=src"
```

### Common Commands

```bash
# Package management
uv add package
uv add --dev pytest mypy ruff

# Linting and formatting
ruff check .
ruff format .

# Type checking
mypy src/

# Testing
pytest
pytest --cov=src --cov-report=html
```
