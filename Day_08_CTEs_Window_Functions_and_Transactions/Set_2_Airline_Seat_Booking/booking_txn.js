// mongosh; requires replica set or sharded cluster.
use airline_day8;
db.seats.deleteMany({}); db.bookings.deleteMany({});
db.seats.insertMany([{_id:"9001-12A",flightId:9001,seatNo:"12A",status:"AVAILABLE"}]);
const session=db.getMongo().startSession(), airline=session.getDatabase("airline_day8");
try {
 session.startTransaction();
 const seat=airline.seats.findOne({_id:"9001-12A",status:"AVAILABLE"});
 if(!seat) throw new Error("Seat unavailable");
 if(airline.seats.updateOne({_id:"9001-12A",status:"AVAILABLE"},{$set:{status:"BOOKED"}}).modifiedCount!==1)
   throw new Error("Seat taken concurrently");
 airline.bookings.insertOne({flightId:9001,seatNo:"12A",passengerName:"Asha",fare:4500,bookedAt:new Date()});
 session.commitTransaction(); print("Seat and booking committed");
} catch(e) { session.abortTransaction(); print("Rolled back: "+e.message); }
finally { session.endSession(); }
airline.seats.find(); airline.bookings.find();
