-- 
-- Autor: David Ruiz
-- Fecha: Octubre de 2024
-- Descripción: Script para crear la BD del ejercicio de Bodegas
-- 

DROP DATABASE IF EXISTS BodegasDB;
CREATE DATABASE BodegasDB;
USE BodegasDB;

DELIMITER //
CREATE OR REPLACE PROCEDURE p_create_db()
BEGIN
	CREATE OR REPLACE TABLE bodegas (
	   bodega_id INT NOT NULL AUTO_INCREMENT,
	   nombre VARCHAR(255) NOT NULL,
	   denominacion_origen VARCHAR(255) NOT NULL,
		PRIMARY KEY (bodega_id),
		CONSTRAINT RN_1_Unicidad UNIQUE (nombre)
	);
	
	CREATE OR REPLACE TABLE vinos (
	   vino_id INT NOT NULL AUTO_INCREMENT,
	   bodega_id INT NOT NULL,
	   nombre VARCHAR(255) NOT NULL,
	   grados DECIMAL(5, 2) NOT NULL,
		PRIMARY KEY (vino_id),
		UNIQUE (nombre),
	   FOREIGN KEY (bodega_id) REFERENCES bodegas(bodega_id),
		CONSTRAINT RN_3_Grados
			CHECK (grados >= 10 AND grados <= 15)
	);
	
	CREATE OR REPLACE TABLE jovenes (
	   vino_id INT NOT NULL,
		tiempo_barrica INT NOT NULL,
		tiempo_botella INT NOT NULL,
		PRIMARY KEY (vino_id),
	   FOREIGN KEY (vino_id) REFERENCES vinos(vino_id),
		CONSTRAINT RN_2_TiempoCrianza 
			CHECK (tiempo_barrica <=6 AND tiempo_barrica + tiempo_botella <=12 )
	);
	
	CREATE OR REPLACE TABLE crianzas (
	   vino_id INT NOT NULL,
		tiempo_barrica INT NOT NULL,
		tiempo_botella INT NOT NULL,
		PRIMARY KEY (vino_id),
	   FOREIGN KEY (vino_id) REFERENCES vinos(vino_id),
		CONSTRAINT RN_2_TiempoCrianza 
		 	CHECK (tiempo_barrica >=6 AND tiempo_barrica + tiempo_botella >=24 )
	);
	
	CREATE OR REPLACE TABLE uvas (
	   uva_id INT NOT NULL AUTO_INCREMENT,
	   nombre VARCHAR(255) NOT NULL,
		PRIMARY KEY (uva_id),
	   CONSTRAINT RN_1_Unicidad UNIQUE (nombre)
	);
	
	CREATE OR REPLACE TABLE cosechas (
	   cosecha_id INT AUTO_INCREMENT ,
	   vino_id INT NOT NULL,
	   año YEAR NOT NULL,
	   calidad VARCHAR(255) NOT NULL,
		PRIMARY KEY (cosecha_id),
	   FOREIGN KEY (vino_id) REFERENCES vinos(vino_id)
			ON DELETE CASCADE, 
		UNIQUE (cosecha_id, año)
	);
	
	CREATE OR REPLACE TABLE vinos_uvas (
	    vino_uva_id INT AUTO_INCREMENT PRIMARY KEY,
	    vino_id INT NOT NULL,
	    uva_id INT NOT NULL,
	    UNIQUE (vino_id, uva_id),
	    FOREIGN KEY (vino_id) REFERENCES vinos(vino_id),
	    FOREIGN KEY (uva_id) REFERENCES uvas(uva_id)
	);
END;
//
DELIMITER ;

CALL p_create_db();















