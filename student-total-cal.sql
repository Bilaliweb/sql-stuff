-- We need to have total score a student has scored/earned and a number of exams he attempted.
-- We also need student's name and branch in results
-- Use temporary table approach using sub-query and Inner join for student's data

SELECT s.student_id AS std_id,
    s.name AS student_name,
    s.branch AS student_branch,
    total_stats.total_score AS total_score,
    total_stats.total_attempts AS total_attempts
    FROM (
        SELECT student_id,
            SUM(score) AS total_score,
            COUNT(*) AS total_attempts
        FROM exam_scores
        GROUP BY student_id
    ) AS total_stats
    INNER JOIN students as s ON s.student_id = total_stats.student_id
    ORDER BY total_stats.total_score DESC;