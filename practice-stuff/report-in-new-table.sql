-- We need to create a report list for highest scorers from exam attempts
-- Which will have score > class_average_score regardless of how many attempts a student has
-- We'll also need student name, subject and score as well in report
-- That report data will be inserted into another table as 'exam_report_table'

INSERT INTO exam_report_table(
    student_id, 
    student_name, 
    subject, 
    score
    )
SELECT s.student_id, s.name, e.subject, e.score
FROM exam_scores AS e
INNER JOIN students AS s ON s.student_id = e.student_id
WHERE e.score > (
    SELECT AVG(score) FROM exam_scores
)