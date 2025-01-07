#let layout(
  title: [],
  subtitle: [],
  author: [],
  fonts: (
    sans-serif: (),
    serif: (),
    mono: (),
  ),
  body
) = {
  set page(
    paper: "a5",
    binding: left,
    margin: (
      top: 25mm,
      bottom: 15mm,
      inside: 15mm,
      outside: 15mm,
    ),
    header: context {
      set text(font: fonts.sans-serif, size: 8pt)

      let current-chapter = query(heading.where(level: 1)).filter(it => it.location().page() <= here().page()).at(-1, default: none)
      let current-section = query(heading.where(level: 2)).filter(it => it.location().page() <= here().page()).at(-1, default: none)

      block(
        width: 100%,
        stroke: (
          bottom: (thickness: 0.5pt, cap: "butt"),
        ),
        inset: (
          bottom: 2pt,
        )
      )[
        #if calc.even(here().page()) {
          align(left)[
            #box(
              width: 2.5em,
              stroke: (right: (thickness: 1.5pt, cap: "butt")),
              inset: (y: 2pt),
              text(weight: "bold", font: fonts.mono, [#here().page()])
            )
            #box(
              inset: (y: 2pt, left: 0.5em),
              if current-chapter != none {
                numbering("1章", ..counter(heading).at(current-chapter.location()))
                h(1em)
                current-chapter.body
              }
            )
          ]
        } else {
          align(right)[
            #box(
              inset: (y: 2pt, right: 0.5em),
              if current-chapter.location().page() != here().page() and current-section != none {
                numbering("1.1", ..counter(heading).at(current-section.location()))
                h(1em)
                current-section.body
              }
            )
            #box(
              width: 2.5em,
              stroke: (left: (thickness: 1.5pt, cap: "butt")),
              inset: (y: 2pt),
              text(weight: "bold", font: fonts.mono, [#here().page()])
            )
          ]
        }
      ]
    }
  )

  set text(
    lang: "ja",
    font: fonts.serif,
    size: 9pt
  )
  show raw: set text(font: fonts.mono)

  set par(
    leading: 0.8em,
    justify: true,
    linebreaks: auto,
    first-line-indent: 1em,
  )

  set heading(numbering: "1.1.1")
  show heading: set text(font: fonts.sans-serif)

  show heading.where(level: 1): it => {
    {
      set page(header: {})
      pagebreak(to: "odd", weak: true)
    }

    set align(right)
    set text(size: 20pt)

    v(3%)

    text(fill: luma(100))[#numbering("1章", ..counter(heading).at(it.location()))]

    v(-12pt)

    [#it.body]

    v(15%)
  }

  show heading.where(level: 2): it => {
    set text(size: 11pt)
    set par(leading: 0.4em)

    block(
      above: 2.2em,
      below: 1em,
      grid(
        columns: (auto, 1fr),
        gutter: 1em,
        counter(heading).display(),
        it.body
      )
    )
  }

  show heading.where(level: 3): it => {
    set text(size: 10pt)
    set par(leading: 0.4em)

    block(
      above: 1.8em,
      below: 0.8em,
      grid(
        columns: (auto, 1fr),
        gutter: 1em,
        counter(heading).display(),
        it.body
      )
    )
  }

  show heading: it => {
    it
    par(text(size: 0pt, ""))
    v(-0.8em)
  }


  {
    set page(header: {})

    block(
      width: 100%,
      height: 100%,
    )[
      #set text(font: fonts.sans-serif, weight: "bold")

      #v(10%)

      #set align(center + top)
      #text(size: 24pt, title)
      #v(-18pt)
      #text(size: 18pt, subtitle)

      #set align(center + bottom)
      #text(size: 16pt, author)

      #v(10%)
    ]
  }

  counter(page).update(1)

  body
}
