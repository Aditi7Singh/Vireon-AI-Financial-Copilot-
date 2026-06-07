# 🧠 Vireon — AI Financial Copilot

> **CFO-grade financial intelligence for every business.**  
> Real-time anomaly detection · KPI dashboards · Natural language insights · Multi-channel alerts


<img width="1508" height="818" alt="Screenshot 2026-05-05 at 5 21 15 PM" src="https://github.com/user-attachments/assets/d762072b-c8da-443f-a9ec-2c8bc475c90d" />
<img width="1499" height="810" alt="Screenshot 2026-05-05 at 5 21 29 PM" src="https://github.com/user-attachments/assets/cb5e1a3d-78c0-42a3-a52e-b619ba303ea3" />


[![Python](https://img.shields.io/badge/Python-3.11+-3776AB?style=flat-square&logo=python&logoColor=white)](https://python.org)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.100+-009688?style=flat-square&logo=fastapi&logoColor=white)](https://fastapi.tiangolo.com)
[![React](https://img.shields.io/badge/React-18+-61DAFB?style=flat-square&logo=react&logoColor=black)](https://reactjs.org)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15+-336791?style=flat-square&logo=postgresql&logoColor=white)](https://postgresql.org)
[![Redis](https://img.shields.io/badge/Redis-7+-DC382D?style=flat-square&logo=redis&logoColor=white)](https://redis.io)
[![Celery](https://img.shields.io/badge/Celery-5+-37814A?style=flat-square&logo=celery&logoColor=white)](https://docs.celeryq.dev)
[![License](https://img.shields.io/badge/License-MIT-yellow?style=flat-square)](LICENSE)

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Getting Started](#-getting-started)
  - [Prerequisites](#prerequisites)
  - [Local Development (Demo Mode)](#local-development-demo-mode)
  - [Docker Compose](#docker-compose)
  - [Production Setup](#production-setup)
- [Environment Variables](#-environment-variables)
- [Dashboard Pages & API Reference](#-dashboard-pages--api-reference)
- [Anomaly Detection](#-anomaly-detection)
- [Data Connectors](#-data-connectors)
- [AI Chat Integration](#-ai-chat-integration)
- [Notifications](#-notifications)
- [Background Workers](#-background-workers)
- [Health Checks](#-health-checks)
- [Future Improvements](#-future-improvements)
- [Contributing](#-contributing)
- [License](#-license)

---

## 🌟 Overview

**Vireon** is an open-source AI Financial Copilot that transforms how small and medium-sized businesses monitor, analyze, and act on their financial data.

It ingests transactional and General Ledger (GL) data from multiple sources, computes critical financial metrics in real time, automatically detects anomalies using statistical algorithms, and provides a conversational AI interface — all in one unified platform.

```
Data Sources (Merge / Plaid / Demo)
        ↓
  Ingestion Pipeline
        ↓
  PostgreSQL + Redis
        ↓
┌───────────────────────────────┐
│   Analytics & KPI Engine      │  ← MRR, ARR, Burn, Runway
│   Anomaly Detection Engine    │  ← Expense spikes, Revenue drops, Duplicates
│   Celery Background Workers   │  ← Scheduled detection & notifications
└───────────────────────────────┘
        ↓
  FastAPI REST API
        ↓
  React Dashboard + AI Chat
```

---

## ✨ Features

### 📊 Financial Dashboards
| Page | Description |
|------|-------------|
| **Scorecard** | Executive snapshot — MRR, ARR, net burn, cash balance, runway |
| **Metrics / History** | Time-series charts for revenue, expenses, and margins |
| **Revenue** | Revenue trends, top customers, AR summary, anomalies |
| **Expenses** | Category breakdown, vendor lists, rolling averages |
| **Alerts / Anomalies** | Central anomaly feed with severity, status, and actions |
| **Duplicate Detection** | Grouped duplicate GL entries and invoice sets |
| **Notifications** | Contact management and multi-channel alert delivery |
| **Integrations** | Connector status, sync control, token management |
| **AI Chat** | Natural language financial Q&A interface |
| **System Health** | DB/Redis readiness, worker status, dependency checks |

### 🔍 Anomaly Detection
- **Expense Spike Detection** — 90-day rolling average baseline with configurable thresholds
- **Revenue Anomaly Detection** — Flags drops and spikes vs historical baseline
- **Duplicate Invoice Detection** — Groups by amount + date + account

### 🤖 AI-Powered Insights
- Natural language queries over your financial data
- Supports **Groq API** (cloud) and **Ollama** (self-hosted/local)
- Context-enriched prompts using live financial data

### 🔔 Multi-Channel Notifications
- Email via SMTP (Gmail, SendGrid, Outlook, etc.)
- Slack webhooks
- Generic HTTP webhooks

---

## 🛠 Tech Stack

| Layer | Technology |
|-------|-----------|
| **Backend** | FastAPI (Python 3.11+) |
| **Database** | PostgreSQL (production) / SQLite (local) |
| **Cache / Queue** | Redis + Celery + Celery Beat |
| **Frontend** | React 18 (SPA) |
| **ORM** | SQLAlchemy |
| **AI / LLM** | Groq API / Ollama |
| **Data Connectors** | Merge API, Plaid, Demo Seed |
| **Notifications** | SMTP, Slack Webhook, HTTP Webhook |
| **Containerization** | Docker + Docker Compose |

---

## 📁 Project Structure

```
vireon/
├── backend/
│   ├── main.py                  # FastAPI app entry point, startup migrations
│   ├── models.py                # SQLAlchemy ORM models
│   ├── anomaly_detection.py     # Expense, revenue & duplicate detectors
│   ├── analytics/
│   │   └── metrics.py           # KPI computation (burn, runway, MRR/ARR)
│   ├── routers/
│   │   ├── scorecard.py         # GET /api/v1/scorecard
│   │   ├── metrics.py           # GET /api/v1/metrics/history
│   │   ├── revenue.py           # GET /api/v1/revenue
│   │   ├── expenses.py          # GET /api/v1/expenses
│   │   ├── alerts.py            # GET/POST /api/v1/alerts
│   │   └── notifications.py     # GET/POST /api/v1/notifications/*
│   ├── workers/
│   │   └── tasks.py             # Celery tasks (detection, notifications)
│   └── requirements.txt
├── frontend/
│   └── app/
│       └── dashboard/           # React dashboard components & routes
├── demo.sh                      # Seed demo data
├── start.sh                     # Start all services
├── docker-compose.yml
├── .env.example                 # ← Copy this to .env
└── README.md
```

---

## 🚀 Getting Started

### Prerequisites

- Python 3.11+
- Node.js 18+
- Docker & Docker Compose (recommended)
- Git

---

### Local Development (Demo Mode)

The fastest way to run Vireon locally — no external API keys required.

```bash
# 1. Clone the repository
git clone https://github.com/your-org/vireon.git
cd vireon

# 2. Copy environment file
cp .env.example .env

# 3. Set demo mode in .env
DEMO_MODE=true

# 4. Install backend dependencies
cd backend
pip install -r requirements.txt

# 5. Seed demo data and start
cd ..
bash demo.sh
# or
bash start.sh
```

The app will be available at `http://localhost:3000` (frontend) and `http://localhost:8000` (API).

---

### Docker Compose

The recommended way to run all services together:

```bash
# 1. Clone and configure
git clone https://github.com/your-org/vireon.git
cd vireon
cp .env.example .env
# Edit .env with your configuration

# 2. Start all services
docker compose up --build

# 3. Seed demo data (optional)
docker compose exec backend bash demo.sh
```

Services started:
- `backend` — FastAPI on port 8000
- `frontend` — React on port 3000
- `postgres` — PostgreSQL on port 5432
- `redis` — Redis on port 6379
- `worker` — Celery worker
- `beat` — Celery Beat scheduler

---

### Production Setup

```bash
# 1. Configure production environment
cp .env.example .env.production
# Fill in all required values (DB, Redis, API keys, SMTP)

# 2. Set environment
export APP_ENV=production

# 3. Start with production compose
docker compose -f docker-compose.prod.yml up -d

# 4. Verify health
curl http://localhost:8000/health/ready
```

---

## ⚙️ Environment Variables

Copy `.env.example` to `.env` and configure:

```properties
# ── Application ───────────────────────────────────────────
COMPANY_NAME=Your Company
DEMO_MODE=true                        # Set false for production
APP_ENV=development

# ── Database ──────────────────────────────────────────────
# Local/Demo: leave blank (uses SQLite)
# Docker:     postgresql://postgres:password@postgres:5432/vireon
# Production: your Postgres connection string
DATABASE_URL=

# ── Redis ─────────────────────────────────────────────────
REDIS_URL=redis://localhost:6379/0

# ── Merge API (accounting connector) ──────────────────────
MERGE_API_KEY=
MERGE_ACCOUNT_TOKEN=

# ── Plaid (banking connector) ─────────────────────────────
PLAID_CLIENT_ID=
PLAID_SECRET=
PLAID_ENV=sandbox                     # sandbox | development | production

# ── Email Alerts ──────────────────────────────────────────
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your@email.com
SMTP_PASS=your_app_password           # Use App Password, not your login password

# ── AI / LLM ──────────────────────────────────────────────
GROQ_API_KEY=                         # Get from console.groq.com
USE_LOCAL_LLM=false
OLLAMA_BASE_URL=http://localhost:11434

# ── CORS ──────────────────────────────────────────────────
ALLOWED_ORIGINS=http://localhost:3000
```

> ⚠️ **Never commit your `.env` file.** It is already in `.gitignore`.

### Getting SMTP Credentials

| Provider | SMTP_HOST | How to get SMTP_PASS |
|----------|-----------|----------------------|
| **Gmail** | `smtp.gmail.com` | Google Account → Security → App Passwords |
| **Outlook** | `smtp.office365.com` | Microsoft Account → Security → App Passwords |
| **SendGrid** | `smtp.sendgrid.net` | sendgrid.com → Settings → API Keys (`SMTP_USER=apikey`) |
| **Mailgun** | `smtp.mailgun.org` | mailgun.com → Sending → Domain Settings |
| **Local Dev** | `localhost` (Mailhog) | `docker run -p 1025:1025 -p 8025:8025 mailhog/mailhog` |

---

## 📡 Dashboard Pages & API Reference

| Dashboard Page | Method | Endpoint | Description |
|----------------|--------|----------|-------------|
| Scorecard | `GET` | `/api/v1/scorecard` | MRR, ARR, burn, runway, cash balance |
| Metrics History | `GET` | `/api/v1/metrics/history` | Time-series financial data |
| Revenue | `GET` | `/api/v1/revenue` | Revenue trends and anomalies |
| Expenses | `GET` | `/api/v1/expenses` | Expense breakdown by category/vendor |
| Alerts (list) | `GET` | `/api/v1/alerts` | All anomalies and their status |
| Alerts (create) | `POST` | `/api/v1/alerts` | Manually create or acknowledge alert |
| Notifications | `GET` | `/api/v1/notifications/contacts` | Contact list and channels |
| System Health | `GET` | `/health/ready` | DB + Redis readiness check |
| Startup Health | `GET` | `/api/v1/system/startup-health` | Full dependency status |

Interactive API docs available at: `http://localhost:8000/docs`

---

## 🔍 Anomaly Detection

Vireon's detection engine lives in `backend/anomaly_detection.py` and runs three algorithms:

### 1. Expense Spike Detection
```
Function : detect_expense_anomalies()
Baseline : 90-day rolling average per account/category
Threshold: Medium  → transaction > 15% above baseline
           High    → transaction > 50% above baseline
Output   : Anomaly record (type: spending_spike)
```

### 2. Revenue Anomaly Detection
```
Function : detect_revenue_anomalies()
Baseline : 90-day rolling average of GL credit entries
Threshold: Medium  → variance > 25% from baseline
           High    → variance > 100% from baseline
Output   : Anomaly record (type: revenue_spike | revenue_drop)
```

### 3. Duplicate Invoice Detection
```
Function : detect_duplicate_invoices()
Method   : Groups GL entries by (amount + date + account_id)
Threshold: Any group with count > 1 is flagged
Output   : Grouped duplicate sets surfaced in Duplicate Detection page
```

Each detected anomaly is stored with: `type`, `severity`, `date`, `description`, `expected_value`, `actual_value`, `status`.

---

## 🔌 Data Connectors

Vireon supports three data source modes, controlled by the `DATA_SOURCE` environment variable:

### Demo Mode (Default)
```bash
DEMO_MODE=true
```
Runs `demo.sh` to seed realistic synthetic companies, GL entries, and expenses. No external accounts required. Perfect for evaluation and development.

### Merge API
Connect to 200+ accounting platforms (QuickBooks, Xero, NetSuite, Sage, FreshBooks):
```properties
MERGE_API_KEY=your_merge_api_key
MERGE_ACCOUNT_TOKEN=your_account_token
DATA_SOURCE=merge
```
Get credentials at [merge.dev](https://merge.dev)

### Plaid
Connect to 12,000+ banking institutions for real-time transaction feeds:
```properties
PLAID_CLIENT_ID=your_client_id
PLAID_SECRET=your_secret
PLAID_ENV=sandbox
DATA_SOURCE=plaid
```
Get credentials at [plaid.com](https://plaid.com)

---

## 🤖 AI Chat Integration

Vireon supports two LLM backends for the AI Chat / Insights feature:

### Option 1: Groq API (Cloud — Recommended)
```properties
GROQ_API_KEY=gsk_xxxxxxxxxxxx
USE_LOCAL_LLM=false
```
Get a free API key at [console.groq.com](https://console.groq.com)

### Option 2: Ollama (Self-Hosted / Local)
```properties
USE_LOCAL_LLM=true
OLLAMA_BASE_URL=http://localhost:11434
```
Install Ollama: [ollama.ai](https://ollama.ai)
```bash
ollama pull llama3
ollama serve
```

---

## 🔔 Notifications

Vireon supports three notification channels:

### Email (SMTP)
Configure SMTP credentials in `.env`. Works with any SMTP provider.  
For local testing, use [Mailhog](https://github.com/mailhog/MailHog):
```bash
docker run -p 1025:1025 -p 8025:8025 mailhog/mailhog
# View emails at http://localhost:8025
```

### Slack
Add a Slack webhook URL to a notification contact's channel configuration in the Notifications dashboard.

### HTTP Webhook
Add any HTTP endpoint as a notification channel. Compatible with PagerDuty, Zapier, n8n, and custom integrations.

---

## ⚙️ Background Workers

Vireon uses **Celery** with a **Redis** broker for async and scheduled tasks:

```bash
# Start worker manually
celery -A backend.workers.tasks worker --loglevel=info

# Start scheduler
celery -A backend.workers.tasks beat --loglevel=info
```

Scheduled tasks include:
- Anomaly detection runs (expense, revenue, duplicate)
- Notification dispatch
- Data connector sync (Merge / Plaid)
- Cache refresh for KPI metrics

In Docker Compose, `worker` and `beat` services start automatically.

---

## 🏥 Health Checks

```bash
# Basic readiness (DB + Redis)
GET /health/ready

# Full startup health
GET /api/v1/system/startup-health
```

Example response:
```json
{
  "status": "ready",
  "database": "ok",
  "redis": "ok",
  "latency_ms": 12,
  "environment": "production"
}
```

Used by Docker, Kubernetes, and ECS health check configurations.

---

## 🔮 Future Improvements

- [ ] **ERPNext Connector** — Native Frappe/ERPNext REST API integration
- [ ] **Predictive Forecasting** — ML-based revenue & expense forecasting (Prophet / ARIMA)
- [ ] **Budget vs Actuals** — Define budgets and track real-time variance
- [ ] **Custom Anomaly Thresholds** — UI-configurable detection sensitivity per account
- [ ] **RBAC** — Role-based access control (CFO, Accountant, Read-only)
- [ ] **Mobile App** — React Native companion for on-the-go monitoring
- [ ] **Audit Trail** — Full log of anomaly actions for compliance reporting
- [ ] **White Label Support** — Multi-tenant branding and isolated deployments
- [ ] **SOC 2 / GAAP Reports** — Automated compliance report generation
- [ ] **Stripe / Shopify Connectors** — Direct revenue data from e-commerce platforms

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

```bash
# 1. Fork the repository
# 2. Create a feature branch
git checkout -b feature/your-feature-name

# 3. Make your changes and commit
git commit -m "feat: add your feature description"

# 4. Push to your fork
git push origin feature/your-feature-name

# 5. Open a Pull Request
```

Please ensure:
- Code follows existing patterns and style
- New features include appropriate tests
- Environment variables are documented in `.env.example`
- No secrets are committed

---

## 📄 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgements

- [FastAPI](https://fastapi.tiangolo.com) — Modern Python web framework
- [Merge API](https://merge.dev) — Unified accounting integrations
- [Plaid](https://plaid.com) — Banking data infrastructure
- [Groq](https://groq.com) — Ultra-fast LLM inference
- [Ollama](https://ollama.ai) — Local LLM runtime

---

<div align="center">
  <strong>Built with ❤️ for finance teams everywhere</strong><br/>
  <sub>⭐ Star this repo if Vireon helps your business!</sub>
</div>
