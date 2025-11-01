# stuff damit wir code schreiben und runnen können und ggf. live demo und so


########################################## WRITER MONAD #################################################
from collections.abc import Callable


class Writer:
    def __init__(self, value, log=""):
        self.value = value
        self.log = log

    @classmethod
    def ret(cls, value):
        return cls(value, "")

    def bind(self, f: Callable[[any], 'Writer']):
        result = f(self.value)
        return Writer(result.value, self.log + result.log)

    def __repr__(self):
        return f"Writer(value={self.value}, log='{self.log}')"


if __name__ == "__main__":
    val = 42
    print(
        Writer.ret(val)
        .bind(lambda x: Writer(x / 2, log="Division by 2; "))
        .bind(lambda x: Writer(x + 2, log="Add 2; "))
    )
