// mongosh; requires replica set or sharded cluster (not standalone mongod).
use bank_day8;
db.accounts.deleteMany({});
db.accounts.insertMany([{_id:101,holder:"Asha",balance:10000,status:"ACTIVE"},{_id:102,holder:"Ravi",balance:2500,status:"ACTIVE"}]);
const session=db.getMongo().startSession(), bank=session.getDatabase("bank_day8");
try {
 session.startTransaction();
 const amount=1000, from=bank.accounts.findOne({_id:101,status:"ACTIVE"}), to=bank.accounts.findOne({_id:102,status:"ACTIVE"});
 if(!from||!to) throw new Error("Both accounts must be ACTIVE");
 if(from.balance<amount) throw new Error("Insufficient funds");
 if(bank.accounts.updateOne({_id:101,status:"ACTIVE",balance:{$gte:amount}},{$inc:{balance:-amount}}).modifiedCount!==1) throw new Error("Debit failed");
 if(bank.accounts.updateOne({_id:102,status:"ACTIVE"},{$inc:{balance:amount}}).modifiedCount!==1) throw new Error("Credit failed");
 bank.transfers.insertOne({from:101,to:102,amount,createdAt:new Date()});
 session.commitTransaction(); print("Transfer committed");
} catch(e) { session.abortTransaction(); print("Transfer aborted: "+e.message); }
finally { session.endSession(); }
db.accounts.find().sort({_id:1});
