# Step 3 — LiveView & Real-Time Updates

## Overview

This step introduces a real-time dashboard powered by Phoenix LiveView and PubSub.

The UI reflects telemetry updates instantly without polling.

---

## Real-Time Flow

Event → Ingestor → PubSub → LiveView → UI

---

## PubSub Integration

After processing each event, the system broadcasts updates:

* Topic: `"telemetry_updates"`
* Message: `{:node_updated, node_id}`

Implementation: 

---

## LiveView Subscription

The dashboard subscribes to updates on mount:

* Ensures real-time synchronization
* Only active connections receive updates

Implementation: 

---

## ETS as Read Layer

The UI reads directly from ETS instead of the database.

Benefits:

* Instant updates
* No query overhead
* Consistent with in-memory state

Data loading logic: 

---

## UI Rendering

The dashboard displays:

* Node ID
* Status
* Event count
* Last update timestamp

All derived from in-memory state.

---

## Trade-offs

### Pros

* True real-time updates
* No polling required
* Minimal latency

### Cons

* LiveView reassigns state on each event, which may lead to unnecessary re-renders.
* No diff optimization per node
* PubSub broadcast per event may scale poorly under extreme load

---

## Design Rationale

Using PubSub + LiveView provides:

* Reactive UI without frontend complexity
* Tight integration with backend processes
* Simpler architecture compared to WebSockets manually
