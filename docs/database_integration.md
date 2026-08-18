# Real database integration

## Architecture

Do not connect the Flutter application directly to the SQL server. A direct
connection would expose database credentials in every installed copy of the app
and would let clients bypass L1-L5 authorization rules.

Use this flow instead:

```text
Flutter app -> HTTPS API -> application service -> SQL database
```

The API owns authentication, role authorization, validation, transactions,
audit logs, and the conversion between the existing database schema and the
Flutter models.

## Information needed from the backup

Before importing anything, identify and provide:

1. Database engine and version: SQL Server, MySQL/MariaDB, PostgreSQL, or SQLite.
2. Backup type: `.bak`, `.sql`, `.dump`, `.backup`, `.db`, or another format.
3. A copy of the backup with confidential production credentials removed.
4. The tables or views currently used for students, accounts, subjects, cycles,
   groups, teacher assignments, grades, and account status.
5. Primary keys, foreign keys, and the meaning of existing account-level fields.

Do not place the backup or database passwords in the Git repository.

## Restore and inspect

Restore the backup into a local development database, never over production.
Create a read-only database account for the first inspection. Export:

- table and view names;
- column names and SQL data types;
- primary and foreign keys;
- row counts;
- a few anonymized rows from each relevant table.

From that inventory, create an explicit mapping document. The first targets are:

| App view | Required data |
| --- | --- |
| Enroll table | registration, CURP, surnames, name, semester, group, active state, cycle |
| Subject table | IDmateria, clave, name, evaluation type, extracurricular state |
| Account table | account id, level, username/CURP, name, active state |
| Grades | cycle, subject assignment, student registration, evaluation, grade |
| Schedule | cycle half, semester/group, teacher, weekday, time range |

## API contract

A practical first API should expose:

```text
POST /api/auth/login
GET  /api/cycles/active
GET  /api/enrollments
GET  /api/enrollments/{registration}
POST /api/enrollments
PUT  /api/enrollments/{registration}
GET  /api/accounts
PUT  /api/accounts/{id}
GET  /api/subjects
POST /api/subjects
PUT  /api/subjects/{idMateria}
GET  /api/subject-assignments
GET  /api/grades
PUT  /api/grades
```

Filtering belongs in query parameters, for example:

```text
GET /api/enrollments?cycle=26-27&active=true&semester=3&group=B&search=perez
GET /api/accounts?levels=L1,L3,L4&active=true&search=curp
```

Every endpoint must enforce the current account level on the server. Hiding a
button in Flutter is useful for the interface, but it is not authorization.

## Flutter migration

1. Keep `MockRepository` as the development fixture while the API is built.
2. Define repository interfaces for accounts, enrollments, subjects, cycles,
   schedules, registries, and grades.
3. Add HTTP implementations that deserialize API DTOs into the current models.
4. Select the API implementation using an environment URL:
   `--dart-define=API_BASE_URL=https://api.example.edu`.
5. Add pagination to the enroll, subject, and account tables.
6. Keep the existing offline queue for enrollment, grades, and registry writes.
7. Run a read-only comparison between SQL-backed screens and the original
   system before enabling create/update operations.
8. Enable writes module by module, with audit logs and database backups.

## Import safety

- Preserve original identifiers where possible.
- Hash passwords with Argon2id or bcrypt in the API; never return hashes.
- Encrypt transport with HTTPS.
- Use parameterized SQL or an ORM.
- Add uniqueness constraints for CURP, registration, username, subject clave,
  and IDmateria where the business rules require them.
- Test restore and rollback before the first production migration.
- Keep an immutable import log linking each source row to its new record.

## Next implementation checkpoint

Attach the backup and state the database engine/version. The first coding pass
will be read-only: schema inventory, model mapping, and the three list endpoints
for enrollments, subjects, and accounts. Writes should be enabled only after
the displayed counts and sample records match the restored database.
