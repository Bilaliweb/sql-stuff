-- Window function is similar to do like ORDER BY
-- Order by reduces the whole table or we can say it groups the rows for specific column mentioned.
-- i.e; if there are 10 rows of specific column with same value it will become one row
-- This is actually a mutation on original table
-- But what If there is a requirement to do the opposite but get actual result means without mutation ?
-- In order to acheive that, window function comes to play


-- Simplest way to acheive GROUP BY result
SELECT e.student_id,
    SUM(e.score) AS total_score
FROM exam_scores AS e
GROUP BY e.student_id;


-- Now let's do syntax for window function
SELECT *,
    SUM(e.score) OVER(PARTITION BY student_id) AS total_sum
FROM exam_scores AS e;
