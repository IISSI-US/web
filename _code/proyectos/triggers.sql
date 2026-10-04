--
-- Triggers para las invariantes temporales y jerárquicas de ProyectosDB
--
USE ProyectosDB;

DELIMITER //
CREATE OR REPLACE TRIGGER t_biu_task_periods_no_overlap
BEFORE INSERT OR UPDATE ON task_periods
FOR EACH ROW
BEGIN
    DECLARE v_overlapping_periods INT DEFAULT 0;

    SELECT COUNT(*) INTO v_overlapping_periods
    FROM task_periods existing_period
    WHERE existing_period.task_id = NEW.task_id
      AND existing_period.task_period_id <> NEW.task_period_id
      AND (existing_period.end_date IS NULL OR NEW.start_date <= existing_period.end_date)
      AND (NEW.end_date IS NULL OR existing_period.start_date <= NEW.end_date);

    IF v_overlapping_periods > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'RN-03: Los periodos de una tarea no pueden solaparse';
    END IF;
END //

CREATE OR REPLACE TRIGGER t_biu_subtasks_same_project
BEFORE INSERT OR UPDATE ON subtasks
FOR EACH ROW
BEGIN
    DECLARE v_same_project INT DEFAULT 0;

    SELECT COUNT(*) INTO v_same_project
    FROM tasks child
    JOIN tasks parent ON parent.project_id = child.project_id
    WHERE child.task_id = NEW.subtask_id
      AND parent.task_id = NEW.task_id;

    IF v_same_project = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'RN-04: La tarea y su subtarea deben pertenecer al mismo proyecto';
    END IF;
END //
DELIMITER ;