#import "@preview/cmarker:0.1.6"
#import "typst-packages/mitex/0.2.5/mitex.typ": mitex

#let strip-quotes(value) = {
  if type(value) != str {
    return value
  }
  let trimmed = value.trim()
  if trimmed.len() >= 2 and (
    (trimmed.starts-with("\"") and trimmed.ends-with("\"")) or
    (trimmed.starts-with("'") and trimmed.ends-with("'"))
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

#let md_path = sys.inputs.at("md", default: "mc2mr/01_universidad/index.md")
#let raw = read(md_path)

// separar meta y contenido
#let (meta, clean) = extract-meta(raw)
#let clean = strip-local-anchors(expand-liquid-paths(expand-sql-embeds(clean)))

// renderizar markdown
#let body = cmarker.render(
  clean,
  h1-level: 0,
  math: algebra-math,
  scope: (image: (path, alt: none) => image(path, alt: alt)),
)

// título y autor desde YAML
#let doc-title  = or-default(get-field(meta, "title"),  "Documento")
#let DEFAULT_AUTHORS = "Pepe Calderón, Fernando Sola, Daniel Ayala, Inma Hernández, Margarita Cruz, Carlos Arévalo, David Ruiz"
#let doc-author = or-default(get-field(meta, "author"), DEFAULT_AUTHORS)
#let compiled-at = datetime.today().display("[day]/[month]/[year]")

// estética global
#set text(font: "Roboto", size: 11pt)
#set page(
  margin: (top: 2.5cm, bottom: 2.5cm, left: 3cm, right: 2.5cm),
  header: context[
    #block[
      #set text(size: 9pt, weight: "medium")
      #block(width: 100%)[#doc-title #h(1fr) Compilado el #compiled-at]
      #line(length: 100%, stroke: 0.4pt)
    ]
  ],
  footer: context[
    #block[
      #line(length: 100%, stroke: 0.4pt)
      #align(center)[#set text(size: 9pt); Página #counter(page).display()]
    ]
  ],
)
#set heading(numbering: "1.")

// cabecera tipo artículo
#align(center)[
  #context[
    #set text(size: 20pt, weight: "bold")
    #doc-title
  ]
  #v(0.15cm)
  #context[
    #set text(size: 12pt)
    #doc-author
  ]
]


#v(0.8cm)
#context[
  #set text(size: 16pt, weight: "bold")
  Contenido
]
#context[
  #set text(size: 11pt)
  #outline(
    title: none,
    target: heading,
    indent: 1em,
  )
]

#pagebreak()

// --- contenido del markdown ---
#body
