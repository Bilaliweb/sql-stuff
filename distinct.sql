-- To fetch the unique values for a column from a specific table
-- This will return us all the ids of overall students regardless of multiple appearance of 1 student in table
-- Actually all ids are unique and don't need to confuse if some id has occurred 5 times and it's not unique but it is unique
-- Every value in column is unique, the difference is some specific one is used multiple times
SELECT DISTINCT student_id FROM exam_scores