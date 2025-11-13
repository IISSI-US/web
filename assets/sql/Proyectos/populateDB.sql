-- 
-- Autor: David Ruiz
-- Fecha: Octubre de 2024
-- Descripción: Script para cargar los datos de pruebas
-- 

-- Insertar datos de ejemplo en la tabla Proyectos
INSERT INTO Proyectos (proyectoId, nombre, presupuesto) VALUES
    (1,'Proyecto A', 100000)
;

-- Insertar datos de ejemplo en la tabla Roles
INSERT INTO Roles (rolId, proyectoId, nombre) VALUES
    (1, 1, 'Director'),
    (2, 1, 'Analista'),
    (3, 1, 'Responsable de pruebas')
;

-- Insertar datos de ejemplo en la tabla Tareas
INSERT INTO Tareas (tareaId, proyectoId, orden, id, descripcion, estimacion) VALUES
    (1, 1, 1, 'T-DI', 'Diseño de interfaz', 30),
    (2, 1, 2, 'T-DB', 'Desarrollo de BackEnd', 50),
    (3, 1, 3, 'T-T', 'Testing', 225),
    (4, 1, 4, 'T-TPU', 'Pruebas unitarias', 150),
    (5, 1, 5, 'T-TPI', 'Pruebas de integración', 75),
    (6, 1, 6, 'T-D', 'Despliegue', 10)
;

-- Insertar datos de ejemplo en la tabla Subtareas
INSERT INTO Subtareas (subtareaId, tareaId, orden) VALUES
    (4, 3, 1),
    (5, 3, 2)
;

-- Insertar datos de ejemplo en la tabla Empleados
INSERT INTO Empleados (empleadoId, dni, nombre) VALUES
    (1, '12345678A', 'Juan Pérez'),
    (2, '87654321B', 'María López'),
    (3, '11223344C', 'Carlos García'),
    (4, '44332211D', 'Ana Rueda')
;

-- Insertar datos de ejemplo en la tabla PeriodosCargos
INSERT INTO PeriodosCargos (periodoCargoId, empleadoId, rolId, fInicio, fFin) VALUES
    (1, 1, 1, '2023-12-01', null),
    (2, 2, 2, '2024-01-01', null),
    (3, 3, 3, '2024-01-01', null),
    (4, 4, 3, '2024-01-01', null)
;

-- Insertar datos de ejemplo en la tabla PeriodosCargos
INSERT INTO PeriodosTareas (periodoTareaId, empleadoId, tareaId, fInicio, fFin) VALUES
    (1, 1, 1, '2024-01-01', '2024-01-30'),
    (2, 2, 2, '2024-02-01', '2024-03-15'),
    (3, 3, 3, '2024-03-01', '2024-04-30'),
    (4, 4, 4, '2024-05-01', '2024-06-15')
;
