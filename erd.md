# Entity Relationship Diagram (ERD)

Below is the structural relationship layout mapping the platform database dependencies.

```mermaid
erDiagram
    students ||--o{ enrollments : registers
    students ||--o{ submissions : executes
    students ||--o{ attendance : logs
    courses ||--o{ batches : provides
    batches ||--o{ enrollments : contains
    batches ||--o{ sessions : schedules
    sessions ||--o{ attendance : records
    problems ||--o{ test_cases : verifies
    problems ||--o{ contest_problems : includes
    problems ||--o{ submissions : evaluates
    contests ||--o{ contest_problems : manages
    contests ||--o{ submissions : tracks
    submissions ||--o{ test_results : produces
    test_cases ||--o{ test_results : scores
