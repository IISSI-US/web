#!/usr/bin/env python3
import re
from pathlib import Path

pattern = re.compile(r"\{\%\s*include\s+sql-embed\.html(?P<inner>[^%}]*)\%\}")

changed_files = 0
for md in Path('req2sql').rglob('*.md'):
    text = md.read_text(encoding='utf-8')
    def repl(m):
        inner = m.group('inner')
        if 'collapsed=true' in inner:
            return m.group(0)
        return "{% include sql-embed.html" + inner + " collapsed=true %}"
    new = pattern.sub(repl, text)
    if new != text:
        md.write_text(new, encoding='utf-8')
        changed_files += 1
print(f"updated_files={changed_files}")
