#import "util.typ": *

= Side Effects
- Ein Side Effect ist alles was eine Funktion macht, außer einfach einen Wert zurückzugeben
  - Globale Variable ändern
  - Internen Zustand eines Objekts ändern (OOP stuff)
  - Etwas in eine Datei schreiben oder Console stuff
  - Netzwerkverbindung aufbauen
- FP minimiert Side Effects oder trennt sie klar vom Rest des Codes #sym.arrow.r `Pure Functions`
== Transparenz
#todo[man muss halt iwi interne Implementierung kennen weil SE nicht klar aldf

(wir müssen es schaffen nen convincing case vs. OOP zu machen)]
- #strong[FP:] Funktionen können isoliert betrachtet und verstanden werden
- #strong[OOP:] Man muss die gesamte Klasse und ihren aktuellen Zustand verstehen, um eine einzige Methode zu verstehen
- #emph[OOP] macht $f(x)$, während #emph[FP] $f(5)$ macht, man sieht also direkt was #emph[FP] macht (solange man keine kryptischen Namen benutzt)
- #strong[WICHTIG:] komplett ohne #emph[Side Effects] kommt man nicht aus, weil irgendwann muss das Programm irgendeinen Zustand ändern damit es sinnvoll ist

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