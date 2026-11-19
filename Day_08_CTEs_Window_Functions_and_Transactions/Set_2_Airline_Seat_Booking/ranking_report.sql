IF OBJECT_ID('dbo.PassengerFare','U') IS NOT NULL DROP TABLE dbo.PassengerFare;
CREATE TABLE dbo.PassengerFare(BookingId int PRIMARY KEY,FlightId int,PassengerName varchar(80),Fare decimal(10,2));
INSERT dbo.PassengerFare VALUES(1,9001,'Asha',5000),(2,9001,'Bala',4500),(3,9001,'Charu',4500),(4,9001,'Dev',4000),
(5,9002,'Esha',6200),(6,9002,'Farhan',6200),(7,9002,'Gita',5100);
WITH FareRanks AS(
 SELECT *,RANK() OVER(PARTITION BY FlightId ORDER BY Fare DESC) FareRank,
 DENSE_RANK() OVER(PARTITION BY FlightId ORDER BY Fare DESC) DenseFareRank,
 SUM(Fare) OVER(PARTITION BY FlightId ORDER BY Fare DESC,BookingId ROWS UNBOUNDED PRECEDING) RunningRevenue
 FROM dbo.PassengerFare
)
SELECT * FROM FareRanks ORDER BY FlightId,Fare DESC,BookingId;
-- For 5000,4500,4500,4000: RANK = 1,2,2,4; DENSE_RANK = 1,2,2,3.
