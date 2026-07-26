-- 
SELECT s.name,
    student_scores.total_score,
    CASE
        WHEN student_scores.total_score > 100 THEN 'TOP'
        WHEN student_scores.total_score > 70 THEN 'AVERAGE'
        ELSE 'LOW'
    END
FROM students AS s
    INNER JOIN (
        SELECT student_id,
            SUM(score) AS total_score
        FROM exam_scores
        GROUP BY student_id
    ) AS student_scores ON student_scores.student_id = s.student_id