# Event-Driven Architecture Examples

## Event and Command Examples

### Base Message Classes

```python
from dataclasses import dataclass


class Event:
    """Base class for domain events."""
    pass


class Command:
    """Base class for commands."""
    pass
```

### Domain Events

```python
@dataclass(frozen=True)
class Allocated(Event):
    """Emitted when an order line is allocated to a batch."""
    orderid: str
    sku: str
    qty: int
    batchref: str


@dataclass(frozen=True)
class OutOfStock(Event):
    """Emitted when allocation fails due to insufficient stock."""
    sku: str
```

### Commands

```python
@dataclass(frozen=True)
class Allocate(Command):
    """Request to allocate an order line."""
    orderid: str
    sku: str
    qty: int


@dataclass(frozen=True)
class CreateBatch(Command):
    """Request to create a new batch."""
    ref: str
    sku: str
    qty: int
    eta: str | None = None
```

## Aggregate with Event Collection

```python
class Product:
    """Aggregate root that collects domain events."""

    def __init__(self, sku: str, batches: list[Batch], version: int = 0):
        self.sku = sku
        self.batches = batches
        self.version = version
        self.events: list[Event] = []  # Event collection

    def allocate(self, line: OrderLine) -> str:
        try:
            batch = next(
                b for b in sorted(self.batches)
                if b.can_allocate(line)
            )
            batch.allocate(line)
            self.version += 1
            # Emit event on successful allocation
            self.events.append(
                Allocated(line.orderid, line.sku, line.qty, batch.reference)
            )
            return batch.reference
        except StopIteration:
            # Emit event on failure
            self.events.append(OutOfStock(line.sku))
            raise OutOfStockError(f"Out of stock for sku {line.sku}")
```

## Message Bus Implementation

```python
from typing import Callable, Union
from collections import deque

Message = Union[Command, Event]


class MessageBus:
    def __init__(
        self,
        uow: AbstractUnitOfWork,
        event_handlers: dict[type[Event], list[Callable]],
        command_handlers: dict[type[Command], Callable],
    ):
        self.uow = uow
        self.event_handlers = event_handlers
        self.command_handlers = command_handlers

    def handle(self, message: Message):
        results = []
        queue = deque([message])

        while queue:
            message = queue.popleft()
            if isinstance(message, Event):
                self._handle_event(message, queue)
            elif isinstance(message, Command):
                result = self._handle_command(message, queue)
                results.append(result)

        return results

    def _handle_event(self, event: Event, queue: deque):
        for handler in self.event_handlers.get(type(event), []):
            try:
                handler(event)
                queue.extend(self.uow.collect_new_events())
            except Exception:
                # Log and continue - events don't fail the whole operation
                continue

    def _handle_command(self, command: Command, queue: deque):
        handler = self.command_handlers[type(command)]
        result = handler(command)
        queue.extend(self.uow.collect_new_events())
        return result
```

## Command and Event Handlers

### Command Handler

```python
def allocate(cmd: Allocate, uow: AbstractUnitOfWork) -> str:
    """Command handler - returns result, raises on failure."""
    line = OrderLine(cmd.orderid, cmd.sku, cmd.qty)

    with uow:
        product = uow.products.get(sku=cmd.sku)
        if product is None:
            raise InvalidSku(f"Invalid sku {cmd.sku}")

        batchref = product.allocate(line)
        uow.commit()

    return batchref
```

### Event Handler

```python
def send_out_of_stock_notification(event: OutOfStock, uow: AbstractUnitOfWork):
    """Event handler - side effect, failures don't propagate."""
    email.send(
        to="stock@example.com",
        subject=f"Out of stock: {event.sku}",
        body=f"The SKU {event.sku} is out of stock.",
    )
```

## Bootstrap Example

```python
from functools import partial


def bootstrap(
    start_orm: bool = True,
    uow: AbstractUnitOfWork | None = None,
    send_mail: Callable | None = None,
) -> MessageBus:
    """Composition root - wire all dependencies."""
    if start_orm:
        orm.start_mappers()

    uow = uow or SqlAlchemyUnitOfWork()
    send_mail = send_mail or email.send

    injected_event_handlers = {
        OutOfStock: [partial(handlers.send_out_of_stock_notification, send_mail=send_mail)],
    }

    injected_command_handlers = {
        Allocate: partial(handlers.allocate, uow=uow),
        CreateBatch: partial(handlers.add_batch, uow=uow),
    }

    return MessageBus(
        uow=uow,
        event_handlers=injected_event_handlers,
        command_handlers=injected_command_handlers,
    )
```

### Test Configuration with Bootstrap

```python
def test__allocate__happy_path():
    """Test using bootstrap with fakes."""
    uow = FakeUnitOfWork()
    uow.products.add(Product("LAMP", [Batch("b1", "LAMP", 100)]))

    bus = bootstrap(start_orm=False, uow=uow)

    bus.handle(Allocate("o1", "LAMP", 10))

    assert uow.products.get("LAMP").batches[0].available_quantity == 90


def test__out_of_stock__sends_notification():
    """Test event handler is triggered."""
    uow = FakeUnitOfWork()
    uow.products.add(Product("LAMP", [Batch("b1", "LAMP", 5)]))

    notifications = []
    fake_send_mail = lambda **kwargs: notifications.append(kwargs)

    bus = bootstrap(start_orm=False, uow=uow, send_mail=fake_send_mail)

    bus.handle(Allocate("o1", "LAMP", 10))  # More than available

    assert len(notifications) == 1
    assert "LAMP" in notifications[0]["subject"]
```
