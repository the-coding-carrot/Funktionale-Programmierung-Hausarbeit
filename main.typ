#set document(title: [Funktionale Programmierung])

#include "cover.typ"
#set page(
  margin: (top: 4cm),
  header: align(right)[
    #pad(
      image("images/DHBW-Logo.svg"),
      top: 1cm,
    )
    #line(length: 100%)
  ],
  numbering: "1",
)
#counter(page).update(1)
#show heading: set block(below: 1em)
#show emph: set text(weight: "bold")
#set bibliography(title: "Literaturverzeichnis")
#outline(
  title: "Inhaltsverzeichnis"
)
#pagebreak()
#include "intro.typ"
#pagebreak()
#include "side-effects.typ"
#pagebreak()
#include "fp.typ"
#pagebreak()
#include "beispiel.typ"
#pagebreak()
#include "conclusion.typ"


#bibliography("fp.bib")

