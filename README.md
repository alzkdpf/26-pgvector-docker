# 26-pgvector-docker

Docker 기반 실행 환경 또는 서비스 구성을 관리하는 저장소입니다.

## Overview

- Repository: [alzkdpf/26-pgvector-docker](https://github.com/alzkdpf/26-pgvector-docker)
- Visibility: Public
- Last updated: 2026-02-06
- Main stack: Shell, Docker

## Project Structure

```text
.env.example
.gitignore
Dockerfile
README.md
backups/.gitkeep
docker-compose.yml
init-scripts/01-init-pgvector.sql
scripts/backup.sh
scripts/restore.sh
```

## Getting Started

Clone the repository and inspect the tracked files for the current workflow.

Run the common development command:

```bash
docker compose up -d
```

## Notes

- This README was generated from the repository metadata and file structure.
- Update this document when setup steps, deployment targets, or project ownership changes.
