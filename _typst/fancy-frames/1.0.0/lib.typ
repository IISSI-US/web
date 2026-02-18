#import "@preview/cetz:0.4.2"

// Frame definitions
#let frames = (
  (
    image: "/_typst/fancy-frames/1.0.0/corners/corner1.svg",
    width: 1.5cm,
    mirror: 1,
    borders: (
      (0.61pt, 0.083cm),
      (1.7pt, 0.335cm),
      (0.61pt, 0.603cm),
    ),
  ),
  (
    image: "/_typst/fancy-frames/1.0.0/corners/corner2.svg",
    width: 1.5cm,
    mirror: 1,
    borders: (
      (0.92pt, 0.053cm),
      (2.8pt, 0.34cm, rgb("#808080")),
      (0.22pt, 0.149cm),
      (0.54pt, 0.239cm),
      (0.54pt, 0.446cm),
      (0.22pt, 0.538cm),
      (0.54pt, 0.62cm),
    ),
    repetitions: (
      (
        image: "/_typst/fancy-frames/1.0.0/repetitions/repetition2.svg",
        width: 0.3085cm,
        margin: 0.1635cm,
        separation-from-corner: (h: 2cm, v: 2cm),
        mirror: 1,
        spacing: 1mm,
      ),
    ),
  ),
  (
    image: "/_typst/fancy-frames/1.0.0/corners/corner3.svg",
    width: 1.5cm,
    mirror: 1,
    borders: (
      (0.7pt, 0.151cm),
      (0.3pt, 0.202cm),
      (0.3pt, 0.28cm),
      (0.7pt, 0.48cm),
      (0.3pt, 0.531cm),
      (0.3pt, 0.598cm),
    ),
  ),
  (
    image: "/_typst/fancy-frames/1.0.0/corners/corner4.svg",
    width: 1.5cm,
    mirror: 1,
    borders: (
      (0.68pt, 0.038cm),
      (0.34pt, 0.15cm),
      (1.35pt, 0.273cm),
    ),
  ),
  (
    image: "/_typst/fancy-frames/1.0.0/corners/corner5.svg",
    width: 1.5cm,
    mirror: 1,
    borders: (
      (0.5pt, 0.03cm),
      (0.3pt, 0.13cm),
      (0.5pt, 0.23cm),
    ),
  ),
  (
    image: "/_typst/fancy-frames/1.0.0/corners/corner6_a.svg",
    width: 1.5cm,
    mirror: 1,
    borders: (
      (3.85pt, 0.155cm),
      (1.12pt, 0.42cm),
      (0.75pt, 0.555cm),
    ),
  ),
  (
    image: "/_typst/fancy-frames/1.0.0/corners/corner6_b.svg",
    width: 1.5cm,
    mirror: 1,
    borders: (
      (3.85pt, 0.155cm),
      (1.12pt, 0.42cm),
      (0.75pt, 0.555cm),
    ),
  ),
  (
    image: "/_typst/fancy-frames/1.0.0/corners/corner7.svg",
    width: 3cm,
    mirror: 1,
    borders: (
      (0.19pt, 0.128cm),
      (0.19pt, 0.241cm),
    ),
    centers: (
      (
        image: "/_typst/fancy-frames/1.0.0/centers/center7_a.svg",
        rotation: 0deg,
        width: 1.63cm,
        margin-h: -0.723cm,
        margin-v: -0.132cm,
      ),
      (
        image: "/_typst/fancy-frames/1.0.0/centers/center7_b.svg",
        rotation: 0deg,
        width: 1.95cm,
        margin-h: -0.882cm,
        margin-v: -0.643cm,
      ),
    ),
  ),
  (
    image: "/_typst/fancy-frames/1.0.0/corners/corner8.svg",
    width: 3cm,
    mirror: 1,
    borders: (
      (0.36pt, 0.020cm),
      (0.4pt, 0.131cm),
    ),
    centers: (
      (
        image: "/_typst/fancy-frames/1.0.0/centers/center8.svg",
        rotation: 0deg,
        width: 2.0cm,
        margin-h: -0.962cm,
        margin-v: -0.1935cm,
      ),
    ),
  ),
  (
    image: "/_typst/fancy-frames/1.0.0/corners/corner9.svg",
    width: 3cm,
    mirror: 1,
    borders: (
      (0.28pt, 0.303cm),
      (0.28pt, 0.439cm),
      (0.28pt, 1.159cm),
      (0.28pt, 1.294cm),
    ),
    centers: (
      (
        image: "/_typst/fancy-frames/1.0.0/centers/center9.svg",
        rotation: -90deg,
        width: 0.712cm,
        margin-h: 0.043cm,
        margin-v: -1.024cm,
      ),
    ),
    repetitions: (
      (
        image: "/_typst/fancy-frames/1.0.0/repetitions/repetition9_a.svg",
        width: 0.94cm,
        margin: 0.400cm,
        separation-from-corner: (h: 2.3cm, v: 2.3cm),
        mirror: 0,
        spacing: -0.41cm,
        gap-in-mid: (horizontal: 3cm, vertical: 3cm),
      ),
      (
        image: "/_typst/fancy-frames/1.0.0/repetitions/repetition9_b.svg",
        width: 1.2cm,
        margin: 0.409cm,
        separation-from-corner: (h: 2.2cm, v: 2.2cm),
        mirror: 0,
        spacing: -0.35cm,
        gap-in-mid: (horizontal: 3cm, vertical: 3cm),
      ),
    ),
  ),
  (
    image: "/_typst/fancy-frames/1.0.0/corners/corner10.svg",
    width: 4cm,
    mirror: 1,
    borders: (
      (0.24pt, 0.033cm),
      (0.24pt, 0.148cm),
    ),
    centers: (
      (
        image: "/_typst/fancy-frames/1.0.0/centers/center10.svg",
        rotation: 0deg,
        width: 2.5cm,
        margin-h: -1.205cm,
        margin-v: -0.1815cm,
      ),
    ),
  ),
  (
    image: (
      tl: "/_typst/fancy-frames/1.0.0/corners/corner11_tl.svg",
      tr: "/_typst/fancy-frames/1.0.0/corners/corner11_tr.svg",
      bl: "/_typst/fancy-frames/1.0.0/corners/corner11_bl.svg",
      br: "/_typst/fancy-frames/1.0.0/corners/corner11_br.svg",
    ),
    multiple-images: true,
    offset: (
      tl: (x: 0.3cm, y: 0.3cm),
      tr: (x: 0.5cm, y: 0.3cm),
      bl: (x: 0.2cm, y: 0.4cm),
      br: (x: 0.2cm, y: -0.4cm),
    ),
    width: 3.6cm,
    mirror: 0,
    borders: (), // no simple borders
    repetitions: (
      (
        image: "/_typst/fancy-frames/1.0.0/repetitions/repetition11.svg",
        width: 2.5cm,
        margin: 1.3cm,
        separation-from-corner: (h: 2.3cm, v: 2.3cm),
        mirror: 0,
        spacing: -0.045cm,
        force-even: false,
        alternate-horizontal-flip: false,
        caps: (
          start: (image: "/_typst/fancy-frames/1.0.0/repetitions/repetition11_start.svg", width: 1.5cm, offset: (x: 1mm, y: 0mm)),
          end: (image: "/_typst/fancy-frames/1.0.0/repetitions/repetition11_end.svg", width: 1.5cm, offset: (x: 1.1mm, y: 0mm)),
        ),
        gap-in-mid: (horizontal: none, vertical: none),
      ),
      (
        image: "/_typst/fancy-frames/1.0.0/repetitions/repetition11_b.svg",
        width: 2.5cm,
        margin: 1.3cm,
        separation-from-corner: (h: 2.5cm, v: 2.7cm),
        mirror: 0,
        spacing: -0.045cm,
        force-even: false,
        alternate-horizontal-flip: false,
        caps: (
          start: (image: "/_typst/fancy-frames/1.0.0/repetitions/repetition11_b_start.svg", width: 2.21cm, offset: (x: 1mm, y: 0mm)),
          end: (image: "/_typst/fancy-frames/1.0.0/repetitions/repetition11_b_end.svg", width: 2.21cm, offset: (x: 1.1mm, y: 0mm)),
        ),
        gap-in-mid: (horizontal: none, vertical: none),
      ),
    ),
  ),
  (
    image: "/_typst/fancy-frames/1.0.0/corners/corner12.svg",
    width: 3cm,
    mirror: 1,
    borders: (
      (2.1pt, 1.22cm),
    ),
    centers: (
      (
        image: "/_typst/fancy-frames/1.0.0/centers/center12.svg",
        rotation: 0deg,
        width: 4.5cm,
        margin-h: -1.97cm,
        margin-v: -0.2cm,
      ),
    ),
  ),
  (
    image: "/_typst/fancy-frames/1.0.0/corners/corner13.svg",
    rotation: 90deg,
    width: 3cm,
    mirror: 1,
    borders: (),
    repetitions: (
      (
        image: "/_typst/fancy-frames/1.0.0/repetitions/repetition13.svg",
        width: 1.74cm,
        margin: 0.73cm,
        separation-from-corner: (h: 2.17cm, v: 2.16cm),
        mirror: 1,
        spacing: -0.04cm,
        gap-in-mid: (horizontal: 0.1cm, vertical: 0.1cm, flexible: true),
        caps: (
          end: (image: "/_typst/fancy-frames/1.0.0/repetitions/repetition13_end.svg", width: 0.6cm, offset: (x: 0.5mm, y: -0.34mm)),
        ),
      ),
    ),
  ),
  (
    image: "/_typst/fancy-frames/1.0.0/corners/corner14.svg",
    multiple-images: false,
    offset: (
      tl: (x: 0.65cm, y: 0cm),
      tr: (x: 0.65cm, y: 0cm),
      bl: (x: 0.65cm, y: 0cm),
      br: (x: 0.65cm, y: 0cm),
    ),
    width: 3.6cm,
    mirror: 1,
    borders: (), // no simple borders
    centers: (
      (
        image: "/_typst/fancy-frames/1.0.0/centers/center14.svg",
        rotation: 0deg,
        width: 3.58cm,
        margin-h: -0.09cm,
        margin-v: 0.657cm,
      ),
    ),
    repetitions: (
      (
        image: "/_typst/fancy-frames/1.0.0/repetitions/repetition14.svg",
        width: 1.25cm,
        margin: 1.8cm,
        separation-from-corner: (h: 2.37cm, v: 1.7cm),
        mirror: 1,
        spacing: -0.16cm,
        alternate-vertical-flip: true,
        flipped-offset: (x: 0cm, y: 0.181cm),
        gap-in-mid: (horizontal: 3.3cm, vertical: 3.3cm, flexible: false),
      ),
      (
        image: "/_typst/fancy-frames/1.0.0/repetitions/repetition14_b.svg",
        width: 1.25cm,
        margin: 1.476cm,
        separation-from-corner: (h: 2.67cm, v: 2cm),
        mirror: 1,
        spacing: -0.16cm,
        alternate-vertical-flip: true,
        flipped-offset: (x: 0cm, y: -0.471cm),
        gap-in-mid: (horizontal: 3.3cm, vertical: 3.3cm, flexible: false),
      ),
      (
        image: "/_typst/fancy-frames/1.0.0/repetitions/repetition14_c.svg",
        width: 1.25cm,
        margin: 1.567cm,
        separation-from-corner: (h: 2.595cm, v: 1.9cm),
        mirror: 1,
        spacing: -0.07cm,
        alternate-vertical-flip: true,
        flipped-offset: (x: 0cm, y: -0.271cm),
        gap-in-mid: (horizontal: 3.3cm, vertical: 3.3cm, flexible: false),
      ),
      (
        image: "/_typst/fancy-frames/1.0.0/repetitions/repetition14_d.svg",
        width: 1.73cm,
        margin: 1.545cm,
        separation-from-corner: (h: 2.63cm, v: 2cm),
        mirror: 1,
        spacing: -0.1cm,
        alternate-vertical-flip: true,
        flipped-offset: (x: 0cm, y: -0.321cm),
        gap-in-mid: (horizontal: 3.44cm, vertical: 3.45cm, flexible: false),
      ),
    ),
  ),
)

#let load-image(path, bg, fg) = {
  let data = read(path)
  if bg != white {
    data = data.replace("rgb(100%,100%,100%)", bg.to-hex())
  }
  if fg != black {
    data = data.replace("rgb(0%,0%,0%)", fg.to-hex())
    data = data.replace("#000000", fg.to-hex())
  }
  let data = bytes(data)
  data
}

#let pick-frame(id) = {
  if type(id) == int {
    if id < 0 or id >= frames.len() {
      panic("frame-type out of range: " + str(id))
    }
    frames.at(id)
  } else {
    panic("Unsupported frame identifier type (expected int for now).")
  }
}

#let normalize-margins = margin => {
  if type(margin) == dictionary {
    let top = margin.at("top", default: margin.at("t", default: margin.at("all", default: 0pt)))
    let bottom = margin.at("bottom", default: margin.at("b", default: margin.at("all", default: 0pt)))
    let left = margin.at("left", default: margin.at("l", default: margin.at("all", default: 0pt)))
    let right = margin.at("right", default: margin.at("r", default: margin.at("all", default: 0pt)))
    (top: top, bottom: bottom, left: left, right: right)
  } else {
    (top: margin, bottom: margin, left: margin, right: margin)
  }
}

#let fit-repetitions = (available, width, spacing, cap-start-width: 0pt, cap-end-width: 0pt, force-even: false) => {
  // If width is zero or negative, nothing fits
  if width <= 0pt { (0, 0pt) }
  // For n elements, total space is cap-start-width + n*width + (n-1)*spacing + cap-end-width
  // Solve for n: cap-start-width + n*width + (n-1)*spacing + cap-end-width <= available
  // => n = floor((available - cap-start-width - cap-end-width + spacing) / (width + spacing))
  // Add a small epsilon to available to prevent floating point precision issues that could cause off-by-one errors in fitting
  let n = calc.max(0, calc.floor(
    (available + 0.00001pt - cap-start-width - cap-end-width + spacing) / (width + spacing),
  ))
  if (force-even and calc.rem(n, 2) != 0) {
    n = n - 1
  }
  let total = cap-start-width + n * width + (if (n > 0) { (n - 1) * spacing } else { 0pt }) + cap-end-width
  (n, total)
}

#let resolve-frame(custom-frame, frame-type) = {
  if custom-frame == none {
    pick-frame(frame-type)
  } else {
    custom-frame
  }
}

#let clamp-index(index, count) = {
  if index < 0 {
    0
  } else if index >= count {
    count - 1
  } else {
    index
  }
}

#let pick-clamped(items, index, panic-message: "Unsupported index type.") = {
  if type(index) != int {
    panic(panic-message)
  }
  items.at(clamp-index(index, items.len()))
}

#let scale-offset(offset, scale-factor) = (
  x: offset.x * scale-factor,
  y: offset.y * scale-factor,
)

#let resolve-repetition(frame, frame-repetition, repetition-options, scale-factor) = {
  let defaults = (
    repetition: none,
    gap-in-mid: none,
    force-even: false,
    alternate-horizontal-flip: false,
    alternate-vertical-flip: false,
    flipped-offset: (x: 0pt, y: 0pt),
  )

  if not frame.keys().contains("repetitions") or frame.repetitions.len() == 0 {
    return defaults
  }
  if frame-repetition == none or type(frame-repetition) != int {
    return defaults
  }

  let repetition = pick-clamped(
    frame.repetitions,
    frame-repetition,
    panic-message: "Unsupported frame-repetition type.",
  )
  repetition += repetition-options
  let flipped-offset = repetition.at("flipped-offset", default: (x: 0pt, y: 0pt))

  (
    repetition: repetition,
    gap-in-mid: repetition.at("gap-in-mid", default: none),
    force-even: repetition.at("force-even", default: false),
    alternate-horizontal-flip: repetition.at("alternate-horizontal-flip", default: false),
    alternate-vertical-flip: repetition.at("alternate-vertical-flip", default: false),
    flipped-offset: scale-offset(flipped-offset, scale-factor),
  )
}

#let repetition-metrics(repetition, scale-factor) = (
  margin: repetition.margin * scale-factor,
  width: repetition.width * scale-factor,
  spacing: repetition.spacing * scale-factor,
  sep-h: repetition.separation-from-corner.h * scale-factor,
  sep-v: repetition.separation-from-corner.v * scale-factor,
  mirror: repetition.at("mirror", default: 0),
)

#let repetition-cap-widths(repetition, scale-factor) = {
  let start = 0pt
  let end = 0pt
  if repetition.keys().contains("caps") {
    if repetition.caps.keys().contains("start") {
      start = repetition.caps.start.width * scale-factor
    }
    if repetition.caps.keys().contains("end") {
      end = repetition.caps.end.width * scale-factor
    }
  }
  (start: start, end: end)
}

#let load-repetition-caps(repetition, background-color, foreground-color, scale-factor) = {
  let start = none
  let end = none
  if repetition.keys().contains("caps") {
    if repetition.caps.keys().contains("start") {
      let raw = repetition.caps.start
      start = (
        image: load-image(raw.image, background-color, foreground-color),
        width: raw.width * scale-factor,
        offset: scale-offset(raw.offset, scale-factor),
      )
    }
    if repetition.caps.keys().contains("end") {
      let raw = repetition.caps.end
      end = (
        image: load-image(raw.image, background-color, foreground-color),
        width: raw.width * scale-factor,
        offset: scale-offset(raw.offset, scale-factor),
      )
    }
  }
  (start: start, end: end)
}

#let gap-width(gap-in-mid, axis, scale-factor) = {
  if gap-in-mid != none and gap-in-mid.at(axis, default: none) != none {
    gap-in-mid.at(axis) * scale-factor
  } else {
    0pt
  }
}

/// Internal helper.
/// Draws one repetition segment (row/column), including optional start/end caps.
#let place-repetition-row(
  draw-content,
  cushion-space,
  start-x,
  start-y,
  count,
  img,
  width,
  spacing,
  cap-start: none,
  cap-end: none,
  orientation: "horizontal",
  outward: 1,
  invert-h: false,
  invert-v: false,
  alternate-horizontal-flip: false,
  alternate-vertical-flip: false,
  invert-starting-end: false,
  flipped-offset: (x: 0pt, y: 0pt),
) = {
  let count = if count < 0 { 0 } else { count }
  let anchor = "mid-west"

  let flip-x = if invert-h { -100% } else { 100% }
  let flip-y = if invert-v { -100% } else { 100% }
  let transform = it => {
    if flip-x == 100% and flip-y == 100% {
      it
    } else {
      scale(x: flip-x, y: flip-y, it)
    }
  }
  let angle = if orientation == "vertical" { 270deg } else { 0deg }

  let start-cap = if invert-h { cap-end } else { cap-start }
  let end-cap = if invert-h { cap-start } else { cap-end }
  let start-cap-width = if start-cap != none { start-cap.width } else { 0pt }
  let reps-length = if count > 0 { count * width + (count - 1) * spacing } else { 0pt }

  let pos = (x, y) => {
    if orientation == "horizontal" {
      (start-x + x + cushion-space, start-y + outward * y + cushion-space)
    } else {
      (start-x + outward * y + cushion-space, start-y - x + cushion-space)
    }
  }

  if start-cap != none {
    let cap-content = transform(image(start-cap.image, width: start-cap.width))
    draw-content(pos(start-cap.offset.x, start-cap.offset.y), anchor: anchor, angle: angle, cap-content)
  }

  let rep-content = transform(image(img, width: width))
  let rep-content-flipped = scale(
    x: if alternate-horizontal-flip { -100% } else { 100% },
    y: if alternate-vertical-flip { -100% } else { 100% },
    rep-content,
  )
  for i in range(0, count) {
    let is-flipped = if (
      (alternate-horizontal-flip or alternate-vertical-flip)
        and calc.rem(if invert-starting-end { count - i - 1 } else { i }, 2) == 0
    ) { false } else { true }
    let c = if is-flipped { rep-content-flipped } else { rep-content }
    let x = start-cap-width + i * (width + spacing)
    let offset = if is-flipped { flipped-offset } else { (x: 0pt, y: 0pt) }
    draw-content(pos(x + offset.x, offset.y), anchor: anchor, angle: angle, c)
  }

  if end-cap != none {
    let cap-content = transform(image(end-cap.image, width: end-cap.width))
    let x = start-cap-width + reps-length - end-cap.offset.x
    draw-content(pos(x, end-cap.offset.y), anchor: anchor, angle: angle, cap-content)
  }
}

/// Internal helper.
/// Computes one-axis margin delta for `fit-to-repetition`.
/// May update `gap-in-mid[axis]` when flexible gap handling is enabled.
#let fit-axis-margin-adjustment(
  axis,
  frame-extent,
  border-margin,
  border-sep,
  border-width,
  border-spacing,
  cap-start-width,
  cap-end-width,
  gap-in-mid,
  scale-factor,
  force-even,
  flexible-gap-space,
) = {
  let axis-gap = if gap-in-mid != none { gap-in-mid.at(axis, default: none) } else { none }
  let has-gap = axis-gap != none
  let gap-size = if has-gap { axis-gap * scale-factor } else { 0pt }

  let available-space = frame-extent - 2 * border-margin - 2 * border-sep
  let n
  let total-width
  if not has-gap {
    (n, total-width) = fit-repetitions(
      available-space,
      border-width,
      border-spacing,
      cap-start-width: cap-start-width,
      cap-end-width: cap-end-width,
      force-even: force-even,
    )
  } else {
    (n, total-width) = fit-repetitions(
      (available-space - gap-size) / 2,
      border-width,
      border-spacing,
      cap-start-width: cap-start-width,
      cap-end-width: cap-end-width,
      force-even: force-even,
    )
    total-width = total-width * 2 + gap-size
    n = n * 2
  }

  let extra-space = available-space - total-width
  let allow-flex-gap = flexible-gap-space and gap-in-mid != none and (
    if axis == "horizontal" { has-gap } else { true }
  )
  if allow-flex-gap {
    gap-size = extra-space
    gap-in-mid.insert(axis, gap-size / scale-factor)
    return (delta: 0pt)
  }

  let no-gap-for-threshold = gap-in-mid == none or axis-gap == 0pt
  let add-more = if no-gap-for-threshold {
    if force-even {
      extra-space > (border-width + border-spacing)
    } else {
      extra-space > (border-width + border-spacing) / 2
    }
  } else if force-even {
    extra-space > 2 * (border-width + border-spacing)
  } else {
    extra-space > (border-width + border-spacing)
  }

  let no-gap-for-add = if axis == "vertical" {
    gap-in-mid == none or axis-gap == none
  } else {
    gap-in-mid == none or axis-gap == 0pt
  }

  let new-margin = border-margin
  if add-more {
    if no-gap-for-add {
      if force-even {
        n = n + 2
        total-width = total-width + 2 * (border-width + border-spacing)
      } else {
        n = n + 1
        total-width = total-width + border-width + border-spacing
      }
    } else if force-even {
      n = n + 4
      total-width = total-width + 4 * (border-width + border-spacing)
    } else {
      n = n + 2
      total-width = total-width + 2 * (border-width + border-spacing)
    }
    new-margin = (frame-extent - total-width - 2 * border-sep) / 2
  } else {
    new-margin = border-margin + extra-space / 2
  }

  (delta: new-margin - border-margin)
}

/// Internal helper.
/// Draws repetitions for one axis (`horizontal` or `vertical`) with and without
/// mid-gap variants.
#let draw-repetition-axis(
  draw-content,
  cushion-space,
  axis,
  frame-width,
  frame-height,
  border-image,
  border-margin,
  border-width,
  border-spacing,
  border-sep,
  border-mirror,
  cap-start,
  cap-end,
  cap-start-width,
  cap-end-width,
  gap-in-mid,
  scale-factor,
  force-even-no-gap: false,
  force-even-split: false,
  alternate-horizontal-flip: false,
  alternate-vertical-flip: false,
  flipped-offset: (x: 0pt, y: 0pt),
) = {
  let gap = gap-width(gap-in-mid, axis, scale-factor)
  let has-gap = gap-in-mid != none and gap-in-mid.at(axis, default: none) != none
  let frame-span = if axis == "horizontal" { frame-width } else { frame-height }
  let available-space = frame-span - 2 * border-margin - 2 * border-sep - gap

  let fit-space = if has-gap { available-space / 2 } else { available-space }
  let fit-force-even = if has-gap { force-even-split } else { force-even-no-gap }
  let (count, segment-width) = fit-repetitions(
    fit-space,
    border-width,
    border-spacing,
    cap-start-width: cap-start-width,
    cap-end-width: cap-end-width,
    force-even: fit-force-even,
  )

  if axis == "horizontal" {
    if not has-gap {
      let start-x = border-margin + border-sep + (available-space - segment-width) / 2
      place-repetition-row(
        draw-content,
        cushion-space,
        start-x,
        frame-height - border-margin,
        count,
        border-image,
        border-width,
        border-spacing,
        cap-start: cap-start,
        cap-end: cap-end,
        orientation: "horizontal",
        outward: 1,
        invert-h: false,
        invert-v: false,
        alternate-horizontal-flip: alternate-horizontal-flip,
        alternate-vertical-flip: alternate-vertical-flip,
        flipped-offset: flipped-offset,
      )
      place-repetition-row(
        draw-content,
        cushion-space,
        start-x,
        border-margin,
        count,
        border-image,
        border-width,
        border-spacing,
        cap-start: cap-start,
        cap-end: cap-end,
        orientation: "horizontal",
        outward: -1,
        invert-h: border-mirror == 0,
        invert-v: true,
        alternate-horizontal-flip: alternate-horizontal-flip,
        alternate-vertical-flip: alternate-vertical-flip,
        flipped-offset: flipped-offset,
      )
    } else {
      let start-x-left = border-margin + border-sep + (available-space / 2 - segment-width)
      let start-x-right = start-x-left + segment-width + gap
      place-repetition-row(
        draw-content,
        cushion-space,
        start-x-left,
        frame-height - border-margin,
        count,
        border-image,
        border-width,
        border-spacing,
        cap-start: cap-start,
        cap-end: cap-end,
        orientation: "horizontal",
        outward: 1,
        invert-h: false,
        invert-v: false,
        alternate-horizontal-flip: alternate-horizontal-flip,
        alternate-vertical-flip: alternate-vertical-flip,
        flipped-offset: flipped-offset,
      )
      place-repetition-row(
        draw-content,
        cushion-space,
        start-x-right,
        frame-height - border-margin,
        count,
        border-image,
        border-width,
        border-spacing,
        cap-start: cap-start,
        cap-end: cap-end,
        orientation: "horizontal",
        outward: 1,
        invert-h: true,
        invert-v: false,
        alternate-horizontal-flip: alternate-horizontal-flip,
        alternate-vertical-flip: alternate-vertical-flip,
        invert-starting-end: true,
        flipped-offset: flipped-offset,
      )
      place-repetition-row(
        draw-content,
        cushion-space,
        start-x-left,
        border-margin,
        count,
        border-image,
        border-width,
        border-spacing,
        cap-start: cap-start,
        cap-end: cap-end,
        orientation: "horizontal",
        outward: -1,
        invert-h: false,
        invert-v: true,
        alternate-horizontal-flip: alternate-horizontal-flip,
        alternate-vertical-flip: alternate-vertical-flip,
        flipped-offset: flipped-offset,
      )
      place-repetition-row(
        draw-content,
        cushion-space,
        start-x-right,
        border-margin,
        count,
        border-image,
        border-width,
        border-spacing,
        cap-start: cap-start,
        cap-end: cap-end,
        orientation: "horizontal",
        outward: -1,
        invert-h: true,
        invert-v: true,
        alternate-horizontal-flip: alternate-horizontal-flip,
        alternate-vertical-flip: alternate-vertical-flip,
        invert-starting-end: true,
        flipped-offset: flipped-offset,
      )
    }
    return
  }

  if not has-gap {
    let start-y = frame-height - border-margin - border-sep - (available-space - segment-width) / 2
    place-repetition-row(
      draw-content,
      cushion-space,
      border-margin,
      start-y,
      count,
      border-image,
      border-width,
      border-spacing,
      cap-start: cap-start,
      cap-end: cap-end,
      orientation: "vertical",
      outward: -1,
      invert-h: border-mirror == 0,
      invert-v: true,
      alternate-horizontal-flip: alternate-horizontal-flip,
      alternate-vertical-flip: alternate-vertical-flip,
      flipped-offset: flipped-offset,
    )
    place-repetition-row(
      draw-content,
      cushion-space,
      frame-width - border-margin,
      start-y,
      count,
      border-image,
      border-width,
      border-spacing,
      cap-start: cap-start,
      cap-end: cap-end,
      orientation: "vertical",
      outward: 1,
      invert-h: false,
      invert-v: false,
      alternate-horizontal-flip: alternate-horizontal-flip,
      alternate-vertical-flip: alternate-vertical-flip,
      flipped-offset: flipped-offset,
    )
  } else {
    let start-y-top = frame-height - border-margin - border-sep - (available-space / 2 - segment-width)
    let start-y-bottom = start-y-top - segment-width - gap
    place-repetition-row(
      draw-content,
      cushion-space,
      border-margin,
      start-y-top,
      count,
      border-image,
      border-width,
      border-spacing,
      cap-start: cap-start,
      cap-end: cap-end,
      orientation: "vertical",
      outward: -1,
      invert-h: false,
      invert-v: true,
      alternate-horizontal-flip: alternate-horizontal-flip,
      alternate-vertical-flip: alternate-vertical-flip,
      flipped-offset: flipped-offset,
    )
    place-repetition-row(
      draw-content,
      cushion-space,
      border-margin,
      start-y-bottom,
      count,
      border-image,
      border-width,
      border-spacing,
      cap-start: cap-start,
      cap-end: cap-end,
      orientation: "vertical",
      outward: -1,
      invert-h: true,
      invert-v: true,
      alternate-horizontal-flip: alternate-horizontal-flip,
      alternate-vertical-flip: alternate-vertical-flip,
      invert-starting-end: true,
      flipped-offset: flipped-offset,
    )
    place-repetition-row(
      draw-content,
      cushion-space,
      frame-width - border-margin,
      start-y-top,
      count,
      border-image,
      border-width,
      border-spacing,
      cap-start: cap-start,
      cap-end: cap-end,
      orientation: "vertical",
      outward: 1,
      invert-h: false,
      invert-v: false,
      alternate-horizontal-flip: alternate-horizontal-flip,
      alternate-vertical-flip: alternate-vertical-flip,
      flipped-offset: flipped-offset,
    )
    place-repetition-row(
      draw-content,
      cushion-space,
      frame-width - border-margin,
      start-y-bottom,
      count,
      border-image,
      border-width,
      border-spacing,
      cap-start: cap-start,
      cap-end: cap-end,
      orientation: "vertical",
      outward: 1,
      invert-h: true,
      invert-v: false,
      alternate-horizontal-flip: alternate-horizontal-flip,
      alternate-vertical-flip: alternate-vertical-flip,
      invert-starting-end: true,
      flipped-offset: flipped-offset,
    )
  }
}

#let default-corner-offsets = (
  tl: (x: 0cm, y: 0cm),
  tr: (x: 0cm, y: 0cm),
  bl: (x: 0cm, y: 0cm),
  br: (x: 0cm, y: 0cm),
)

#let resolve-corner-offsets(frame) = frame.at("offset", default: default-corner-offsets)

#let build-corner-images(frame, background-color, foreground-color) = {
  if type(frame.image) == str {
    let img = image(load-image(frame.image, background-color, foreground-color), width: frame.width)
    (tl: img, tr: img, bl: img, br: img)
  } else {
    (
      tl: image(load-image(frame.image.tl, background-color, foreground-color), width: frame.width),
      tr: image(load-image(frame.image.tr, background-color, foreground-color), width: frame.width),
      bl: image(load-image(frame.image.bl, background-color, foreground-color), width: frame.width),
      br: image(load-image(frame.image.br, background-color, foreground-color), width: frame.width),
    )
  }
}

#let resolve-background-color(background-color, block-attributes) = {
  if background-color != none {
    return background-color
  }
  let fill = block-attributes.at("fill", default: none)
  if fill != none {
    fill
  } else {
    white
  }
}

/// Draw a frame around the current context (parent object)
/// with given parameters.
///
/// Parameters
/// - `frame-type` (int): Selects the frame style.
/// - `custom-frame` (dict | none): If provided, uses this frame definition. The image must be provided directly Example: ```typ
/// (
///   image: image("./carnet.jpg", width: 1.5cm),
///   mirror: 1,
///   borders: (
///     (0.61pt, 0.083cm),
///     (1.7pt, 0.335cm),
///     (0.61pt, 0.603cm),
///   ),
/// )
/// ```
/// - `scale-factor` (number): Scales all frame elements; larger → bigger frame.
/// - `margin` (length | dict): Space between frame and content. Single value or
///   dictionary `{ top, bottom, left, right }` (aliases: `t, b, l, r`, or `all`).
/// - `mirror` (0 | 1 | none): Horizontal mirroring. If `none`, uses frame default.
/// - `frame-center` (int | none): Index of center decoration (if available).
/// - `frame-repetition` (int | none): Index of repetition border (if available).
///   Out-of-range values are clamped. If `none`, no repetition border is drawn.
/// - `background-color` (color): Replaces white in images to blend with bg.
/// - `foreground-color` (color): Replaces black in images (frame color).
/// - `fit-to-repetition` (bool): If true and a repetition border is selected,
///   adjusts margins so repetitions/caps fit cleanly.
/// - `repetition-options` (dict): Overrides merged into the selected repetition
///   definition (for example `spacing`, `gap-in-mid`, `force-even`).
/// - `cushion-space` (length): Extra off-page drawing room used by the canvas
///   for frame elements that extend beyond the margin box.
///
/// Defaults
/// - `frame-type: 0` · `scale-factor: 2` · `margin: 1cm`
/// - `mirror: none` · `frame-center: none`
/// - `background-color: white` · `foreground-color: black`
/// - `fit-to-repetition: false` · `cushion-space: 1cm`
///
/// Example
/// ```typ
/// // Inside a container/context:
/// #frame-background(
///   frame-type: 2,
///   scale-factor: 2.2,
///   margin: (top: 8mm, bottom: 10mm, left: 12mm, right: 12mm),
///   frame-center: 0,
///   foreground-color: rgb(20%,20%,20%),
/// )
/// ```
///
/// Notes
/// - Colors are applied by replacing white/black in the SVG assets.
/// - If `frame-center` is out of range, it is clamped to the nearest valid index.
/// - If `frame-repetition` is out of range, it is clamped to the nearest valid index.
#let frame-background(
  frame-type: 0,
  custom-frame: none,
  scale-factor: 2,
  margin: 1cm,
  mirror: none,
  frame-center: none,
  frame-repetition: none,
  background-color: white,
  foreground-color: black,
  fit-to-repetition: false,
  repetition-options: (:),
  cushion-space:0.1cm,
) = context {
  let frame = resolve-frame(custom-frame, frame-type)
  let mirror = if mirror != none { mirror } else { frame.mirror }
  let m = normalize-margins(margin)
  layout(size => {
    let frame-height = size.height - m.top - m.bottom
    let frame-width = size.width - m.left - m.right
    let adjusted-m = m
    let repetition-state = resolve-repetition(frame, frame-repetition, repetition-options, scale-factor)
    let repetition = repetition-state.repetition
    let gap-in-mid = repetition-state.gap-in-mid
    let force-even = repetition-state.force-even
    let alternate-horizontal-flip = repetition-state.alternate-horizontal-flip
    let alternate-vertical-flip = repetition-state.alternate-vertical-flip
    let flipped-offset = repetition-state.flipped-offset
    // --- Fit-to-repetition margin adjustment ---
    if fit-to-repetition and repetition != none {
      let border = repetition
      let metrics = repetition-metrics(border, scale-factor)
      let border-width = metrics.width
      let border-spacing = metrics.spacing
      let border-margin = metrics.margin
      let border-sep-h = metrics.sep-h
      let border-sep-v = metrics.sep-v
      let caps = repetition-cap-widths(border, scale-factor)
      let cap-start-width = caps.start
      let cap-end-width = caps.end
      let flexible-gap-space = if gap-in-mid != none { gap-in-mid.at("flexible", default: false) } else { false }
      let horizontal-fit = fit-axis-margin-adjustment(
        "horizontal",
        frame-width,
        border-margin,
        border-sep-h,
        border-width,
        border-spacing,
        cap-start-width,
        cap-end-width,
        gap-in-mid,
        scale-factor,
        force-even,
        flexible-gap-space,
      )
      adjusted-m = (
        top: adjusted-m.top,
        bottom: adjusted-m.bottom,
        left: m.left + horizontal-fit.delta,
        right: m.right + horizontal-fit.delta,
      )

      let vertical-fit = fit-axis-margin-adjustment(
        "vertical",
        frame-height,
        border-margin,
        border-sep-v,
        border-width,
        border-spacing,
        cap-start-width,
        cap-end-width,
        gap-in-mid,
        scale-factor,
        force-even,
        flexible-gap-space,
      )
      adjusted-m = (
        top: adjusted-m.top + vertical-fit.delta,
        bottom: adjusted-m.bottom + vertical-fit.delta,
        left: adjusted-m.left,
        right: adjusted-m.right,
      )

      frame-height = size.height - adjusted-m.top - adjusted-m.bottom
      frame-width = size.width - adjusted-m.left - adjusted-m.right
    }

    box(width: 100%, height: 100%)[
      #place(
        left,
        dx: adjusted-m.left - cushion-space,
        dy: adjusted-m.bottom - cushion-space,
        cetz.canvas({
          import cetz.draw: content, rect
          let horizontal-bounding = size.width
          horizontal-bounding = horizontal-bounding - adjusted-m.left
          horizontal-bounding = horizontal-bounding - adjusted-m.right
          horizontal-bounding = horizontal-bounding + cushion-space * 2
          let vertical-bounding = size.height
          vertical-bounding = vertical-bounding - adjusted-m.top
          vertical-bounding = vertical-bounding - adjusted-m.bottom
          vertical-bounding = vertical-bounding + cushion-space * 2
          // transparent border that takes the entire area (size) to determine the canvas size
          rect((0, 0), (horizontal-bounding, vertical-bounding), fill: none, stroke: none)
          // Draw normal borders
          for border in frame.borders {
            if type(border) == array {
              let border-color = if border.len() > 2 { border.at(2) } else { foreground-color }
              let inset = border.at(1) * scale-factor
              rect(
                (inset / 2 + cushion-space, inset / 2 + cushion-space),
                (
                  rel: (
                    frame-width - inset,
                    frame-height - inset,
                  ),
                ),
                stroke: (paint: border-color, thickness: (border.at(0) * scale-factor)),
              )
            }
          }
          // Draw repetition border if present
          if repetition != none {
            let border = repetition
            let border-image = load-image(border.image, background-color, foreground-color)
            let metrics = repetition-metrics(border, scale-factor)
            let border-margin = metrics.margin
            let border-width = metrics.width
            let border-spacing = metrics.spacing
            let border-sep-h = metrics.sep-h
            let border-sep-v = metrics.sep-v
            let border-mirror = metrics.mirror
            let caps = load-repetition-caps(border, background-color, foreground-color, scale-factor)
            let cap-start = caps.start
            let cap-end = caps.end
            let cap-start-width = if cap-start != none { cap-start.width } else { 0pt }
            let cap-end-width = if cap-end != none { cap-end.width } else { 0pt }
            draw-repetition-axis(
              content,
              cushion-space,
              "horizontal",
              frame-width,
              frame-height,
              border-image,
              border-margin,
              border-width,
              border-spacing,
              border-sep-h,
              border-mirror,
              cap-start,
              cap-end,
              cap-start-width,
              cap-end-width,
              gap-in-mid,
              scale-factor,
              force-even-no-gap: false,
              force-even-split: force-even,
              alternate-horizontal-flip: alternate-horizontal-flip,
              alternate-vertical-flip: alternate-vertical-flip,
              flipped-offset: flipped-offset,
            )
            draw-repetition-axis(
              content,
              cushion-space,
              "vertical",
              frame-width,
              frame-height,
              border-image,
              border-margin,
              border-width,
              border-spacing,
              border-sep-v,
              border-mirror,
              cap-start,
              cap-end,
              cap-start-width,
              cap-end-width,
              gap-in-mid,
              scale-factor,
              force-even-no-gap: force-even,
              force-even-split: false,
              alternate-horizontal-flip: alternate-horizontal-flip,
              alternate-vertical-flip: alternate-vertical-flip,
              flipped-offset: flipped-offset,
            )
          }
        }),
      )
    ]

    // Place corners
    let corner-images = build-corner-images(frame, background-color, foreground-color)
    let offsets = resolve-corner-offsets(frame)
    let multiple-images = frame.at("multiple-images", default: false)

    let corner-tl = corner-images.tl
    let corner-tr = corner-images.tr
    let corner-bl = corner-images.bl
    let corner-br = corner-images.br

    if multiple-images {
      corner-tl = scale(x: 100% * scale-factor, y: 100% * scale-factor, origin: top + left, corner-images.tl)

      corner-tr = scale(
        x: 100% * (1 - mirror * 2),
        scale(x: 100% * scale-factor, y: 100% * scale-factor, origin: top + right, corner-images.tr),
      )

      corner-bl = scale(
        y: 100% * (1 - mirror * 2),
        scale(x: 100% * scale-factor, y: 100% * scale-factor, origin: bottom + left, corner-images.bl),
      )

      corner-br = scale(
        x: 100% * (1 - mirror * 2),
        y: 100% * (1 - mirror * 2),
        scale(x: 100% * scale-factor, y: 100% * scale-factor, origin: bottom + right, corner-images.br),
      )
    } else {
      let rotation = frame.at("rotation", default: 0deg)
      corner-tl = rotate(270deg, scale(
        x: 100% * scale-factor,
        y: 100% * scale-factor,
        origin: top + right,
        rotate(rotation, corner-images.tl),
      ))

      corner-tr = scale(
        x: 100% * (1 - mirror * 2),
        rotate(270deg * mirror, scale(
          x: 100% * scale-factor,
          y: 100% * scale-factor,
          origin: top + right,
          rotate(rotation, corner-images.tr),
        )),
      )

      corner-bl = scale(
        y: 100% * (1 - mirror * 2),
        rotate(180deg + 90deg * mirror, scale(
          x: 100% * scale-factor,
          y: 100% * scale-factor,
          origin: top + right,
          rotate(rotation, corner-images.bl),
        )),
      )

      corner-br = scale(
        x: 100% * (1 - mirror * 2),
        y: 100% * (1 - mirror * 2),
        rotate(180deg + 90deg * mirror, scale(
          x: 100% * scale-factor,
          y: 100% * scale-factor,
          origin: top + right,
          rotate(rotation, corner-images.br),
        )),
      )
    }

    place(
      left + top,
      dx: adjusted-m.left + offsets.tl.x * scale-factor,
      dy: adjusted-m.top + offsets.tl.y * scale-factor,
      corner-tl,
    )

    place(
      top + right,
      dx: -(adjusted-m.right + offsets.tr.x * scale-factor),
      dy: adjusted-m.top + offsets.tr.y * scale-factor,
      corner-tr,
    )

    place(
      left + bottom,
      dx: adjusted-m.left + offsets.bl.x * scale-factor,
      dy: -(adjusted-m.bottom + offsets.bl.y * scale-factor),
      corner-bl,
    )

    place(
      bottom + right,
      dx: -(adjusted-m.right + offsets.br.x * scale-factor),
      dy: -(adjusted-m.bottom + offsets.br.y * scale-factor),
      corner-br,
    )

    // Place centers
    if (frame-center != none and frame.keys().contains("centers")) {
      let fc = pick-clamped(frame.centers, frame-center, panic-message: "Unsupported frame-center type.")
      let center-image = load-image(fc.image, background-color, foreground-color)
      let center-width = fc.width * scale-factor

      place(
        left + horizon,
        dx: adjusted-m.left + fc.margin-h * scale-factor,
        dy: (adjusted-m.top - adjusted-m.bottom) / 2,
        [
          #rotate(270deg + fc.rotation, image(center-image, width: center-width))
        ],
      )

      place(
        right + horizon,
        dx: -(adjusted-m.right + fc.margin-h * scale-factor),
        dy: (adjusted-m.top - adjusted-m.bottom) / 2,
        scale(
          x: -100%,
          rotate(270deg + fc.rotation, image(center-image, width: center-width)),
        ),
      )

      place(
        center + top,
        dx: (adjusted-m.left - adjusted-m.right) / 2,
        dy: adjusted-m.top + fc.margin-v * scale-factor,
        rotate(fc.rotation, image(center-image, width: center-width)),
      )

      place(
        center + bottom,
        dx: (adjusted-m.left - adjusted-m.right) / 2,
        dy: -(adjusted-m.bottom + fc.margin-v * scale-factor),
        scale(
          x: -100%,
          rotate(180deg + fc.rotation, image(center-image, width: center-width)),
        ),
      )
    }
  })
}

/// Adds a frame to each page of the document.
///
/// Parameters
/// - `frame-type` (int): Frame style index.
/// - `custom-frame` (dict | none): If provided, uses this frame definition. The image must be provided directly Example: ```typ
/// (
///  image: image("./carnet.jpg", width: 1.5cm),
///  mirror: 1,
///  borders: (
///    (0.61pt, 0.083cm),
///    (1.7pt, 0.335cm),
///    (0.61pt, 0.603cm),
///  ),
/// )
/// ```
/// - `scale-factor` (number): Global frame scaling.
/// - `outer-margin` (length): Margin to page edge on outer sides.
/// - `inner-margin` (length): Margin to content on inner side (spreads).
/// - `mirror` (0 | 1 | none): Horizontal mirroring; `none` uses frame default.
/// - `frame-center` (int | none): Center ornament index (if available).
/// - `frame-repetition` (int | none): Index of repetition border (if available).
///   Out-of-range values are clamped. If `none`, no repetition border is drawn.
/// - `inner-odd` (bool): If true, inner margin applied to odd pages; else even.
/// - `page-color` (color): Replaces white in images so they blend with the page.
/// - `foreground-color` (color): Frame stroke color via black replacement.
/// - `fit-to-repetition` (bool): If true and a repetition border is selected,
///   adjusts margins so repetitions/caps fit cleanly.
/// - `repetition-options` (dict): Overrides merged into the selected repetition
///   definition (for example `spacing`, `gap-in-mid`, `force-even`).
/// - `doc` (content): Document content to render with page background framing.
///
/// Defaults
/// - `frame-type: 0` · `scale-factor: 2`
/// - `outer-margin: 1cm` · `inner-margin: 3cm` · `inner-odd: true`
/// - `mirror: none` · `frame-center: none`
/// - `page-color: white` · `foreground-color: black`
/// - `fit-to-repetition: false`
///
/// Example
/// ```typst
/// #frame-pages(
///   frame-type: 7,
///   scale-factor: 1.8,
///   outer-margin: 12mm,
///   inner-margin: 28mm,
///   inner-odd: true,
///   page-color: white,
///   foreground-color: rgb(15%,15%,15%),
/// )[
///   // Entire document content…
/// —
/// ]
/// ```
///
/// Notes
/// - This draws via `page(background: …)`. It does not alter the page fill.
/// - Inner margin side flips based on page parity and `inner-odd`.
#let frame-pages(
  frame-type: 0,
  custom-frame: none,
  scale-factor: 2,
  outer-margin: 1cm,
  inner-margin: 3cm,
  mirror: none,
  frame-center: none,
  frame-repetition: none,
  inner-odd: true,
  page-color: white,
  foreground-color: black,
  fit-to-repetition: false,
  repetition-options: (:),
  doc,
) = {
  let frame = resolve-frame(custom-frame, frame-type)
  let mirror = if mirror != none { mirror } else { frame.mirror }
  set page(
    background: context {
      let isOdd = calc.rem(counter(page).get().at(0), 2)
      if inner-odd {
        isOdd = (1 - isOdd)
      }
      let page-margin = (
        top: outer-margin,
        bottom: outer-margin,
        left: isOdd * inner-margin + (1 - isOdd) * outer-margin,
        right: (1 - isOdd) * inner-margin + isOdd * outer-margin,
      )

      frame-background(
        frame-type: frame-type,
        custom-frame: frame,
        scale-factor: scale-factor,
        margin: page-margin,
        mirror: mirror,
        frame-center: frame-center,
        frame-repetition: frame-repetition,
        background-color: page-color,
        foreground-color: foreground-color,
        fit-to-repetition: fit-to-repetition,
        repetition-options: repetition-options,
      )
    },
  )
  doc
}

/// Wraps arbitrary content in a framed block, respecting block attributes and
/// automatically defaulting the frame background to the block `fill` if set.
///
/// Parameters
/// - `frame-type` (int): Frame style index.
/// - `custom-frame` (dict | none): If provided, uses this frame definition. The image must be provided directly Example: ```typ
/// (
///  image: image("./carnet.jpg", width: 1.5cm),
///  mirror: 1,
///  borders: (
///    (0.61pt, 0.083cm),
///    (1.7pt, 0.335cm),
///    (0.61pt, 0.603cm),
///  ),
/// )
/// ```
/// - `scale-factor` (number): Global frame scaling.
/// - `margin` (length | dict): Gap between content and frame; accepts single
///   value or `{ top, bottom, left, right }` (aliases `t, b, l, r`, or `all`).
/// - `mirror` (0 | 1 | none): Horizontal mirroring; `none` uses frame default.
/// - `frame-center` (int | none): Center ornament index (if available).
/// - `frame-repetition` (int | none): Index of repetition border (if available).
///   Out-of-range values are clamped. If `none`, no repetition border is drawn.
/// - `background-color` (color | none): Replaces white in images. If `none` and
///   the block has `fill`, that fill is used; otherwise defaults to `white`.
/// - `foreground-color` (color): Frame stroke color via black replacement.
/// - `..block-attributes`: Forwarded to the underlying block (e.g., `inset`,
///   `align`, `width`, `height`, `fill`, etc.).
/// - `body`: The content to render inside the frame. *Important:* the frame will break if the contents are too small. It is usually a good idea to place the content within a padded block.
/// - `fit-to-repetition` (bool): If true and a repetition border is selected,
///   adjusts margins so repetitions/caps fit cleanly.
/// - `repetition-options` (dict): Overrides merged into the selected repetition
///   definition (for example `spacing`, `gap-in-mid`, `force-even`).
///
/// Defaults
/// - `frame-type: 0` · `scale-factor: 2` · `margin: 1cm`
/// - `mirror: none` · `frame-center: none`
/// - `background-color: none → (fill | white)` · `foreground-color: black`
/// - `fit-to-repetition: false`
///
/// Example
/// ```typ
///#framed-block(
///  frame-type: 6,
///  scale-factor: 1.6,
///  margin: 3mm,
///  fill: rgb(98%,98%,98%),
///  foreground-color: rgb(25%,25%,25%),
///)[
///  #block(inset: 2.5cm)[
///  = Framed Section
///  Elegant content with a subtle background.
///  ]
///]
/// ```
///
/// Notes
/// - The block’s size matches its measured content unless attributes override it.
/// - Background color resolution: explicit `background-color` > `fill` > `white`.
#let framed-block(
  frame-type: 0,
  custom-frame: none,
  scale-factor: 2,
  margin: 1cm,
  mirror: none,
  frame-center: none,
  frame-repetition: none,
  background-color: none,
  foreground-color: black,
  fit-to-repetition: false,
  repetition-options: (:),
  ..block-attributes,
  body,
) = context {
  let size = measure(body)
  let background-color = resolve-background-color(background-color, block-attributes)
  block(
    width: size.width,
    height: size.height,
    ..block-attributes,
    [
      #place(left + top)[
        #frame-background(
          frame-type: frame-type,
          custom-frame: custom-frame,
          scale-factor: scale-factor,
          margin: margin,
          mirror: mirror,
          frame-center: frame-center,
          frame-repetition: frame-repetition,
          background-color: background-color,
          foreground-color: foreground-color,
          fit-to-repetition: fit-to-repetition,
          repetition-options: repetition-options,
        )]
      #body
    ],
  )
}
