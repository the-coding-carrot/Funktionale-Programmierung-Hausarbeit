#import "util.typ": *

= Side Effects
#emph[Side Effects] sind alle Dinge die eine Funktion macht, die nicht Teil ihres Outputs sind. Das Ändern von globalen Variablen, das Modifizieren von Objekten, das Schreiben in Dateien oder das Aufbauen von Netzwerkverbindungen sind alles Beispiele für Side Effects. Der Nachteil von Side Effects ist, dass sie den Zustand des Programms verändern können, was zu unerwartetem Verhalten führen kann. Dies erschwert das Testen und Debuggen von Code, da die Funktion nicht mehr isoliert betrachtet werden kann. Außerdem leidet die Transparenz des Codes, da der Leser nicht sofort erkennen kann, welche Teile des Codes den Zustand verändern. Der Leser muss den gesamten Kontext verstehen, um die Auswirkungen einer Funktion vollständig zu begreifen. Ein Beispiel für Side Effects ist eine Funktion, die eine globale Variable ändert:

```python
counter = 0
def increment():
    global counter
    counter += 1
increment()
print(counter)  # Ausgabe: 1
```

Funktionale Programmierung hingegen strebt danach, Side Effects zu minimieren oder klar vom Rest des Codes zu trennen, um die Vorteile reiner Funktionen zu nutzen. #emph[Pure Functions] sind Funktionen, die für dieselben Eingaben immer dieselben Ausgaben liefern und keine Side Effects haben:
$ f:A arrow B, x mapsto y $
Die Funktion erhält als Parameter einen Wert $x$ vom Typ $A$ und gibt einen Wert $y$ vom Typ $B$ zurück. Dabei wird $x$ selbst nicht verändert, und es gibt keine anderen Auswirkungen auf den Zustand des Programms. Eine solche Funktion  folgt also der mengentheoretischen Definition einer Funktion als deterministische Abbildung der Menge $A$ in die Menge $B$.

Dieser Determinismus erleichtert das Verständnis, Testen und die Wiederverwendbarkeit von Code erheblich. Ein Beispiel für eine reine Funktion ist:

```python
def increment(x):
    return x + 1

counter = increment(0)
print(counter)  # Ausgabe: 1
```
In diesem Beispiel hat die Funktion `increment` keine Side Effects, da sie nur den Wert ihrer Eingabe um 1 erhöht, ohne den Zustand des Programms zu verändern. Außerdem erkennt man sofort, dass `increment(0)` immer `1` zurückgibt, unabhängig vom Kontext.

Jedoch kommt man in der Praxis nicht komplett ohne Side Effects aus, da Programme mit der Außenwelt interagieren müssen um einen Nutzen zu haben (z.B. Benutzereingaben, Datenbanken, Netzwerke). Es ist daher notwendig, Side Effects zu verwalten und zu kontrollieren, um die Vorteile der funktionalen Programmierung zu nutzen, ohne die Notwendigkeit von Side Effects zu vernachlässigen. Es ist außerdem möglich, Side Effects an den Rand des Programms zu verlagern, sodass der Großteil des Codes rein und frei von Side Effects bleibt. Dies kann beispielsweise duch den Einsatz von Datenbanken ermöglicht werden, indem der Zustand in der Datenbank gespeichert wird und die Hauptlogik des Programms rein bleibt.

== Transparenz
Beim #emph[OOP] ist Transparenz im Code oft eingeschränkt, da Methoden den internen Zustand von Objekten verändern zu können. Man muss den die gesamte Klasse und ihre Zustände verstehen, um die Auswirkungen einer einzelnen Methode zu verstehen. Das erschwert das Lesen und Warten, des Codes, da die Auswirkungen einer Methode nicht isoliert betrachtet werden können. In der #emph[funktionalen Programmierung] hingegen sind Funktionen  reine Funktionen ohne Side Effects. Dadurch können sie isoliert betrachtet und verstanden werden, was die Transparenz des Codes erhöht. Beim Beispiel #todo[Beispiel referenzieren] muss man wissen, wechen Zustand die Variable `counter`hat, um zu verstehen, was das Ergebnis von `increment()` ist. Man kann erahnen, dass `increment()` den Zustand von Counter erhöht, aber man weiß nicht das konkrete Ergebnis ohne den aktuellen Zustand zu kennen. Hier ist das noch kein großes Problem, aber bei komplexeren Methoden und Klassen wird es schnell unübersichtlich, sodass nicht direkt klar ist, was eine Methode genau macht.

In der #emph[FP] hingegen ist die Funktion `increment(x)` aus #todo[Beispiel referenzieren] eine reine Funktion, die für eine Eingabe immer dieselbe Ausgabe liefert, ohne den Zustand des Programms zu verändern. Beim Aufruf von `increment(0)` sieht man den Eingabewert und kann damit besser nachvollziehen, woher die Eingabe kommt und was die Funktion macht. Dadurch wird der Code transparenter und leichter verständlich. Da reine Funktionen außerdem isoliert betrachtet werden können, ist es einfacher, sie zu verstehen, da man nicht den gesamten Kontext der Klasse oder des Objekts kennen muss um zu verstehen, was die Funktion macht.

== Concurrency
Unter #emph[Concurrency] versteht man die Fähigkeit eines Programms, mehrere Aufgaben gleichzeitig auszuführen. Ein Problem im #emph[OOP] ist der Umgang mit #emph[Shared Mutable State], also mit gemeinsam genutztem, veränderbarem Zustand. Wenn mehrere Threads gleichzeitig auf denselben Zustand zugreifen und diesen ändern, kann es zu Inkonsistenzen kommen. Das führt zu unerwartetem Verhalten, da die Threads sich gegenseitig beeinflussen. In #emph[OOP] wird dieses Problem mit #emph[Locks] gelöst, die sicherstellen, dass nur ein Thread gleichzeitig auf den Zustand zugreifen kann. Dies kann jedoch zu #emph[Deadlocks] führen, bei denen zwei oder mehr Threads sich gegenseitig blockieren und nicht weiterarbeiten können. In der #emph[funktionalen Programmierung] hingegen sind Daten #emph[immutable]. Ein Thread in der #emph[funktionalen Programmierung] bekommt also keinen globalen Zustand, den er ändern kann, sondern eine Kopie des Zustands. Wenn ein Thread eine Änderung vornehmen möchte, dann erstellt er eine neue Version des Zustands, anstatt den ursprünglichen Zustand zu ändern. Damit können Threads nicht mehr konkurrieren und sich gegenseitig beeinflussen. In der #emph[funktionalen Programmierung] wird das Problem der #emph[Concurrency] vermieden indem es keine gemeinsamen Zustände gibt.

Das Problem der #emph[Concurrency] soll anhand eines Beispiels verdeutlicht werden. Im folgenden Beispiel wird die Summe der Quadrate der Zahlen von $0$ bis $N-1$ im #emph[OOP] berechnet:

```python
from threading import Thread
N = 100_000

class Acc:
    def __init__(self):
        self.sum = 0  # geteilter, veränderlicher Zustand

    def add(self, v):
        # ohne Lock: race-conditions möglich
        self.sum += v

def worker(acc, items):
    for i in items:
        acc.add(i * i)

if __name__ == "__main__":
    acc = Acc()
    items = list(range(N))
    half = len(items) // 2
    t1 = Thread(target=worker, args=(acc, items[:half]))
    t2 = Thread(target=worker, args=(acc, items[half:]))
    t1.start(); t2.start()
    t1.join(); t2.join()
    print("OOP (ohne Lock) -> sum =", acc.sum)
    # Erwartet: N*(N-1)*(2N-1)/6; ohne Lock meist kleiner/falsch
```

Im obigen Beispiel wird eine Klasse `Acc` definiert, die einen gemeinsamen, veränderlichen Zustand `sum` enthält. Zwei Threads werden gestartet, die jeweils die Quadrate der Zahlen in einem bestimmten Bereich berechnen und zur Summe hinzufügen. Da kein Lock verwendet wird, können Race-Conditions auftreten, was zu einem falschen Ergebnis führt. Wenn beide Threads gleichzeitig auf `self.sum` zugreifen und diesen Wert ändern, kann es passieren, dass eine Änderung die andere überschreibt, was zu einem inkonsistenten Zustand führt.

Im folgenden Beispiel wird dasselbe Problem in der #emph[funktionalen Programmierung] gelöst:

```python
from concurrent.futures import ThreadPoolExecutor
N = 100_000

def square(x):
    return x * x  # reine Funktion, keine Seiteneffekte

if __name__ == "__main__":
    items = list(range(N))
    with ThreadPoolExecutor(max_workers=4) as ex:
        results = list(ex.map(square, items))  # map-ähnliche FP-Semantik
    total = sum(results)  # Aggregation erfolgt danach (im Hauptthread)
    print("FP (no shared mutation) -> sum =", total)
```

Im obigen Beispiel wird die Funktion `square` definiert, die eine reine Funktion ist und keine Seiteneffekte hat. Mehrere Threads werden gestartet, die jeweils die Quadrate der Zahlen in einem bestimmten Bereich berechnen. Da es keinen gemeinsamen, veränderlichen Zustand gibt, treten keine Race-Conditions auf, und das Ergebnis ist konsistent.
