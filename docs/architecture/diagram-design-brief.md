# VoteSphere – Architecture Diagram Design Brief

**Organisation:** Veltara Technologies
**Project:** VoteSphere
**Tagline:** Every Vote. Every Voice. Counted.
**Document Purpose:** Guide for designing the VoteSphere system architecture diagram using draw.io (diagrams.net).

## 1. Overview

VoteSphere is a cloud-native voting platform designed to provide secure voter registration, election management, vote submission, background vote processing, and election result reporting.

The architecture diagram should illustrate how the frontend, backend API, message queue, background worker, database, and infrastructure communicate with one another.

The diagram should be professional, technically accurate, easy to understand, and suitable for technical presentations and project documentation.

## 2. Technology Stack

| Component | Technology | Responsibility |
|---|---|---|
| Frontend | HTML, CSS, JavaScript | User interface and voter interaction |
| Reverse Proxy | Nginx | Serves frontend and routes API requests |
| Backend API | Python Flask | Authentication, election management and vote submission |
| Message Broker / Cache | Redis | Queues vote-processing jobs and supports caching |
| Background Worker | Node.js | Processes queued voting requests |
| Database | PostgreSQL | Stores users, elections, candidates, voter eligibility and votes |
| Containerisation | Docker | Packages application services |
| Orchestration | Docker Compose | Runs local multi-container environment |
| CI/CD | GitHub Actions | Automates testing and application delivery |
| Cloud Infrastructure | AWS | Hosts the future production deployment |

## 3. Architecture Layers

The diagram should be arranged into the following logical layers.

### Layer 1: User and Presentation Layer

Include:
- Voter
- Administrator
- Web Browser
- Frontend application (HTML, CSS and JavaScript)

Voters interact with the platform to register, log in, view available elections and submit votes.

Administrators manage elections, candidates and eligible voters.

### Layer 2: Web and Routing Layer

**Nginx Reverse Proxy**

Nginx sits between the browser and the backend services.

Its responsibilities include:
- Serving the frontend application.
- Receiving incoming HTTP requests.
- Forwarding `/api/` requests to the Flask backend.
- Acting as the application's entry point.

### Layer 3: Application Layer

**Flask Backend API**

Responsible for:
- User registration and authentication.
- Role-based access control.
- Election management.
- Candidate management.
- Voter eligibility verification.
- Vote submission.
- Publishing vote-processing jobs to Redis.
- Retrieving election information and results.

**Node.js Background Worker**

Responsible for:
- Consuming queued voting jobs from Redis.
- Processing vote requests.
- Validating the election and voter eligibility.
- Recording valid votes in PostgreSQL.
- Updating voter voting status.
- Handling failed processing attempts.

### Layer 4: Messaging and Caching Layer

**Redis**

Redis provides communication between the Flask API and Node.js worker.

Show two directional connections:

1. Flask API → Redis: Publishes vote-processing jobs.
2. Redis → Node.js Worker: Delivers queued jobs for processing.

Redis may also support caching operations where appropriate.

### Layer 5: Data Layer

**PostgreSQL Database**

PostgreSQL is the primary persistent data store.

Represent the following database entities:

- Users
- Elections
- Candidates
- Election Voters
- Votes

The database is responsible for maintaining relationships, enforcing constraints and preserving voting records.

Important integrity controls include:
- One eligibility record per voter per election.
- Unique vote constraint per voter and election.
- Candidate-election relationship validation.
- Transactional vote processing.

**Important:** The initial design associates vote records with voter identities. Do not describe this initial implementation as anonymous voting.

## 4. Main Data Flow

The diagram should illustrate the following sequence.

**A. User access**

1. Voter or administrator opens the application in a web browser.
2. Browser sends requests to Nginx.
3. Nginx serves the frontend application.

**B. Authentication and election management**

1. Frontend sends API requests through Nginx.
2. Nginx forwards API requests to Flask.
3. Flask validates requests and communicates with PostgreSQL when necessary.
4. PostgreSQL returns the requested information.

**C. Vote submission and processing**

1. An authenticated voter selects a candidate and submits a vote.
2. Flask validates the request and checks voter eligibility.
3. Flask publishes a vote-processing job to Redis.
4. Node.js worker retrieves the job from Redis.
5. Worker validates the request and processes it within a database transaction.
6. PostgreSQL enforces the relevant integrity constraints and stores the vote.
7. Worker updates the voter's voting status in the same transaction.
8. Processing status can be communicated back through the application API.

**D. Results and reporting**

1. Frontend requests election results.
2. Flask retrieves aggregated voting information from PostgreSQL.
3. Results are returned to the frontend for display.

## 5. Suggested Diagram Layout

Use a horizontal, left-to-right architecture layout.

Recommended arrangement:

**Far left – Users**
- Voter
- Administrator
- Web Browser

**Centre-left – Presentation and Routing**
- Frontend Application
- Nginx Reverse Proxy

**Centre – Application Services**
- Flask Backend API
- Node.js Background Worker

**Centre-right – Messaging**
- Redis Queue / Cache

**Far right – Persistent Data**
- PostgreSQL Database
- Users
- Elections
- Candidates
- Election Voters
- Votes

Place Docker and Docker Compose around the local application services as the containerisation and orchestration environment, rather than treating them as application services.

## 6. Connection and Arrow Guidelines

Use labelled directional arrows.

| Source | Destination | Arrow label |
|---|---|---|
| Browser | Nginx | HTTP Requests |
| Nginx | Frontend | Serve Static Files |
| Nginx | Flask API | API Requests |
| Flask API | PostgreSQL | SQL Queries |
| Flask API | Redis | Publish Vote Job |
| Redis | Node.js Worker | Consume Vote Job |
| Node.js Worker | PostgreSQL | Transactional Vote Processing |
| Flask API | Frontend | API Responses |
| PostgreSQL | Flask API | Election Data / Results |

Use solid arrows for direct service communication and a distinct dashed style for asynchronous queue communication if helpful.

## 7. Future Cloud Deployment

Show AWS as a separate future deployment environment or as a clearly labelled future-state section.

Potential AWS services include:

- Amazon EC2 – Application hosting.
- AWS IAM – Identity and access management.
- Amazon CloudWatch – Logs, metrics and monitoring.
- Terraform – Infrastructure provisioning and automation.

Do not represent future services as already deployed.

The diagram should distinguish the initial local Docker Compose architecture from the planned AWS production architecture.

## 8. Visual Design Guidelines

The diagram should:
- Use a clean, professional cloud architecture style.
- Group related components into clearly labelled sections.
- Use official technology icons where available.
- Keep arrow directions consistent.
- Avoid crossing connection lines unnecessarily.
- Use readable text and consistent spacing.
- Include a legend explaining arrows, boundaries and future components.

Suggested colours:
- Blue: Presentation and frontend.
- Purple: Backend application services.
- Orange: Messaging and background processing.
- Green: Database and persistent storage.
- Grey: Infrastructure and deployment environment.

## 9. Required Deliverables

The architecture team member should provide:

1. Editable draw.io source file (`.drawio`).
2. High-resolution PNG export.
3. SVG export for documentation and presentations.
4. A short explanation of the architecture and major data flows.

**Suggested file locations:**

- `docs/architecture/system-architecture.drawio`
- `docs/architecture/system-architecture.png`
- `docs/architecture/system-architecture.svg`

## 10. Final Acceptance Criteria

Before submitting the diagram, verify that:

- Every major service is represented.
- All communication paths are correctly labelled.
- Redis clearly sits between Flask and the Node.js worker for asynchronous processing.
- PostgreSQL is shown as the authoritative persistent database.
- Nginx is shown as the entry point for frontend and API traffic.
- Docker and Docker Compose are represented as deployment tools, not application components.
- AWS services are clearly identified as planned future infrastructure.
- The diagram accurately represents the initial non-anonymous voting data model.

**Expected Outcome:** A professional, editable VoteSphere architecture diagram that communicates the system structure, service responsibilities, data flow, infrastructure and planned cloud deployment.