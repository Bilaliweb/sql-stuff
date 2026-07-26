-- ! Criteria for placement of students
-- 1. At least one attempt exam score should be >= 85
-- AND
-- 2. Any of their projects should have marks >= 80

SELECT * FROM students AS s
WHERE s.student_id IN (
    SELECT student_id FROM exam_scores WHERE score >= 85
) AND s.student_id IN (
    SELECT student_id FROM projects WHERE marks >= 80
);
