USE BodegasDB;

-- Verificar los resultados de la suite heredada, sin modificar sus pruebas.
DELIMITER //
CREATE OR REPLACE PROCEDURE p_assert_test_results()
BEGIN
    IF (SELECT COUNT(*) FROM test_results) <> 4
       OR EXISTS (SELECT 1 FROM test_results WHERE test_status <> 'PASS') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Bodegas: pruebas incompletas o fallidas';
    END IF;
END //
DELIMITER ;
CALL p_assert_test_results();
DROP PROCEDURE p_assert_test_results;
