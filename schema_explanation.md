The CodeJudge platform dataset captures the complete relational footprint of an operational programming practice environment. Instead of keeping a flat file tracking everything, the dataset splits individual components into unique files that logically represent the operational structure of the platform:

1. students.csv: Represents the platform's core users. Contains attributes unique to the individual's identity (e.g., student name, join dates, contact parameters).

2. courses.csv & batches.csv: Tracks educational entities. Courses capture overarching syllabus types, whereas batches represent an active timeline instance of a course led by specific instructors.

3. enrollments.csv & attendance.csv: Captures operational links showing which student is in which batch and tracks daily physical or virtual session attendance metrics.

4. problems.csv & test_cases.csv: Captures the coding evaluation assets. Problems contain definitions and restrictions, while test cases establish hidden inputs and expected outputs to score student code execution.

5. contests.csv & contest_problems.csv: Captures testing environments. A contest bundles several problems together into a timed window for evaluations.

6. submissions.csv & test_results.csv: Tracks code metrics. Captures specific code scripts pushed by students, along with precise pass/fail executions matching back to individual test_case IDs.

7. sessions.csv: Records live code-along classes or instruction blocks tied back to specific active batches.

8. regrade_requests & plagiarism_flags & operation_requests: Handles transactional administrative logic tracking manual score shifts, system-flagged anomalies, and automated queue events.




Every entity below must exist as a separate database table to protect data persistence, avoid redundant text duplication, and allow independent transactional updates.

1. students: Deserves a unique table because student details (name, email) stay constant regardless of how many courses they take or fail. Mashing this with enrollments causes massive data redundancy.

2. courses: Needs an isolated table so course syllabus descriptions or titles don't repeat endlessly for every physical classroom batch spun up.

3. batches: Deserves its own space to track specific active cohorts with distinct schedules and specific instructors running a specific course_id.

4. enrollments: Operates as a distinct relationship mapping table. It uniquely connects a single student to a single batch, maintaining transaction history (enrollment status, date).

5. problems: Must be a standalone catalog table containing static configurations (statement details, execution time limits, max scores) isolated from temporary user contests or submissions.

6. test_cases: Must be a distinct entity separate from problems because one singular problem owns an unpredictable number of input/output test parameters. This forms a standard One-to-Many relationship.

7. contests: Needs an independent window table to define overarching context criteria (start timestamps, end timestamps, structural visibility, grading metrics).

8. contest_problems: Operates explicitly as a many-to-many lookup table linking multiple problems into a single contest container, while allowing the same problem to be recycled across different contests over time.

9. submissions: Must exist independently to record chronological student attempts at a specific point in time, logging their written source code without bloating core system user profiles.

10. test_results: A distinct operational table linking single compilation outcomes back to the micro test cases executed during platform code compilation.

11. sessions: Represents independent lecture slots tied to a parent batch timeline.

12. attendance: Tracks the dynamic state of real-time presence indicators mapping one student to one distinct session block.

13. regrade_requests: Keeps manual grading workflows separated from automated transaction tables.

14. plagiarism_flags: Tracks independent automated integrity reports isolated from general coding metrics.

15. operation_requests: Tracks raw administrative system tasks independently.
