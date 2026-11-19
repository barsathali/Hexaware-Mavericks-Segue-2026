# Isolation levels and MongoDB cost
**READ COMMITTED:** prevents dirty reads. A reader cannot see uncommitted data. In locking mode, shared locks are generally released after each statement. Two-session example: Session A updates account 101 but leaves the transaction open; Session B's SELECT waits, then sees A's committed value (or the old value if A rolls back).

**SNAPSHOT:** reads a transaction-level version as of transaction start. Enable with `ALTER DATABASE YourDB SET ALLOW_SNAPSHOT_ISOLATION ON;`. Session B: `SET TRANSACTION ISOLATION LEVEL SNAPSHOT; BEGIN TRAN; SELECT Balance FROM dbo.BankAccount WHERE AccountId=101; WAITFOR DELAY '00:00:10'; SELECT Balance FROM dbo.BankAccount WHERE AccountId=101; COMMIT;`. If Session A commits during the delay, B continues to see its original snapshot.

**MongoDB:** transaction.js uses one session transaction to debit one account and credit another. Multi-document transactions incur coordination, journaling and replication overhead; they are more expensive than a single-document atomic update. Keep them short and use them when an invariant spans documents.
