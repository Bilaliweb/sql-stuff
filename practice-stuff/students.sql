INSERT INTO students (name, branch) VALUES 
('Ali', 'NY'),
('Ahmad', 'CA'),
('Akbar', 'SA'),
('Jamal', 'LA'),
('Bilal', 'LHR'),
('Umar', 'ISB');

UPDATE students SET branch = 'IT'
WHERE name IN ('Bilal', 'Umar', 'Ali')