
// Day 6 - Set 1: Retail Sales

use("NexoraRetailSalesMongo");

// Create sales collection
if (db.getCollectionNames().includes("sales_lines")) {
    db.sales_lines.drop();
}

db.createCollection("sales_lines");

// Add sales records
db.sales_lines.insertMany([
    { orderId: 1001, customerId: 1, customerName: "Arun Kumar", city: "Chennai", product: "Laptop", category: "Electronics", quantity: 1, unitPrice: 50000, orderDate: new Date("2026-10-01") },
    { orderId: 1001, customerId: 1, customerName: "Arun Kumar", city: "Chennai", product: "Headphones", category: "Accessories", quantity: 2, unitPrice: 2000, orderDate: new Date("2026-10-01") },
    { orderId: 1002, customerId: 1, customerName: "Arun Kumar", city: "Chennai", product: "Mobile", category: "Electronics", quantity: 1, unitPrice: 20000, orderDate: new Date("2026-10-05") },
    { orderId: 1002, customerId: 1, customerName: "Arun Kumar", city: "Chennai", product: "Chair", category: "Furniture", quantity: 2, unitPrice: 5000, orderDate: new Date("2026-10-05") },
    { orderId: 1003, customerId: 1, customerName: "Arun Kumar", city: "Chennai", product: "Laptop", category: "Electronics", quantity: 1, unitPrice: 50000, orderDate: new Date("2026-10-10") },
    { orderId: 1004, customerId: 1, customerName: "Arun Kumar", city: "Chennai", product: "Table", category: "Furniture", quantity: 2, unitPrice: 8000, orderDate: new Date("2026-11-02") },
    { orderId: 1005, customerId: 2, customerName: "Priya S", city: "Coimbatore", product: "Mobile", category: "Electronics", quantity: 2, unitPrice: 20000, orderDate: new Date("2026-10-12") },
    { orderId: 1006, customerId: 2, customerName: "Priya S", city: "Coimbatore", product: "Headphones", category: "Accessories", quantity: 3, unitPrice: 2000, orderDate: new Date("2026-11-05") },
    { orderId: 1007, customerId: 3, customerName: "Karthik R", city: "Chennai", product: "Chair", category: "Furniture", quantity: 1, unitPrice: 5000, orderDate: new Date("2026-11-10") },
    { orderId: 1008, customerId: 4, customerName: "Divya M", city: "Bengaluru", product: "Table", category: "Furniture", quantity: 1, unitPrice: 8000, orderDate: new Date("2026-11-12") }
]);

// 1. Month-wise sales
db.sales_lines.aggregate([
    {
        $group: {
            _id: {
                $dateToString: { format: "%Y-%m", date: "$orderDate" }
            },
            totalSales: {
                $sum: { $multiply: ["$quantity", "$unitPrice"] }
            }
        }
    },
    { $sort: { _id: 1 } }
]);

// 2. Top products by revenue
db.sales_lines.aggregate([
    {
        $group: {
            _id: "$product",
            revenue: {
                $sum: { $multiply: ["$quantity", "$unitPrice"] }
            }
        }
    },
    { $sort: { revenue: -1 } },
    { $limit: 5 }
]);

// 3. Average basket value per city
db.sales_lines.aggregate([
    {
        $group: {
            _id: {
                orderId: "$orderId",
                city: "$city"
            },
            orderTotal: {
                $sum: { $multiply: ["$quantity", "$unitPrice"] }
            }
        }
    },
    {
        $group: {
            _id: "$_id.city",
            averageBasketValue: { $avg: "$orderTotal" }
        }
    },
    { $sort: { averageBasketValue: -1 } }
]);

