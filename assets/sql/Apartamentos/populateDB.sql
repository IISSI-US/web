-- -
-- Autor: David Ruiz
-- Fecha: Octubre de 2024
-- Descripción: Script para hacer la carga inicial del ejercicio de Apartamentos
-- -

-- Insertar datos de usuarios
INSERT INTO Usuarios (usuarioId, dni, nombre, apellidos, correo, contrasena, direccion, telefono, fCompra, esPropietario, esHuesped) VALUES 
	(1, '12345678A', 'Juan', 'Pérez', 'juanperez@example.com', 'juan123', 'Calle Falsa 123', '600123456', NULL, FALSE, TRUE), 
   (2, '87654321B', 'Marta', 'López', 'martalopez@example.com', 'marta456', 'Av. Siempre Viva 456', '600654321', '2022-01-15', TRUE, FALSE)
;

-- Insertar datos en la tabla ZonasTuristicas
INSERT INTO ZonasTuristicas (zonaId, zona) VALUES 
	(1, 'Costa del Sol')
;

-- Insertar datos en la tabla Alojamientos
INSERT INTO Alojamientos (alojamientoId, propietarioId, zonaId, direccion,numDormitorios, numBaños, ocupacionMaxima) VALUES 
	(1, 2, 1, 'Calle Mayor 10', 3, 2, 6)
;

-- Insertar datos en la tabla Reservas
INSERT INTO Reservas (reservaId, huespedId, alojamientoId, checkIn, checkOut, comentario, valoracion) VALUES 
	(1, 1, 1, '2024-10-01', '2024-10-10', 'Excelente estancia', 1)
;

-- Insertar datos en la tabla Servicios
INSERT INTO Servicios (servicioId, alojamientoId, tipoServicio, disponible) VALUES 
	(1, 1, 'Wifi', true),
	(2, 1, 'Piscina', true)
;

-- Insertar datos en la tabla Fotos
INSERT INTO Fotos (fotoId, alojamientoId, titulo, fotoURL) VALUES 
	(1, 1, 'Salón', 'Siempre-viva-salon.jpg'),
	(2, 1, 'Cocina', 'Siempre-viva-cocina.jpg')
;

-- Insertar datos adicionales en la tabla Huespedes
INSERT INTO Usuarios (usuarioId, dni, nombre, apellidos, correo, contrasena, direccion, telefono, fCompra, esPropietario, esHuesped) VALUES 
	(3, '23456789B', 'Ana', 'García', 'anagarcia@example.com', 'ana123', 'Calle Luna 234', '600234567', NULL, FALSE, TRUE),
	(4, '34567890C', 'Luis', 'Martínez', 'luismartinez@example.com', 'luis123', 'Calle Sol 345', '600345678', NULL, FALSE, TRUE),
	(5, '45678901D', 'María', 'Rodríguez', 'mariarodriguez@example.com', 'maria123', 'Calle Estrella 456', '600456789', NULL, FALSE, TRUE),
	(6, '56789012E', 'Carlos', 'Fernández', 'carlosfernandez@example.com', 'carlos123', 'Calle Cometa 567', '600567890', NULL, FALSE, TRUE),
	(7, '67890123F', 'Laura', 'Gómez', 'lauragomez@example.com', 'laura123', 'Calle Planeta 678', '600678901', NULL, FALSE, TRUE),
	(8, '78901234G', 'Jorge', 'Díaz', 'jorgediaz@example.com', 'jorge123', 'Calle Universo 789', '600789012', NULL, FALSE, TRUE),
	(9, '89012345H', 'Elena', 'Ruiz', 'elenaruiz@example.com', 'elena123', 'Calle Galaxia 890', '600890123', NULL, FALSE, TRUE),
	(10, '90123456I', 'Pedro', 'Hernández', 'pedrohernandez@example.com', 'pedro123', 'Calle Nebulosa 901', '600901234', NULL, FALSE, TRUE),
	(11, '01234567J', 'Sofía', 'López', 'sofialopez@example.com', 'sofia123', 'Calle Estrella 012', '600012345', NULL, FALSE, TRUE),
	(12, '12345678K', 'Raúl', 'Sánchez', 'raulsanchez@example.com', 'raul123', 'Calle Cometa 123', '600123456', NULL, FALSE, TRUE)
;

-- Insertar datos adicionales en la tabla Propietarios
INSERT INTO Usuarios (usuarioId, dni, nombre, apellidos, correo, contrasena, direccion, telefono, fCompra, esPropietario, esHuesped) VALUES 
	(13, '98765432C', 'Lucía', 'Moreno', 'luciamoreno@example.com', 'lucia456', 'Av. Siempre Viva 789', '600987654', '2022-02-20', TRUE, FALSE),
	(14, '87654321D', 'Miguel', 'Torres', 'migueltorres@example.com', 'miguel456', 'Av. Siempre Viva 890', '600876543', '2022-03-25', TRUE, FALSE),
	(15, '76543210E', 'Isabel', 'Ramírez', 'isabelramirez@example.com', 'isabel456', 'Av. Siempre Viva 901', '600765432', '2022-04-30', TRUE, FALSE)
;

-- Insertar datos adicionales en la tabla ZonasTuristicas
INSERT INTO ZonasTuristicas (zonaId, zona) VALUES 
	(2, 'Sierra Nevada'),
	(3, 'La Alpujarra'),
	(4, 'Cabo de Gata')
;

-- Insertar datos adicionales en la tabla Alojamientos
INSERT INTO Alojamientos (alojamientoId, propietarioId, zonaId, direccion, numDormitorios, numBaños, ocupacionMaxima) VALUES 
	(2, 2, 1, 'Calle Nueva 1', 2, 1, 4),
	(3, 2, 2, 'Calle Nueva 2', 3, 2, 6),
	(4, 13, 3, 'Calle Nueva 3', 1, 1, 2),
	(5, 13, 4, 'Calle Nueva 4', 4, 3, 8),
	(6, 14, 4, 'Calle Nueva 5', 2, 1, 4),
	(7, 14, 3, 'Calle Nueva 6', 3, 2, 6),
	(8, 15, 2, 'Calle Nueva 7', 1, 1, 2),
	(9, 15, 1, 'Calle Nueva 8', 4, 3, 8),
	(10, 2, 2, 'Calle Nueva 9', 2, 1, 4),
	(11, 2, 3, 'Calle Nueva 10', 3, 2, 6),
	(12, 13, 4, 'Calle Nueva 11', 1, 1, 2),
	(13, 13, 4, 'Calle Nueva 12', 4, 3, 8),
	(14, 14, 3, 'Calle Nueva 13', 2, 1, 4),
	(15, 14, 2, 'Calle Nueva 14', 3, 2, 6),
	(16, 15, 1, 'Calle Nueva 15', 1, 1, 2),
	(17, 15, 2, 'Calle Nueva 16', 4, 3, 8),
	(18, 2, 3, 'Calle Nueva 17', 2, 1, 4),
	(19, 2, 4, 'Calle Nueva 18', 3, 2, 6),
	(20, 13, 2, 'Calle Nueva 19', 1, 1, 2),
	(21, 13, 1, 'Calle Nueva 20', 4, 3, 8)
;

-- Insertar datos adicionales en la tabla Reservas
INSERT INTO Reservas (reservaId, huespedId, alojamientoId, checkIn, checkOut, comentario, valoracion) VALUES 
	(2, 1, 2, '2022-01-01', '2022-01-10', 'Muy buena experiencia', 5),
	(3, 3, 3, '2022-01-11', '2022-01-20', 'Todo perfecto', 4),
	(4, 4, 4, '2022-01-21', '2022-01-30', 'Recomendado', 5),
	(5, 5, 5, '2022-02-01', '2022-02-10', 'Excelente', 5),
	(6, 6, 6, '2022-02-11', '2022-02-20', 'Muy bien', 4),
	(7, 7, 7, '2022-02-21', '2022-02-28', 'Buena estancia', 4),
	(8, 8, 8, '2022-03-01', '2022-03-10', 'Todo bien', 4),
	(9, 9, 9, '2022-03-11', '2022-03-20', 'Muy recomendable', 5),
	(10, 10, 10, '2022-03-21', '2022-03-30', 'Perfecto', 5),
	(11, 11, 11, '2022-04-01', '2022-04-10', 'Muy bueno', 4),
	(12, 1, 12, '2022-04-11', '2022-04-20', 'Muy buena experiencia', 5),
	(13, 3, 13, '2022-04-21', '2022-04-30', 'Todo perfecto', 4),
	(14, 4, 14, '2022-05-01', '2022-05-10', 'Recomendado', 5),
	(15, 5, 15, '2022-05-11', '2022-05-20', 'Excelente', 5),
	(16, 6, 16, '2022-05-21', '2022-05-30', 'Muy bien', 4),
	(17, 7, 17, '2022-06-01', '2022-06-10', 'Buena estancia', 4),
	(18, 8, 18, '2022-06-11', '2022-06-20', 'Todo bien', 4),
	(19, 9, 19, '2022-06-21', '2022-06-30', 'Muy recomendable', 5),
	(20, 10, 20, '2022-07-01', '2022-07-10', 'Perfecto', 5),
	(21, 11, 21, '2022-07-11', '2022-07-20', 'Muy bueno', 4),
	(22, 1, 2, '2022-07-21', '2022-07-30', 'Muy buena experiencia', 5),
	(23, 3, 3, '2022-08-01', '2022-08-10', 'Todo perfecto', 4),
	(24, 4, 4, '2022-08-11', '2022-08-20', 'Recomendado', 5),
	(25, 5, 5, '2022-08-21', '2022-08-30', 'Excelente', 5),
	(26, 6, 6, '2022-09-01', '2022-09-10', 'Muy bien', 4),
	(27, 7, 7, '2022-09-11', '2022-09-20', 'Buena estancia', 4),
	(28, 8, 8, '2022-09-21', '2022-09-30', 'Todo bien', 4),
	(29, 9, 9, '2022-10-01', '2022-10-10', 'Muy recomendable', 5),
	(30, 10, 10, '2022-10-11', '2022-10-20', 'Perfecto', 5),
	(31, 11, 11, '2022-10-21', '2022-10-30', 'Muy bueno', 4),
	(32, 1, 12, '2022-11-01', '2022-11-10', 'Muy buena experiencia', 5),
	(33, 3, 13, '2022-11-11', '2022-11-20', 'Todo perfecto', 4),
	(34, 4, 14, '2022-11-21', '2022-11-30', 'Recomendado', 5),
	(35, 5, 15, '2022-12-01', '2022-12-10', 'Excelente', 5),
	(36, 6, 16, '2022-12-11', '2022-12-20', 'Muy bien', 4),
	(37, 7, 17, '2022-12-21', '2022-12-30', 'Buena estancia', 4),
	(38, 8, 18, '2023-01-01', '2023-01-10', 'Todo bien', 4),
	(39, 9, 19, '2023-01-11', '2023-01-20', 'Muy recomendable', 5),
	(40, 10, 20, '2023-01-21', '2023-01-30', 'Perfecto', 5),
	(41, 11, 21, '2023-02-01', '2023-02-10', 'Muy bueno', 4),
	(42, 1, 2, '2023-02-11', '2023-02-20', 'Muy buena experiencia', 5),
	(43, 3, 3, '2023-02-21', '2023-02-28', 'Todo perfecto', 4),
	(44, 4, 4, '2023-03-01', '2023-03-10', 'Recomendado', 5),
	(45, 5, 5, '2023-03-11', '2023-03-20', 'Excelente', 5),
	(46, 6, 6, '2023-03-21', '2023-03-30', 'Muy bien', 4),
	(47, 7, 7, '2023-04-01', '2023-04-10', 'Buena estancia', 4),
	(48, 8, 8, '2023-04-11', '2023-04-20', 'Todo bien', 4),
	(49, 9, 9, '2023-04-21', '2023-04-30', 'Muy recomendable', 5),
	(50, 10, 10, '2023-05-01', '2023-05-10', 'Perfecto', 5),
	(51, 11, 11, '2023-05-11', '2023-05-20', 'Muy bueno', 4),
	(52, 1, 12, '2023-05-21', '2023-05-30', 'Muy buena experiencia', 5),
	(53, 3, 13, '2023-06-01', '2023-06-10', 'Todo perfecto', 4)
;

-- Insertar datos adicionales en la tabla Servicios
INSERT INTO Servicios (servicioId, alojamientoId, tipoServicio, disponible) VALUES 
	(3, 2, 'Wifi', true),
	(4, 2, 'Piscina', false),
	(5, 2, 'Garaje', true),
	(6, 2, 'AireAcondicionado', false),
	(7, 3, 'Wifi', true),
	(8, 3, 'Piscina', true),
	(9, 3, 'Garaje', false),
	(10, 3, 'AireAcondicionado', true),
	(11, 4, 'Wifi', false),
	(12, 4, 'Piscina', true),
	(13, 4, 'Garaje', true),
	(14, 4, 'AireAcondicionado', false),
	(15, 5, 'Wifi', true),
	(16, 5, 'Piscina', false),
	(17, 5, 'Garaje', true),
	(18, 5, 'AireAcondicionado', true),
	(19, 6, 'Wifi', true),
	(20, 6, 'Piscina', true),
	(21, 6, 'Garaje', false),
	(22, 6, 'AireAcondicionado', true),
	(23, 7, 'Wifi', false),
	(24, 7, 'Piscina', true),
	(25, 7, 'Garaje', true),
	(26, 7, 'AireAcondicionado', false),
	(27, 8, 'Wifi', true),
	(28, 8, 'Piscina', false),
	(29, 8, 'Garaje', true),
	(30, 8, 'AireAcondicionado', true),
	(31, 9, 'Wifi', true),
	(32, 9, 'Piscina', true),
	(33, 9, 'Garaje', false),
	(34, 9, 'AireAcondicionado', true),
	(35, 10, 'Wifi', false),
	(36, 10, 'Piscina', true),
	(37, 10, 'Garaje', true),
	(38, 10, 'AireAcondicionado', false),
	(39, 11, 'Wifi', true),
	(40, 11, 'Piscina', false),
	(41, 11, 'Garaje', true),
	(42, 11, 'AireAcondicionado', true),
	(43, 12, 'Wifi', true),
	(44, 12, 'Piscina', true),
	(45, 12, 'Garaje', false),
	(46, 12, 'AireAcondicionado', true),
	(47, 13, 'Wifi', false),
	(48, 13, 'Piscina', true),
	(49, 13, 'Garaje', true),
	(50, 13, 'AireAcondicionado', false),
	(51, 14, 'Wifi', true),
	(52, 14, 'Piscina', false),
	(53, 14, 'Garaje', true),
	(54, 14, 'AireAcondicionado', true),
	(55, 15, 'Wifi', true),
	(56, 15, 'Piscina', true),
	(57, 15, 'Garaje', false),
	(58, 15, 'AireAcondicionado', true),
	(59, 16, 'Wifi', false),
	(60, 16, 'Piscina', true),
	(61, 16, 'Garaje', true),
	(62, 16, 'AireAcondicionado', false),
	(63, 17, 'Wifi', true),
	(64, 17, 'Piscina', false),
	(65, 17, 'Garaje', true),
	(66, 17, 'AireAcondicionado', true),
	(67, 18, 'Wifi', true),
	(68, 18, 'Piscina', true),
	(69, 18, 'Garaje', false),
	(70, 18, 'AireAcondicionado', true),
	(71, 19, 'Wifi', false),
	(72, 19, 'Piscina', true),
	(73, 19, 'Garaje', true),
	(74, 19, 'AireAcondicionado', false),
	(75, 20, 'Wifi', true),
	(76, 20, 'Piscina', false),
	(77, 20, 'Garaje', true),
	(78, 20, 'AireAcondicionado', TRUE)
;

-- Insertar datos adicionales en la tabla Fotos 
INSERT INTO Fotos (fotoId, alojamientoId, titulo, fotoURL) VALUES 
	(3, 2, 'Salón', 'Siempre-viva-salon.jpg'),
	(4, 2, 'Cocina', 'Siempre-viva-cocina.jpg'),
	(5, 2, 'Dormitorio', 'Siempre-viva-dormitorio.jpg'),
	(6, 3, 'Salón', 'Sierra-nevada-salon.jpg'),
	(7, 3, 'Cocina', 'Sierra-nevada-cocina.jpg'),
	(8, 3, 'Dormitorio', 'Sierra-nevada-dormitorio.jpg'),
	(9, 4, 'Salón', 'Alpujarra-salon.jpg'),
	(10, 4, 'Cocina', 'Alpujarra-cocina.jpg'),
	(11, 4, 'Dormitorio', 'Alpujarra-dormitorio.jpg'),
	(12, 5, 'Salón', 'Cabo-de-gata-salon.jpg'),
	(13, 5, 'Cocina', 'Cabo-de-gata-cocina.jpg'),
	(14, 5, 'Dormitorio', 'Cabo-de-gata-dormitorio.jpg'),
	(15, 6, 'Salón', 'Siempre-viva-salon.jpg'),
	(16, 6, 'Cocina', 'Siempre-viva-cocina.jpg'),
	(17, 6, 'Dormitorio', 'Siempre-viva-dormitorio.jpg'),
	(18, 7, 'Salón', 'Sierra-nevada-salon.jpg'),
	(19, 7, 'Cocina', 'Sierra-nevada-cocina.jpg'),
	(20, 7, 'Dormitorio', 'Sierra-nevada-dormitorio.jpg'),
	(21, 8, 'Salón', 'Alpujarra-salon.jpg'),
	(22, 8, 'Cocina', 'Alpujarra-cocina.jpg'),
	(23, 8, 'Dormitorio', 'Alpujarra-dormitorio.jpg'),
	(24, 9, 'Salón', 'Cabo-de-gata-salon.jpg'),
	(25, 9, 'Cocina', 'Cabo-de-gata-cocina.jpg'),
	(26, 9, 'Dormitorio', 'Cabo-de-gata-dormitorio.jpq'),
	(27, 10, 'Salón', 'Siempre-viva-salon.jpg'),
	(28, 10, 'Cocina', 'Siempre-viva-cocina.jpg'),
	(29, 10, 'Dormitorio', 'Siempre-viva-dormitorio.jpg'),
	(30, 11, 'Salón', 'Sierra-nevada-salon.jpg'),
	(31, 11, 'Cocina', 'Sierra-nevada-cocina.jpg'),
	(32, 11, 'Dormitorio', 'Sierra-nevada-dormitorio.jpg'),
	(33, 12, 'Salón', 'Alpujarra-salon.jpg'),
	(34, 12, 'Cocina', 'Alpujarra-cocina.jpg'),
	(35, 12, 'Dormitorio', 'Alpujarra-dormitorio.jpg'),
	(36, 13, 'Salón', 'Cabo-de-gata-salon.jpg'),
	(37, 13, 'Cocina', 'Cabo-de-gata-cocina.jpg'),
	(38, 13, 'Dormitorio', 'Cabo-de-gata-dormitorio.jpg'),
	(39, 14, 'Salón', 'Siempre-viva-salon.jpg'),
	(40, 14, 'Cocina', 'Siempre-viva-cocina.jpg'),
	(41, 14, 'Dormitorio', 'Siempre-viva-dormitorio.jpg'),
	(42, 15, 'Salón', 'Sierra-nevada-salon.jpg'),
	(43, 15, 'Cocina', 'Sierra-nevada-cocina.jpg'),
	(44, 15, 'Dormitorio', 'Sierra-nevada-dormitorio.jpg'),
	(45, 16, 'Salón', 'Alpujarra-salon.jpg'),
	(46, 16, 'Cocina', 'Alpujarra-cocina.jpg'),
	(47, 16, 'Dormitorio', 'Alpujarra-dormitorio.jpg'),
	(48, 17, 'Salón', 'Cabo-de-gata-salon.jpq'),
	(49, 17, 'Cocina', 'Cabo-de-gata-cocina.jpg'),
	(50, 17, 'Dormitorio', 'Cabo-de-gata-dormitorio.jpg'),
	(51, 18, 'Salón', 'Siempre-viva-salon.jpg'),
	(52, 18, 'Cocina', 'Siempre-viva-cocina.jpg'),
	(53, 18, 'Dormitorio', 'Siempre-viva-dormitorio.jpg'),
	(54, 19, 'Salón', 'Sierra-nevada-salon.jpg'),
	(55, 19, 'Cocina', 'Sierra-nevada-cocina.jpg'),
	(56, 19, 'Dormitorio', 'Sierra-nevada-dormitorio.jpg'),
	(57, 20, 'Salón', 'Alpujarra-salon.jpg'),
	(58, 20, 'Cocina', 'Alpujarra-cocina.jpg'),
	(59, 20, 'Dormitorio', 'Alpujarra-dormitorio.jpg')
;
