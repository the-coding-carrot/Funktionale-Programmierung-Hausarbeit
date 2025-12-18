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
#show ref: it => {
  let eq = math.equation
  let el = it.element
  // Skip all other references.
  if el == none or el.func() != eq { return it }
  // Override equation references.
  link(el.location(), numbering(
    el.numbering,
    ..counter(eq).at(el.location())
  ))
}
#set heading(numbering: "1.")
#counter(page).update(1)
#show ref.where(form: "normal"): set ref(supplement: x => {
  if x.func() == heading [Kapitel]
  else {x.supplement}
})
#show heading: set block(below: 1em)
#show raw: set block(fill: rgb(245, 245, 245), inset: 1em, width: 100%)
#show raw.where(block: false): box.with(fill: luma(240), inset:(x: 0.4em), outset: (y: 0.3em), radius: 2pt)
// #show emph: set text(weight: "bold") // wenn man es oft benutzt sieht es scheiße aus
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

