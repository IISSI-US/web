#!/bin/bash
# Script maestro para cargar todas las bases de datos
# Autor: David Ruiz
# Fecha: Septiembre de 2025

echo "=== INICIANDO CARGA DE TODAS LAS BASES DE DATOS ==="

# Directorio base
BASE_DIR="/home/druiz/Ejercicios-IISSI-1-PDF/sql"

# Array con todas las bases de datos
databases=("AficionesDin" "AficionesEst" "Animales" "Apartamentos" "Banco" "Bodegas" "Bodegas2" "Empleados" "Espectaculos" "Grados" "Proyectos" "Usuarios" "Usuarios2")

# Cargar cada base de datos
for db in "${databases[@]}"; do
    echo ""
    echo ">>> Cargando $db..."
    
    # Cambiar al directorio de la BD y ejecutar el loadDB.sql
    if [ -f "$BASE_DIR/$db/loadDB.sql" ]; then
        cd "$BASE_DIR/$db"
        mysql < loadDB.sql
        if [ $? -eq 0 ]; then
            echo "✓ $db cargada correctamente"
        else
            echo "✗ Error cargando $db"
        fi
    else
        echo "✗ No se encontró loadDB.sql para $db"
    fi
done

echo ""
echo "=== CARGA COMPLETA DE TODAS LAS BASES DE DATOS ==="