# Step 1 — Foundation & Authentication

## Overview

This step establishes the foundational architecture of the system, including:

* Phoenix LiveView setup
* SQLite configuration
* Authentication via `phx.gen.auth`
* Domain modeling for telemetry ingestion

---

## Architectural Decisions

### Separation of Concerns

The system is divided into:

* **Accounts** → authentication and users
* **Telemetry** → sensor data domain

This ensures that real-time ingestion logic remains isolated from web concerns.

---

## Data Modeling

### Nodes

Represents physical sensors deployed in the plant.

* `machine_identifier`
* `location`

### NodeMetrics

Represents the latest known state of each node.

* `status`
* `total_events_processed`
* `last_payload`
* `last_seen_at`

A **unique index on `node_id`** ensures:

* Fast upserts
* No duplication
* Efficient write-behind strategy in later stages

---

## Trade-offs

* SQLite chosen for simplicity and edge deployment
* Write contention is expected → mitigated later using ETS

---