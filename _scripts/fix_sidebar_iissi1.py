import os

# Directorios y su sidebar correspondiente
TARGETS = [
    ("laboratorios/iissi1", "labs-iissi-1"),
    # mc2mr y req2sql tienen sus propias sidebars, no las tocamos o las forzamos si el usuario quiere
    # De momento solo fixed laboratorios que es lo que falla
]

for base_dir, sidebar_name in TARGETS:
    for root, dirs, files in os.walk(base_dir):
        for filename in files:
            if filename.endswith(".md"):
                filepath = os.path.join(root, filename)
                
                with open(filepath, "r") as f:
                    content = f.read()
                
                # Chequear si ya tiene sidebar
                if "sidebar:" in content:
                    print(f"Skipping {filepath}, already has sidebar.")
                    continue
                    
                # Inyectar sidebar
                if "layout: single" in content:
                    replacement = f"layout: single\nsidebar:\n  nav: {sidebar_name}"
                    new_content = content.replace("layout: single", replacement)
                    
                    with open(filepath, "w") as f:
                        f.write(new_content)
                    print(f"Updated {filepath} with {sidebar_name}")
                else:
                    print(f"Skipping {filepath}, no 'layout: single' found.")
