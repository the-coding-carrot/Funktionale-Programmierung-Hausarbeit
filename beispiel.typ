#import "util.typ": *

= Funktionale Programmierung für Praktische Anwendungen
In der Praxis ist es nahezu unmöglich, ein Programm vollständig ohne Zustände zu schreiben. Schlussendlich ist Software nur ein Mittel zu einem Zweck, und dieser Zweck manifestiert sich in aller Regel als ein Zustand, der verändert werden muss.

Aus diesem fundamentalen Umstand ergibt sich beinahe von selbst ein Pattern, wie Software mit funktionalen Mitteln aufgebaut werden kann: Der State, der absolut notwendig ist (beispielsweise das Speichern/Laden von Daten aus einer Datenbank) wird an den Rand der Applikation ausgelagert. Der Kern der Applikation wird dann funktional gestaltet, um Komputationen vorzunehmen. Die Seiteneffekte vom Rand der Applikation können durch monadische Strukturen durch die Applikation propagiert werden.

