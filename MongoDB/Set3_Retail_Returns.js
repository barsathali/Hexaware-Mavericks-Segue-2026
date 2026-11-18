
use("NexoraRetailReturnsMongo");

// Clear existing collections
db.customers.drop();
db.products.drop();
db.orders.drop();
db.returns.drop();
db.refunds.drop();
db.return_reasons.drop();

// 1. CUSTOMERS
db.customers.insertMany([
  { customerId: 1, customerName: "Arun Kumar", city: "Chennai" },
  { customerId: 2, customerName: "Priya Sharma", city: "Bengaluru" },
  { customerId: 3, customerName: "Rahul Verma", city: "Hyderabad" },
  { customerId: 4, customerName: "Meena Raj", city: "Mumbai" },
  { customerId: 5, customerName: "Karthik Das", city: "Pune" },
  { customerId: 6, customerName: "Divya Nair", city: "Delhi" }
]);

// 2. PRODUCTS
db.products.insertMany([
  { productId: 1, productName: "Laptop", category: "Electronics", price: 55000 },
  { productId: 2, productName: "Smartphone", category: "Electronics", price: 25000 },
  { productId: 3, productName: "Headphones", category: "Accessories", price: 2500 },
  { productId: 4, productName: "Office Chair", category: "Furniture", price: 8000 },
  { productId: 5, productName: "Keyboard", category: "Accessories", price: 1500 },
  { productId: 6, productName: "Monitor", category: "Electronics", price: 12000 },
  { productId: 7, productName: "Table", category: "Furniture", price: 6000 },
  { productId: 8, productName: "Mouse", category: "Accessories", price: 800 }
]);

// 3. ORDERS
db.orders.insertMany([
  { orderId: 1, customerId: 1, orderDate: ISODate("2026-09-01"), status: "Delivered" },
  { orderId: 2, customerId: 2, orderDate: ISODate("2026-09-03"), status: "Delivered" },
  { orderId: 3, customerId: 3, orderDate: ISODate("2026-09-05"), status: "Delivered" },
  { orderId: 4, customerId: 4, orderDate: ISODate("2026-09-08"), status: "Delivered" },
  { orderId: 5, customerId: 5, orderDate: ISODate("2026-09-10"), status: "Delivered" },
  { orderId: 6, customerId: 6, orderDate: ISODate("2026-09-12"), status: "Delivered" },
  { orderId: 7, customerId: 1, orderDate: ISODate("2026-10-01"), status: "Delivered" },
  { orderId: 8, customerId: 2, orderDate: ISODate("2026-10-05"), status: "Delivered" },
  { orderId: 9, customerId: 3, orderDate: ISODate("2026-10-08"), status: "Delivered" },
  { orderId: 10, customerId: 4, orderDate: ISODate("2026-10-12"), status: "Delivered" }
]);

// 4. RETURNS
db.returns.insertMany([
  { returnId: 1, orderId: 1, productId: 1, reasonId: 1, returnDate: ISODate("2026-09-05"), quantity: 1, status: "Approved" },
  { returnId: 2, orderId: 2, productId: 2, reasonId: 3, returnDate: ISODate("2026-09-08"), quantity: 1, status: "Approved" },
  { returnId: 3, orderId: 3, productId: 4, reasonId: 2, returnDate: ISODate("2026-09-12"), quantity: 1, status: "Approved" },
  { returnId: 4, orderId: 4, productId: 6, reasonId: 1, returnDate: ISODate("2026-09-15"), quantity: 1, status: "Approved" },
  { returnId: 5, orderId: 5, productId: 7, reasonId: 5, returnDate: ISODate("2026-09-18"), quantity: 1, status: "Pending" },
  { returnId: 6, orderId: 6, productId: 3, reasonId: 4, returnDate: ISODate("2026-09-20"), quantity: 1, status: "Approved" },
  { returnId: 7, orderId: 7, productId: 1, reasonId: 3, returnDate: ISODate("2026-10-05"), quantity: 1, status: "Approved" },
  { returnId: 8, orderId: 8, productId: 2, reasonId: 2, returnDate: ISODate("2026-10-09"), quantity: 1, status: "Rejected" },
  { returnId: 9, orderId: 9, productId: 5, reasonId: 1, returnDate: ISODate("2026-10-12"), quantity: 1, status: "Approved" },
  { returnId: 10, orderId: 10, productId: 4, reasonId: 5, returnDate: ISODate("2026-10-15"), quantity: 1, status: "Pending" }
]);

// 5. RETURN REASONS
db.return_reasons.insertMany([
  { reasonId: 1, reasonName: "Damaged Product" },
  { reasonId: 2, reasonName: "Wrong Item Delivered" },
  { reasonId: 3, reasonName: "Product Not as Described" },
  { reasonId: 4, reasonName: "Size or Compatibility Issue" },
  { reasonId: 5, reasonName: "Changed Mind" }
]);

// 6. REFUNDS
db.refunds.insertMany([
  { refundId: 1, returnId: 1, refundDate: ISODate("2026-09-07"), refundAmount: 55000, method: "Original Payment" },
  { refundId: 2, returnId: 2, refundDate: ISODate("2026-09-10"), refundAmount: 25000, method: "Bank Transfer" },
  { refundId: 3, returnId: 3, refundDate: ISODate("2026-09-14"), refundAmount: 8000, method: "Original Payment" },
  { refundId: 4, returnId: 4, refundDate: ISODate("2026-09-17"), refundAmount: 12000, method: "Bank Transfer" },
  { refundId: 5, returnId: 6, refundDate: ISODate("2026-09-22"), refundAmount: 2500, method: "Original Payment" },
  { refundId: 6, returnId: 7, refundDate: ISODate("2026-10-07"), refundAmount: 55000, method: "Bank Transfer" },
  { refundId: 7, returnId: 9, refundDate: ISODate("2026-10-14"), refundAmount: 1500, method: "Original Payment" }
]);

// LOOKUP 1: Returns with customer details
db.returns.aggregate([
  {
    $lookup: {
      from: "orders",
      localField: "orderId",
      foreignField: "orderId",
      as: "orderDetails"
    }
  },
  { $unwind: "$orderDetails" },
  {
    $lookup: {
      from: "customers",
      localField: "orderDetails.customerId",
      foreignField: "customerId",
      as: "customerDetails"
    }
  },
  { $unwind: "$customerDetails" },
  {
    $project: {
      _id: 0,
      returnId: 1,
      customerName: "$customerDetails.customerName",
      productId: 1,
      returnDate: 1,
      status: 1
    }
  }
]);

// LOOKUP 2: Returns with product and return reason
db.returns.aggregate([
  {
    $lookup: {
      from: "products",
      localField: "productId",
      foreignField: "productId",
      as: "productDetails"
    }
  },
  { $unwind: "$productDetails" },
  {
    $lookup: {
      from: "return_reasons",
      localField: "reasonId",
      foreignField: "reasonId",
      as: "reasonDetails"
    }
  },
  { $unwind: "$reasonDetails" },
  {
    $project: {
      _id: 0,
      returnId: 1,
      productName: "$productDetails.productName",
      reason: "$reasonDetails.reasonName",
      quantity: 1,
      status: 1
    }
  }
]);

// LOOKUP 3: Returns with refund information
db.returns.aggregate([
  {
    $lookup: {
      from: "refunds",
      localField: "returnId",
      foreignField: "returnId",
      as: "refundDetails"
    }
  },
  {
    $project: {
      _id: 0,
      returnId: 1,
      status: 1,
      refundCount: { $size: "$refundDetails" },
      totalRefund: { $sum: "$refundDetails.refundAmount" },
      refundDetails: 1
    }
  }
]);

// VERIFY COLLECTION COUNTS
printjson({
  Customers: db.customers.countDocuments(),
  Products: db.products.countDocuments(),
  Orders: db.orders.countDocuments(),
  Returns: db.returns.countDocuments(),
  ReturnReasons: db.return_reasons.countDocuments(),
  Refunds: db.refunds.countDocuments()
});
