#import "util.typ": *

= Beispiel
- ein Beispiel von Kapitel 2 aufgreifen und mit FP fixen
- idealerweise auf alle Konzepte eingehen

#todo[Vielleicht ist das ein verständliches Beispiel?]

OOP:
```python 
# OOP-Stil
import threading

class Account:
    def __init__(self, owner, balance=0):
        self.owner = owner
        self.balance = balance
        self.lock = threading.Lock()  # Thread-safety nötig

    def deposit(self, amount):
        with self.lock:
            if amount < 0:
                raise ValueError("Cannot deposit negative amount")
            self.balance += amount

    def withdraw(self, amount):
        with self.lock:
            if amount > self.balance:
                raise ValueError("Insufficient funds")
            self.balance -= amount

    def transfer(self, other, amount):
        with self.lock:
            self.withdraw(amount)
            other.deposit(amount)

```
#todo[Das wäre dann der Fix in FP (aber ich glaub definitiv nicht fertig???)]

FP:
```python 
from dataclasses import dataclass
from typing import NamedTuple, Optional

# --- Funktionaler Datentyp ---
@dataclass(frozen=True)
class Account:
    owner: str
    balance: float


# --- Result Monad (vereinfacht) ---
class Result(NamedTuple):
    value: Optional[Account]
    error: Optional[str]

    @staticmethod
    def ok(value): return Result(value, None)
    @staticmethod
    def err(error): return Result(None, error)


# --- Pure Functions ---
def deposit(account: Account, amount: float) -> Result:
    if amount < 0:
        return Result.err("Negative deposit not allowed")
    new_acc = Account(account.owner, account.balance + amount)
    return Result.ok(new_acc)

def withdraw(account: Account, amount: float) -> Result:
    if amount > account.balance:
        return Result.err("Insufficient funds")
    new_acc = Account(account.owner, account.balance - amount)
    return Result.ok(new_acc)

def transfer(a_from: Account, a_to: Account, amount: float) -> Result:
    result = withdraw(a_from, amount)
    if result.error:
        return result
    result2 = deposit(a_to, amount)
    if result2.error:
        return result2
    return Result.ok((result.value, result2.value))

```

#todo[FP Concurrency Beispiel]

Concurrency in FP:
```python 
from concurrent.futures import ThreadPoolExecutor

acc1 = Account("Alice", 1000)
acc2 = Account("Bob", 500)

with ThreadPoolExecutor() as executor:
    future1 = executor.submit(lambda: deposit(acc1, 100))
    future2 = executor.submit(lambda: withdraw(acc2, 50))
    r1, r2 = future1.result(), future2.result()

print(r1, r2)

```

= ggf. Comparison mit anderen Paradigmen (OOP & Procedural) // Vielleicht kann man das auch in der Zusammenfassung machen? Außer wir wollen das ausfühlich machen

