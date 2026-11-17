
// Day 5 - Set 2: Bank Activity

use("NexoraBankMongo");

// Create capped collection
if (db.getCollectionNames().includes("customer_activity")) {
    db.customer_activity.drop();
}

db.createCollection("customer_activity", {
    capped: true,
    size: 100000,
    max: 100
});

// Add 20 activity records
db.customer_activity.insertMany([
    { customerId: "CUST001", activity: "Login", device: "Mobile", date: new Date("2026-10-01T09:00:00Z") },
    { customerId: "CUST002", activity: "Login", device: "Desktop", date: new Date("2026-10-01T10:00:00Z") },
    { customerId: "CUST001", activity: "Balance Check", device: "Mobile", date: new Date("2026-10-02T09:15:00Z") },
    { customerId: "CUST003", activity: "Login", device: "Mobile", date: new Date("2026-10-02T11:00:00Z") },
    { customerId: "CUST001", activity: "Login", device: "Desktop", date: new Date("2026-10-03T08:30:00Z") },
    { customerId: "CUST004", activity: "Login", device: "Mobile", date: new Date("2026-10-03T12:00:00Z") },
    { customerId: "CUST002", activity: "Fund Transfer", device: "Mobile", date: new Date("2026-10-04T10:30:00Z") },
    { customerId: "CUST001", activity: "Login", device: "Mobile", date: new Date("2026-10-05T09:00:00Z") },
    { customerId: "CUST005", activity: "Login", device: "Desktop", date: new Date("2026-10-05T13:00:00Z") },
    { customerId: "CUST003", activity: "Balance Check", device: "Mobile", date: new Date("2026-10-06T11:30:00Z") },
    { customerId: "CUST001", activity: "Login", device: "Desktop", date: new Date("2026-10-07T08:45:00Z") },
    { customerId: "CUST004", activity: "Fund Transfer", device: "Mobile", date: new Date("2026-10-07T14:00:00Z") },
    { customerId: "CUST002", activity: "Login", device: "Mobile", date: new Date("2026-10-08T09:20:00Z") },
    { customerId: "CUST001", activity: "Login", device: "Mobile", date: new Date("2026-10-09T09:10:00Z") },
    { customerId: "CUST005", activity: "Balance Check", device: "Desktop", date: new Date("2026-10-09T15:00:00Z") },
    { customerId: "CUST003", activity: "Login", device: "Mobile", date: new Date("2026-10-10T10:00:00Z") },
    { customerId: "CUST001", activity: "Login", device: "Desktop", date: new Date("2026-10-11T08:30:00Z") },
    { customerId: "CUST004", activity: "Login", device: "Mobile", date: new Date("2026-10-11T12:00:00Z") },
    { customerId: "CUST002", activity: "Balance Check", device: "Desktop", date: new Date("2026-10-12T11:00:00Z") },
    { customerId: "CUST001", activity: "Login", device: "Mobile", date: new Date("2026-10-13T09:00:00Z") }
]);

// View all activity records
db.customer_activity.find();

// Get the last five login events of one customer
db.customer_activity.find({
    customerId: "CUST001",
    activity: "Login"
})
.sort({ date: -1 })
.limit(5);
