import os
import re
import shutil

BASE_DIR = "laboratorios/iissi2"
FILES = [f for f in os.listdir(BASE_DIR) if f.endswith(".md") and f != "index.md"]

HEADER_TEMPLATE = """> [Versión PDF disponible](./index.pdf)

"""

for filename in FILES:
    filepath = os.path.join(BASE_DIR, filename)
    slug = filename.replace(".md", "")
    new_dir = os.path.join(BASE_DIR, slug)
    
    # 1. Crear directorio
    os.makedirs(new_dir, exist_ok=True)
    
    # 2. Leer contenido
    with open(filepath, "r") as f:
        content = f.read()
    
    # 3. Modificar Frontmatter
    # Asegurar layout single
    content = re.sub(r"layout:.*", "layout: single", content)
    
    # Añadir keys si no existen (usando un enfoque simple de replace sobre el layout)
    # Asumimos que layout: single está al principio
    extra_keys = """toc: true
toc_label: "Contenido"
toc_icon: "fa-solid fa-list-ul"
toc_sticky: true
pdf_version: true"""
    
    if "toc: true" not in content:
        content = content.replace("layout: single", f"layout: single\n{extra_keys}")
        
    # 4. Insertar Enlace PDF después del segundo ---
    parts = content.split("---", 2)
    if len(parts) >= 3:
        # parts[0] is empty, parts[1] is frontmatter, parts[2] is body
        new_body = HEADER_TEMPLATE + parts[2]
        new_content = f"---{parts[1]}---{new_body}"
    else:
        new_content = content # Fallback
        
    # 5. Escribir index.md en nueva carpeta
    new_filepath = os.path.join(new_dir, "index.md")
    with open(new_filepath, "w") as f:
        f.write(new_content)
        
    # 6. Borrar archivo original
    os.remove(filepath)
    print(f"Propagated {filename} -> {new_dir}/index.md")
