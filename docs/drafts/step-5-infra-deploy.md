# Step 5 — Infrastructure & Deployment (Docker)

## Overview

This step packages the application into a portable and reproducible container using Docker.

The goal is to ensure the system can run in an isolated environment with minimal setup, aligning with edge deployment requirements.

---

## Containerization Strategy

The application is built using a multi-stage Dockerfile:

1. **Build Stage**

   * Compiles Elixir dependencies
   * Builds assets
   * Generates a release

2. **Runtime Stage**

   * Minimal Alpine image
   * Runs the compiled release
   * Includes only necessary system libraries

This approach reduces image size and improves security.

---

## Runtime Configuration

The system follows the **12-factor app** principle by externalizing configuration via environment variables:

* `SECRET_KEY_BASE`
* `DATABASE_PATH`
* `PHX_SERVER`

This ensures the container is environment-agnostic and easily configurable.

---

## Database Persistence

SQLite is used as the persistent storage layer.

To ensure durability across container restarts, a volume is mounted:

```yaml
volumes:
  - ./data:/app/data
```

This guarantees:

* No data loss when the container stops
* Compatibility with edge environments (no external DB required)

---

## Networking & Access

The application runs on port `4000`:

```yaml
ports:
  - "4000:4000"
```

In production scenarios:

* HTTPS should be handled by an external proxy (e.g., Nginx, Load Balancer)
* The container itself runs over HTTP internally

---

## SSL Considerations

During development, enforcing SSL caused connection issues due to the absence of a TLS termination layer.

To address this:

* SSL enforcement (`force_ssl`) was made optional
* The system can run locally without HTTPS
* In production, SSL is expected to be handled externally

---

## Trade-offs

### Pros

* Fully reproducible environment
* No dependency on external services
* Simple deployment model
* Suitable for edge computing

### Cons

* SQLite limits horizontal scalability
* No built-in TLS (relies on external proxy)
* Requires careful configuration of environment variables

---

## Final Architecture

```
[Client]
   ↓
[Reverse Proxy / TLS Termination]
   ↓
[Phoenix Container]
   ↓
[ETS (real-time state)]
   ↓
[SQLite (persistent state)]
```

---

## Design Rationale

The deployment strategy prioritizes:

* Simplicity
* Portability
* Independence from external infrastructure

This aligns with the system's goal of running in constrained environments (edge computing) while maintaining real-time responsiveness.

---

## Conclusion

At this stage, the system is:

* Fully containerized
* Production-configurable
* Capable of handling real-time telemetry workloads
