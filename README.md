# Vireon — AI Financial Copilot

Vireon ingests financial data (demo, Merge, Plaid, ERPNext), detects anomalies, and provides dashboards, alerts, and an AI assistant ("Finley") for natural-language insights.

Screenshots
------------

![Dashboard 1](assets/screenshots/Screenshot-2026-05-05-17.21.15.png)
![Dashboard 2](assets/screenshots/Screenshot-2026-05-05-17.21.29.png)

Quick start (Docker)
--------------------
1. Copy demo env (do NOT commit secrets):
   cp backend/.env.demo backend/.env
2. Edit backend/.env for real credentials (DB/SMTP/LLM) — do not commit this file.
3. Start:
   docker compose up -d --build
4. Health:
   curl -sf http://localhost:8000/health/ready && echo "backend ready"

Project Structure
-----------------
- backend/ — FastAPI app, SQLAlchemy models, anomaly detection, Celery tasks
- frontend/ — React app with dashboard UI (scorecard, revenue, expenses, alerts)
- docker-compose.yml — development/demo stack (Postgres, Redis, Mailhog, Ollama optional)

Important notes
---------------
- Do NOT commit .env or other secret-containing files. Use environment variables or secrets managers.
- For Gmail SMTP use smtp.gmail.com and an App Password (2FA required).
- Finley (AI chat) requires a valid LLM key (GROQ_API_KEY or local Ollama).

Contributing
------------
1. Create a branch: git checkout -b feat/your-change
2. Commit changes and open a PR.

License
-------
Specify your license here.
