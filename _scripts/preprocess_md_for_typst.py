import re
import os

def preprocess_markdown_for_typst(md_filepath, output_filepath, sql_base_path):
    with open(md_filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    # Regex para encontrar includes de sql-embed.html
    # Captura el src y el label
    # Ejemplo: {% include sql-embed.html src='/assets/sql/Usuarios/fGetAge.sql' label='Usuarios/fGetAge.sql' collapsed=true %}
    pattern = re.compile(r'{%\s*include\s+sql-embed\.html\s+src=['"](.*?)['"](?:\s+label=['"](.*?)['"])?.*?%}')

    def replace_sql_include(match):
        sql_src_path = match.group(1).replace('/assets/sql/', sql_base_path)
        sql_label = match.group(2) if match.group(2) else os.path.basename(sql_src_path)
        
        try:
            with open(sql_src_path, 'r', encoding='utf-8') as sql_file:
                sql_content = sql_file.read()
            # Reemplazar con un bloque de código Typst
            return f'== {sql_label}\n```sql\n{sql_content}```\n'
        except FileNotFoundError:
            print(f"[ERROR] SQL file not found: {sql_src_path}")
            return f'**ERROR: SQL content for {sql_label} not found at {sql_src_path}**\n'

    processed_content = pattern.sub(replace_sql_include, content)

    with open(output_filepath, 'w', encoding='utf-8') as f:
        f.write(processed_content)

    print(f"Processed Markdown saved to {output_filepath}")

if __name__ == "__main__":
    # Configuración para la prueba inicial con mc2mr/01_universidad/index.md
    # md_file = "mc2mr/01_universidad/index.md"
    # output_file = "mc2mr/01_universidad/index.preprocessed.md"
    # sql_base = "assets/sql/"

    # Configuración para req2sql/1_Usuarios/index.md
    md_file = "req2sql/1_Usuarios/index.md"
    output_file = "req2sql/1_Usuarios/index.preprocessed.md"
    sql_base = "assets/sql/"

    # Obtener la ruta absoluta del workspace para sql_base_path
    current_dir = os.path.dirname(os.path.abspath(__file__))
    workspace_root = os.path.abspath(os.path.join(current_dir, "..")) # Asumiendo que el script está en _scripts/
    full_sql_base_path = os.path.join(workspace_root, sql_base)
    full_md_file_path = os.path.join(workspace_root, md_file)
    full_output_file_path = os.path.join(workspace_root, output_file)

    preprocess_markdown_for_typst(full_md_file_path, full_output_file_path, full_sql_base_path)

