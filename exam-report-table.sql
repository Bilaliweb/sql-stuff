CREATE TABLE exam_report_table (
    id SERIAL PRIMARY KEY,
    student_id INT NOT NULL REFERENCES students(student_id),
    student_name VARCHAR(30) NOT NULL,
    subject VARCHAR(30) NOT NULL,
    score INT NOT NULL CHECK (score BETWEEN 0 AND 100),
    archived_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);