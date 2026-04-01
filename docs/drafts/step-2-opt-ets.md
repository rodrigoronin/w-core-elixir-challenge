# Step 2 — OTP Architecture & ETS Cache

## Overview

This step introduces a high-performance ingestion pipeline using OTP principles and an in-memory cache powered by ETS.

The system is designed to handle high-throughput telemetry events while minimizing database contention.

---

## Architecture

The ingestion flow is structured as:

Sensor → Ingestor → ETS Cache → Writer → Database

### Components

* **Ingestor (GenServer)**
  Responsible for receiving telemetry events asynchronously.

* **Cache (ETS)**
  Acts as the primary read/write layer for telemetry state.

* **Writer (GenServer)**
  Periodically flushes in-memory data to the database.

* **SensorSimulator (GenServer)**
  Simulates real-time event generation.

---

## ETS as Source of Truth

The system uses an ETS table as the main data store for real-time state.

Key configuration:

* `:public` table for concurrent access
* `read_concurrency: true`
* `write_concurrency: true`

This allows multiple processes to read/write efficiently without bottlenecks.

Implementation highlights:

* Upsert logic avoids locks and contention
* Event count aggregation happens in-memory
* Last known state is always immediately available

As seen in the cache implementation: 

---

## Asynchronous Ingestion

Events are processed using `GenServer.cast`, ensuring non-blocking ingestion:

* No backpressure from database
* High throughput under load
* Fault isolation

Ingestor implementation: 

---

## Write-Behind Strategy

Instead of writing every event to the database:

* Events are accumulated in ETS
* A periodic flush persists aggregated state

Key characteristics:

* Flush interval: 5 seconds
* Batch processing per node
* Reduced database load

Writer implementation: 

---

## Trade-offs

### Pros

* Extremely fast ingestion
* Reduced database contention
* Scales well with concurrency

### Cons

* Eventual consistency (not real-time persistence)
* Risk of data loss on crash (no WAL for ETS)
* Requires careful synchronization guarantees

## Failure Model

ETS is owned by a process and is not persisted.

If the node crashes before a flush cycle:
- In-memory state is lost
- Database may be stale

This is an accepted trade-off in favor of throughput.

---

## Design Rationale

Using ETS as the primary state layer enables:

* Real-time dashboards without DB queries
* Efficient aggregation (event_count)
* Isolation between ingestion and persistence

This design aligns with high-throughput telemetry systems where latency is critical.
