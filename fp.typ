#import "util.typ": *

= Fundamentale Konzepte des FP
Funktionale Programmierung ist tief verwurzelt in den theoretischen Feldern der Kategorientheorie und des Lambda Kalküls. Auf diese theoretischen Grundlagen einzugehen, überschreitet den Umfang der Arbeit um ein Weites, weshalb wir nur die wichtigsten Begrifflichkeiten und Konzepte erörter werden.
== Notation
Im Folgenden werden wir Signaturen von Funktionen basierend auf ihren Datentypen in folgender Form schreiben:

$ X arrow Y $

Hierbei ist $X$ der Vektor der Datentypen der Parameter, und $Y$ der Datentyp des Rückgabewerts der Funktion. Um Funktionstypen in Java darzustellen, nutzen wir die generische Klasse `Function` aus dem `java.util.function` Paket:
```java
Function<X, Y>
```


Anzumerken ist, dass bei dieser Schreibweise vorausgesetzt wird, dass die beschriebene Funktion rein ist.
// == Pure Functions
// äh ich glaub Maxim du führst den Begriff einfach bei Side effects ein und gut ist #todo[Okidoki]
== Higher-Order Functions
Als "Higher-Order Function" (HoF) wird jede Funktion bezeichnet, die entweder durch eine andere Funktion parameterisiert wird, oder eine Funktion als Rückgabewert besitzt. In Java können wir dies durch funktionale Interfaces realisieren:

```java
int applyFToX(int x, Function<Integer, Integer> f) {
    return f.apply(x);
}
```
Dies ist ein Beispiel für den Syntax einer #emph[HoF] in Java. Genutzt werden kann diese, indem man `applyFToX` den Bezeichner einer anderen Funktion übergibt:

```java
int square(int x) {
    return x * x;
}

assert applyFToX(4, this::square) == 16;
```

=== Anonymous Functions
Besonders für kleine Funktionen, wie `square` im vorherigen Beispiel, kann es schnell verbos und unleserlich werden, jede dieser Funktionen seperat mit einem Bezeichner zu deklarieren. In den meisten Sprachen gibt es deshalb einen Weg, Funktionen ohne Bezeichner zu initialisieren, um sie direkt an HoFs zu übergeben. In Java geschieht dies durch den Lambda Syntax:
```java
(arg1, arg2, arg3, ...) -> <result>
```

Das obige Beispiel kann demnach bedeutend kompakter geschrieben werden, ohne die Funktion `square` seperat zu deklarieren:

```java
applyFToX(4, x -> x * x);
```

Anonyme Funktionen gibt es in beinahe allen modernen Programmiersprachen. In JavaScript beispielsweise ist der Syntax analog:
```js
(x) => x * x
```
Python besitzt den sogenannten lambda-Syntax:

```py
lambda x: x * x
```

=== Currying
Wie im vorherigen Kapitel erwähnt, können #emph[Higher-Order Functions] auch Funktionen zurückgeben. Ein Anwendungsfall für dieses Pattern ist eine Art "Konstruktor" für Funktionen. Dies lässt sich gut aufzeigen am Beispiel der vorher eingeführten `square` Funktion: Es soll nun nicht nur quadriert werden, sondern der Exponent soll konfigurierbar sein. Die triviale Lösung hierfür ist eine zweistellige Funktion

$ ("int", "int") -> "int", $

wo der Exponent ein weiterer Parameter ist:
```java
int power(int base, int exponent) {
    return (int) Math.pow(base, exponent);
}
```
// $ (A, B) -> C quad equiv quad A ->(B -> C) $

Wollen wir nun eine Funktion mit dem selben Exponenten häufiger verwenden, können wir die Funktion `power` auch interpretieren als eine Funktion

$ "int" -> ("int" -> "int"), $

die den Exponenten als Parameter nimmt, und eine Funktion zurückgibt, welche das Potenzieren zu diesem Exponenten durchführt:
```java
Function<Integer, Integer> cPower(int exponent) {
    return base -> (int) Math.pow(base, exponent);
}
```

Wir können `cPower` nun nutzen, um mehrere Exponentialfunktionen zu erstellen:
```java
Function<Integer, Integer> square = cPower(2);
Function<Integer, Integer> cube = cPower(3);

assert square.apply(2) == power(2, 2);
assert cube.apply(2) == power(2, 3);
```
Diese Re-Interpretation einer Funktion mit mehreren Parametern als eine #emph[Higher-Order Function] nennt sich #emph[Currying]. Zu bemerken ist, dass die zurückgegebene Funktion den Kontext `exponent` beibehält, obwohl sie den Scope der Funktion `c_power` verlässt. Sie "captured" die Variable `exponent`. Capturing ist ein Weg, wie (immutable) State zwischen Funktionen weitergereicht werden kann. #todo[irgendwas zitieren für den Bullshit den ich da labere (should be like 90% correct)]


== Monaden
Das Pattern der Monade ist der Weg, wie deterministisch mit Seiteneffekten umgegangen werden kann. Monaden an sich sind ein Konzept aus der Kategorientheorie und entsprechend tief theoretisch verwurzelt, mit verschiedensten äquivalenten Definitionen. Wir wollen Monaden aber nur aus der Perspektive eines Software-Engineers betrachten, und werden deshalb theoretische Grundlagen auslassen. Erwähnt sei, dass folgende Definition einer Monade auf einem sogenanten #emph[Kleisli Tripel] basiert #todo[CITATION].

=== Definition

Eine Monade kann definiert werden als ein Parameterisierter Datentyp $M chevron.l T chevron.r$, der Methoden mit den Folgenen Signaturen bereitstellt/*@notions_computations*/:


#set math.equation(numbering: "(1)")

$ "unit": T -> M chevron.l T chevron.r $
$ "bind": (M chevron.l A chevron.r,med med A -> M chevron.l B chevron.r) -> M chevron.l B chevron.r $


// + `unit: T -> M<T>`
// + `bind: (M<A>, A -> M<B>) -> M<B>`
//

Damit $M$ tatsächlich eine Monade ist, muss `unit` als Neutrales Element bezüglich der `bind` Operation agieren (3) `bind` assoziativ sein (4)/*@monad_intro_medium*/:

$ "bind"("unit"(a), f) quad equiv quad f(a) \ "bind"(a, "unit") quad equiv quad a $ <identity>
$ "bind"("bind"(a, f), g) equiv "bind"(a, "bind"(f(a), g)) $ <associativity>




=== Maybe Monade

Die Rolle der Methoden `unit` und `bind` können gut anhand des Beispiels der sogenannten "Maybe Monade" demonstriert werden. Diese abstrahiert den Side-Effect der möglichen Nicht-Existenz des enkapsulierten Wertes. Listing @maybe-monad ist eine beispielhafte, rudimentäre Implementierung der Maybe Monade. Diese benutzt das Sprach-Feature von "Sealed Interfaces", die seit Java 17 unterstützt werden. #todo[Anhang]

#figure(
  ```java
  public sealed interface Maybe<T> permits Maybe.Just, Maybe.Nothing {
        static <T> Maybe<T> unit(T value) {
            if (value == null) return new Nothing<>();
            return new Just<>(value);
        }

        <S> Maybe<S> bind(Function<T, Maybe<S>> f);

        boolean isPresent();
        T getValue() throws Exception;

        // Implementierung der `Just` Variante
        final class Just<T> implements Maybe<T> {
            private final T value;

            public <S> Maybe<S> bind(Function<T, Maybe<S>> f) {
                return f.apply(this.value);
            }
            // weitere Methoden - s. Anhang
        }

        // Implementierung der `Nothing` Variante
        final class Nothing<T> implements Maybe<T> {
            public <S> Maybe<S> bind(Function<T, Maybe<S>> f) {
                return new Nothing<>();
            }
            // weitere Methoden - s. Anhang
        }
  }
  ```,
  caption: [Rudimentäre Implementierung der Maybe Monade],
) <maybe-monad>
Dieses Interface implementiert beide Methoden einer Monade. Die Implementierung von `bind` als Methode eines Objektes ermöglicht die Nutzung der Maybe Monade durch das aneinander-ketten von `bind` aufrufen wie folgt:

```java
int val = 4;
Maybe<String> result = Maybe.unit(val)
    .bind(x -> Maybe.unit(x - 2))
    .bind(x -> Maybe.unit(String.valueOf(x)));
assert result.getValue().equals("2");
```
Diese Kette an Operationen verändert erst einen Integer, und konvertiert ihn dann in einen String. Diese Aufgabe ist trvial genug, dass auch ein rein prozedureller Ansatz ohne unvorhergesehene Fehler durchlaufen könnte. Dies ändert sich allerdings, wenn man die Aufgabe umdreht: Es soll zuerst ein String von stdin eingelesen werden, dann in einen Integer konvertiert und schlussendlich verarbeitet werden.

```java
Maybe<Integer> result = Maybe.unit(input.nextLine())
    .bind(s -> s.matches("\\d+")
        ? Maybe.unit(Integer.parseInt(s))
        : Maybe.nothing())
    .bind(x -> Maybe.unit(x - 2));
```
Gibt der Nutzer eine valide Zahl ein (dies wird überprüft durch die `matches` Methode mit einem regulären Ausdruck), enthält `result.getValue()` das korrekte Ergebnis als Integer. Tut der Nutzer dies allerdings nicht, gibt `result.isPresent()` `false` zurück. In diesem Fall könnte man beispielsweise dem Benutzer eine Fehlermeldung anzeigen. Die hier gezeigte Implementierung ist der Übersichtlichkeit halber rudimentär gehalten - in einer tatsächlichen Codebase sollte die Klasse weitere API Methoden enthalten (zum beispiel eine Funktion $"getValueOrDefault":M chevron.l T chevron.r arrow T$, die im Falle einer Nicht-Existenz einen Default Wert zurück gibt anstatt eine Exception zu werfen), um Entwicklern eine sinnvolle Nutzung der `Maybe` Klasse mit semantischer Relevanz zu ermöglichen.

// === Funktorialität
// #todo[Unsure]

== Monaden in der Praxis
Monadische Strukturen finden sich in beinahe allen modernen Programmiersprachen (außer halt Python lol). Die Maybe Monade beispielsweise manifestiert sich in Java als die Klasse `Optional`, und in Rust als der `Option` Datentyp. Ein weiteres Prominentes beispiel ist die sogenannte "IO Monade", die in JavaScript als die Klasse `Promise`, und in Java und Rust als Klasse bzw. der Datentyp `Future` realisiert ist. Die IO Monade enkapsuliert den Side-Effekt, dass ein Wert möglicherweise erst in der Zukunft existiert. Sie findet häufig Anwendung in Web Applikationen, wo Daten über ein Netzwerk geladen werden müssen.

// Ebenfalls ein prominentes Beispiel für Monaden, die häufig Anwendung finden ist die List Monade. Sie enkapsuliert den Side-Effekt, dass dieselbe Operation auf mehreren Elementen gleichzeitig ausgeführt werden soll. Die List Monade findet sich beispielsweise in Java in Form der Streams API und in Rust in Form der Iterator API. In JavaScript ist bereits der Array Datentyp an sich eine Monade. oke keinen bock mal schauen das ding is für list monads müsste man fmap einführen wofür man die Funktorialität von Monaden definieren muss und dann muss man über das ganze theoretische Zeugs schreiben ich hasse wissenschaftliches Schreiben
