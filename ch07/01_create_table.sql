BEGIN TRANSACTION;

CREATE TABLE departments (
    dept_id INTEGER,
    dept TEXT,
    city TEXT,
    CONSTRAINT dept_key PRIMARY KEY (dept_id),
    CONSTRAINT dept_city_unique UNIQUE (dept, city)
);

CREATE TABLE employees(
    emp_id INTEGER,
    first_name TEXT,
    last_name TEXT,
    salary NUMERIC(10, 2),
    dept_id INTEGER REFERENCES departments (dept_id),
    CONSTRAINT emp_key PRIMARY KEY (emp_id)
);

INSERT INTO departments
VALUES 
    (1, 'Tax', 'Atlanta'),
    (2, 'IT', 'Boston');

INSERT INTO employees
VALUES
    (1,
 'Julia',
 'Reyes',
 115300,
 1), (2,
      'Janet',
      'King',
      98000,
      1), (3,
           'Arthur',
           'Pappas',
           72700,
           2), (4,
                'Michael',
                'Taylor',
                89500,
                2);

COMMIT;

SELECT * FROM departments;
SELECT * FROM employees;