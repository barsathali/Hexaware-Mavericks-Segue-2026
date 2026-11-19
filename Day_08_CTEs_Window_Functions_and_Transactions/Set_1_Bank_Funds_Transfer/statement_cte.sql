-- CTE monthly statement with ROW_NUMBER and LAG.
IF OBJECT_ID('dbo.StatementTransaction','U') IS NOT NULL DROP TABLE dbo.StatementTransaction;
CREATE TABLE dbo.StatementTransaction(TransactionId int PRIMARY KEY,AccountId int,TxnDate date,Description varchar(80),Amount decimal(10,2),BalanceAfter decimal(10,2));
INSERT dbo.StatementTransaction VALUES
(1,101,'2026-01-02','Opening credit',5000,5000),(2,101,'2026-01-05','Groceries',-450,4550),
(3,101,'2026-01-12','Salary',6000,10550),(4,101,'2026-01-18','Utility bill',-550,10000),
(5,101,'2026-02-02','Transfer debit',-1000,9000);
DECLARE @AccountId int=101,@MonthStart date='2026-01-01';
WITH MonthlyStatement AS(
 SELECT * FROM dbo.StatementTransaction
 WHERE AccountId=@AccountId AND TxnDate>=@MonthStart AND TxnDate<DATEADD(MONTH,1,@MonthStart)
)
SELECT ROW_NUMBER() OVER(ORDER BY TxnDate,TransactionId) RowNum,TxnDate,Description,Amount,BalanceAfter,
 LAG(BalanceAfter) OVER(ORDER BY TxnDate,TransactionId) PreviousBalance
FROM MonthlyStatement ORDER BY TxnDate,TransactionId;
