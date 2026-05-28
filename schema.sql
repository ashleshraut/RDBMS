-- Drop tables if they exist to allow clean regeneration
DROP TABLE IF EXISTS test_results;
DROP TABLE IF EXISTS submissions;
DROP TABLE IF EXISTS contest_problems;
DROP TABLE IF EXISTS contests;
DROP TABLE IF EXISTS test_cases;
DROP TABLE IF EXISTS problems;
DROP TABLE IF EXISTS attendance;
DROP TABLE IF EXISTS sessions;
DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS batches;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS students;

-- 1. Students Table
CREATE TABLE students (
    student_id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(20),
    joined_at TIMESTAMP NOT NULL,
    CONSTRAINT chk_email CHECK (email LIKE '%@%')
);

-- 2. Courses Table
CREATE TABLE courses (
    course_id VARCHAR(50) PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    course_slug VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);

-- 3. Batches Table
CREATE TABLE batches (
    batch_id VARCHAR(50) PRIMARY KEY,
    course_id VARCHAR(50) NOT NULL,
    batch_name VARCHAR(255) NOT NULL,
    instructor_id VARCHAR(50),
    started_at DATE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE RESTRICT
);

-- 4. Enrollments Mapping Table (Many-to-Many Student <-> Batch)
CREATE TABLE enrollments (
    enrollment_id VARCHAR(50) PRIMARY KEY,
    student_id VARCHAR(50) NOT NULL,
    batch_id VARCHAR(50) NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'active',
    enrolled_at TIMESTAMP NOT NULL,
    UNIQUE(student_id, batch_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (batch_id) REFERENCES batches(batch_id) ON DELETE CASCADE
);

-- 5. Sessions Table
CREATE TABLE sessions (
    session_id VARCHAR(50) PRIMARY KEY,
    batch_id VARCHAR(50) NOT NULL,
    title VARCHAR(255) NOT NULL,
    scheduled_at TIMESTAMP NOT NULL,
    FOREIGN KEY (batch_id) REFERENCES batches(batch_id) ON DELETE CASCADE
);

-- 6. Attendance Table
CREATE TABLE attendance (
    attendance_id VARCHAR(50) PRIMARY KEY,
    session_id VARCHAR(50) NOT NULL,
    student_id VARCHAR(50) NOT NULL,
    attendance_status VARCHAR(20) NOT NULL, -- present, absent, late
    marked_at TIMESTAMP NOT NULL,
    UNIQUE(session_id, student_id),
    FOREIGN KEY (session_id) REFERENCES sessions(session_id) ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE
);

-- 7. Problems Table
CREATE TABLE problems (
    problem_id VARCHAR(50) PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    problem_slug VARCHAR(100) NOT NULL UNIQUE,
    statement TEXT NOT NULL,
    max_score INT NOT NULL DEFAULT 100,
    time_limit_ms INT NOT NULL DEFAULT 1000,
    CONSTRAINT chk_score CHECK (max_score > 0)
);

-- 8. Test Cases Table (One-to-Many with Problems)
CREATE TABLE test_cases (
    test_case_id VARCHAR(50) PRIMARY KEY,
    problem_id VARCHAR(50) NOT NULL,
    input TEXT NOT NULL,
    expected_output TEXT NOT NULL,
    is_hidden BOOLEAN NOT NULL DEFAULT TRUE,
    FOREIGN KEY (problem_id) REFERENCES problems(problem_id) ON DELETE CASCADE
);

-- 9. Contests Table
CREATE TABLE contests (
    contest_id VARCHAR(50) PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP NOT NULL,
    CONSTRAINT chk_times CHECK (end_time > start_time)
);

-- 10. Contest Problems Link Table (Many-to-Many Contest <-> Problem)
CREATE TABLE contest_problems (
    contest_id VARCHAR(50) NOT NULL,
    problem_id VARCHAR(50) NOT NULL,
    points INT NOT NULL DEFAULT 10,
    PRIMARY KEY (contest_id, problem_id),
    FOREIGN KEY (contest_id) REFERENCES contests(contest_id) ON DELETE CASCADE,
    FOREIGN KEY (problem_id) REFERENCES problems(problem_id) ON DELETE CASCADE
);

-- 11. Submissions Table
CREATE TABLE submissions (
    submission_id VARCHAR(50) PRIMARY KEY,
    student_id VARCHAR(50) NOT NULL,
    problem_id VARCHAR(50) NOT NULL,
    contest_id VARCHAR(50),
    source_code TEXT NOT NULL,
    language VARCHAR(30) NOT NULL,
    submitted_at TIMESTAMP NOT NULL,
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (problem_id) REFERENCES problems(problem_id) ON DELETE CASCADE,
    FOREIGN KEY (contest_id) REFERENCES contests(contest_id) ON DELETE SET NULL
);

-- 12. Test Results Table
CREATE TABLE test_results (
    test_result_id VARCHAR(50) PRIMARY KEY,
    submission_id VARCHAR(50) NOT NULL,
    test_case_id VARCHAR(50) NOT NULL,
    status VARCHAR(50) NOT NULL, -- passed, failed, runtime_error
    execution_time_ms INT DEFAULT 0,
    UNIQUE(submission_id, test_case_id),
    FOREIGN KEY (submission_id) REFERENCES submissions(submission_id) ON DELETE CASCADE,
    FOREIGN KEY (test_case_id) REFERENCES test_cases(test_case_id) ON DELETE CASCADE
);
