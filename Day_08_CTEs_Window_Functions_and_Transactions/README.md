# Day 8 — CTEs, Window Functions and Transactions
Complete pack for the three sets in the uploaded assignment:
1. Bank Funds Transfer
2. Airline Seat Booking
3. Retail Inventory Reservation

Each set contains SQL Server scripts, MongoDB JavaScript scripts and explanation notes. Flow PNGs are explanatory diagrams, not live query-result screenshots.

## SQL execution order
- Set 1: `transfer.sql`, then `statement_cte.sql`.
- Set 2: `booking_transaction.sql`, then `ranking_report.sql`.
- Set 3: `reservation.sql`, then `rank_report.sql`.

Run scripts in a dedicated practice database only; scripts drop/recreate their sample tables. MongoDB multi-document transactions require a replica set or sharded cluster, not a standalone mongod.

Assignment heading specifies SQL Server 2025 and MongoDB 8.0. Core SQL used here is compatible with SQL Server 2022 too. The local setup previously discussed may be SQL Server 2022 / MongoDB 7.x; use the available versions for practice and note compatibility if needed.
