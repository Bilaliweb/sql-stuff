-- For each project get student's name, branch, project marks
-- 1st way by doing sub-query in Where clause

-- With Where Clause
SELECT s.name AS std_name,
    s.branch AS std_branch,
    p.title AS project_name,
    p.marks AS project_marks
FROM projects AS p
    INNER JOIN students as s ON s.student_id = p.student_id
WHERE p.marks >= (
        SELECT MAX(marks) as highest_marks
        FROM projects
    );
    

-- With Inner Join
SELECT s.name AS std_name,
    s.branch AS std_branch,
    p.title AS project_name,
    p.marks AS project_marks,
    project_stats.avg_score AS average_score
FROM projects AS p
    INNER JOIN students as s ON s.student_id = p.student_id
    INNER JOIN (
        SELECT student_id, AVG(score) as avg_score FROM exam_scores GROUP BY student_id
    ) as project_stats ON project_stats.student_id = p.student_id