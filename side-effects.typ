#import "util.typ": *

= Side Effects <Side-Effects>
#emph[Side Effects] ist alles was eine Funktion macht, die nicht Teil ihres Outputs sind @fp_basics[p.10]. Das Ändern von globalen Variablen, das Modifizieren von Objekten, das Schreiben in Dateien oder das Aufbauen von Netzwerkverbindungen sind alles Beispiele für Side Effects. Auch das nutzen globaler Variablen als Input ist ein Side Effect. Der Nachteil von Side Effects ist, dass sie den Zustand des Programms verändern können, was zu unerwartetem Verhalten führen kann @fp_basics[p.11]. Dies erschwert das Testen und Debuggen von Code, da die Funktion nicht mehr isoliert betrachtet werden kann. Außerdem leidet die Transparenz des Codes, da der Leser nicht sofort erkennen kann, welche Teile des Codes den Zustand verändern. Der Leser muss den gesamten Kontext verstehen, um die Auswirkungen einer Funktion vollständig zu begreifen. Ein Beispiel für Side Effects ist eine Funktion, die eine globale Variable ändert:

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
  caption: [Side Effects in #emph[prozedureller Programmierung]],
) <Side-Effect-OOP>

Funktionale Programmierung hingegen strebt danach, Side Effects zu minimieren und klar vom Rest des Codes zu trennen, um die Vorteile reiner Funktionen zu nutzen. #emph[Pure Functions] sind Funktionen, die für dieselben Eingaben immer dieselben Ausgaben liefern und keine Side Effects haben @fp_basics[p.11]. Solche Funktionen sind #emph[referenziell transparent], man kann sie also vollständig durch ihren ```java return```-Wert ersetzen ohne das Verhalten des Programms zu ändern @fp_basics[p.15]. Eine #emph[Pure Function] wird folgendermaßen definiert:
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
  caption: [Pure Function in #emph[FP]],
) <Pure-Function-FP>

In dem Beispiel aus @Pure-Function-FP hat die Funktion `increment` keine Side Effects, da sie nur den Wert ihrer Eingabe um 1 erhöht, ohne den Zustand des Programms zu verändern. Außerdem erkennt man sofort, dass `increment(0)` immer `1` zurückgibt, unabhängig vom Kontext.

Jedoch kommt man in der Praxis nicht komplett ohne Side Effects aus, da Programme mit der Außenwelt interagieren müssen um einen Nutzen zu haben (z.B. Benutzereingaben, Datenbanken, Netzwerke). Es ist daher notwendig, Side Effects zu verwalten und zu kontrollieren, um die Vorteile der funktionalen Programmierung zu nutzen, ohne die Notwendigkeit von Side Effects zu vernachlässigen. Es ist außerdem möglich, Side Effects an den Rand des Programms zu verlagern, sodass der Großteil des Codes rein und frei von Side Effects bleibt. Dies kann beispielsweise duch den Einsatz von Datenbanken ermöglicht werden, indem der Zustand in der Datenbank gespeichert wird und die Hauptlogik des Programms rein bleibt.

== Transparenz
Beim #emph[OOP] ist Transparenz im Code oft eingeschränkt, da Methoden den internen Zustand von Objekten verändern zu können. Man muss den die gesamte Klasse und ihre Zustände verstehen, um die Auswirkungen einer einzelnen Methode zu verstehen. Das erschwert das Lesen und Warten, des Codes, da die Auswirkungen einer Methode nicht isoliert betrachtet werden können. Reine Funktionen hingegen können isoliert betrachtet und verstanden werden. Beim Beispiel @Side-Effect-OOP muss man wissen, wechen Zustand die Variable `counter` hat, um zu verstehen, was das Ergebnis von `increment()` ist. Man kann erahnen, dass `increment()` den Zustand von Counter erhöht, aber man weiß nicht das konkrete Ergebnis ohne den aktuellen Zustand zu kennen. Hier ist das noch kein großes Problem, aber bei komplexeren Methoden und Klassen wird es schnell unübersichtlich, sodass nicht direkt klar ist, was eine Methode genau macht.

== Concurrency
Unter #emph[Concurrency] versteht man die Fähigkeit eines Programms, mehrere Aufgaben gleichzeitig auszuführen. Ein Problem im #emph[OOP] ist der Umgang mit #emph[Shared Mutable State], also mit gemeinsam genutztem, veränderbarem Zustand. Wenn mehrere Threads gleichzeitig auf denselben Zustand zugreifen und diesen ändern, kann es zu Inkonsistenzen kommen. Das führt zu unerwartetem Verhalten, da die Threads sich gegenseitig beeinflussen. In #emph[OOP] wird dieses Problem mit #emph[Locks] gelöst, die sicherstellen, dass nur ein Thread gleichzeitig auf den Zustand zugreifen kann. Dies kann jedoch zu #emph[Deadlocks] führen, bei denen zwei oder mehr Threads sich gegenseitig blockieren und nicht weiterarbeiten können. In der #emph[funktionalen Programmierung] hingegen sind Daten #emph[immutable]. Ein Thread in der #emph[funktionalen Programmierung] bekommt also keinen globalen Zustand, den er ändern kann, sondern eine Kopie des Zustands. Wenn ein Thread eine Änderung vornehmen möchte, dann erstellt er eine neue Version des Zustands, anstatt den ursprünglichen Zustand zu ändern. Damit können Threads nicht mehr konkurrieren und sich gegenseitig beeinflussen. In der #emph[funktionalen Programmierung] wird das Problem der #emph[Concurrency] vermieden indem es keine gemeinsamen Zustände gibt.

Das Problem der #emph[Concurrency] soll anhand eines Beispiels verdeutlicht werden. Im folgenden Beispiel wird die Summe der Quadrate der Zahlen von $0$ bis $N-1$ im #emph[OOP] berechnet:

#figure(
  ```java
  class Acc {
      long sum = 0;  // geteilter, veränderlicher Zustand

      void add(long v) {
          // ohne Lock: race-conditions möglich
          sum += v;
      }
  }

  static void worker(Acc acc, int[] items) {
      for (int i : items) {
          acc.add((long) i * i);
      }
  }

  public static void main(String[] args) throws InterruptedException {
      int N = 100_000;
      Acc acc = new Acc();
      int[] items = IntStream.range(0, N).toArray();
      int half = items.length / 2;

      Thread t1 = new Thread(() -> worker(acc, Arrays.copyOfRange(items, 0, half)));
      Thread t2 = new Thread(() -> worker(acc, Arrays.copyOfRange(items, half, items.length)));
      t1.start(); t2.start();
      t1.join(); t2.join();
      System.out.println("OOP (ohne Lock) -> sum = " + acc.sum);
      // Erwartet: N*(N-1)*(2N-1)/6; ohne Lock meist kleiner/falsch
  }
  ```,
  caption: [Multithreading in #emph[OOP]],
) <Multithreading-OOP>

Im Beispiel aus @Multithreading-OOP wird eine Klasse `Acc` definiert, die einen gemeinsamen, veränderlichen Zustand `sum` enthält. Zwei Threads werden gestartet, die jeweils die Quadrate der Zahlen in einem bestimmten Bereich berechnen und zur Summe hinzufügen. Da kein Lock verwendet wird, können Race-Conditions auftreten, was zu einem falschen Ergebnis führt. Wenn beide Threads gleichzeitig auf `self.sum` zugreifen und diesen Wert ändern, kann es passieren, dass eine Änderung die andere überschreibt, was zu einem inkonsistenten Zustand führt.

Im folgenden Beispiel wird dasselbe Problem in der #emph[funktionalen Programmierung] gelöst:

#figure(
  ```java
  static long square(int x) {
      return (long) x * x;  // reine Funktion, keine Seiteneffekte
  }

  public static void main(String[] args) {
      int N = 100_000;
      int[] items = IntStream.range(0, N).toArray();

      // map-ähnliche FP-Semantik mit parallelStream
      long total = Arrays.stream(items)
          .parallel()
          .mapToLong(Main::square)
          .sum();  // Aggregation erfolgt danach (thread-safe)

      System.out.println("FP (no shared mutation) -> sum = " + total);
  }
  ```,
  caption: [Multithreading in #emph[FP]],
) <Multithreading-FP>

Im Beispiel aus @Multithreading-FP wird die Funktion `square` definiert, die eine reine Funktion ist und keine Seiteneffekte hat. Mehrere Threads werden gestartet, die jeweils die Quadrate der Zahlen in einem bestimmten Bereich berechnen. Da es keinen gemeinsamen, veränderlichen Zustand gibt, treten keine Race-Conditions auf, und das Ergebnis ist konsistent.

== Funktionale Programmierung und Pure Funktionale Programmierung
Neben der #emph[Funktionalen Programmierung] gibt es auch die #emph[Pure Funktionale Programmierung]. Sie unterscheiden sich darin welche Art von Mutationen erlaubt sind.

Bei der Funktionalen Programmierung sind globale Mutationen nicht erlaubt. Was innerhalb einer Funktion geschieht ist dabei irrelevant, solange ein globaler Zustand nicht verändert oder genutzt wird. Das bedeutet, dass Mutationen innerhalb eines lokalen Funktions-Scopes erlaubt sind.

Bei der puren Funktionalen Programmierung hingegen sind selbst Zustandsänderungen innerhalb einer Funktion nicht erlaubt. Damit sind auch for-Schleifen nicht erlaubt, da diese die Iterationsvariable in jedem Schritt inkrementieren und damit den Zustand dieser Variable ändern.
