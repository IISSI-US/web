#import "@preview/cmarker:0.1.6"
#import "typst-packages/mitex/0.2.5/mitex.typ": mitex
#import "@preview/gentle-clues:1.2.0": *
#import "@preview/hydra:0.6.2": anchor, hydra
#import "_typst/fancy-frames/1.0.0/lib.typ": *

#let color-strong = rgb("#165693")
#let color-weak = rgb("#D9E1F2")

#let strip-quotes(value) = {
  if type(value) != str {
    return value
  }
  let trimmed = value.trim()
  if (
    trimmed.len() >= 2
      and (
        (trimmed.starts-with("\"") and trimmed.ends-with("\"")) or (trimmed.starts-with("'") and trimmed.ends-with("'"))
      )
  ) {
    trimmed.slice(1, -1)
  } else {
    trimmed
  }
}

#let parse-meta-lines(lines) = {
  let meta = (:)
  for line in lines {
    let trimmed = line.trim()
    if trimmed == "" or trimmed.starts-with("#") {
      continue
    }
    let parts = trimmed.split(":")
    if parts.len() < 2 {
      continue
    }
    let key = parts.at(0).trim()
    if key == "" {
      continue
    }
    let value = parts.slice(1).join(":").trim()
    meta.insert(key, strip-quotes(value))
  }
  meta
}

#let extract-meta(text) = {
  if type(text) != str or not text.starts-with("---") {
    return ((:), text)
  }
  let lines = text.split("\n")
  if lines.len() == 0 or lines.at(0).trim() != "---" {
    return ((:), text)
  }
  let rest = lines.slice(1)
  let closing = rest.position(line => line.trim() == "---")
  if closing == none {
    return ((:), text)
  }
  let meta-lines = rest.slice(0, closing)
  let content = rest.slice(closing + 1).join("\n")
  (parse-meta-lines(meta-lines), content)
}

#let get-field(meta, key) = {
  if type(meta) != dictionary {
    return none
  }
  meta.at(key, default: none)
}

#let or-default(value, fallback) = {
  if value == none {
    fallback
  } else if type(value) == str and value.trim() == "" {
    fallback
  } else {
    value
  }
}

#let include-pattern = regex("\\{\\%\\s*include\\s+sql-embed\\.html([^%]*)\\%\\}")
#let liquid-asset-pattern = regex("\\{\\{\\s*['\\\"]([^'\\\"]+)['\\\"]\\s*\\|\\s*relative_url\\s*\\}\\}")

#let extract-attr(attrs, name) = {
  let pat = regex(name + "\\s*=\\s*['\\\"]([^'\\\"]+)['\\\"]")
  let match = attrs.match(pat)
  if match == none {
    none
  } else {
    match.captures.at(0)
  }
}

#let expand-sql-embeds(text) = {
  if type(text) != str {
    return text
  }
  text.replace(include-pattern, m => {
    let attrs = m.captures.at(0)
    let raw-src = extract-attr(attrs, "src")
    if raw-src == none {
      return ""
    }
    let label = extract-attr(attrs, "label")

    // Si es una URL HTTP, no intentar leerla, solo mostrar referencia
    if raw-src.starts-with("http://") or raw-src.starts-with("https://") {
      let title = if label != none { "**" + label + "**\n\n" } else { "" }
      return title + "> _Código SQL disponible en: " + raw-src + "_\n\n"
    }

    // Para rutas locales, leer el archivo
    let rel = if raw-src.starts-with("/") { raw-src.slice(1) } else { raw-src }
    let sql = read(rel)
    let title = if label != none { "**" + label + "**\n\n" } else { "" }
    title + "```sql\n" + sql + "\n```\n"
  })
}

#let expand-liquid-paths(text) = {
  if type(text) != str {
    return text
  }
  text.replace(liquid-asset-pattern, m => {
    let path = m.captures.at(0)
    if path.starts-with("/") {
      path.slice(1)
    } else {
      path
    }
  })
}

#let strip-local-anchors(text) = {
  if type(text) != str {
    return text
  }
  let anchor-pattern = regex("\\[([^\\]]+)\\]\\(\\s*#([^\\)]+)\\)")
  text.replace(anchor-pattern, m => m.captures.at(0))
}

// Reescribe macros de álgebra relacional para mejor renderizado en LaTeX
#let rewrite-math(src) = {
  src
    // selección
    .replace("\\Sel{", "\\Large \\displaystyle \\sigma\\limits_{")
    // proyección
    .replace("\\Proj{", "\\Large \\displaystyle \\Pi\\limits_{")
    // renombrado
    .replace("\\Ren{", "\\Large \\displaystyle \\rho\\limits_{")
    // agrupación (gamma con superíndice)
    .replace("\\Group{", "\\Large \\displaystyle \\gamma\\limits^{")
    // agrupación (gamma con superíndice) II
    .replace("\\GroupUp{", "\\Large \\displaystyle \\gamma\\limits^{")
    // operadores estándar
    .replace("\\NatJoin", "\\Large \\displaystyle \\Join")
    .replace("\\JoinR{", "\\Large \\displaystyle \\Join\\limits_{")
    .replace("\\GroupDown{", "\\Large \\displaystyle \\gamma\\limits_{")
    .replace("\\Inter", "\\Large \\displaystyle \\cap")
    .replace("\\Union", "\\Large \\displaystyle \\cup")
    .replace("\\Diff", "\\Large \\displaystyle \\setminus")
    .replace("\\Div", "\\Large \\displaystyle \\div")
    .replace("\\LeftJoin", "\\Large \\displaystyle \\ltimes")
    .replace("\\RightJoin", "\\Large \\displaystyle \\rtimes")
    .replace("\\OuterJoin", "\\Large \\displaystyle \\bowtie")
}

// Handler de matemáticas: reescribe macros y pasa por MiTeX
#let algebra-math(src, block: false) = {
  mitex(rewrite-math(src), block: block)
}

#let md-path = sys.inputs.at("md", default: "mc2mr/01_universidad/index.md")
#let raw-contents = read(md-path)

// separar meta y contenido
#let (meta, clean) = extract-meta(raw-contents)
#let clean = strip-local-anchors(expand-liquid-paths(expand-sql-embeds(clean)))

// renderizar markdown
#let body = cmarker.render(
  clean,
  h1-level: 0,
  math: algebra-math,
  scope: (image: (path, alt: none) => image(path, alt: alt)),
)

// título y autor desde YAML
#let doc-title = or-default(get-field(meta, "title"), "Documento")
#set document(title:doc-title)
#let DEFAULT_AUTHORS = "Pepe Calderón, Fernando Sola, Daniel Ayala, Inma Hernández, Margarita Cruz, Carlos Arévalo, David Ruiz"
#let doc-author = or-default(get-field(meta, "author"), DEFAULT_AUTHORS)
#let compiled-at = datetime.today().display("[day]/[month]/[year]")

// estética global

#show title: it => {
  set text(size: 24pt)
  set block(height: auto, spacing: -5pt)
  it
}
#set line(stroke: 3pt + color-weak)

#set text(lang: "es", hyphenate: true, size: 12pt, font: "Libertinus Sans")
#set par(justify: true, first-line-indent: 1cm, justification-limits: (
  tracking: (min: -0.01em, max: 0.02em),
))
#show image: set align(center)
#show quote: it => {
  info[#it]
}

// BLOQUES DE CÓDIGO
#set raw.line()
#set raw(syntaxes: ("relational-model.sublime-syntax", "http.sublime-syntax"))
#let code-background = rgb("#f6f8fa")
#let code-stroke = 2pt + rgb("#d1d5da")
#let code-text = rgb("#181818")
#show raw.where(block: true): it => {
  set text(fill: code-text)
  set block(inset: 0.3cm, fill: code-background, stroke: code-stroke, radius: 0.2cm, breakable: true, width: 100%)
  it
}
#show raw.where(block: false): it => {
  set text(fill: code-text)
  box(fill: code-background, inset: (x: 3pt, y: 0pt), outset: (y: 4pt), radius: 2pt, it)
}

// ENCABEZADOS DE SECCIONES
#set heading(numbering: "1.1.")
// ENCABEZADO DEL ÍNDICE (los otros de nivel 1 se configuran más abajo)
#show heading.where(level: 1): it => {
  set align(right)
  set text(size: 24pt, fill: color-strong, weight: "bold")
  v(3cm)
  it.body
  v(-0.6cm)
  line(length: 100%, stroke: 3pt + color-strong)
  v(2cm)
}
#show heading.where(level: 2): it => {
  set text(size: 18pt)
  v(0.7cm)
  it
  v(0.5cm)
}
#show heading.where(level: 3): set heading(outlined: false)
#show heading.where(level: 3): it => {
  set text(size: 14pt)
  it
}

// PORTADA
#let stroke-style = 5pt + color-strong
#frame-pages(frame-type: 6, outer-margin: 1cm, inner-margin: 1cm, foreground-color: color-weak)[
  #align(center + horizon)[
    #block(
      fill: color-weak,
      stroke: (top: stroke-style, bottom: stroke-style),
      radius: 100%,
      width: 100%,
      inset: (x: 2.0cm, y: 0.4cm),
    )[
      #set text(fill: color-strong)
      #set align(center+horizon)
      *#title()*
      #linebreak()
    ]

    #align(center)[
      #v(1.4cm)
      #set text(fill: color-strong, size: 18pt, weight: "bold")
      #doc-author
      #v(3.0cm)
      #image("./assets/images/etsii-us.png")
    ]
  ]
]

#pagebreak()

// CONFIGURACIÓN DE ENCABEZADOS Y PIE DE PÁGINA
#let current-heading = state("current-heading", "")
#context (metadata(current-heading.get()))
#let is-odd-page() = calc.rem(counter(page).get().first(), 2) == 1
#set page(
  header: context {
    anchor()
    box(width: 100%, [
      #let contenido
      #let posicion
      #let page-heading = hydra(use-last: true, skip-starting: false, 1)
      #let is-title = false
      #if page-heading != current-heading.get() {
        is-title = true
      } else {
        is-title = false
      }
      #if is-odd-page() {
        posicion = left
        contenido = page-heading
      } else {
        posicion = right
        contenido = hydra(skip-starting: false, 2)
      }
      #if (not is-title) {
        place(left + horizon, line(start: (-5cm, 0cm), end: (100% + 5cm, 0cm), stroke: if is-title {
          color-strong
        } else { color-weak }))
        set text(size: 10pt, fill: red)
        place(posicion + horizon, box(
          outset: 2mm,
          radius: 1cm,
          fill: if is-title { color-strong } else { color-weak },
          text(size: 12pt, fill: if is-title { color-weak } else { color-strong }, style: "italic", contenido),
        ))
      }
    ])
  },
  numbering: "I",
  footer: context {
    box(width: 100%, [
      #let contenido = [#counter(page).display()]
      #let posicion
      #let page-heading = hydra(use-last: true, skip-starting: false, 1)
      #let is-title = false
      #if page-heading != current-heading.get() {
        [#current-heading.update(page-heading)]
        is-title = true
      } else {
        is-title = false
      }
      #place(left + horizon, line(start: (-5cm, 0cm), end: (100% + 5cm, 0cm), stroke: if is-title {
        color-strong
      } else { color-weak }))
      #if is-odd-page() {
        posicion = left
      } else {
        posicion = right
      }
      #place(posicion + horizon, box(
        outset: 2mm,
        radius: 1cm,
        fill: if is-title { color-strong } else { color-weak },
        text(size: 12pt, fill: if is-title { color-weak } else { color-strong }, contenido),
      ))
    ])
  },
)

// ÍNDICE
#show outline.entry.where(level: 1): it => {
  set text(size: 12pt, weight: "bold")
  it
}

#counter(page).update(1)
#[
  #outline()
]
#set page(numbering: "1")
#counter(page).update(1)
// ENCABEZADOS DE NIVEL 1 DESPUÉS DEL ÍNDICE
#show heading.where(level: 1): it => {
  pagebreak()
  set align(center)
  set text(size: 24pt, fill: color-strong, weight: "bold", hyphenate: false)
  set par(justify: false)
  v(5cm)
  block(width: 100%, inset: 1cm, stroke: (top: 3pt + color-strong, bottom: 3pt + color-strong))[
    // Número de laboratorio en la esquina superior derecha
    #place(top + right, dy: -1.5cm, box(
      height: 1cm,
      width: 1cm,
      stroke: 1pt + color-strong,
      fill: white,
      radius: 100%,
      inset: (x: 0.5cm),
      align(center + horizon, [#counter(heading).get().at(0)]),
    ))
    // Título centrado
    #it.body
  ]
  v(3cm)
}

// --- contenido del markdown ---
#body
