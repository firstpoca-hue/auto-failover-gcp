Create a GCP Hot–Cold Disaster Recovery Architecture Diagram with the following components and automation flow.
Use a clean white background, clear icons, and organized left-to-right flow.
Use labeled arrows to indicate data flow, failover triggers, and automation steps.

1️⃣ Primary (HOT) Region (Left Side)

Title: Primary Region (HOT)

Components:

GKE Cluster (Primary) → running main application workloads.

Cloud SQL (Primary Database) → connected to the GKE workloads.

Cloud Monitoring → monitors GKE cluster, Cloud SQL health, and load balancer.

Artifact Registry → stores application Docker images and replicate it to the Secondary Region.

CI/CD Pipeline (GitHub Actions) → deploys workloads to GKE through terraform.

Connect GKE Cluster → Cloud SQL Primary (App DB traffic).

Connect Artifact Registry → GKE Cluster (for image deployment).

Connect Cloud Monitoring → Failover Logic (for failure detection).

2️⃣ Global Access Layer (Center)

Title: Global Access Layer

Components:

Global HTTPS Load Balancer (External Managed) → main entry point for users.

Cloud CDN → attached to the Load Balancer.

Connect End Users → Global HTTPS Load Balancer → Primary GKE backend.

Add a dashed line from Load Balancer to Secondary GKE backend (used during failover).

Show Health Check arrows from Load Balancer → both regions.

3️⃣ Secondary (COLD) Region (Right Side)

Title: Secondary Region (COLD / DR)

Components:

GKE Cluster (Secondary) → provisioned dynamically during failover.

Cloud SQL Read Replica (Standby) → replicates from the primary database.

Cloud Monitoring (Secondary) → monitors GKE and DB post failover.

Connect Cloud SQL Read Replica ← Cloud SQL Primary (replication arrow).

Label the arrow: “Asynchronous Cross-Region Replication”.

Add a note: “Replica remains in Read-Only mode until promotion”.

4️⃣ Automation Logic (Between Primary and Secondary)

Title: Failover Automation Logic

Components:

Cloud Monitoring Alert → triggers Cloud Function.

Cloud Function performs:

Promotes Cloud SQL Read Replica to Primary.

Triggers Terraform Job to provision Secondary GKE.

Updates Secret Manager with new DB connection string.

Restarts Secondary GKE Deployments using new DB.

Terraform Infrastructure Module → provisions GKE cluster and network components in secondary region.

Connect flow arrows:

Cloud Monitoring Alert → Cloud Function

Cloud Function → Cloud SQL Replica (Promote)

Cloud Function → Terraform (Provision Secondary GKE)

Cloud Function → Secret Manager (Update DB credentials)

Cloud Function → GKE Cluster (Secondary)

5️⃣ Traffic Flow After Failover

Add a thick dashed arrow showing:

Global Load Balancer → Secondary GKE backend (via health checks) once primary becomes unavailable.

Label it: “Traffic Automatically Shifted to Secondary Region”.

6️⃣ Notes & Labels

Label data flows clearly:

App Data Flow (solid line) → between GKE and SQL.

Failover Automation Flow (dashed line) → between Monitoring and Terraform.

Use a Cloud icon background grouping for each region.

Show region names:

Left cloud label → “us-central1 (Primary)”

Right cloud label → “us-west1 (Secondary)