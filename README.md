# IISSI - Documentación del Curso (2026/27)

Sitio web del curso IISSI creado con Jekyll y el tema Minimal Mistakes, desplegado en GitHub Pages.

## 📚 Contenido

Este sitio contiene:

- **Laboratorios IISSI-1**: Bases de datos relacionales, SQL, procedimientos, APIs REST
- **Laboratorios IISSI-2**: Frontend web (HTML, CSS, JavaScript, AJAX)
- **MC→MR**: Ejercicios de transformación de Modelo Conceptual a Relacional
- **Req→SQL**: Ejercicios de requisitos a implementación SQL
- Información sobre evaluación, planificación y exámenes

## 🚀 Desarrollo local

### Prerrequisitos

- **Ruby** 3.1 o superior
- **Bundler**: `gem install bundler`
- **PlantUML** y **Java** (para renderizar diagramas)
- **Typst** (opcional, para generar PDFs)
- **Python 3** (opcional, para el script `_scripts/build_pdfs.py`)

### Instalación

```bash
# 1. Clona el repositorio
git clone https://github.com/IISSI-US/web.git
cd web

# 2. Instala las dependencias Ruby
bundle install

# 3. Lanza el servidor de desarrollo
make serve-dev
```

Abre tu navegador en `http://127.0.0.1:4000/`

### Flujos de trabajo

#### Desarrollo diario (recomendado)
```bash
make serve-dev
```
- Sitio disponible en `http://127.0.0.1:4000/` (sin prefijo `/web`)
- Livereload automático al guardar cambios
- Usa `_config.dev.yml` que sobrescribe `baseurl` a vacío
- **Ventaja**: URLs más simples durante desarrollo

#### Probar antes de desplegar
```bash
make serve-prod
```
- Sitio disponible en `http://127.0.0.1:4000/web/`
- Simula el comportamiento de GitHub Pages
- **Útil para**: detectar problemas de rutas/enlaces antes de hacer push

#### Ver comandos disponibles
```bash
make help
```

## 🛠️ Comandos útiles

### Diagramas
```bash
make images              # Renderiza todos los diagramas PlantUML
make mc2mr-images        # Solo diagramas MC→MR
make req2sql-images      # Solo diagramas Req→SQL
make grades-images       # Solo diagramas de requisitos
make clean-images        # Elimina imágenes generadas
```

### PDFs
```bash
make pdfs                # Genera PDFs de cada index.md con pdf_version: true
```

### Build
```bash
make build               # Build estándar
make build-prod          # Build con JEKYLL_ENV=production
```

## 📁 Estructura del proyecto

```
.
├── _config.yml              # Configuración principal (producción)
├── _config.dev.yml          # Override para desarrollo local
├── .github/workflows/       # GitHub Actions para despliegue
├── laboratorios/
│   ├── iissi1/             # Labs de bases de datos y backend
│   └── iissi2/             # Labs de frontend web
├── mc2mr/                   # Ejercicios MC→MR
├── req2sql/                 # Ejercicios Req→SQL
├── assets/                  # Recursos estáticos (CSS, imágenes, JS)
├── _data/navigation.yml     # Menús y navegación
├── _includes/               # Componentes reutilizables
├── _sass/                   # Estilos SCSS personalizados
├── _scripts/                # Scripts de automatización
├── _diagrams/               # Fuentes PlantUML de diagramas
└── Makefile                 # Comandos de desarrollo
```

## 🚀 Despliegue en GitHub Pages

El sitio se despliega **automáticamente** mediante GitHub Actions:

1. **Trigger**: Cualquier push a la rama `main`
2. **Workflow**: `.github/workflows/jekyll.yml`
3. **Proceso**:
   - Instala Ruby 3.1 y dependencias
   - Ejecuta `jekyll build` con baseurl dinámico
   - Despliega a GitHub Pages
4. **URL producción**: https://iissi-us.github.io/web/

### Configuración de URLs

| Entorno | Archivo | URL | Baseurl |
|---------|---------|-----|----------|
| **Desarrollo** | `_config.dev.yml` | `http://127.0.0.1:4000` | `""` (vacío) |
| **Producción** | `_config.yml` | `https://iissi-us.github.io` | `/web` |
| **GitHub Actions** | Workflow | — | Dinámico vía `steps.pages.outputs.base_path` |

### Notas importantes

- El workflow **sobrescribe** el `baseurl` automáticamente, no es necesario editarlo manualmente
- Para probar localmente con el baseurl de producción: `make serve-prod`
- Los assets (imágenes, CSS, JS) usan `{{ '...' | relative_url }}` para funcionar en ambos entornos

## 🔧 Tecnologías

- **Jekyll** 3.9+ (generador de sitios estáticos)
- **Minimal Mistakes** 4.27.3 (tema)
- **GitHub Pages** (hosting)
- **PlantUML** (diagramas)
- **Typst** (generación de PDFs)
- **Kramdown** (procesador Markdown con extensiones)

## 📝 Contribuir

1. Haz fork del repositorio
2. Crea una rama para tu feature: `git checkout -b feature/nueva-funcionalidad`
3. Haz commit de tus cambios: `git commit -am 'Añade nueva funcionalidad'`
4. Push a la rama: `git push origin feature/nueva-funcionalidad`
5. Crea un Pull Request

## 📄 Licencia

Este proyecto es material docente de la Universidad de Sevilla.
