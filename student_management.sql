-- ============================================
-- Student Management Database
-- Author: Mateus Pereira
-- Description: Relational database for managing
-- students, addresses, courses, and enrollments.
-- ============================================

-- Create Database
CREATE DATABASE student_management;

USE student_management;

-- ============================================
-- 1. ADDRESS TABLE
-- ============================================

CREATE TABLE student_address (
    address_id INT PRIMARY KEY AUTO_INCREMENT,
    street VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50),
    zip_code VARCHAR(10),
    country VARCHAR(50) NOT NULL
);

-- ============================================
-- 2. STUDENT TABLE
-- ============================================

CREATE TABLE students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE,
    email VARCHAR(100) UNIQUE NOT NULL,
    major VARCHAR(100),
    enrollment_year INT,
    address_id INT,

    FOREIGN KEY (address_id)
        REFERENCES student_address(address_id)
);

-- ============================================
-- 3. COURSE TABLE
-- ============================================

CREATE TABLE courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_code VARCHAR(20) UNIQUE NOT NULL,
    course_name VARCHAR(100) NOT NULL,
    credits INT NOT NULL
);

-- ============================================
-- 4. ENROLLMENT TABLE
-- ============================================

CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    semester VARCHAR(20) NOT NULL,
    grade VARCHAR(5),

    FOREIGN KEY (student_id)
        REFERENCES students(student_id),

    FOREIGN KEY (course_id)
        REFERENCES courses(course_id)
);

-- ============================================
-- INSERT ADDRESS DATA
-- ============================================

INSERT INTO student_address
    (street, city, state, zip_code, country)
VALUES
    ('100 University Avenue', 'Mobile', 'AL', '36613', 'USA'),
    ('200 Oak Street', 'Mobile', 'AL', '36608', 'USA'),
    ('15 Main Street', 'Lisbon', NULL, '1000-001', 'Portugal'),
    ('25 Ocean Avenue', 'Pensacola', 'FL', '32501', 'USA');

-- ============================================
-- INSERT STUDENT DATA
-- ============================================

INSERT INTO students
    (first_name, last_name, date_of_birth, email,
     major, enrollment_year, address_id)
VALUES
    ('Mateus', 'Pereira', '2004-07-01',
     'mateus@example.com', 'Computer Information Systems', 2023, 1),

    ('John', 'Smith', '2003-05-15',
     'john@example.com', 'Cybersecurity', 2022, 2),

    ('Ana', 'Silva', '2004-11-20',
     'ana@example.com', 'Business Administration', 2023, 3),

    ('Michael', 'Johnson', '2002-08-10',
     'michael@example.com', 'Computer Science', 2021, 4);

-- ============================================
-- INSERT COURSE DATA
-- ============================================

INSERT INTO courses
    (course_code, course_name, credits)
VALUES
    ('CIS101', 'Introduction to Information Systems', 3),
    ('CIS220', 'Database Management', 3),
    ('CIS250', 'Computer Networking', 3),
    ('CIS300', 'Operating Systems', 3),
    ('CYB210', 'Introduction to Cybersecurity', 3);

-- ============================================
-- INSERT ENROLLMENT DATA
-- ============================================

INSERT INTO enrollments
    (student_id, course_id, semester, grade)
VALUES
    (1, 1, 'Fall 2025', 'A'),
    (1, 2, 'Spring 2026', 'A'),
    (1, 3, 'Spring 2026', 'B'),
    (2, 1, 'Fall 2025', 'B'),
    (2, 5, 'Spring 2026', 'A'),
    (3, 1, 'Fall 2025', 'A'),
    (4, 2, 'Fall 2025', 'B');

-- ============================================
-- BASIC QUERIES
-- ============================================

-- Display all students
SELECT *
FROM students;

-- Display students and their addresses
SELECT
    s.student_id,
    s.first_name,
    s.last_name,
    s.email,
    s.major,
    a.city,
    a.state,
    a.country
FROM students s
JOIN student_address a
    ON s.address_id = a.address_id;

-- Display all available courses
SELECT *
FROM courses;

-- Display students enrolled in courses
SELECT
    s.first_name,
    s.last_name,
    c.course_code,
    c.course_name,
    e.semester,
    e.grade
FROM enrollments e
JOIN students s
    ON e.student_id = s.student_id
JOIN courses c
    ON e.course_id = c.course_id
ORDER BY s.last_name;

-- Find all CIS students
SELECT
    first_name,
    last_name,
    email,
    major
FROM students
WHERE major LIKE '%Information Systems%';

-- Find students with an A
SELECT
    s.first_name,
    s.last_name,
    c.course_name,
    e.grade
FROM enrollments e
JOIN students s
    ON e.student_id = s.student_id
JOIN courses c
    ON e.course_id = c.course_id
WHERE e.grade = 'A';

-- Count students by major
SELECT
    major,
    COUNT(*) AS number_of_students
FROM students
GROUP BY major;

-- Count students enrolled in each course
SELECT
    c.course_code,
    c.course_name,
    COUNT(e.student_id) AS enrolled_students
FROM courses c
LEFT JOIN enrollments e
    ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_code, c.course_name;
