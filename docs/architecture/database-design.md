# VoteSphere – Database Design

## 1. Overview

VoteSphere uses PostgreSQL as its primary relational database.

The database is designed to manage users, elections, candidates, voter eligibility and submitted votes while maintaining data consistency and voting integrity.

## 2. Database Entities

The initial database design consists of five core entities.

### 2.1 Users

Stores registered platform users.

| Column | Type | Description |
|---|---|---|
| id | UUID | Primary key |
| full_name | VARCHAR | User's full name |
| email | VARCHAR | Unique email address |
| password_hash | VARCHAR | Hashed password |
| role | VARCHAR | Voter or administrator |
| created_at | TIMESTAMP | Account creation time |
| updated_at | TIMESTAMP | Last account update |

### 2.2 Elections

Stores election information.

| Column | Type | Description |
|---|---|---|
| id | UUID | Primary key |
| title | VARCHAR | Election title |
| description | TEXT | Election details |
| start_time | TIMESTAMP | Election opening time |
| end_time | TIMESTAMP | Election closing time |
| status | VARCHAR | Draft, scheduled, active or completed |
| created_by | UUID | References users.id |
| created_at | TIMESTAMP | Creation time |

### 2.3 Candidates

Stores candidates participating in elections.

| Column | Type | Description |
|---|---|---|
| id | UUID | Primary key |
| election_id | UUID | References elections.id |
| full_name | VARCHAR | Candidate name |
| description | TEXT | Candidate information |
| created_at | TIMESTAMP | Record creation time |

### 2.4 Election Voters

Defines which users are eligible to participate in an election and tracks their participation.

| Column | Type | Description |
|---|---|---|
| id | UUID | Primary key |
| election_id | UUID | References elections.id |
| user_id | UUID | References users.id |
| has_voted | BOOLEAN | Participation status |
| voted_at | TIMESTAMP | Participation time |

A unique constraint on `(election_id, user_id)` prevents duplicate eligibility records.

### 2.5 Votes

Stores submitted voting records.

| Column | Type | Description |
|---|---|---|
| id | UUID | Primary key |
| election_id | UUID | References elections.id |
| voter_id | UUID | References users.id |
| candidate_id | UUID | References candidates.id |
| created_at | TIMESTAMP | Vote submission time |

A unique constraint on `(election_id, voter_id)` prevents a user from submitting more than one vote in the same election.

## 3. Entity Relationships

- One user can participate in multiple elections.
- One election can have multiple eligible voters.
- One election can have multiple candidates.
- One eligible voter can submit at most one vote per election.
- Each vote belongs to one election and one candidate.

## 4. Data Integrity Rules

The database must enforce the following rules:

1. Email addresses must be unique.
2. An election must have a valid creator.
3. Candidates must belong to an existing election.
4. Only eligible users can vote.
5. A user cannot vote more than once in the same election.
6. A candidate must belong to the election in which the vote is cast.
7. Vote submissions must be committed transactionally.
8. Votes must not be accepted outside the election's permitted voting period.

Application checks alone are insufficient. Critical integrity rules must also be enforced at the database level.

## 5. Transaction Management

Vote processing will use PostgreSQL transactions.

The worker must:
- Verify that the election is active.
- Verify voter eligibility.
- Confirm the candidate belongs to the election.
- Check that the voter has not already voted.
- Insert the vote.
- Update the participation record.
- Commit the transaction.

If any operation fails, the transaction must roll back.

A unique database constraint provides an additional safeguard against concurrent duplicate submissions.

## 6. Vote Processing and Idempotency

Redis will temporarily queue accepted voting jobs.

Each voting request should have a unique idempotency identifier.

The worker must safely handle:
- Duplicate queue messages.
- Worker restarts.
- Failed processing attempts.
- Retried transactions.

A repeated job must never create an additional vote.

## 7. Security Considerations

The initial database design associates each vote with a voter to enforce one-person-one-vote rules.

This means the initial implementation is **not an anonymous voting system**. Access to individual voting records must be restricted.

If anonymous ballots become a requirement, the database architecture will need a separate privacy-preserving design that separates voter participation verification from ballot choices.

## 8. Future Improvements

Potential enhancements include:

- Database indexing and query optimisation.
- Database migration management.
- Automated backups and recovery testing.
- Read replicas for reporting workloads.
- Stronger audit trails.
- Privacy-preserving ballot architecture.

---

**Project:** VoteSphere
**Organisation:** Veltara Technologies
**Document:** Database Design
**Status:** Initial Database Specification