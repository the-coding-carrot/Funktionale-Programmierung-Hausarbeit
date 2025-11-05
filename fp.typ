#import "util.typ": *

= Fundamentale Konzepte des FP
== (es wäre schon witzig über Kategorien, Funktorialität und Monoiden zu yappen)
== Notation
Im Folgenden werden wir Signaturen von Funktionen basierend auf ihren Datentypen in folgender Form schreiben:

$ x arrow y $

Hier ist $x$ ein Vektor aus Parametern, und $y$ der Rückgabewert der Funktion.
== Pure Functions
äh ich glaub Maxim du führst den Begriff einfach bei Side effects ein und gut ist #todo[Okidoki]
== Higher-Order Functions
Als "Higher-Order Function" wird jede Funktion bezeichnet, die entweder durch eine andere Funktion parameterisiert wird, oder eine Funktion als Rückgabewert besitzt. Durch die Pythons dynamic geht dies ohne weiteres:

```py
def apply_f_to_x(x: int, f: Callable) -> int:
  return f(x)
```
Dies ist ein Beispiel für den Syntax einer #emph[HoF] in Python. Genutzt werden kann diese, indem man `apply_f_to_x` den Bezeichner einer anderen Funktion übergibt:

```py
def square(x: int) -> int:
  return x ** 2

assert apply_f_to_x(4, square) == 16
```

=== Anonymous Functions
Besonders für kleine Funktionen, wie `square` im vorherigen Beispiel, kann es schnell verbos und unleserlich werden, jede dieser Funktionen seperat mit Namen zu initialisieren. In den meisten Sprachen gibt es deshalb einen Weg, Funktionen ohne Namen zu initialisieren, um sie direkt an Higher-Order Funktionen zu übergeben. In Python geschieht dies durch den `lambda` syntax:
```py
lambda arg1 [, arg2, arg3, ...]: <result>
```

Das obige Beispiel kann demnach bedeutend kompakter geschrieben werden, ohne die Funktion `square` seperat zu deklarieren:

```py
apply_f_to_x(4, lambda x: x ** 2)
```

=== Currying
Wie im vorherigen Kapitel erwähnt, können #emph[Higher-Order Functions] auch Funktionen zurückgeben. Ein Anwendungsfall für dieses Pattern ist eine Art "Konstruktor" für Funktionen. Dies lässt sich gut aufzeigen am Beispiel der vorher eingeführten `square` Funktion: Es soll nun nicht nur quadriert werden, sondern der Exponent soll konfiguerbar sein. Die triviale Lösung hierfür ist eine zweistellige Funktion `(int, int) -> int`, wo der Exponent ein weiterer Parameter ist:
```py
def power(base: int, exponent: int) -> int:
    return base ** exponent
```

Wollen wir nun eine Funktion mit dem selben Exponenten häufiger verwenden, können wir die Funktion `power` auch interpretieren als eine Funktion `int -> (int -> int)`, die den Exponenten als Parameter nimmt, und eine Funktion zurückgibt, welche das Potenzieren zu diesem Exponenten durchführt:
```py
def c_power(exponent: int) -> Callable[[int], int]:
    return lambda base: base ** exponent
```
#todo[Hier fehlt glaub ich eine eckige Klammer bei Callable]

Wir können `c_power` nun nutzen, um mehrere Exponentialfunktionen zu erstellen:
```py
square = c_power(2)
cube = c_power(3)
the_answer = c_power(42)
```
Diese Reinterpretation einer Funktion mit mehreren Parametern als eine #emph[Higher-Order Function] nennt sich #emph[Currying]. Zu bemerken ist, dass die zurückgegebene Funktion den Kontext `exponent` beibehält, obwohl sie den Scope der Funktion `c_power` verlässt. Sie "captured" die Variable `exponent`. Capturing ist ein Weg, wie (immutable) State zwischen Funktionen weitergereicht werden kann. #todo[irgendwas zitieren für den Bullshit den ich da labere (should be like 90% correct)]


== Monaden
Das Pattern der Monade ist der Weg, wie deterministisch mit Seiteneffekten umgegangen werden kann. Monaden an sich sind ein Konzept aus der Kategorientheorie und entsprechend tief theoretisch verwurzelt. Wir wollen Monaden aber nur aus der Perspektive eines Software-Engineers betrachten, und werden deshalb theoretische Grundlagen auslassen. #todo[unless we don't still gotta decide]

Eine Monade kann definiert werden als ein Parameterisierter Datentyp `M<T>`, der Methoden mit den Folgenen Signaturen bereitstellt/*@notions_computations*/:
+ `unit: T -> M<T>`
+ `bind: (M<A>, A -> M<B>) -> M<B>`

Damit `M` tatsächlich eine Monade ist, muss `unit` als Neutrales Element bezüglich der `bind` Operation agieren, und die Operation `bind` assoziativ sein/*@monad_intro_medium*/.

Die Rolle der Methoden `unit` und `bind` können gut anhand des Beispiels der sogenannten "Maybe Monade" demonstriert werden. Diese abstrahiert den Side-Effect der möglichen Nicht-Existenz des enkapsulierten Wertes. Folgendes ist eine beispielhafte Implementierung der Maybe Monade in Python #footnote("Anzumerken ist, dass sich die Mächtigkeit der Struktur besser aufzeigen ließe in einer Sprache, die Algebraische Summentypen unterstützt. Da Python dies nicht tut, nutzt unsere Implementierung weiterhin das prozedurale null-pattern (`None`) zur Repräsentation eines nicht existierenden Wertes."):

```py
T, S = TypeVar("T"), TypeVar("S")
class Maybe(Generic[T]):
    value: T

    def __init__(self, value: T):
        self.value = value

    @classmethod
    def unit(cls, value: T) -> "Maybe[T]":
        return cls(value)

    def bind(self, f: Callable[[T], "Maybe[S]"]) -> "Maybe[S]":
        if self.value is None:
            return Maybe(None)
        return f(self.value)
```
Diese Klasse implementiert beide Methoden einer Monade. Die Implementierung von `bind` als Methode eines Objektes ermöglicht die Nutzung der Maybe Monade durch das aneinander-ketten von `bind` aufrufen wie folgt:

```py
val = 4
result = Maybe.unit(val)
    .bind(lambda x: Maybe(x - 2))
    .bind(lambda x: Maybe(str(x)))
assert result.value == "2"
```
Diese Kette an Operationen verändert erst einen Integer, und konvertiert ihn dann in einen String. Diese Aufgabe ist trvial genug, dass auch ein rein prozedureller Ansatz ohne unvorhergesehene Fehler durchlaufen könnte. Dies ändert sich allerdings, wenn man die Aufgabe umdreht: Es soll zuerst ein String von stdout eingelesen werden, dann in einen Integer konvertiert und schlussendlich verarbeitet werden.

```py
result = Maybe.unit(input(""))
    .bind(lambda s: Maybe(int(s) if s.isdigit() else Maybe(None)))
    .bind(lambda x: x - 2)
```
Gibt der Nutzer eine valide Zahl ein (dies wird überprüft durch Pythons eingebaute Funktion `str.isdigit`), enthält `result.value` das korrekte Ergebnis als Integer. Tut der Nutzer dies allerdings nicht, ist der Wert von `result.value` `None`. In diesem Fall könnte man beispielsweise dem Benutzer eine Fehlermeldung anzeigen. Die hier gezeigte Implementierung ist der Übersichtlichkeit halber primitiv gehalten - in einer tatsächlichen Codebase sollte die Klasse weitere API Methoden enthalten, um Entwicklern eine sinnvolle Nutzung der `Maybe` Klasse mit semantischer Relevanz zu ermöglichen.


== Monaden in der Praxis
Monadische Strukturen finden sich in beinahe allen modernen Programmiersprachen (außer halt Python lol). Die Maybe Monade beispielsweise manifestiert sich in Java als die Klasse `Optional`, und in Rust als der `Option` Datentyp. Ein weiteres Prominentes beispiel ist die sogenannte "IO Monade", die in JavaScript als die Klasse `Promise`, und in Java und Rust als Klasse bzw. der Datentyp `Future` realisiert ist. Die IO Monade enkapsuliert den Side-Effekt, dass ein Wert möglicherweise erst in der Zukunft existiert. Sie findet häufig Anwendung in Web Applikationen, wo Daten über ein Netzwerk geladen werden müssen.

Ebenfalls ein prominentes Beispiel für Monaden, die häufig Anwendung finden ist die List Monade. Sie enkapsuliert den Side-Effekt, dass dieselbe Operation auf mehreren Elementen gleichzeitig ausgeführt werden soll. Die List Monade findet sich beispielsweise in Java in Form der Streams API und in Rust in Form der Iterator API. In JavaScript ist bereits der Array Datentyp an sich eine Monade. oke keinen bock mal schauen das ding is für list monads müsste man fmap einführen wofür man die Funktorialität von Monaden definieren muss und dann muss man über das ganze theoretische Zeugs schreiben ich hasse wissenschaftliches Schreiben
