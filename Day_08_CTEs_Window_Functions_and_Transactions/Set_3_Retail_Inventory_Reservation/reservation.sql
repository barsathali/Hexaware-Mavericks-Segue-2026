IF OBJECT_ID('dbo.OrderLine','U') IS NOT NULL DROP TABLE dbo.OrderLine;
IF OBJECT_ID('dbo.CustomerOrder','U') IS NOT NULL DROP TABLE dbo.CustomerOrder;
IF OBJECT_ID('dbo.Product','U') IS NOT NULL DROP TABLE dbo.Product;
CREATE TABLE dbo.Product(ProductId int PRIMARY KEY,ProductName varchar(80),Category varchar(40),StockQty int CHECK(StockQty>=0),UnitPrice decimal(10,2));
CREATE TABLE dbo.CustomerOrder(OrderId int IDENTITY PRIMARY KEY,CustomerId int,OrderDate datetime2 DEFAULT sysdatetime(),OrderStatus varchar(15));
CREATE TABLE dbo.OrderLine(OrderLineId int IDENTITY PRIMARY KEY,OrderId int REFERENCES dbo.CustomerOrder(OrderId),ProductId int REFERENCES dbo.Product(ProductId),Quantity int CHECK(Quantity>0),UnitPrice decimal(10,2));
INSERT dbo.Product VALUES(1,'Keyboard','Accessories',20,1200),(2,'Mouse','Accessories',8,600),(3,'Monitor','Electronics',5,9000),(4,'Webcam','Electronics',12,2500),(5,'Notebook','Stationery',30,100);
GO
CREATE OR ALTER PROCEDURE dbo.PlaceRetailOrder @CustomerId int,@ProductId int,@Quantity int
AS
BEGIN
 SET NOCOUNT ON; SET XACT_ABORT ON;
 IF @Quantity<=0 THROW 53000,'Quantity must be positive.',1;
 BEGIN TRY
  BEGIN TRAN;
  DECLARE @Stock int,@Price decimal(10,2);
  SELECT @Stock=StockQty,@Price=UnitPrice FROM dbo.Product WITH(UPDLOCK,HOLDLOCK) WHERE ProductId=@ProductId;
  IF @Stock IS NULL THROW 53001,'Product not found.',1;
  IF @Stock<@Quantity THROW 53002,'Insufficient stock.',1;
  UPDATE dbo.Product SET StockQty=StockQty-@Quantity WHERE ProductId=@ProductId;
  INSERT dbo.CustomerOrder(CustomerId,OrderStatus) VALUES(@CustomerId,'RESERVED');
  DECLARE @OrderId int=SCOPE_IDENTITY();
  INSERT dbo.OrderLine(OrderId,ProductId,Quantity,UnitPrice) VALUES(@OrderId,@ProductId,@Quantity,@Price);
  COMMIT; SELECT 'RESERVED' Result,@OrderId OrderId;
 END TRY BEGIN CATCH IF XACT_STATE()<>0 ROLLBACK; THROW; END CATCH
END;
GO
SELECT 'BEFORE' Evidence,ProductId,StockQty FROM dbo.Product WHERE ProductId=3;
BEGIN TRY EXEC dbo.PlaceRetailOrder 7001,3,99; END TRY BEGIN CATCH SELECT ERROR_MESSAGE() ExpectedRollbackReason; END CATCH;
SELECT 'AFTER_FAILED_ORDER' Evidence,ProductId,StockQty FROM dbo.Product WHERE ProductId=3; -- still 5
EXEC dbo.PlaceRetailOrder 7002,3,2;
SELECT * FROM dbo.Product; SELECT * FROM dbo.CustomerOrder; SELECT * FROM dbo.OrderLine;
