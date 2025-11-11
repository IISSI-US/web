source "https://rubygems.org"

# Gema de GitHub Pages que incluye Jekyll y todas las dependencias compatibles
gem "github-pages", group: :jekyll_plugins

# Tema Just the Docs
gem "just-the-docs"

# Plugins adicionales (opcionales)
group :jekyll_plugins do
  gem "jekyll-feed"
  gem "jekyll-seo-tag"
end

# Windows y JRuby no incluyen archivos zoneinfo, por lo que se incluye la gema tzinfo-data
platforms :mingw, :x64_mingw, :mswin, :jruby do
  gem "tzinfo", ">= 1", "< 3"
  gem "tzinfo-data"
end

# Mejora el rendimiento de la observación de directorios en Windows
gem "wdm", "~> 0.1.1", :platforms => [:mingw, :x64_mingw, :mswin]

# Lock `http_parser.rb` para versiones de JRuby
gem "http_parser.rb", "~> 0.6.0", :platforms => [:jruby]
