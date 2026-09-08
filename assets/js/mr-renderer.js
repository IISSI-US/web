(function () {
  'use strict';

  function ready(fn) {
    if (document.readyState !== 'loading') fn();
    else document.addEventListener('DOMContentLoaded', fn);
  }

  function escapeHtml(value) {
    return String(value)
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;');
  }

  function splitTopLevel(text) {
    const parts = [];
    let current = '';
    let quote = null;
    let depth = 0;

    for (let i = 0; i < text.length; i += 1) {
      const ch = text[i];
      const prev = text[i - 1];

      if ((ch === '"' || ch === "'") && prev !== '\\') {
        quote = quote === ch ? null : (quote || ch);
        current += ch;
        continue;
      }

      if (!quote) {
        if (ch === '(' || ch === '{' || ch === '[') depth += 1;
        if (ch === ')' || ch === '}' || ch === ']') depth -= 1;
        if (ch === ',' && depth === 0) {
          parts.push(current.trim());
          current = '';
          continue;
        }
      }

      current += ch;
    }

    if (current.trim()) parts.push(current.trim());
    return parts;
  }

  function splitLineComment(line) {
    let quote = null;
    for (let i = 0; i < line.length - 1; i += 1) {
      const ch = line[i];
      const prev = line[i - 1];
      if ((ch === '"' || ch === "'") && prev !== '\\') quote = quote === ch ? null : (quote || ch);
      if (!quote && ch === '-' && line[i + 1] === '-') {
        return { code: line.slice(0, i), comment: line.slice(i + 2).trim() };
      }
    }
    return { code: line, comment: '' };
  }

  function stripOuterQuotes(value) {
    const trimmed = String(value).trim();
    if ((trimmed.startsWith("'") && trimmed.endsWith("'")) || (trimmed.startsWith('"') && trimmed.endsWith('"'))) {
      return trimmed.slice(1, -1);
    }
    return trimmed;
  }

  function cleanAttribute(value) {
    return value.trim().replace(/\*+$/g, '').trim();
  }

  function relationByName(relations, schemas, name) {
    let relation = relations.find((candidate) => candidate.name === name);
    if (!relation) {
      const known = schemas[name];
      relation = {
        name,
        attributes: known ? known.attributes.slice() : [],
        rows: [],
        constraints: known ? known.constraints.slice() : [],
        comments: [],
      };
      relations.push(relation);
    }
    return relation;
  }

  function parseConstraint(line) {
    const match = line.trim().match(/^(PK|AK|FK)\s*\(([^)]*)\)\s*(?:\/\s*([^/]+?))?\s*$/i);
    if (!match) return null;
    const kind = match[1].toUpperCase();
    const attrs = splitTopLevel(match[2]).map(cleanAttribute).join(', ');
    const target = match[3] ? match[3].trim() : '';
    return target ? `${kind}(${attrs}) / ${target}` : `${kind}(${attrs})`;
  }

  function collectAssignment(lines, startIndex, firstLine) {
    const first = splitLineComment(firstLine);
    const match = first.code.trim().match(/^(.+?)\s*=\s*\{(.*)$/);
    if (!match) return null;

    const name = match[1].trim().replace(/^Extensión\s*\(([^)]*)\)$/i, '$1').replace(/^Intensión\s*\(([^)]*)\)$/i, '$1');
    const comments = first.comment ? [first.comment] : [];
    const bodyLines = [];
    let body = match[2];
    let endIndex = startIndex;

    while (true) {
      const close = body.indexOf('}');
      if (close >= 0) {
        bodyLines.push(body.slice(0, close));
        break;
      }

      bodyLines.push(body);
      endIndex += 1;
      if (endIndex >= lines.length) return null;
      const line = splitLineComment(lines[endIndex]);
      body = line.code;
      if (line.comment) comments.push(line.comment);
    }

    return { name, body: bodyLines.join('\n').trim(), comments, endIndex };
  }

  function parseRows(body) {
    const rows = [];
    const tuplePattern = /\(([^()]*)\)/g;
    for (const match of body.matchAll(tuplePattern)) {
      rows.push(splitTopLevel(match[1]).map(stripOuterQuotes));
    }
    if (rows.length === 0 && /\.\./.test(body)) {
      const row = [body.trim()];
      row.commentOnly = true;
      rows.push(row);
    }
    return rows;
  }

  function looksLikeAttributeList(body) {
    const attrs = splitTopLevel(body).map(cleanAttribute).filter(Boolean);
    return attrs.length > 0 && attrs.every((attr) => /^[A-Za-zÁÉÍÓÚÜÑáéíóúüñ_][\wÁÉÍÓÚÜÑáéíóúüñ_]*$/.test(attr));
  }

  function parseSchemaLine(line) {
    const match = line.trim().match(/^([^()={}]+?)\s*\((.*)\)\s*$/);
    if (!match) return null;
    if (/^(PK|AK|FK)$/i.test(match[1].trim())) return null;
    return {
      name: match[1].trim(),
      attributes: splitTopLevel(match[2]).map(cleanAttribute).filter(Boolean),
    };
  }

  function collectSchema(lines, startIndex, firstLine) {
    const first = splitLineComment(firstLine);
    const start = first.code.trim().match(/^([^()={}]+?)\s*\((.*)$/);
    if (!start) return null;

    const name = start[1].trim();
    if (/^(PK|AK|FK)$/i.test(name)) return null;
    const bodyLines = [];
    const comments = first.comment ? [first.comment] : [];
    let body = start[2];
    let endIndex = startIndex;

    while (true) {
      const close = body.indexOf(')');
      if (close >= 0) {
        bodyLines.push(body.slice(0, close));
        break;
      }

      bodyLines.push(body);
      endIndex += 1;
      if (endIndex >= lines.length) return null;
      const line = splitLineComment(lines[endIndex]);
      body = line.code;
      if (line.comment) comments.push(line.comment);
    }

    const attributes = splitTopLevel(bodyLines.join('\n')).map(cleanAttribute).filter(Boolean);
    return attributes.length > 0 ? { name, attributes, comments, endIndex } : null;
  }

  function parseRelations(code, schemas) {
    const relations = [];
    const lines = code.split('\n');
    let current = null;

    for (let i = 0; i < lines.length; i += 1) {
      const raw = lines[i];
      const parts = splitLineComment(raw);
      const line = parts.code.trim();
      if (!line) continue;

      const assignment = collectAssignment(lines, i, raw);
      if (assignment) {
        const rows = parseRows(assignment.body);
        const relation = relationByName(relations, schemas, assignment.name);
        if (rows.length > 0) relation.rows = rows;
        else if (schemas[assignment.name] && !looksLikeAttributeList(assignment.body)) {
          const row = [assignment.body.trim()];
          row.commentOnly = true;
          relation.rows = row[0] ? [row] : [];
        }
        else {
          relation.attributes = splitTopLevel(assignment.body).map(cleanAttribute).filter(Boolean);
          relation.rows = [];
          relation.constraints = [];
          relation.comments = [];
        }
        relation.comments.push.apply(relation.comments, assignment.comments);
        current = relation;
        i = assignment.endIndex;
        continue;
      }

      const constraint = parseConstraint(line);
      if (constraint && current) {
        current.constraints.push(constraint);
        if (parts.comment) current.comments.push(parts.comment);
        continue;
      }

      const schema = parseSchemaLine(line);
      if (schema) {
        current = relationByName(relations, schemas, schema.name);
        current.attributes = schema.attributes;
        current.rows = [];
        current.constraints = [];
        current.comments = [];
        if (parts.comment) current.comments.push(parts.comment);
        continue;
      }

      const multiLineSchema = collectSchema(lines, i, raw);
      if (multiLineSchema) {
        current = relationByName(relations, schemas, multiLineSchema.name);
        current.attributes = multiLineSchema.attributes;
        current.rows = [];
        current.constraints = [];
        current.comments = multiLineSchema.comments;
        i = multiLineSchema.endIndex;
        continue;
      }

      return null;
    }

    const valid = relations.filter((relation) => relation.name && relation.attributes.length > 0);
    return valid.length > 0 ? valid : null;
  }

  function constraintAttrs(relation, kind) {
    return relation.constraints.flatMap((constraint) => {
      const match = constraint.match(new RegExp(`^${kind}\\(([^)]*)\\)`, 'i'));
      return match ? splitTopLevel(match[1]).map(cleanAttribute) : [];
    });
  }

  function attrClasses(relation, attr) {
    const name = cleanAttribute(attr);
    const classes = [];
    if (constraintAttrs(relation, 'PK').includes(name)) classes.push('mr-pk-col');
    if (constraintAttrs(relation, 'FK').includes(name)) classes.push('mr-fk-col');
    return classes.join(' ');
  }

  function renderConstraint(constraint) {
    const match = constraint.match(/^(PK|AK|FK)(\(.*)$/);
    if (!match) return escapeHtml(constraint);
    const kind = match[1];
    return `<span class="mr-constraint-kind mr-constraint-${kind.toLowerCase()}">${kind}</span>${escapeHtml(match[2])}`;
  }

  function renderTable(relation) {
    const colCount = Math.max(1, relation.attributes.length);
    const header = relation.attributes.map((attr) => {
      const cls = attrClasses(relation, attr);
      return `<th${cls ? ` class="${cls}"` : ''}>${escapeHtml(attr)}</th>`;
    }).join('');

    const notes = [
      ...Array.from(new Set(relation.constraints)).map((constraint) => `<div class="mr-constraint">${renderConstraint(constraint)}</div>`),
      ...Array.from(new Set(relation.comments)).map((comment) => `<div class="mr-comment">${escapeHtml(comment)}</div>`),
    ].join('');

    const rows = relation.rows.map((row) => {
      if (row.commentOnly) return `<tr class="mr-notes"><td colspan="${colCount}">${escapeHtml(row[0])}</td></tr>`;
      const cells = relation.attributes.map((attr, index) => {
        const cls = attrClasses(relation, attr);
        const value = row[index] == null ? '' : row[index];
        const nullClass = /^null$/i.test(String(value).trim()) ? ' mr-null' : '';
        return `<td${cls || nullClass ? ` class="${[cls, nullClass.trim()].filter(Boolean).join(' ')}"` : ''}>${escapeHtml(value)}</td>`;
      });
      return `<tr>${cells.join('')}</tr>`;
    }).join('');

    return [
      '<figure class="mr-relation-block">',
      '<table class="mr-table">',
      '<thead>',
      `<tr class="mr-relation-name"><th colspan="${colCount}">${escapeHtml(relation.name)}</th></tr>`,
      notes ? `<tr class="mr-notes"><td colspan="${colCount}">${notes}</td></tr>` : '',
      `<tr class="mr-intension">${header}</tr>`,
      '</thead>',
      rows ? `<tbody>${rows}</tbody>` : '',
      '</table>',
      '</figure>',
    ].join('');
  }

  function rememberSchemas(relations, schemas) {
    relations.forEach((relation) => {
      schemas[relation.name] = {
        attributes: relation.attributes.slice(),
        constraints: Array.from(new Set(relation.constraints)),
      };
    });
  }

  function candidateCodeBlocks() {
    return Array.from(document.querySelectorAll('.page__content pre > code.language-mr-table'));
  }

  function isCandidate(codeEl) {
    return codeEl.classList.contains('language-mr-table');
  }

  function renderBlock(codeEl, schemas) {
    if (!isCandidate(codeEl)) return;
    const relations = parseRelations(codeEl.textContent, schemas);
    if (!relations) return;
    rememberSchemas(relations, schemas);
    const wrapper = document.createElement('div');
    wrapper.className = 'mr-relations';
    wrapper.innerHTML = relations.map(renderTable).join('');
    const container = codeEl.closest('div.highlighter-rouge') || codeEl.closest('figure.highlight') || codeEl.closest('pre') || codeEl.parentNode;
    container.replaceWith(wrapper);
  }

  ready(function () {
    const schemas = {};
    candidateCodeBlocks().forEach((codeEl) => renderBlock(codeEl, schemas));
  });
}());
