// Single-document atomic stock update with $inc; mongosh.
use retail_day8;
db.products.deleteMany({});
db.products.insertMany([{_id:1,name:"Keyboard",stockQty:20},{_id:2,name:"Mouse",stockQty:8},{_id:3,name:"Monitor",stockQty:5}]);
const productId=3, quantity=2;
const result=db.products.updateOne({_id:productId,stockQty:{$gte:quantity}},{$inc:{stockQty:-quantity}});
print(result.modifiedCount===1 ? "Stock reserved successfully" : "Insufficient stock or product missing");
db.products.find({_id:productId});
// Multi-document transaction is needed if stock and separate order/order-line documents
// must all commit or roll back together. Single-document $inc is simpler and cheaper
// when the invariant fits inside one document.
