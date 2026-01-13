SELECT 'STUDENT: sus notas' AS escenario, grade_value, exam_call
FROM grades
WHERE student_id = 6;


UPDATE grades SET grade_value=10 WHERE student_id=6 LIMIT 1;
