-- Correlated subquery: products with stock below their category average.
SELECT p.ProductId,p.ProductName,p.Category,p.StockQty
FROM dbo.Product p
WHERE p.StockQty < (SELECT AVG(CAST(p2.StockQty AS decimal(10,2))) FROM dbo.Product p2 WHERE p2.Category=p.Category);
GO
IF OBJECT_ID('dbo.ProductSales','U') IS NOT NULL DROP TABLE dbo.ProductSales;
CREATE TABLE dbo.ProductSales(SalesId int PRIMARY KEY,ProductId int,SalesMonth date,UnitsSold int);
INSERT dbo.ProductSales VALUES
(1,1,'2026-01-01',30),(2,1,'2026-02-01',42),(3,1,'2026-03-01',38),
(4,2,'2026-01-01',50),(5,2,'2026-02-01',45),(6,2,'2026-03-01',60),
(7,3,'2026-01-01',10),(8,3,'2026-02-01',15),(9,3,'2026-03-01',20),
(10,4,'2026-01-01',25),(11,4,'2026-02-01',28),(12,4,'2026-03-01',35),
(13,5,'2026-01-01',80),(14,5,'2026-02-01',75),(15,5,'2026-03-01',90);
WITH ProductTotals AS(
 SELECT p.ProductId,p.ProductName,p.Category,SUM(s.UnitsSold) TotalUnits
 FROM dbo.Product p JOIN dbo.ProductSales s ON s.ProductId=p.ProductId
 GROUP BY p.ProductId,p.ProductName,p.Category
), Ranked AS(
 SELECT *,ROW_NUMBER() OVER(PARTITION BY Category ORDER BY TotalUnits DESC,ProductId) CategoryRow
 FROM ProductTotals
)
SELECT * FROM Ranked WHERE CategoryRow<=3 ORDER BY Category,CategoryRow;
WITH Monthly AS(
 SELECT ProductId,SalesMonth,SUM(UnitsSold) UnitsSold FROM dbo.ProductSales GROUP BY ProductId,SalesMonth
)
SELECT ProductId,SalesMonth,UnitsSold,
 LAG(UnitsSold) OVER(PARTITION BY ProductId ORDER BY SalesMonth) PreviousMonthUnits,
 UnitsSold-LAG(UnitsSold) OVER(PARTITION BY ProductId ORDER BY SalesMonth) ChangeFromPreviousMonth,
 LEAD(UnitsSold) OVER(PARTITION BY ProductId ORDER BY SalesMonth) NextMonthUnits
FROM Monthly ORDER BY ProductId,SalesMonth;
