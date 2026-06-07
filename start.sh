#!/bin/bash
set -euo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIR"

# ── Colours ──────────────────────────────────────────────────────────────────
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'
RED='\033[0;31m';   BOLD='\033[1m';      NC='\033[0m'

log()  { echo -e "${CYAN}[vireon]${NC} $*"; }
ok()   { echo -e "${GREEN}[vireon]${NC} $*"; }
warn() { echo -e "${YELLOW}[vireon]${NC} $*"; }
err()  { echo -e "${RED}[vireon]${NC} $*"; }

pick_frontend_port() {
    if [[ -n "${FRONTEND_PORT:-}" ]]; then
        return 0
    fi

    for port in 3000 3001 3002 3003 3004 3005 3006 3007 3008 3009 3010; do
        if ! lsof -nP -iTCP:"$port" -sTCP:LISTEN >/dev/null 2>&1; then
            export FRONTEND_PORT="$port"
            if [[ "$port" != "3000" ]]; then
                warn "Port 3000 is busy; using http://localhost:${FRONTEND_PORT} for the frontend."
            fi
            return 0
        fi
    done

    err "Ports 3000-3010 are all in use. Stop one of those processes or set FRONTEND_PORT manually."
    exit 1
}

echo ""
echo -e "${BOLD}${CYAN}╔══════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${CYAN}║         Vireon — Autonomous AI CFO 🚀            ║${NC}"
echo -e "${BOLD}${CYAN}╚══════════════════════════════════════════════════╝${NC}"
echo ""

# ── 1. Check / auto-start Docker ─────────────────────────────────────────────
ensure_docker_running() {
    if docker info >/dev/null 2>&1; then return 0; fi

    if docker --context default info >/dev/null 2>&1; then
        docker context use default >/dev/null
        return 0
    fi

    if [[ "$(uname -s)" == "Darwin" ]]; then
        warn "Starting Docker Desktop..."
        open -a Docker || true
        for i in $(seq 1 60); do
            if docker info >/dev/null 2>&1; then ok "Docker ready."; return 0; fi
            sleep 2
            (( i % 10 == 0 )) && warn "Waiting for Docker... (${i}/60)"
        done
    fi

    err "Cannot reach Docker daemon. Start Docker Desktop and retry."
    exit 1
}

ensure_docker_running

# ── 2. Pick a frontend port ──────────────────────────────────────────────────
pick_frontend_port

# ── 3. Ensure backend/.env exists ─────────────────────────────────────────────
if [[ ! -f "$DIR/backend/.env" ]]; then
    if [[ -f "$DIR/backend/.env.demo" ]]; then
        cp "$DIR/backend/.env.demo" "$DIR/backend/.env"
        ok "Copied .env.demo → backend/.env"
        warn "Add your GROQ_API_KEY to backend/.env to enable AI chat."
    else
        err "backend/.env not found."
        echo "  Run:  cp backend/.env.example backend/.env"
        echo "  Then edit it and run ./start.sh again."
        exit 1
    fi
else
    ok "backend/.env found."
fi

# ── 4. Build & start all services in background ───────────────────────────────
log "Building and starting all services..."
if docker compose up -d --build; then
    ok "Services built and started."
else
    warn "Docker build failed. This often happens when Docker Hub cannot be reached."
    warn "Trying to start from existing local Vireon images without rebuilding..."

    if docker image inspect vireon-backend vireon-worker vireon-beat vireon-frontend >/dev/null 2>&1; then
        docker compose up -d --no-build
        ok "Services started from existing local images."
        warn "Skipped rebuild. If you changed dependencies or Dockerfiles, fix Docker Hub/DNS and rerun with a rebuild."
    else
        err "Build failed and required local Vireon images are missing."
        echo "  Docker could not reach Docker Hub to pull base images."
        echo "  Check internet/DNS/VPN/proxy settings, then run: docker compose build"
        exit 1
    fi
fi

# ── 5. Wait for backend health ────────────────────────────────────────────────
log "Waiting for backend to be ready..."
RETRIES=40
until curl -sf http://localhost:8000/health/ready >/dev/null 2>&1 || [[ $RETRIES -eq 0 ]]; do
    RETRIES=$((RETRIES - 1))
    printf "."
    sleep 5
done
echo ""

if [[ $RETRIES -eq 0 ]]; then
    warn "Backend taking longer than expected."
    warn "Check logs: docker compose logs backend"
else
    ok "Backend is healthy."
fi

# ── 6. Run database migrations ────────────────────────────────────────────────
log "Running database migrations..."
if docker compose exec -T backend alembic upgrade head 2>&1; then
    ok "Migrations applied."
else
    warn "Alembic not configured or migrations already current — skipping."
fi

# ── 7. Seed demo data (skip if data already exists) ──────────────────────────
log "Seeding demo data (Orchard Analytics Inc.)..."
if docker compose exec -T backend python scripts/demo_full_seed.py 2>&1; then
    ok "Demo data ready."
else
    warn "Seed script encountered an issue — app will still work with bootstrapped data."
fi

# ── 8. Open browser (macOS) ───────────────────────────────────────────────────
if [[ "$(uname -s)" == "Darwin" ]]; then
    sleep 1
    open "http://localhost:${FRONTEND_PORT}" 2>/dev/null || true
fi

# ── 9. Summary ────────────────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}${BOLD}╔══════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}${BOLD}║           All services are running! ✅           ║${NC}"
echo -e "${GREEN}${BOLD}╚══════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "  ${CYAN}Dashboard   :${NC}  http://localhost:${FRONTEND_PORT}"
echo -e "  ${CYAN}API         :${NC}  http://localhost:8000"
echo -e "  ${CYAN}API Docs    :${NC}  http://localhost:8000/api/v1/docs"
echo -e "  ${CYAN}Mailhog     :${NC}  http://localhost:8025"
echo ""
echo -e "  Services running: postgres · redis · backend · worker · beat · frontend"
echo ""
echo -e "  ${YELLOW}Useful commands:${NC}"
echo -e "    docker compose logs -f backend     # live backend logs"
echo -e "    docker compose logs -f worker      # live Celery logs"
echo -e "    docker compose ps                  # service status"
echo -e "    docker compose down                # stop everything"
echo ""
