# stuff damit wir code schreiben und runnen können und ggf. live demo und so


########################################## WRITER MONAD #################################################
from collections.abc import Callable
from typing import Generic, TypeVar


class Writer:
    def __init__(self, value, log=""):
        self.value = value
        self.log = log

    @classmethod
    def ret(cls, value):
        return cls(value, "")

    def bind(self, f: Callable[[any], "Writer"]):
        result = f(self.value)
        return Writer(result.value, self.log + result.log)

    def __repr__(self):
        return f"Writer(value={self.value}, log='{self.log}')"


T = TypeVar("T")
S = TypeVar("S")


class Maybe(Generic[T]):
    value: T

    def __init__(self, value: T):
        self.value = value

    def __repr__(self) -> str:
        if not self.value is not None:
            return "None"
        return f"Some({self.value})"

    @classmethod
    def unit(cls, value: T) -> "Maybe[T]":
        return cls(value)

    def bind(self, f: Callable[[T], "Maybe[S]"]) -> "Maybe[S]":
        if self.value is None:
            return Maybe(None)
        return f(self.value)


def save_divide(a: int, b: int) -> Maybe[float]:
    if b == 0:
        return Maybe(None)
    return Maybe(a / b)


if __name__ == "__main__":
    val = 42
    val = 4
    result = Maybe.unit(val).bind(lambda x: Maybe(x - 2)).bind(lambda x: Maybe(str(x)))
    assert result.value == "2"

    result = (
        Maybe.unit(input(""))
        .bind(lambda s: Maybe(int(s) if s.isdigit() else Maybe(None)))
        .bind(lambda x: x - 2)
    )

    print(
        Writer.ret(val)
        .bind(lambda x: Writer(x / 2, log="Division by 2; "))
        .bind(lambda x: Writer(x + 2, log="Add 2; "))
    )
