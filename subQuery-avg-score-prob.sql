-- First select required columns to display 
-- Then do Inner join so that student detail can be attached with score data on a condition s.student_id = e.student_id
-- Then put a 'Where' clause for actual condition which is to show the data with score > average
-- score > average -> average will contain whole sql query for average's calculation which results in 'sub-query'
SELECT 
s.name as student_name,
s.branch as student_branch,
e.score
FROM exam_scores AS e
INNER JOIN students AS s ON s.student_id = e.student_id
WHERE e.score > (
    SELECT AVG(score) as average_score FROM exam_scores
);
