# Execution checklist
## Set 1
- Run transfer.sql; capture before balances, deliberate error, unchanged balances after rollback, and successful transfer with fee savepoint rollback.
- Run statement_cte.sql; capture RowNum and PreviousBalance.
- Run transaction.js in mongosh on a replica set; capture committed accounts and transfer.

## Set 2
- Run booking_transaction.sql; capture first booking success and second same-seat rejection.
- Follow its two-session lab comments to compare READ COMMITTED and SERIALIZABLE.
- Run ranking_report.sql; capture RANK, DENSE_RANK and RunningRevenue.
- Run booking_txn.js on a replica set; capture seat and booking documents.

## Set 3
- Run reservation.sql; capture insufficient-stock rollback and successful reservation.
- Run rank_report.sql; capture correlated query, top-three ranking and LAG/LEAD output.
- Run stock_update.js; capture successful $inc update.

The included diagrams are not fabricated execution screenshots. Capture actual results from your database client after running the scripts.
