# Java Code Examples

This folder contains Java implementations of the Python code examples from `fp.typ`.

## Files

- **HigherOrderFunctions.java**: Demonstrates higher-order functions and anonymous functions (lambdas)
- **Currying.java**: Shows currying pattern with the power/square/cube example
- **Maybe.java**: Rudimentary implementation of the Maybe Monad
- **MaybeExample.java**: Demonstrates usage of the Maybe Monad with chaining

## Compilation and Running

To compile all files:

```bash
javac *.java
```

To run individual examples:

```bash
java HigherOrderFunctions
java Currying
java MaybeExample
```

## Notes

- Java uses `Function<T, R>` from `java.util.function` for functional interfaces
- Lambda syntax in Java: `x -> x * x` (similar to Python's `lambda x: x ** 2`)
- The Maybe monad is a simplified version; Java's built-in `Optional<T>` class provides similar functionality with more features
- Assertions need to be enabled with `-ea` flag: `java -ea HigherOrderFunctions`
