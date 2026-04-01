# Step 4 — Concurrency & System Validation

## Overview

This step validates the system under concurrent load, ensuring correctness and stability.

The goal is to simulate high-throughput telemetry ingestion and verify:

* No data races
* Correct aggregation
* Consistent persistence

---

## Concurrency Model

The system leverages:

* OTP processes (GenServer)
* ETS for lock-free reads/writes
* Asynchronous message passing

This enables safe concurrent ingestion across multiple processes.

---

## Simulation

The `SensorSimulator` generates events per node using independent processes:

* Random intervals
* Continuous ingestion loop
* Parallel execution

Implementation: 

---

## Expected Guarantees

Under concurrent load:

* Each node maintains correct `event_count`
* No duplicate records in database
* Latest state reflects last processed event

---

## Write Consistency

Even with eventual persistence:

* ETS always reflects the latest state
* Database is updated via periodic flush

This ensures:

* Strong real-time correctness (in-memory)
* Eventual consistency (persistent layer)

---

## Failure Considerations

* ETS is memory-based → data loss on crash
* Write-behind may drop unflushed data
* No retry mechanism for failed writes (potential improvement)

## Observability Considerations

In a production environment, metrics such as:
- ingestion rate
- flush latency
- ETS size

would be critical to monitor system health.

---

## Suggested Improvements

* Add retry logic in Writer
* Introduce batching with transactions
* Add metrics/telemetry for ingestion rate
* Backpressure strategy if needed

---

## Design Rationale

The system prioritizes:

1. Throughput
2. Responsiveness
3. Simplicity

Over strict consistency guarantees.

This is a common approach in telemetry and monitoring systems.
