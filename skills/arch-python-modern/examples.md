# Modern Python Standards - Examples

## Modern Python Project Structure

```
myproject/
├── pyproject.toml
├── src/
│   └── myproject/
│       ├── __init__.py
│       ├── domain/
│       │   ├── __init__.py
│       │   └── model.py
│       ├── service_layer/
│       │   └── services.py
│       └── adapters/
│           └── repository.py
└── tests/
    ├── unit/
    │   └── test_model.py
    └── integration/
        └── test_repository.py
```

## Type-Safe Configuration

```python
from dataclasses import dataclass
from pathlib import Path
import tomllib

@dataclass(frozen=True)
class DatabaseConfig:
    host: str
    port: int
    name: str
    user: str
    password: str

    @property
    def url(self) -> str:
        return f"postgresql://{self.user}:{self.password}@{self.host}:{self.port}/{self.name}"

@dataclass(frozen=True)
class AppConfig:
    debug: bool
    database: DatabaseConfig
    log_level: str = "INFO"

    @classmethod
    def from_toml(cls, path: Path) -> "AppConfig":
        with path.open("rb") as f:
            data = tomllib.load(f)

        return cls(
            debug=data.get("debug", False),
            log_level=data.get("log_level", "INFO"),
            database=DatabaseConfig(**data["database"])
        )
```

## Repository with Type Hints

```python
from abc import ABC, abstractmethod
from dataclasses import dataclass
from typing import TypeVar, Generic
from uuid import UUID

T = TypeVar("T")

class Repository(ABC, Generic[T]):
    @abstractmethod
    async def get(self, id: UUID) -> T | None:
        ...

    @abstractmethod
    async def add(self, entity: T) -> None:
        ...

    @abstractmethod
    async def update(self, entity: T) -> None:
        ...

    @abstractmethod
    async def delete(self, id: UUID) -> None:
        ...


@dataclass
class User:
    id: UUID
    email: str
    name: str


class UserRepository(Repository[User]):
    def __init__(self, session):
        self._session = session

    async def get(self, id: UUID) -> User | None:
        result = await self._session.execute(
            "SELECT * FROM users WHERE id = $1", id
        )
        row = result.fetchone()
        return User(**row) if row else None

    async def add(self, entity: User) -> None:
        await self._session.execute(
            "INSERT INTO users (id, email, name) VALUES ($1, $2, $3)",
            entity.id, entity.email, entity.name
        )

    async def update(self, entity: User) -> None:
        await self._session.execute(
            "UPDATE users SET email = $2, name = $3 WHERE id = $1",
            entity.id, entity.email, entity.name
        )

    async def delete(self, id: UUID) -> None:
        await self._session.execute(
            "DELETE FROM users WHERE id = $1", id
        )
```

## Modern Testing

```python
import pytest
from dataclasses import dataclass
from unittest.mock import AsyncMock, patch

@dataclass
class Order:
    id: str
    total: float
    status: str = "pending"

    def confirm(self) -> None:
        if self.total <= 0:
            raise ValueError("Order total must be positive")
        self.status = "confirmed"


class TestOrder:
    def test__confirm__changes_status(self):
        order = Order(id="123", total=100.0)

        order.confirm()

        assert order.status == "confirmed"

    def test__confirm__raises_on_zero_total(self):
        order = Order(id="123", total=0)

        with pytest.raises(ValueError, match="must be positive"):
            order.confirm()


@pytest.fixture
def mock_api_client():
    client = AsyncMock()
    client.get.return_value = {"id": 1, "name": "Test"}
    return client


@pytest.mark.asyncio
async def test__fetch_user__returns_user(mock_api_client):
    result = await mock_api_client.get("/users/1")

    assert result["name"] == "Test"
    mock_api_client.get.assert_called_once_with("/users/1")
```

## FastAPI with Modern Patterns

```python
from fastapi import FastAPI, HTTPException, Depends
from pydantic import BaseModel, EmailStr
from typing import Annotated
from uuid import UUID, uuid4

app = FastAPI()

class UserCreate(BaseModel):
    email: EmailStr
    name: str

class UserResponse(BaseModel):
    id: UUID
    email: str
    name: str

async def get_repository() -> UserRepository:
    async with get_session() as session:
        yield UserRepository(session)

@app.post("/users", response_model=UserResponse)
async def create_user(
    user: UserCreate,
    repo: Annotated[UserRepository, Depends(get_repository)]
) -> UserResponse:
    new_user = User(
        id=uuid4(),
        email=user.email,
        name=user.name
    )
    await repo.add(new_user)
    return UserResponse(
        id=new_user.id,
        email=new_user.email,
        name=new_user.name
    )

@app.get("/users/{user_id}", response_model=UserResponse)
async def get_user(
    user_id: UUID,
    repo: Annotated[UserRepository, Depends(get_repository)]
) -> UserResponse:
    user = await repo.get(user_id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return UserResponse(
        id=user.id,
        email=user.email,
        name=user.name
    )
```
