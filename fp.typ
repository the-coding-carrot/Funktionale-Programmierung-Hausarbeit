#import "util.typ": *

= Fundamentale Konzepte des FP
== (es wäre schon witzig über Kategorien, Funktorialität und Monoiden zu yappen)
== Notation
ja erkläre halt generic types und `a -> b` notation für Funktionen
== Pure Functions
== Higher-Order Functions
== Anonymous Functions
- python's lambda notation einführen
== Monaden
Das Pattern der Monade ist der Weg, wie deterministisch mit Seiteneffekten umgegangen werden kann. Monaden an sich sind ein Konzept aus der Kategorientheorie und entsprechend tief theoretisch verwurzelt. Wir wollen Monaden aber nur aus der Perspektive eines Software-Engineers betrachten, und werden deshalb theoretische Grundlagen auslassen. (unless we don't still gotta decide)

Eine Monade kann definiert werden als ein Parameterisierter Datentyp `M<T>`, der Methoden mit den Folgenen Signaturen bereitstellt /*@notions_computations*/:
+ `unit: T -> M<T>`
+ `bind: (M<A>, A -> M<B>) -> M<B>`

Damit `M` tatsächlich eine Monade ist, muss `unit` als Neutrales Element bezüglich der `bind` Operation agieren, und die Operation `bind` assoziativ sein/*@monad_intro_medium*/.

Die Rolle der Methoden `unit` und `bind` können gut anhand des Beispiels der sogenannten "Maybe Monade" demonstriert werden. Diese abstrahiert den Side-Effect der möglichen Nicht-Existenz des enkapsulierten Wertes. Folgendes ist eine beispielhafte Implementierung der Maybe Monade in Python #footnote("Anzumerken ist, dass sich die Mächtigkeit der Struktur besser aufzeigen ließe in einer Sprache, die Algebraische Summentypen unterstützt. Da Python dies nicht tut, nutzt unsere Implementierung weiterhin das prozedurelle null-pattern (`None`) zur Repräsentation eines nicht existierenden Wertes."):

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
assert(result.value == "2")
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
