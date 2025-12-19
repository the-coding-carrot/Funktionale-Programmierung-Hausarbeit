#import "util.typ": *

= Funktionale Programmierung für Praktische Anwendungen
In diesem Kapitel wollen wir abschließend oberflächlich beleuchten, wie die funktionale Programmierung in der Praxis eingesetzt werden kann, und wo ihre Vorteile liegen.

== State als inhärenter Teil von Software
In der Praxis ist es nahezu unmöglich, ein Programm vollständig ohne Zustände zu schreiben. Schlussendlich ist Software nur ein Mittel zu einem Zweck, und dieser Zweck manifestiert sich in aller Regel als ein Zustand, der verändert werden muss.

Aus diesem fundamentalen Umstand ergibt sich beinahe von selbst ein Pattern, wie Software mit funktionalen Mitteln aufgebaut werden kann: Der State, der absolut notwendig ist (beispielsweise das Speichern/Laden von Daten aus einer Datenbank) wird an den Rand der Applikation ausgelagert. Der Kern der Applikation wird dann funktional gestaltet, um Berechnungen vorzunehmen. Die Seiteneffekte vom Rand der Applikation können mittels monadischer Strukturen durch die Applikation propagiert werden. Durch den Aufbau des Programmkerns kann dann ein weiterer Vorteil der funktionalen Programmieren ausgespielt werden: Die Fähigkeit zu inhärenter #emph[Concurrency].


== Concurrency
Unter #emph[Concurrency] versteht man die Fähigkeit eines Programms, mehrere Aufgaben gleichzeitig auszuführen. Ein Problem im #emph[OOP] ist der Umgang mit #emph[Shared Mutable State], also mit gemeinsam genutztem, veränderbarem Zustand. Wenn mehrere Threads gleichzeitig auf denselben Zustand zugreifen und diesen ändern, kann es zu Inkonsistenzen kommen. Das führt zu unerwartetem Verhalten, da die Threads sich gegenseitig beeinflussen. In #emph[OOP] wird dieses Problem mit #emph[Locks] gelöst, die sicherstellen, dass nur ein Thread gleichzeitig auf den Zustand zugreifen kann. Dies kann jedoch zu #emph[Deadlocks] führen, bei denen zwei oder mehr Threads sich gegenseitig blockieren und nicht weiterarbeiten können. In der #emph[funktionalen Programmierung] hingegen sind Daten #emph[immutable] @fp_basics[p.18]. Ein Thread in der #emph[funktionalen Programmierung] bekommt also keinen globalen Zustand, den er ändern kann, sondern eine Kopie des Zustands. Wenn ein Thread eine Änderung vornehmen möchte, dann erstellt er eine neue Version des Zustands, anstatt den ursprünglichen Zustand zu ändern. Damit können Threads nicht mehr konkurrieren und sich gegenseitig beeinflussen. In der #emph[funktionalen Programmierung] wird das Problem der #emph[Concurrency] vermieden, indem es keine gemeinsamen Zustände gibt.

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
