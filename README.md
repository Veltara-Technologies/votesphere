# VoteSphere

**Every Vote. Every Voice. Counted.**

VoteSphere is a cloud-native voting platform designed to provide secure, reliable and transparent digital election management. It enables users to participate in elections, cast votes and access election results through a structured, scalable application.

## Project Objectives

- Provide secure user registration and authentication.
- Enable administrators to create and manage elections.
- Allow eligible users to cast votes.
- Prevent duplicate voting.
- Process votes reliably using asynchronous background processing.
- Provide accurate election results and analytics.
- Deploy and operate the application using modern DevOps practices.

## Technology Stack

| Component | Technology |
|---|---|
| Frontend | HTML, CSS, JavaScript |
| Backend API | Python, Flask |
| Background Worker | Node.js |
| Database | PostgreSQL |
| Message Queue | Redis |
| Reverse Proxy | Nginx |
| Containerisation | Docker |
| Container Orchestration (Local) | Docker Compose |
| CI/CD | GitHub Actions |
| Cloud Infrastructure | AWS |
| Monitoring | AWS CloudWatch |

## Architecture Overview

VoteSphere uses a multi-service architecture.

- **Frontend:** Provides the user interface.
- **Nginx:** Routes incoming application traffic.
- **Flask API:** Handles authentication, election management and vote submissions.
- **Redis:** Supports asynchronous vote processing.
- **Node.js Worker:** Processes queued voting requests.
- **PostgreSQL:** Stores application data and maintains vote integrity.

PostgreSQL serves as the authoritative data store. Database constraints and transactions will enforce voting rules and prevent duplicate votes.

## Repository Structure

```text
votesphere/
├── frontend/
├── api/
├── worker/
├── database/
├── nginx/
├── docs/
├── .github/
│   └── workflows/
├── docker-compose.yml
├── .env.example
├── .gitignore
└── README.md
```

## Development Workflow

The project follows a collaborative Git workflow:

- `main` – Stable, production-ready code.
- `Develop` – Main integration branch.
- Feature branches – Individual development tasks.

All changes should be submitted through Pull Requests and reviewed before merging.

## Getting Started

Local development will use Docker Desktop and Docker Compose.

Setup instructions will be maintained in `docs/development/local-setup.md` as the environment is implemented.

## Documentation

Technical documentation is maintained in the `docs/` directory, covering architecture, development, deployment, security and operations.

## Project Organisation

**Veltara Technologies**

Repository: https://github.com/Veltara-Technologies/votesphere

---

*Building reliable systems. Delivering secure digital voting experiences.*
