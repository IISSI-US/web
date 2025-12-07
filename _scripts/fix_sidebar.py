import os

BASE_DIR = "laboratorios/iissi2"

# Recorrer todos los index.md dentro de subdirectorios (los labs)
for root, dirs, files in os.walk(BASE_DIR):
    for filename in files:
        if filename == "index.md":
            filepath = os.path.join(root, filename)
            
            with open(filepath, "r") as f:
                content = f.read()
            
            # Verificar si ya tiene sidebar
            if "nav: laboratorios-frontend" in content:
                print(f"Skipping {filepath}, already has sidebar.")
                continue
                
            # Inyectar sidebar después de layout: single
            # Buscamos "layout: single" y añadimos las lineas
            if "layout: single" in content:
                # Usamos replace simple
                new_content = content.replace("layout: single", "layout: single\nsidebar:\n  nav: laboratorios-frontend")
                
                with open(filepath, "w") as f:
                    f.write(new_content)
                print(f"Updated {filepath}")
            else:
                print(f"Warning: {filepath} does not have 'layout: single'")
