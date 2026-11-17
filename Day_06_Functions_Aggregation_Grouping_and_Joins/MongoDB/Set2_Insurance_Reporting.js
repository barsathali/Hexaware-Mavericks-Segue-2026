
// Day 6 - Set 2: Insurance Claims

use("NexoraInsuranceMongo");

// Create claims collection
if (db.getCollectionNames().includes("claims_notes")) {
    db.claims_notes.drop();
}

db.createCollection("claims_notes");

// Add claim records
db.claims_notes.insertMany([
    { claimId: 1, policyNumber: "POL1001", status: "Settled", damageCategory: "Medical", claimDate: new Date("2026-01-10"), settlementDate: new Date("2026-01-20"), amount: 5000 },
    { claimId: 2, policyNumber: "POL1003", status: "Settled", damageCategory: "Medical", claimDate: new Date("2026-02-15"), settlementDate: new Date("2026-03-01"), amount: 7000 },
    { claimId: 3, policyNumber: "POL1004", status: "Settled", damageCategory: "Vehicle", claimDate: new Date("2026-04-10"), settlementDate: new Date("2026-04-25"), amount: 3000 },
    { claimId: 4, policyNumber: "POL1005", status: "Pending", damageCategory: "Property", claimDate: new Date("2026-05-15"), settlementDate: null, amount: 8000 },
    { claimId: 5, policyNumber: "POL1006", status: "Settled", damageCategory: "Vehicle", claimDate: new Date("2026-06-20"), settlementDate: new Date("2026-07-05"), amount: 4000 },
    { claimId: 6, policyNumber: "POL1008", status: "Pending", damageCategory: "Medical", claimDate: new Date("2026-07-10"), settlementDate: null, amount: 2000 },
    { claimId: 7, policyNumber: "POL1011", status: "Rejected", damageCategory: "Property", claimDate: new Date("2026-08-01"), settlementDate: null, amount: 6000 },
    { claimId: 8, policyNumber: "POL1012", status: "Settled", damageCategory: "Vehicle", claimDate: new Date("2026-08-10"), settlementDate: new Date("2026-08-20"), amount: 4500 },
    { claimId: 9, policyNumber: "POL1013", status: "Pending", damageCategory: "Medical", claimDate: new Date("2026-09-05"), settlementDate: null, amount: 3500 },
    { claimId: 10, policyNumber: "POL1014", status: "Settled", damageCategory: "Property", claimDate: new Date("2026-09-15"), settlementDate: new Date("2026-10-05"), amount: 9000 }
]);

// 1. Claims grouped by status
db.claims_notes.aggregate([
    { $match: { status: { $in: ["Settled", "Pending", "Rejected"] } } },
    {
        $group: {
            _id: "$status",
            totalClaims: { $sum: 1 },
            totalAmount: { $sum: "$amount" }
        }
    },
    { $sort: { totalClaims: -1 } }
]);

// 2. Average settlement time in days
db.claims_notes.aggregate([
    { $match: { settlementDate: { $ne: null } } },
    {
        $group: {
            _id: null,
            averageDays: {
                $avg: {
                    $divide: [
                        { $subtract: ["$settlementDate", "$claimDate"] },
                        86400000
                    ]
                }
            }
        }
    },
    { $sort: { averageDays: -1 } }
]);

// 3. Top three damage categories
db.claims_notes.aggregate([
    { $match: { damageCategory: { $exists: true } } },
    {
        $group: {
            _id: "$damageCategory",
            totalClaims: { $sum: 1 },
            totalAmount: { $sum: "$amount" }
        }
    },
    { $sort: { totalClaims: -1 } },
    { $limit: 3 }
]);
