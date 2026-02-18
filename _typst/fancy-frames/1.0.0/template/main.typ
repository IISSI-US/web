#import "@local/fancy-frames:1.0.0": *

// Adding a frame to each page of the document
#show: doc => frame-pages(frame-type: 1, scale-factor: 2, frame-repetition: 0, outer-margin: 1cm, inner-margin: 2cm, frame-center: 0,
 doc)


// Adding a framed block
#align(center+horizon)[
#framed-block(frame-type: 7, frame-center:1, margin: 0cm, scale-factor: 1.2, fill: rgb("#ddd"), outset:5mm, radius: 5mm,[

  #block(inset: 2cm)[
    = Framed Section
    #v(1cm)
    This is a test of the framed block.

    The frame should be centered around this text.

    The frame should automatically resize to fit the text which is.
  ]

])
#v(1cm)
#framed-block(
  frame-type: 0,
  scale-factor: 1,
  margin: 3mm,
  inset: -8mm,
  fill: rgb(98%,98%,98%),
  foreground-color: rgb(25%,25%,25%),
)[ 
  #v(5mm)
  #grid(columns: (3cm, 3cm), align: center+horizon, gutter: 1mm, inset: 3mm, [*Header 1*],grid.vline(),[*Header 2*],
  [Cell 1],[Cell 2],
  [Cell 3],[Cell 4],
  [Cell 5],[Cell 6]
  )
  #v(5mm)
]

]

