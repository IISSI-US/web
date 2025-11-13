-- 
-- Autor: David Ruiz
-- Fecha: Octubre de 2024
-- Descripción: Script para crear la BD del ejercicio de Bodegas, con una
-- tabla para cada subclase
-- 

DROP DATABASE IF exists Bodegas2DB;
CREATE DATABASE Bodegas2DB;
USE Bodegas2DB;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_create_db()
BEGIN
	CREATE OR REPLACE TABLE bodegas (
		bodega_id INT NOT NULL AUTO_INCREMENT,
		nombre VARCHAR(255) NOT NULL UNIQUE,
		denominacion_origen VARCHAR(255) NOT NULL,
		PRIMARY KEY (bodega_id),
		CONSTRAINT RN_1_Unicidad UNIQUE (nombre)
	);
	
	CREATE OR REPLACE TABLE jovenes (
		joven_id VARCHAR(32),
		bodega_id INT NOT NULL,
		nombre VARCHAR(255) NOT NULL,
		grados DECIMAL(5, 2) NOT NULL,
		tiempo_barrica INT NOT NULL,
		tiempo_botella INT NOT NULL,
		CONSTRAINT RN_2_TiempoCrianza 
		 	CHECK (tiempo_barrica <=6 AND tiempo_barrica + tiempo_botella <=12 ),
		CONSTRAINT RN_3_Grados
			CHECK (grados >= 10 AND grados <= 15),
		PRIMARY KEY (joven_id),
		FOREIGN KEY (bodega_id) REFERENCES bodegas(bodega_id),
		CONSTRAINT RN_1_Unicidad UNIQUE (nombre)
	);
	
	CREATE OR REPLACE TABLE crianzas (
		crianza_id VARCHAR(32),
		bodega_id INT NOT NULL,
		nombre VARCHAR(255) NOT NULL,
		grados DECIMAL(5, 2) NOT NULL,	
		tiempo_barrica INT NOT NULL,
		tiempo_botella INT NOT NULL,
		CONSTRAINT RN_2_TiempoCrianza 
			CHECK (tiempo_barrica >=6 AND tiempo_barrica + tiempo_botella >= 24 ), 
		CONSTRAINT RN_3_Grados
			CHECK (grados >= 10 AND grados <= 15),
		PRIMARY KEY (crianza_id),
		FOREIGN KEY (bodega_id) REFERENCES bodegas(bodega_id),
		CONSTRAINT RN_1_Unicidad UNIQUE(nombre)
	);
	
	CREATE OR REPLACE TABLE uvas (
		uva_id INT AUTO_INCREMENT,
		nombre VARCHAR(255) NOT NULL,
		PRIMARY KEY (uva_id),
		CONSTRAINT RN_1_Unicidad UNIQUE (nombre)
	);
	
	CREATE OR REPLACE TABLE cosechas (
		cosecha_id INT AUTO_INCREMENT,
		crianza_id VARCHAR(32) NOT NULL,
		año YEAR NOT NULL,
		calidad VARCHAR(255) NOT NULL,
		PRIMARY KEY (cosecha_id),
		FOREIGN KEY (crianza_id) REFERENCES crianzas(crianza_id)
			ON DELETE CASCADE,
		CONSTRAINT RN_4_CosechasAño UNIQUE (cosecha_id, año)
	);
	
	CREATE OR REPLACE TABLE vinos_uvas(
		vino_uva_id INT AUTO_INCREMENT,
		joven_id VARCHAR(32),
		crianza_id VARCHAR(32),
		uva_id INT NOT NULL,
		UNIQUE (joven_id, uva_id),
		UNIQUE (crianza_id, uva_id),
		PRIMARY KEY (vino_uva_id),
		FOREIGN KEY (joven_id) REFERENCES jovenes(joven_id),
		FOREIGN KEY (crianza_id) REFERENCES crianzas(crianza_id),
		FOREIGN KEY (uva_id) REFERENCES uvas(uva_id)
	);
	
END;
//
DELIMITER ;

CALL p_create_db();