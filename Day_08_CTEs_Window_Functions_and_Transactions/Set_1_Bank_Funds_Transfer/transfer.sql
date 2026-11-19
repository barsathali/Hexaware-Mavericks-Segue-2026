-- Set 1: Bank transfer with TRY/CATCH, THROW, full rollback and SAVEPOINT.
IF OBJECT_ID('dbo.TransferLog','U') IS NOT NULL DROP TABLE dbo.TransferLog;
IF OBJECT_ID('dbo.BankAccount','U') IS NOT NULL DROP TABLE dbo.BankAccount;
GO
CREATE TABLE dbo.BankAccount(AccountId int PRIMARY KEY, Holder nvarchar(80), Balance decimal(12,2) CHECK(Balance>=0), AccountStatus varchar(12));
CREATE TABLE dbo.TransferLog(TransferId int IDENTITY PRIMARY KEY, FromId int, ToId int, Amount decimal(12,2), Fee decimal(12,2), CreatedAt datetime2 DEFAULT sysdatetime());
INSERT dbo.BankAccount VALUES(101,'Asha',10000,'ACTIVE'),(102,'Ravi',2500,'ACTIVE'),(103,'Blocked',500,'BLOCKED');
GO
CREATE OR ALTER PROCEDURE dbo.TransferFunds
 @FromId int,@ToId int,@Amount decimal(12,2),@ForceFailure bit=0,@SkipFee bit=0
AS
BEGIN
 SET NOCOUNT ON;
 IF @Amount<=0 THROW 51000,'Amount must be positive.',1;
 IF @FromId=@ToId THROW 51001,'Accounts must differ.',1;
 DECLARE @Bal decimal(12,2),@S1 varchar(12),@S2 varchar(12),@Fee decimal(12,2)=10;
 BEGIN TRY
  BEGIN TRAN;
  SELECT @Bal=Balance,@S1=AccountStatus FROM dbo.BankAccount WITH(UPDLOCK,HOLDLOCK) WHERE AccountId=@FromId;
  SELECT @S2=AccountStatus FROM dbo.BankAccount WITH(UPDLOCK,HOLDLOCK) WHERE AccountId=@ToId;
  IF @Bal IS NULL OR @S2 IS NULL THROW 51002,'Account not found.',1;
  IF @S1<>'ACTIVE' OR @S2<>'ACTIVE' THROW 51003,'Both accounts must be ACTIVE.',1;
  IF @Bal<@Amount THROW 51004,'Insufficient funds.',1;
  UPDATE dbo.BankAccount SET Balance=Balance-@Amount WHERE AccountId=@FromId;
  IF @ForceFailure=1 THROW 51005,'Deliberate failure after debit.',1;
  UPDATE dbo.BankAccount SET Balance=Balance+@Amount WHERE AccountId=@ToId;
  SAVE TRANSACTION FeePosting;
  BEGIN TRY
   IF @SkipFee=1 THROW 51006,'Deliberate fee failure.',1;
   UPDATE dbo.BankAccount SET Balance=Balance-@Fee WHERE AccountId=@FromId;
   INSERT dbo.TransferLog(FromId,ToId,Amount,Fee) VALUES(@FromId,@ToId,@Amount,@Fee);
  END TRY
  BEGIN CATCH
   IF XACT_STATE()=1 ROLLBACK TRANSACTION FeePosting;
   SET @Fee=0;
   INSERT dbo.TransferLog(FromId,ToId,Amount,Fee) VALUES(@FromId,@ToId,@Amount,0);
   PRINT 'Fee rolled back to savepoint; transfer retained.';
  END CATCH;
  COMMIT;
 END TRY
 BEGIN CATCH
  IF XACT_STATE()<>0 ROLLBACK;
  THROW;
 END CATCH
END;
GO
SELECT 'BEFORE' Evidence,* FROM dbo.BankAccount;
BEGIN TRY EXEC dbo.TransferFunds 101,102,1000,1,0; END TRY BEGIN CATCH SELECT ERROR_MESSAGE() ExpectedFailure; END CATCH;
SELECT 'AFTER_FORCED_ROLLBACK' Evidence,* FROM dbo.BankAccount; -- balances remain 10000 and 2500
EXEC dbo.TransferFunds 101,102,1000,0,1; -- fee step fails, transfer retained
SELECT 'AFTER_SAVEPOINT' Evidence,* FROM dbo.BankAccount;
SELECT * FROM dbo.TransferLog;
GO
