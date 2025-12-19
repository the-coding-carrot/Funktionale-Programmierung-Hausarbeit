#import "util.typ": *

= Side Effects <Side-Effects>
Side Effects sind alles, was eine Funktion macht, die nicht Teil ihres Outputs sind @fp_basics[p.10]. Das Ändern von globalen Variablen, das Modifizieren von Objekten, das Schreiben in Dateien oder das Aufbauen von Netzwerkverbindungen stellen  Beispiele für Side Effects dar. Auch das Nutzen globaler Variablen als Input ist ein Side Effect. Der Nachteil von Side Effects ist, dass sie den Zustand des Programms verändern können, was zu unerwartetem Verhalten führen kann @fp_basics[p.11]. Dies erschwert das Testen und Debuggen von Code, da die Funktion nicht mehr isoliert betrachtet werden kann. Außerdem leidet die Transparenz des Codes, da der Leser nicht sofort erkennen kann, welche Teile des Codes den Zustand verändern. Der Leser muss den gesamten Kontext verstehen, um die Auswirkungen einer Funktion vollständig zu begreifen. Ein Beispiel für Side Effects ist eine Funktion, die eine globale Variable ändert:

#figure(
  ```java
  static int counter = 0;

  static void increment() {
      counter += 1;
  }

  public static void main(String[] args) {
      increment();
      System.out.println(counter);  // Ausgabe: 1
  }
  ```,
  caption: [Side Effects in Prozedureller Programmierung],
) <Side-Effect-OOP>

Die Funktionale Programmierung (FP) hingegen strebt danach, Side Effects zu minimieren und klar vom Rest des Codes zu trennen, um die Vorteile reiner Funktionen zu nutzen. Reine Funktionen sind Funktionen, die für dieselben Eingaben immer dieselben Ausgaben liefern und keine Side Effects haben @fp_basics[p.11]. Solche Funktionen sind referenziell transparent, man kann sie also vollständig durch ihren Rückgabewert ersetzen, ohne das Verhalten des Programms zu ändern @fp_basics[p.15]. Eine reine Funktion wird folgendermaßen definiert:
$ f:A arrow B, x mapsto y $
Die Funktion $f$ erhält als Parameter einen Wert $x$ vom Typ $A$ und gibt einen Wert $y$ vom Typ $B$ zurück. Dabei wird $x$ selbst nicht verändert, und es gibt keine anderen Auswirkungen auf den Zustand des Programms. Eine solche Funktion folgt also der mengentheoretischen Definition einer Funktion als deterministische Abbildung der Menge $A$ in die Menge $B$.

Dieser Determinismus erleichtert das Verständnis, Testen und die Wiederverwendbarkeit von Code erheblich. Ein Beispiel für eine reine Funktion ist:

#figure(
  ```java
  static int increment(int x) {
      return x + 1;
  }

  public static void main(String[] args) {
      int counter = increment(0);
      System.out.println(counter);  // Ausgabe: 1
  }
  ```,
  caption: [Reine Funktion in FP],
) <Pure-Function-FP>

In dem Beispiel aus @Pure-Function-FP hat die Funktion `increment` keine Side Effects, da sie nur den Wert ihrer Eingabe um 1 erhöht, ohne den Zustand des Programms zu verändern. Außerdem erkennt man sofort, dass `increment(0)` immer `1` zurückgibt, unabhängig vom Kontext.

Jedoch kommt man in der Praxis nicht komplett ohne Side Effects aus, da Programme mit der Außenwelt interagieren müssen um einen Nutzen zu haben (z.B. Benutzereingaben, Datenbanken, Netzwerke). Es ist daher notwendig, Side Effects zu verwalten und zu kontrollieren, um die Vorteile der funktionalen Programmierung zu nutzen, ohne die Notwendigkeit von Side Effects zu vernachlässigen. Es ist außerdem möglich, Side Effects an den Rand des Programms zu verlagern, sodass der Großteil des Codes rein und frei von Side Effects bleibt. Dies kann beispielsweise durch den Einsatz von Datenbanken ermöglicht werden, indem der Zustand in der Datenbank gespeichert wird und die Hauptlogik des Programms rein bleibt.

== Transparenz
Bei der Objektorientierten Programmierung (OOP) ist Transparenz im Code oft eingeschränkt, da Methoden den internen Zustand von Objekten verändern können. Man muss die gesamte Klasse und ihre Zustände verstehen, um die Auswirkungen einer einzelnen Methode zu verstehen. Das erschwert das Lesen und Warten des Codes, da die Auswirkungen einer Methode nicht isoliert betrachtet werden können. Reine Funktionen hingegen können isoliert betrachtet und verstanden werden. Beim Beispiel @Side-Effect-OOP muss man wissen, welchen Zustand die Variable `counter` hat, um zu verstehen, was das Ergebnis von `increment()` ist. Man kann erahnen, dass `increment()` den Zustand von Counter erhöht, aber man weiß nicht das konkrete Ergebnis, ohne den aktuellen Zustand zu kennen. Hier ist das noch kein großes Problem, aber bei komplexeren Methoden und Klassen wird es schnell unübersichtlich, sodass nicht direkt klar ist, was eine Methode genau macht.

== Funktionale Programmierung und Pure Funktionale Programmierung
Neben der Funktionalen Programmierung gibt es auch die Pure Funktionale Programmierung. Sie unterscheiden sich darin, welche Art von Mutationen erlaubt sind.

Bei der Funktionalen Programmierung sind globale Mutationen nicht erlaubt. Was innerhalb einer Funktion geschieht ist dabei irrelevant, solange ein globaler Zustand nicht verändert oder genutzt wird. Das bedeutet, dass Mutationen innerhalb eines lokalen Funktions-Scopes erlaubt sind.

Bei der Puren Funktionalen Programmierung hingegen sind selbst Zustandsänderungen innerhalb einer Funktion nicht erlaubt. Damit sind auch for-Schleifen nicht erlaubt, da diese die Iterationsvariable in jedem Schritt inkrementieren und damit den Zustand dieser Variable ändern.
