-- Common Table Expressions (CTEs)
-- Also known as WITH Query
-- Similar to sub-query, just different syntax, readability and maintainability
-- Syntax as:
-- WITH ____ AS (
--     -- SQL Query
-- )
-- Rest of the logic

-- Picking reference from 'projects-subquery.sql -> Line no. 17-27' and converting that to CTE
-- WITH cte_project_stats AS (
--         SELECT student_id, AVG(score) as avg_score FROM exam_scores GROUP BY student_id
-- )
-- SELECT s.name AS std_name,
--     s.branch AS std_branch,
--     p.title AS project_name,
--     p.marks AS project_marks,
--     project_stats.avg_score AS average_score
-- FROM projects AS p
--     INNER JOIN students as s ON s.student_id = p.student_id
--     INNER JOIN cte_project_stats as project_stats ON project_stats.student_id = p.student_id


-- Another example from 'student-total-cal.sql -> Line no. 1-13' and converting that to CTE
WITH cte_total_stats AS (
        SELECT student_id,
            SUM(score) AS total_score,
            COUNT(*) AS total_attempts
        FROM exam_scores
        GROUP BY student_id
)
SELECT s.student_id AS std_id,
    s.name AS student_name,
    s.branch AS student_branch,
    total_stats.total_score AS total_score,
    total_stats.total_attempts AS total_attempts
    FROM cte_total_stats AS total_stats
    INNER JOIN students as s ON s.student_id = total_stats.student_id
    ORDER BY total_stats.total_score DESC;


-- Another example from 'subQuery-stdnts-eligible.sql' and convert that to CTE
-- To achieve the result, we have to create multiple CTE's

-- 1st CTE
WITH cte_stdnts_eligible_score AS ( 
    SELECT student_id FROM exam_scores AS e WHERE e.score >= 85
),
-- 2nd CTE
cte_stdnts_eligible_marks AS (
    SELECT student_id FROM projects AS p WHERE p.marks >= 80
)
SELECT * FROM students AS s
WHERE s.student_id IN (SELECT student_id FROM cte_stdnts_eligible_score) AND s.student_id IN (SELECT student_id FROM cte_stdnts_eligible_marks);
