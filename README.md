# ts-template

## Getting Started

```bash
git clone <repo-url> my-project
cd my-project
cp .env.example .env
yarn install
yarn dev
```

## Project Structure

```text
ts-template/
├── src/                  # TypeScript source files
│   ├── index.ts          # Entry point
│   └── __tests__/        # Test files
├── data/                 # Data files (JSON, CSV, etc.)
├── scripts/              # Standalone utility scripts
├── dist/                 # Compiled output (gitignored)
├── .env.example          # Environment variable template
├── eslint.config.mjs     # ESLint 9 flat config
├── .prettierrc           # Prettier config
└── tsconfig.json         # TypeScript config
```

### The Two-Gate Workflow

```text
yarn prep   →  build + lint:fix + format   ✓ passes = ready to test
yarn ci     →  prep + test                  ✓ passes = ready to deploy
```

Run `yarn prep` while developing to keep the codebase clean. Run `yarn ci` before pushing to confirm everything — including tests — is green.

## Environment Variables

Copy `.env.example` to `.env` and fill in your values:

```bash
cp .env.example .env
```

Variables are loaded automatically via `dotenv/config` in `src/index.ts`.

## Docker

```bash
docker compose up --build
docker compose up --build -d   # detached
docker compose down
docker compose logs -f         # follow logs

# Prune (reclaim disk space)
docker system prune -f              # stopped containers, unused networks, dangling images
docker system prune -a --volumes -f # full reset: all unused images, containers, volumes
```

The `app` service builds from `Dockerfile` (multi-stage, non-root user, `node:22-alpine`).

### Enable PostgreSQL

In `docker-compose.yml`, uncomment the `db` service block and the `postgres_data` volume.
Then uncomment `depends_on` in the `app` service.
Update `POSTGRES_URL` in your `.env`.

### Enable Ollama (local LLM)

In `docker-compose.yml`, uncomment the `ollama` service block and the `ollama_data` volume.
Set `OLLAMA_MODEL` in your `.env` (default: `llama3.2:3b`).
The model is pulled automatically on first startup via `ollama-entrypoint.sh`.

### Enable NVIDIA GPU for Ollama

Uncomment the `deploy.resources` block inside the `ollama` service.

---

## Requirements

- Node >= 22.0.0
- Yarn >= 1.22.0
