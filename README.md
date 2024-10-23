# flutter-odoo-timesheets

Odoo timesheets Flutter project

### Initialize git

    `git init`

### Enable pre-commit manually

After git initialization use `chmod +x tools/install-hook.bash && ./tools/install-hook.bash && chmod ug+x .git/hooks/pre-commit`

### DB Diagram

```mermaid
erDiagram
    ProjectProjects ||--o{ ProjectTasks : has
    ProjectProjects ||--o{ AnalyticLines : has
    ProjectTasks ||--o{ AnalyticLines : has
    SyncBackends ||--o{ ProjectProjects : owns
    SyncBackends ||--o{ ProjectTasks : owns
    SyncBackends ||--o{ AnalyticLines : owns
    SyncBackends ||--o{ SyncRegistries : tracks

    ProjectProjects {
        int id PK
        string backendId PK,FK
        bool active
        bool isFavorite
        int color
        string name
        int taskCount
        datetime createDate
        datetime writeDate
        bool isMarkedAsDeleted
    }

    ProjectTasks {
        int id PK
        string backendId PK,FK
        bool active
        int color
        datetime dateDeadline
        datetime dateEnd
        string description
        string name
        string priority
        int projectId FK
        datetime createDate
        datetime writeDate
        bool isMarkedAsDeleted
    }

    AnalyticLines {
        int id PK
        string backendId PK,FK
        datetime date
        string name
        int projectId FK
        int taskId FK
        float unitAmount
        int currentStatus
        datetime lastTicked
        bool isFavorite
        datetime startTime
        datetime endTime
        string showTimeControl
        datetime createDate
        datetime writeDate
        bool isMarkedAsDeleted
    }

    SyncBackends {
        string id PK
        string type
        string baseUrl
        datetime createdAt
    }

    SyncRegistries {
        int id PK
        string modelName
        int modelRecordId
        string backendId FK
        datetime recordWriteDate
        datetime recordDeletedAt
        bool pendingSync
        datetime createdAt
        datetime updatedAt
    }
```
