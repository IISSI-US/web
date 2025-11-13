-- 1. Pruebas con AUTOCOMMIT ON, sin transacciones
SET FOREIGN_KEY_CHECKS=0;-- Desactiva integridad referencial
TRUNCATE Movimientos; -- Vaciado de movimientos
TRUNCATE Cuentas;-- Vaciado de cuentas
SET FOREIGN_KEY_CHECKS=1;-- Activa integridad referencial
SET AUTOCOMMIT=1; -- Sincronización instrucción a instrucción 
-- (a) (Commit): Se añade una cuenta con saldo 100€
INSERT INTO Cuentas (cuentaId, titular, saldo) VALUES (1,'Titular 1',100);
-- (b) (Commit): Se añade un ingreso de 100€ (saldo nuevo=200€)
INSERT INTO Movimientos (cuentaId, importe, debeHaber, concepto) VALUES (1,100,'H','Ingreso');
-- (c) (Rollback):Se intenta insertar un reintegro de 201€, que falla por no haber saldo suficiente (Trigger) /* Error de SQL (4025): CONSTRAINT `CO_RN01_Saldo_Deudor` failed for `transactions`.`cuentas` */
INSERT INTO Movimientos (cuentaId, importe, debeHaber, concepto) VALUES (1,201,'D','Reintegro');
-- (d) (Rollback):Se intenta insertar un movimiento no permitido (Constraint)
INSERT INTO Movimientos (cuentaId, importe, debeHaber, concepto) VALUES (1,10,'X','Reintegro');
-- (e) (Consulta) Cada Commit se ha hecho persistente
/* Filas afectadas: 2  Filas encontradas: 0  Advertencias: 0  Duración para 3 de 5 consultas: 0,203 seg. */
SELECT * FROM Cuentas NATURAL JOIN Movimientos; 











