#import "util.typ": *

= Side Effects
- Ein Side Effect ist alles was eine Funktion macht, außer einfach einen Wert zurückzugeben
  - Globale Variable ändern
  - Internen Zustand eines Objekts ändern (OOP stuff)
  - Etwas in eine Datei schreiben oder Console stuff
  - Netzwerkverbindung aufbauen
- FP minimiert Side Effects oder trennt sie klar vom Rest des Codes #sym.arrow.r `Pure Functions`
#todo[EXPLIZIT darauf eingehen was die Nachteile davon sind mit Beispielen etc.]

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
#todo[global mutable Variablen sind halt scheiße für multithreading nh]

- #emph[Shared Mutable State] ist Endgegner von Multithreading
- Beispiel: Bankautomat
  - Konto hat 100 Rubel
  - Thread 1 hebt 50 Euro ab
  - Thread 2 hebt 50 Drachmen ab
  - Beide lesen 100, ziehen 50 ab, beide schreiben 50 rein
  - Konto hat nach abziehen von $50+50=100$ immer noch 50
- In #emph[OOP] muss man das mit #emph[Locks] verhindern
- Thread 1 muss Transaktion erst abschließen und Thread 2 muss warten
- Führt oft zu #emph[Deadlocks]
#strong[FP-Lösung:]

Thread 1 und 2 möchten wieder von einem Account jeweils 50 abheben.
- `withdraw`-Funktion ist #emph[rein] und der Account ist #emph[immutable]
- Thread 1 bekommt ein neues Objekt vom Account
- Thread 2 bekommt ein neues Objekt vom Account
- Threads konkurrieren nicht mehr und beschreiben nicht denselben Speicher
