
DROP DATABASE if EXISTS BancoDB;
CREATE DATABASE BancoDB;
USE BancoDB;

DELIMITER //
CREATE OR REPLACE PROCEDURE createDB()
BEGIN 
	CREATE TABLE Cuentas (
	  cuentaId INT NOT NULL AUTO_INCREMENT,
	  titular  VARCHAR(64) NOT NULL,
	  saldo    DOUBLE NOT NULL,
	  PRIMARY KEY(cuentaId),
	  CONSTRAINT RN01_Saldo CHECK (saldo>=0)
	);
	
	CREATE TABLE Movimientos (
	  movimientoId   INT NOT null AUTO_INCREMENT,
	  fechaHora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	  cuentaId INT NOT NULL,
	  importe DOUBLE  NOT NULL,
	  debeHaber ENUM('D','H'),
	  concepto VARCHAR(64) NOT NULL,
	  PRIMARY KEY (movimientoId),
	  FOREIGN KEY(cuentaId) REFERENCES Cuentas(cuentaId),
	  CONSTRAINT RN02_Importe_Negativo CHECK(importe>0)
	);
	
	
END; 
//
DELIMITER ;

CALL createDB();

-- Trigger para Actualizar saldo con cualquier movimiento ‘D’: Salidas, ‘H’: Ingresos
DELIMITER //
CREATE OR REPLACE TRIGGER tAI_Movimientos AFTER INSERT ON Movimientos FOR EACH ROW
BEGIN
  IF (NEW.debeHaber='H') THEN -- El ingreso aumenta el saldo
    UPDATE Cuentas SET saldo = saldo + NEW.importe WHERE cuentaId=NEW.cuentaId;
  ELSE  -- Reduce el saldo
    UPDATE Cuentas SET saldo = saldo - NEW.importe WHERE cuentaId=NEW.cuentaId;
	END IF; 
END;
//
DELIMITER ;