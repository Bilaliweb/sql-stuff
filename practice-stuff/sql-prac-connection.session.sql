CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    branch VARCHAR(30) NOT NULL
);

CREATE TABLE exam_scores (
    score_id SERIAL PRIMARY KEY,
    student_id INT NOT NULL REFERENCES students(student_id),
    subject VARCHAR(30) NOT NULL,
    score INT NOT NULL CHECK (score BETWEEN 0 AND 100),
    exam_month VARCHAR(10) NOT NULL
);

CREATE TABLE projects (
    project_id SERIAL PRIMARY KEY,
    student_id INT NOT NULL REFERENCES students(student_id),
    title VARCHAR(50) NOT NULL,
    marks INT NOT NULL CHECK (marks BETWEEN 0 AND 100)
);