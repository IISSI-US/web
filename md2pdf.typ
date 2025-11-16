#import "@preview/cmarker:0.1.6"
#import "@preview/mitex:0.2.4": mitex

// Ruta del markdown actual
#let md_dir = "mc2mr/01_universidad/"
#let raw = read(md_dir + "index.md")

// ---------- 1. Extraer front-matter + cuerpo ----------

// Devuelve (meta-lines, body-text)
#let extract-meta(text) = {
  let lines = text.split("\n")
  if lines.len() > 0 and lines.at(0).trim() == "---" {
    // buscar el cierre ---
    let idx = 1
    while idx < lines.len() and lines.at(idx).trim() != "---" {
      idx += 1
    }
    if idx < lines.len() {
      let meta-lines = lines.slice(1, idx)
      let body = lines.slice(idx + 1).join("\n")
      (meta-lines, body)
    } else {
      ((), text)
    }
  } else {
    ((), text)
  }
}

// Busca una clave tipo "title:" o "author:" en las líneas de meta
#let get-field(meta, key) = {
  for line in meta {
    let trimmed = line.trim()
    if trimmed.starts-with(key + ":") {
      // todo lo que hay después de "key:"
      let value = trimmed.slice(key.len() + 1).trim()

      // si empieza y acaba con comillas, se las quitamos
      if value.len() >= 2 and value.starts-with("\"") and value.ends-with("\"") {
        value = value.slice(1, value.len() - 1)
      }

      return value
    }
  }
  none
}

// Valor por defecto si el campo es none
#let or-default(value, fallback) = {
  if value == none { fallback } else { value }
}

// Separar meta y cuerpo
#let (meta, clean) = extract-meta(raw)

// ---------- 2. Traducción de macros de Álgebra Relacional ----------

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
    // natural join
    .replace("\\NatJoin", "\\Large \\displaystyle \\Join")
    // cierre genérico }{
    .replace("}{", "}_{")
}

// Handler de matemáticas: reescribe macros y pasa por MiTeX
#let algebra-math(src, block: false) = {
  mitex(rewrite-math(src), block: block)
}

// ---------- 3. Renderizar Markdown con cmarker ----------

#let body = cmarker.render(
  clean,
  math: algebra-math,
  scope: (
    image: (path, alt: none) => image(path, alt: alt),
  ),
)

// ---------- 4. Estética del documento ----------

// Fuente Roboto (debe existir en el sistema)
#set text(font: "Roboto")

// Título y autores desde el front-matter
#let doc-title  = or-default(get-field(meta, "title"),  "IISSI")
#let doc-author = or-default(get-field(meta, "author"), "David Ruiz")

#set document(
  title: doc-title,
  author: doc-author,
)

// ---------- 5. Volcar contenido ----------

#align(center)[
  #set text(size: 2.2em, weight: "bold")
  #doc-title

  #set text(size: 1.3em)
  #doc-author

  #set text(size: 0.9em)
  Documento generado automáticamente el #datetime.today().display("[year]-[month]-[day]")
]


#body
