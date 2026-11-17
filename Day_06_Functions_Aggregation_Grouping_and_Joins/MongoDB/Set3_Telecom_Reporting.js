
// Day 6 - Set 3: Telecom Usage

use("NexoraTelecomMongo");

// Create usage collection
if (db.getCollectionNames().includes("usage_events")) {
    db.usage_events.drop();
}

db.createCollection("usage_events");

// Add usage records
db.usage_events.insertMany([
    { subscriberId: 1, tower: "Tower-A", startTime: new Date("2026-11-01T09:10:00Z"), durationMinutes: 20, dataUsedGB: 1.5 },
    { subscriberId: 2, tower: "Tower-B", startTime: new Date("2026-11-01T09:25:00Z"), durationMinutes: 15, dataUsedGB: 2.0 },
    { subscriberId: 3, tower: "Tower-A", startTime: new Date("2026-11-01T09:40:00Z"), durationMinutes: 30, dataUsedGB: 3.5 },
    { subscriberId: 4, tower: "Tower-C", startTime: new Date("2026-11-01T10:05:00Z"), durationMinutes: 10, dataUsedGB: 1.0 },
    { subscriberId: 1, tower: "Tower-A", startTime: new Date("2026-11-01T10:20:00Z"), durationMinutes: 25, dataUsedGB: 2.5 },
    { subscriberId: 5, tower: "Tower-B", startTime: new Date("2026-11-01T10:35:00Z"), durationMinutes: 40, dataUsedGB: 4.0 },
    { subscriberId: 6, tower: "Tower-C", startTime: new Date("2026-11-01T11:10:00Z"), durationMinutes: 12, dataUsedGB: 1.2 },
    { subscriberId: 2, tower: "Tower-A", startTime: new Date("2026-11-01T11:25:00Z"), durationMinutes: 18, dataUsedGB: 2.2 },
    { subscriberId: 7, tower: "Tower-B", startTime: new Date("2026-11-01T11:45:00Z"), durationMinutes: 35, dataUsedGB: 3.8 },
    { subscriberId: 8, tower: "Tower-A", startTime: new Date("2026-11-01T12:05:00Z"), durationMinutes: 22, dataUsedGB: 2.1 },
    { subscriberId: 3, tower: "Tower-C", startTime: new Date("2026-11-01T12:20:00Z"), durationMinutes: 28, dataUsedGB: 3.0 },
    { subscriberId: 9, tower: "Tower-B", startTime: new Date("2026-11-01T12:40:00Z"), durationMinutes: 16, dataUsedGB: 1.8 },
    { subscriberId: 10, tower: "Tower-A", startTime: new Date("2026-11-01T13:00:00Z"), durationMinutes: 32, dataUsedGB: 3.2 },
    { subscriberId: 4, tower: "Tower-C", startTime: new Date("2026-11-01T13:15:00Z"), durationMinutes: 14, dataUsedGB: 1.4 },
    { subscriberId: 5, tower: "Tower-B", startTime: new Date("2026-11-01T13:35:00Z"), durationMinutes: 45, dataUsedGB: 4.5 }
]);

// 1. Hourly usage
db.usage_events.aggregate([
    {
        $group: {
            _id: {
                $dateTrunc: {
                    date: "$startTime",
                    unit: "hour"
                }
            },
            totalUsageGB: { $sum: "$dataUsedGB" },
            totalSessions: { $sum: 1 }
        }
    },
    { $sort: { _id: 1 } }
]);

// 2. Average session length
db.usage_events.aggregate([
    {
        $group: {
            _id: null,
            averageSessionMinutes: {
                $avg: "$durationMinutes"
            }
        }
    }
]);

// 3. Busiest cell tower
db.usage_events.aggregate([
    {
        $group: {
            _id: "$tower",
            totalSessions: { $sum: 1 },
            totalUsageGB: { $sum: "$dataUsedGB" }
        }
    },
    { $sort: { totalSessions: -1 } },
    { $limit: 1 }
]);
