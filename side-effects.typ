#import "util.typ": *

= Side Effects
#todo[Sieht irgendwie nach zu wenig Text aus]

#emph[Side Effects] sind alle Dinge die eine Funktion macht, die nicht Teil ihres Outputs sind. Das Ändern von globalen Variablen, das Modifizieren von Objekten, das Schreiben in Dateien oder das Aufbauen von Netzwerkverbindungen sind alles Beispiele für Side Effects. Der Nachteil von Side Effects ist, dass sie den Zustand des Programms verändern können, was zu unerwartetem Verhalten führen kann. Dies erschwert das Testen und Debuggen von Code, da die Funktion nicht mehr isoliert betrachtet werden kann. Außerdem leidet die Transparenz des Codes, da der Leser nicht sofort erkennen kann, welche Teile des Codes den Zustand verändern. Der Leser muss den gesamten Kontext verstehen, um die Auswirkungen einer Funktion vollständig zu begreifen. Ein Beispiel für Side Effects ist eine Funktion, die eine globale Variable ändert:

```python
counter = 0
def increment():
    global counter
    counter += 1
increment()
print(counter)  # Ausgabe: 1
```

Funktionale Programmierung hingegen strebt danach, Side Effects zu minimieren oder klar vom Rest des Codes zu trennen, um die Vorteile reiner Funktionen zu nutzen. #emph[Pure Functions] sind Funktionen, die für dieselben Eingaben immer dieselben Ausgaben liefern und keine Side Effects haben. Dies erleichtert das Verständnis, Testen und die Wiederverwendbarkeit von Code erheblich. Ein Beispiel für eine reine Funktion ist:

```python
def increment(x):
    return x + 1

counter = increment(0)
print(counter)  # Ausgabe: 1
```
In diesem Beispiel hat die Funktion `increment` keine Side Effects, da sie nur den Wert ihrer Eingabe um 1 erhöht, ohne den Zustand des Programms zu verändern. Außerdem erkennt man sofort, dass `increment(0)` immer `1` zurückgibt, unabhängig vom Kontext.

== Transparenz
#todo[man muss halt iwi interne Implementierung kennen weil SE nicht klar aldf

  (wir müssen es schaffen nen convincing case vs. OOP zu machen)]
- #strong[FP:] Funktionen können isoliert betrachtet und verstanden werden
- #strong[OOP:] Man muss die gesamte Klasse und ihren aktuellen Zustand verstehen, um eine einzige Methode zu verstehen
- #emph[OOP] macht $f(x)$, während #emph[FP] $f(5)$ macht, man sieht also direkt was #emph[FP] macht (solange man keine kryptischen Namen benutzt)
- #strong[WICHTIG:] komplett ohne #emph[Side Effects] kommt man nicht aus, weil irgendwann muss das Programm irgendeinen Zustand ändern damit es sinnvoll ist #todo[Drauf eingehen, dass man das an den Rand verlagern kann (Beispiel: Datenbank für auslagern von state)]

== Concurrency
#todo[Maybe Beispiele hinzufügen?]

#todo[Under construction, die Beispiele werden noch angepasst und an die richtige Stelle gepackt]
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

Bla Bla

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

Unter #emph[Concurrency] versteht man die Fähigkeit eines Programms, mehrere Aufgaben gleichzeitig auszuführen. Ein Problem im #emph[OOP] ist der Umgang mit #emph[Shared Mutable State], also mit gemeinsam genutztem, veränderbarem Zustand. Wenn mehrere Threads gleichzeitig auf denselben Zustand zugreifen und diesen ändern, kann es zu Inkonsistenzen kommen. Das führt zu unerwartetem Verhalten, da die Threads sich gegenseitig beeinflussen. In #emph[OOP] wird dieses Problem mit #emph[Locks] gelöst, die sicherstellen, dass nur ein Thread gleichzeitig auf den Zustand zugreifen kann. Dies kann jedoch zu #emph[Deadlocks] führen, bei denen zwei oder mehr Threads sich gegenseitig blockieren und nicht weiterarbeiten können. In der #emph[funktionalen Programmierung] hingegen sind Daten #emph[immutable]. Ein Thread in der #emph[funktionalen Programmierung] bekommt also keinen globalen Zustand, den er ändern kann, sondern eine Kopie des Zustands. Wenn ein Thread eine Änderung vornehmen möchte, dann erstellt er eine neue Version des Zustands, anstatt den ursprünglichen Zustand zu ändern. Damit können Threads nicht mehr konkurrieren und sich gegenseitig beeinflussen. In der #emph[funktionalen Programmierung] wird das Problem der #emph[Concurrency] also vermieden indem es keine gemeinsamen Zustände gibt.
