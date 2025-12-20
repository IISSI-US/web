#!/usr/bin/env python3
import re
from pathlib import Path

root = Path('req2sql')
# Match legacy div blocks and capture the relative sql path
pattern_div = re.compile(r"<div\s+class=\"sql-file\"\s+data-src=\"\{\{\s*'/(?:silence-db/sql|assets/sql)/([^']+)'\s*\|\s*relative_url\s*\}\}\">\s*</div>")
# Match placeholder include lines produced by a failed conversion
pattern_placeholder = re.compile(r"\{\%\s*include\s+sql-embed\.html\s+src='/assets/DB-Silence-IISSI-1/'\s+label=''(?P<rest>\s+(?:collapsed|collapsible)=true)?\s*\%\}")


def extract_paths(text: str):
    return re.findall(r"data-src=\"\{\{\s*'/(?:silence-db/sql|assets/sql)/([^']+)'", text)


def main():
    # Iterate directories that have a backup with the original sql-file blocks
    for bak in root.rglob('index.md.bak'):
        dir_path = bak.parent
        paths = extract_paths(bak.read_text(encoding='utf-8'))
        if not paths:
            continue
        for md in dir_path.glob('*.md'):
            txt = md.read_text(encoding='utf-8')
            changed = False
            # Convert any remaining legacy divs
            def repl_div(m):
                p = m.group(1)
                return f"{{% include sql-embed.html src='/assets/DB-Silence-IISSI-1/{p}' label='{p}' %}}"
            new_txt = pattern_div.sub(repl_div, txt)
            if new_txt != txt:
                txt = new_txt
                changed = True
            # Fix placeholders using paths from .bak in order
            i = 0
            def repl_ph(m):
                nonlocal i
                if i >= len(paths):
                    return m.group(0)
                p = paths[i]
                i += 1
                rest = m.group('rest') or ''
                # normalize legacy 'collapsible=true' to 'collapsed=true'
                norm = ' collapsed=true' if rest.strip() else ''
                return f"{{% include sql-embed.html src='/assets/DB-Silence-IISSI-1/{p}' label='{p}'{norm} %}}"
            new_txt = pattern_placeholder.sub(repl_ph, txt)
            if new_txt != txt:
                txt = new_txt
                changed = True
            if changed:
                md.write_text(txt, encoding='utf-8')

    # As a final pass, convert any leftover legacy divs anywhere
    for md in root.rglob('*.md'):
        txt = md.read_text(encoding='utf-8')
        new_txt = pattern_div.sub(lambda m: f"{{% include sql-embed.html src='/assets/DB-Silence-IISSI-1/{m.group(1)}' label='{m.group(1)}' %}}", txt)
        if new_txt != txt:
            md.write_text(new_txt, encoding='utf-8')

    # Report leftovers
    leftovers = []
    for md in root.rglob('*.md'):
        if pattern_placeholder.search(md.read_text(encoding='utf-8')):
            leftovers.append(str(md))
    if leftovers:
        print('Leftover placeholders:', len(leftovers))
        for f in leftovers:
            print(' -', f)
    else:
        print('All placeholders fixed.')


if __name__ == '__main__':
    main()
