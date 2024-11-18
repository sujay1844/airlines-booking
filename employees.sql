-- Employee table
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100)
);
-- Employee_hierarchy table
CREATE TABLE employee_hierarchy (
    employee_id INT,
    manager_id INT,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (manager_id) REFERENCES employees(employee_id)
);
-- Insert employees
INSERT INTO employees (employee_id, employee_name) VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie');
-- Insert employee hierarchy (relationships between employees)
INSERT INTO employee_hierarchy (employee_id, manager_id) VALUES
(2, 1), -- Bob reports to Alice
(3, 1); -- Charlie reports to Alice
-- Recursive query to find all employees reporting to Alice
WITH RECURSIVE subordinates AS (
    -- Base case: direct reports to Alice
    SELECT e.employee_id, e.employee_name, 1 as level
    FROM employees e
    JOIN employee_hierarchy eh ON e.employee_id = eh.employee_id
    WHERE eh.manager_id = 1

    UNION ALL

    -- Recursive case: indirect reports
    SELECT e.employee_id, e.employee_name, s.level + 1
    FROM employees e
    JOIN employee_hierarchy eh ON e.employee_id = eh.employee_id
    JOIN subordinates s ON eh.manager_id = s.employee_id
)
SELECT employee_id, employee_name, level
FROM subordinates
ORDER BY level, employee_name;