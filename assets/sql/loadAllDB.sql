--
-- Script maestro para crear todas las bases de datos
-- Autor: David Ruiz (generado automáticamente)
-- Fecha: Septiembre de 2025
--

-- Cargar todas las bases de datos del proyecto
SELECT '=== INICIANDO CARGA DE TODAS LAS BASES DE DATOS ===';

-- AficionesDin
SELECT '';
SELECT '>>> Cargando AficionesDin...';
SOURCE AficionesDin/loadDB.sql

-- AficionesEst  
SELECT '';
SELECT '>>> Cargando AficionesEst...';
SOURCE AficionesEst/loadDB.sql

-- Animales
SELECT '';
SELECT '>>> Cargando Animales...';
SOURCE Animales/loadDB.sql

-- Apartamentos
SELECT '';
SELECT '>>> Cargando Apartamentos...';
SOURCE Apartamentos/loadDB.sql

-- Banco
SELECT '';
SELECT '>>> Cargando Banco...';
SOURCE Banco/loadDB.sql

-- Bodegas
SELECT '';
SELECT '>>> Cargando Bodegas...';
SOURCE Bodegas/loadDB.sql

-- Bodegas2
SELECT '';
SELECT '>>> Cargando Bodegas2...';
SOURCE Bodegas2/loadDB.sql

-- Empleados
SELECT '';
SELECT '>>> Cargando Empleados...';
SOURCE Empleados/loadDB.sql

-- Espectaculos
SELECT '';
SELECT '>>> Cargando Espectaculos...';
SOURCE Espectaculos/loadDB.sql

-- Grados
SELECT '';
SELECT '>>> Cargando Grados...';
SOURCE Grados/loadDB.sql

-- Proyectos
SELECT '';
SELECT '>>> Cargando Proyectos...';
SOURCE Proyectos/loadDB.sql

-- Usuarios
SELECT '';
SELECT '>>> Cargando Usuarios...';
SOURCE Usuarios/loadDB.sql

-- Usuarios2
SELECT '';
SELECT '>>> Cargando Usuarios2...';
SOURCE Usuarios2/loadDB.sql

SELECT '';
SELECT '=== CARGA COMPLETA DE TODAS LAS BASES DE DATOS ===';