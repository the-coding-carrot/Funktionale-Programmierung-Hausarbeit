## Funktionale Programmierung Hausarbiet
bla bla bla

## REST API Examples - REVIEW COMPLETED ✅

### Summary of Changes

I've reviewed and significantly improved both REST API examples to better demonstrate the FP concepts in your writeup:

1. **State at edges** - I/O operations pushed to Repository and Controller boundaries
2. **Monads** - Using Maybe/Optional for safe composition without exceptions
3. **Anonymous functions in HoFs** - Functions as parameters, method references, lambda expressions

### Two Example Implementations

#### 1. **fp-example-improved/** (RECOMMENDED for Writeup) ⭐
- **Manual implementation** using your custom `Maybe` monad
- **Best for teaching** - clear, simple, no framework complexity
- **Runs instantly**: `javac *.java && java Main`
- **Demonstrates all concepts explicitly**:
  - ✅ Monadic composition (map, bind chains)
  - ✅ Pure functions throughout service layer
  - ✅ Higher-order functions as parameters
  - ✅ No exceptions - functional error handling
  - ✅ Clear "state at edges" architecture
- **See**: `java-code/fp-example-improved/README.md`

#### 2. **fp-example/** (Production-style, Improved)
- **Quarkus + Vert.x** with reactive drivers
- **Now improved** with proper FP principles:
  - ✅ Removed exception throwing (uses Optional)
  - ✅ Added monadic composition chains
  - ✅ Added pure business logic functions
  - ✅ Added HoF examples
- **Good for**: Showing "real-world" production code
- **Requires**: Docker for PostgreSQL
- **See**: `java-code/fp-example/README-FP.md`

### Detailed Analysis

See `java-code/COMPARISON.md` for:
- Side-by-side comparison of both approaches
- Why manual implementation is better for teaching
- Detailed walkthrough of improvements made
- Evaluation of framework vs manual implementation

### Recommendation

**Use `fp-example-improved/` for your writeup** because:
1. Uses the same `Maybe` monad you already explained
2. No framework magic obscuring FP concepts
3. Clear demonstration of state at edges
4. Rich monadic composition examples
5. Multiple HoF patterns shown
6. Runs immediately without setup

## Aufteilung
- [ ] Intro: am ende
- [ ] Side Effects & Nachteile: maxim
- [ ] Fundamentale Konzepte: emil
      - [ ] pure functions
      - [ ] HOF
      - [ ] Burrito
- [ ] Beispiel: -> zusammen
- [ ] Conclusion: am Ende
