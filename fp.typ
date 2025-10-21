= Fundamentale Konzepte des FP
== Pure Functions
== Higher-Order Functions
== Monaden

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

