-- 2.Pruebas con AUTOCOMMIT OFF y Transacción explícita 
SET FOREIGN_KEY_CHECKS=0;-- Desactiva integridad referencial
TRUNCATE Movimientos; -- Vaciado de movimientos
TRUNCATE Cuentas;-- Vaciado de cuentas
SET FOREIGN_KEY_CHECKS=1;-- Activa integridad referencial
/* Activación del control explícito de transacciones. 
El programador codifica los puntos de sincronismo o bien, 
si se produce una excepción, hay Rollback de toda la transacción */
SET AUTOCOMMIT=0; -- Activación del control de transacciones
START TRANSACTION; -- Inicio de la transacción
-- (a) (OK): Se añada una cuenta con saldo 100€
INSERT INTO Cuentas (cuentaId, titular, saldo) VALUES (2,'Titular 2',100);
-- (b) (OK): Se añade un ingreso de 100€ (saldo nuevo=200€)
INSERT INTO Movimientos (cuentaId, importe, debeHaber, concepto) VALUES (2,100,'H','Ingreso');
-- (c) (NOK):Se intenta insertar un reintegro de 201€, que falla por no haber saldo suficiente (Trigger)
INSERT INTO Movimientos (cuentaId, importe, debeHaber, concepto) VALUES (2,201,'D','Reintegro');
-- La transacción sigue activa, pendiente de terminación (Commit) o (Rollback)
-- (d) El alumno debe probar a ejecutar manualmente (COMMIT) o (ROLLBACK) 
--     y a continuación hacer el SELECT: SELECT * FROM cuentas NATURAL JOIN movimientos; 
COMMIT WORK;
ROLLBACK WORK;

SELECT * FROM Cuentas NATURAL JOIN Movimientos;