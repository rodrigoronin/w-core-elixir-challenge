# W-Core Telemetry Engine — Solution

This project is a solution for the **W-Core Engineering Challenge**, focused on building a real-time telemetry ingestion engine using Elixir and the BEAM.

---

## 🚀 Overview

The system is designed to handle high-throughput telemetry events from thousands of sensors, providing:

* Real-time state updates
* High concurrency ingestion
* Resilient persistence
* Minimal infrastructure dependencies

---

## 🧠 Architecture Summary

The system follows a CQRS-inspired approach:

* **Write Path** → Event-driven ingestion via GenServer + ETS
* **Read Path** → Real-time UI powered by LiveView reading from ETS
* **Persistence** → Asynchronous write-behind to SQLite

```text
Events → Ingestor → ETS → Writer → SQLite
                     ↓
                 LiveView (UI)
```

---

## ⚡ Key Technologies

* Elixir / OTP
* Phoenix LiveView
* ETS (in-memory state)
* SQLite (persistent storage)
* Docker (deployment)

---

## 🔥 Core Concepts

### ETS as Real-Time State

ETS acts as the primary state layer:

* O(1) reads/writes
* Lock-free access
* Immediate availability for UI

---

### Write-Behind Strategy

Instead of writing every event to the database:

* Events are aggregated in memory
* Periodic flush persists state

Benefits:

* Reduced I/O contention
* Improved throughput
* Better scalability

---

### LiveView + PubSub

* Push-based updates (no polling)
* Reactive UI
* Minimal frontend complexity

---

## 🧪 Running the Project

### 🐳 With Docker (recommended)

```bash
docker compose up --build
```

Then access:

```
http://localhost:4000
```

---

### ⚙️ Environment Variables

Required:

* `SECRET_KEY_BASE`
* `DATABASE_PATH`
* `PHX_SERVER=true`

Example (already configured in docker-compose):

```yaml
DATABASE_PATH=/app/data/elixir_telemetry_engine.db
```

---

### 💾 Persistence

SQLite database is stored via Docker volume:

```
./data → /app/data
```

This ensures data is preserved across container restarts.

---

## 📊 Testing & Validation

The system was validated using:

* Concurrent event simulation
* High-throughput ingestion tests
* State consistency verification

See:

```
/docs/drafts/step-4-tests.md
```

---

## 📚 Documentation

Detailed architectural decisions are documented step-by-step:

* `/docs/drafts/step-1-foundation.md`
* `/docs/drafts/step-2-otp-ets.md`
* `/docs/drafts/step-3-liveview-ds.md`
* `/docs/drafts/step-4-tests.md`
* `/docs/drafts/step-5-infra-arch.md`

---

## ⚠️ Production Considerations

* SSL should be handled by an external proxy (Nginx / Load Balancer)
* ETS is in-memory → not durable
* SQLite limits horizontal scaling

---

## 🧠 Design Philosophy

The system prioritizes:

1. Throughput
2. Responsiveness
3. Simplicity

Over strict consistency guarantees.

---

## 🏁 Conclusion

This solution demonstrates:

* Strong OTP design
* Efficient concurrency handling
* Real-time data processing
* Production-aware architecture

---

## 👨‍💻 Author

[Rodrigo 'Kraby' Lira](https://github.com/rodrigoronin)

---
