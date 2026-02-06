# Domain-Driven Architecture Examples

## Domain Model Examples

### Entity with Rich Behavior

```python
from dataclasses import dataclass
from typing import Optional
from datetime import date

@dataclass
class OrderLine:
    """Value Object - immutable, equality by attributes."""
    orderid: str
    sku: str
    qty: int


class Batch:
    """Entity - identity by reference, contains behavior."""

    def __init__(self, ref: str, sku: str, qty: int, eta: Optional[date] = None):
        self.reference = ref
        self.sku = sku
        self._purchased_quantity = qty
        self.eta = eta
        self._allocations: set[OrderLine] = set()

    def __eq__(self, other):
        if not isinstance(other, Batch):
            return False
        return self.reference == other.reference

    def __hash__(self):
        return hash(self.reference)

    def allocate(self, line: OrderLine) -> None:
        """Business logic lives in the domain."""
        if self.can_allocate(line):
            self._allocations.add(line)

    def can_allocate(self, line: OrderLine) -> bool:
        """Encapsulate business rules."""
        return self.sku == line.sku and self.available_quantity >= line.qty

    @property
    def available_quantity(self) -> int:
        """Derived properties express business concepts."""
        return self._purchased_quantity - sum(line.qty for line in self._allocations)
```

### Value Object with Behavior

```python
from dataclasses import dataclass
from decimal import Decimal

@dataclass(frozen=True)
class Money:
    """Immutable value object with domain logic."""
    amount: Decimal
    currency: str

    def add(self, other: "Money") -> "Money":
        if self.currency != other.currency:
            raise ValueError(f"Cannot add {self.currency} to {other.currency}")
        return Money(self.amount + other.amount, self.currency)

    def multiply(self, factor: int) -> "Money":
        return Money(self.amount * factor, self.currency)
```

## Repository Examples

### Abstract Repository

```python
from abc import ABC, abstractmethod
from typing import Optional

class AbstractBatchRepository(ABC):
    @abstractmethod
    def add(self, batch: Batch) -> None:
        raise NotImplementedError

    @abstractmethod
    def get(self, reference: str) -> Optional[Batch]:
        raise NotImplementedError

    @abstractmethod
    def find_by_sku(self, sku: str) -> list[Batch]:
        raise NotImplementedError
```

### Fake Repository for Testing

```python
class FakeBatchRepository(AbstractBatchRepository):
    """In-memory repository for fast unit tests."""

    def __init__(self):
        self._batches: set[Batch] = set()

    def add(self, batch: Batch) -> None:
        self._batches.add(batch)

    def get(self, reference: str) -> Optional[Batch]:
        return next(
            (b for b in self._batches if b.reference == reference),
            None
        )

    def find_by_sku(self, sku: str) -> list[Batch]:
        return [b for b in self._batches if b.sku == sku]
```

## Unit of Work Examples

### Abstract Unit of Work

```python
from abc import ABC, abstractmethod

class AbstractUnitOfWork(ABC):
    batches: AbstractBatchRepository

    def __enter__(self):
        return self

    def __exit__(self, *args):
        self.rollback()

    @abstractmethod
    def commit(self):
        raise NotImplementedError

    @abstractmethod
    def rollback(self):
        raise NotImplementedError
```

### Fake Unit of Work

```python
class FakeUnitOfWork(AbstractUnitOfWork):
    def __init__(self):
        self.batches = FakeBatchRepository()
        self.committed = False

    def commit(self):
        self.committed = True

    def rollback(self):
        pass
```

## Test Examples

### Unit Test for Domain Logic

```python
def test__batch_allocation__reduces_available_quantity():
    batch = Batch("batch-001", "SMALL-TABLE", qty=20)
    line = OrderLine("order-ref", "SMALL-TABLE", 2)

    batch.allocate(line)

    assert batch.available_quantity == 18


def test__batch_allocation__idempotent():
    batch = Batch("batch-001", "SMALL-TABLE", qty=20)
    line = OrderLine("order-ref", "SMALL-TABLE", 2)

    batch.allocate(line)
    batch.allocate(line)  # Same line again

    assert batch.available_quantity == 18  # Only allocated once
```

### Service Layer Test with Fake

```python
def test__allocate__returns_batch_reference():
    uow = FakeUnitOfWork()
    uow.batches.add(Batch("b1", "COMPLICATED-LAMP", 100))

    result = allocate("o1", "COMPLICATED-LAMP", 10, uow)

    assert result == "b1"
    assert uow.committed
```
