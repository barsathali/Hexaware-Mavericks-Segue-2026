-- Atomic seat booking; SERIALIZABLE + UPDLOCK/HOLDLOCK serializes same-seat requests.
IF OBJECT_ID('dbo.Booking','U') IS NOT NULL DROP TABLE dbo.Booking;
IF OBJECT_ID('dbo.Seat','U') IS NOT NULL DROP TABLE dbo.Seat;
CREATE TABLE dbo.Seat(FlightId int,SeatNo varchar(5),SeatStatus varchar(12),PRIMARY KEY(FlightId,SeatNo));
CREATE TABLE dbo.Booking(BookingId int IDENTITY PRIMARY KEY,FlightId int,SeatNo varchar(5),PassengerName varchar(80),Fare decimal(10,2),
 CONSTRAINT UQ_Flight_Seat UNIQUE(FlightId,SeatNo));
INSERT dbo.Seat VALUES(9001,'12A','AVAILABLE'),(9001,'12B','AVAILABLE');
GO
CREATE OR ALTER PROCEDURE dbo.BookSeat @FlightId int,@SeatNo varchar(5),@Passenger varchar(80),@Fare decimal(10,2)
AS
BEGIN
 SET NOCOUNT ON; SET XACT_ABORT ON;
 BEGIN TRY
  SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; BEGIN TRAN;
  DECLARE @Status varchar(12);
  SELECT @Status=SeatStatus FROM dbo.Seat WITH(UPDLOCK,HOLDLOCK) WHERE FlightId=@FlightId AND SeatNo=@SeatNo;
  IF @Status IS NULL THROW 52001,'Seat does not exist.',1;
  IF @Status<>'AVAILABLE' THROW 52002,'Seat already booked.',1;
  INSERT dbo.Booking(FlightId,SeatNo,PassengerName,Fare) VALUES(@FlightId,@SeatNo,@Passenger,@Fare);
  UPDATE dbo.Seat SET SeatStatus='BOOKED' WHERE FlightId=@FlightId AND SeatNo=@SeatNo;
  COMMIT; SELECT 'BOOKED' Result;
 END TRY BEGIN CATCH IF XACT_STATE()<>0 ROLLBACK; THROW; END CATCH
END;
GO
EXEC dbo.BookSeat 9001,'12A','Passenger A',4500;
BEGIN TRY EXEC dbo.BookSeat 9001,'12A','Passenger B',4700; END TRY BEGIN CATCH SELECT ERROR_MESSAGE() ExpectedConflict; END CATCH;
SELECT * FROM dbo.Seat; SELECT * FROM dbo.Booking;
-- Two-session lab:
-- Session A: BEGIN TRAN; SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
-- SELECT SeatStatus FROM dbo.Seat WHERE FlightId=9001 AND SeatNo='12B';
-- WAITFOR DELAY '00:00:10'; INSERT booking for 12B; UPDATE Seat to BOOKED; COMMIT.
-- Session B during delay: SELECT same seat, then attempt insert/update.
-- Plain READ COMMITTED reads do not reserve the row through transaction end; without a lock protocol
-- both can observe AVAILABLE. UNIQUE(FlightId,SeatNo) prevents duplicate committed booking.
-- Repeat with SERIALIZABLE and SELECT ... WITH(UPDLOCK,HOLDLOCK): B waits, then sees BOOKED.
