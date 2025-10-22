#import "util.typ": *

= Fundamentale Konzepte des FP
== Pure Functions
== Higher-Order Functions
== Monaden
Das Pattern der Monade ist der Weg, wie mit Seiteffekten umgegangen werden kann, ohne den pur-funktionalen Bereich zu verlassen. Das Konzept der Monaden steckt tief im mathematischen Feld der Kategorientheorie#footnote[Diese inhärente Komplexität kann gut aufgezeigt werden durch eine sarkastische Definition der Monade als ein "Monoid in der Kategorie der Endofunktoren".]. Diese theoretischen Grundlagen zu Genüge einzuführen sprenkt den Rahmen dieser Ausarbeitung, weshalb wir Monaden stattdessen anhand eines prominenten Beispiels exemplarisch motivieren wollen: Der sogenannten "Writer-Monade".

Die Writer-Monade löst das Problem der Log-Aggregation. Logging ist ein essenzieller Bestandteil vieler Enterprise Applications. In der Realität wird hier mit I/O Streams gearbeitet, um Logs nach `stdout` oder in eine Datei zu schreiben; der Einfachkeit halber werden wir dies abstrahieren und durch einen global mutierbaren String modellieren.
In diesem simplen Beispiel ist die aufgabe der Funktion `add_2`, die Zahl zwei auf ihre Eingabe zu addieren. Dies ist an sich eine pure Operation, allerdings mutiert die Funktion den globalen `logger` State.

```rust
thread_local! {
    pub static logger: RefCell<String> = RefCell::new(String::from(""));
}

pub fn add_2(i: i32) -> bool {
    logger.with(|ref_cell| {
        *ref_cell.borrow_mut() += "Added two; ";
    });
    i + 2
}
```
#todo[Von Rust nach Java migrieren]

Der Grundgedanke der Monade ist es, die Datentypen einer Funktion zu "wrappen", sodass die Mutation des States aus der Funktion zurückgegeben werden kann. So kann der State durch das ganze Programm kaskadieren. Die Writer Monade wrapped einen generischen Typ mit einem String, der den State des Loggers mit sich trägt:

```rs
struct Writer<T> {
    data: T,
    log: String,
}
```

Die Funktion `add_2` kann nun ihre Mutation als neue Instanz des `Writer<i32>` returnen:

```rs
fn add_2(i: i32) -> Writer<i32> {
    Writer {
        data: i + 2,
        log: "Added two; ".to_owned(),
    }
}
```

Um zwei solcher Funktionen zu komposieren, sprich, den Seiteneffek tatsächlich auszuführen, muss noch eine weitere Funktion definiert werden: `compose`. Diese Funktion nimmt als Argument zwei Funktionen  $"left" : A --> "Writer<B>"$ und
$"right" : B --> "Writer<C>"$, und komposiert diese zu einer Funktion $"right" circle.small "left": A --> "Writer<C>"$:

```rs
pub fn compose<A, B, C>(
    left: fn(A) -> Writer<B>,
    right: fn(B) -> Writer<C>,
) -> impl Fn(A) -> Writer<C>
{
    move |a: A| {
        let res_left = left(a);
        let res_right = right(res_left.data);
        Writer {
            data: res_right.data,
            log: res_left.effect + &res_right.effect, // Konkatenation der Side effects
        }
    }
}
```

Diese Funktion `compose` ermöglicht es uns, eine neue Funktion einfach zu definieren, und mit anderen Funktionen zu verketten. Beispielsweise können wir eine weitere Funktion definieren, die ihre Eingabe quadriert. Diese kann einfach in das existierende `Writer` Ökosystem integriert werden:

```rs
pub fn square(i: i32) -> Writer<i32> {
    Writer {
      data: i * i,
      log: "Squared; ".to_owned()
    }
}
```

Die Mächtigkeit der `compose` Funktion zeigt sich, wenn wir nun eine Funktion `square_and_add` bauen wollen, die ihren Parameter zuerst quadriert, und dann zwei addiert. Da wir beide dieser Funktionen bereits definiert haben, können wir `square_and_add` einfach als die Komposition dieser beiden Funktionen definieren:

```rs
let square_and_add: impl Fn(i32) -> Writer<i32> = compose(square, add);
// demonstrate that the thing actually works
let result: Writer<i32> = square_and_add(3);
assert_eq(result.data, 11);
assert_eq(result.log, "Squared; Added two; ")
```



= FP in der Praxis
Es gibt Haskell und Scala und so (todo: Footnotes). Krass. Solch rein funktionale Sprachen sind in der Industrie allerdings seltenst anzutreffen. (todo: besser begründen & citations). Ein zentraler Grund ist, dass die Ideologie von vollständig zustandslosen Programmen in der Realität oftmals schwer umzusetzen ist. Software, die realen Nutzen bringt, muss beinahe zwangsläufig Zustände mutieren.

Ein sinnvoller Kompromiss zwischen herkömmlichen Paradigmen wie OOP oder Prozedureller Programmierung ist es deswegen, die elementaren Seiteneffekte an die Randschnittstellen der Software zu verlagern (z.B. an eine Schnittstelle zur Kommunikation mit einer Datenbank), wo sie benötigt werden. Der Rest des Programms kann dann in einer pur-funktionalen Art und weise geschrieben werden, was die vorher etablierten Vorteile der Funktionalen Programmierung mit sich bringt.

== In etablierten Sprachen
Viele etablierte Programmiersprachen haben in den vergangenen Jahren Elemente aus pur-funktionalen Sprachen wie Haskell oder Scala übernommen. In dieser Sektion werden wir die prominentesten davon vorstellen.

=== Callbacks
Beispiel: JavaScript Promises  mit `.then`
Ja irgendwie auf HOFs beziehen

```JavaScript
function processData(object) {
  console.log(object);
}
fetch("/api/some-data").then(processData)
``` <js_promise>

=== Lambda Ausdrücke
(todo: citations)
Ein Lambda Ausdruck, auch bekannt als Anonyme Funktion, ist eine Funktion die definiert ist, aber keinen Namen trägt. Lambda Ausdrücke werden häufig verwendet um Callbacks zu definieren, ohne den Code unübersichtlicher zu machen. Das Beispiel aus Listing  (\@Maxim wie mach ich Listings KI kann typst nicht und google ist ass. Da muss man irgendein Paket runterladen oder so, ich mach das mal gleich, ich hab gerade Hunger und bin in einer Stunde wieder da) Kann mit einer anonymen Funktion anstelle der Funktion `processData` folgendermaßen geschrieben werden:

```JavaScript
fetch("/api/some-data").then((object) => {
  console.log(object)
});
```

Lambda ausdrücke werden z.B. unterstützt von Java, Python, und Rust (todo: citations).

(Dass man das eigentlich nicht machen sollte wegen callback hells ignorieren wir hier mal gekonnt)

=== List processing
Seit Java 8 existiert in Java die Streams API. Diese ermöglicht Operationen auf Listen/Arrays in funktionalem Stil:

- Die Eingabe wird nicht mutiert - das Ergebnis einer Stream operation muss in einer neuen Liste gespeichert werden
- Incorporation of Callbacks (ich kann keine deutschen Texte mehr schreiben nachdem ich 3 Praxisarbeiten auf englisch verfasst habe)
- Anstatt zu spezifizieren, wie über die Liste iteriert wird, wird deklarativ gearbeitet

Folgendes Beispiel (again how the fuck do I do references to listings in typst) zeigt eine Operation, die jedem Element einer Liste aus Bestellungen diejenigen selektiert, die noch nicht abgeschlossen wurden, und für jeden dieser Bestellungen zurück gibt, welche Produkte die Bestellung enthält. (todo wir brauchen ein besseres Beispiel (ich such mich mal durch meine Rust projekte))


```Java
List<List<Product>> getOrderingDateOf(List<Order> orders) {
  return orders.stream()
    .filter((Order o) -> !o.isCompleted())
    .map((Order o) -> o.getProducts());
}
```
TODO die häufigsten Operationen (filter, map, foreach etc.) kurz erklären?

JavaScript liefert für Arrays eine beinahe identische API. Aucn Rusts closures bieten eine vergleichbare API. (TODDO mention python list comprehension?)

