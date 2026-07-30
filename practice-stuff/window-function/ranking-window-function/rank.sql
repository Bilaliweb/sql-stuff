SELECT e.student_id,
    s.name,
    s.branch,
    SUM(e.score) AS total_score,
    RANK() OVER(
        PARTITION BY s.branch
        ORDER BY SUM(e.score) DESC
    )
FROM exam_scores AS e
INNER JOIN students As s ON s.student_id = e.student_id
GROUP BY e.student_id, s.name, s.branch;