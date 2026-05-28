3 Examples of Redundancy in Raw Imports

1. Student Personal Profiles: In un-normalized structures like raw_student_import.csv, every single row registering an event or score repeats the student's legal name, phone number, and location details alongside their identifier.

2. Course Syllabus Text: If batch assignments and course tracks are mixed together, a multi-paragraph text block containing course goals or titles will repeat across hundreds of rows for every distinct batch launched.

3. Problem Information inside Contests: A problem statement, execution time limits, and baseline score configurations are written out fully every single time that task is assigned to a new contest container.


2 Examples of Splitting Data to Improve Integrity
1. Isolating test_cases from problems: Pulling inputs/outputs into a separate table ensures that modifying a test edge case doesn't mean changing the problem's descriptive definition or duplicating details across thousands of files.

2. Extracting enrollments from students: Separating these fields prevents a student from needing multiple rows in the main student profile table just because they signed up for three different programming tracks.


Normalization Level Justification
The updated database design successfully reaches Third Normal Form (3NF):

1NF achieved: All columns hold completely atomic values (e.g., individual marked_at timestamps instead of comma-separated string arrays) and duplicate rows are explicitly disallowed by primary keys.

2NF achieved: It reaches 1NF, and all non-key attributes are fully dependent on the complete primary identifier. In our multi-key tables like contest_problems, attributes describe the relationship as a whole and do not exhibit partial dependencies.

3NF achieved: It reaches 2NF, and transitive dependencies are eliminated. Non-key features describe the primary identifier exclusively (e.g., an instructor name or course details change only within their own master catalogs, preventing cascading modification failures elsewhere in the schema).
