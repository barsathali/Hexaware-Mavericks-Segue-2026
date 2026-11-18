// DAY 7 - SET 1
// LOGISTICS SHIPMENT ANALYSIS
// MongoDB 8.0

use("NexoraLogisticsMongo");

// Clear old collections before inserting sample data
db.shipments.drop();
db.delivery_events.drop();
db.customers.drop();
db.carriers.drop();

// 1. CUSTOMER COLLECTION

db.customers.insertMany([
    { customerId: 1, customerName: "Aarav Traders", city: "Chennai" },
    { customerId: 2, customerName: "Bright Stores", city: "Bengaluru" },
    { customerId: 3, customerName: "City Mart", city: "Hyderabad" },
    { customerId: 4, customerName: "Delta Retail", city: "Mumbai" }
]);

// 2. CARRIER COLLECTION

db.carriers.insertMany([
    { carrierId: 1, carrierName: "SwiftMove" },
    { carrierId: 2, carrierName: "RoadRunner" },
    { carrierId: 3, carrierName: "BlueDartline" }
]);

// 3. SHIPMENT COLLECTION

db.shipments.insertMany([
    {
        shipmentId: 1001,
        trackingNumber: "NX1001",
        customerId: 1,
        carrierId: 1,
        originHub: "Chennai Central",
        destinationHub: "Bengaluru Hub",
        promisedDelivery: ISODate("2026-10-03"),
        actualDelivery: ISODate("2026-10-06"),
        shippingCost: 850,
        status: "Delivered"
    },
    {
        shipmentId: 1002,
        trackingNumber: "NX1002",
        customerId: 2,
        carrierId: 2,
        originHub: "Bengaluru Hub",
        destinationHub: "Hyderabad Hub",
        promisedDelivery: ISODate("2026-10-04"),
        actualDelivery: ISODate("2026-10-04"),
        shippingCost: 620,
        status: "Delivered"
    },
    {
        shipmentId: 1003,
        trackingNumber: "NX1003",
        customerId: 3,
        carrierId: 1,
        originHub: "Hyderabad Hub",
        destinationHub: "Mumbai Hub",
        promisedDelivery: ISODate("2026-10-05"),
        actualDelivery: ISODate("2026-10-09"),
        shippingCost: 1100,
        status: "Delivered"
    },
    {
        shipmentId: 1004,
        trackingNumber: "NX1004",
        customerId: 4,
        carrierId: 3,
        originHub: "Mumbai Hub",
        destinationHub: "Pune Hub",
        promisedDelivery: ISODate("2026-10-07"),
        actualDelivery: ISODate("2026-10-07"),
        shippingCost: 740,
        status: "Delivered"
    },
    {
        shipmentId: 1005,
        trackingNumber: "NX1005",
        customerId: 1,
        carrierId: 2,
        originHub: "Chennai Central",
        destinationHub: "Delhi Hub",
        promisedDelivery: ISODate("2026-10-08"),
        actualDelivery: ISODate("2026-10-12"),
        shippingCost: 980,
        status: "Delivered"
    }
]);

// 4. DELIVERY EVENTS COLLECTION

db.delivery_events.insertMany([
    {
        eventId: 1,
        shipmentId: 1001,
        eventType: "Picked Up",
        eventDate: ISODate("2026-10-01T09:00:00Z"),
        location: "Chennai Central"
    },
    {
        eventId: 2,
        shipmentId: 1001,
        eventType: "Delivered",
        eventDate: ISODate("2026-10-06T11:15:00Z"),
        location: "Bengaluru Hub"
    },
    {
        eventId: 3,
        shipmentId: 1002,
        eventType: "Delivered",
        eventDate: ISODate("2026-10-04T16:00:00Z"),
        location: "Hyderabad Hub"
    },
    {
        eventId: 4,
        shipmentId: 1003,
        eventType: "Delayed",
        eventDate: ISODate("2026-10-07T12:00:00Z"),
        location: "Mumbai Hub"
    },
    {
        eventId: 5,
        shipmentId: 1003,
        eventType: "Delivered",
        eventDate: ISODate("2026-10-09T17:20:00Z"),
        location: "Mumbai Hub"
    }
]);

// PIPELINE 1: Shipments with delivery events

db.shipments.aggregate([
    {
        $lookup: {
            from: "delivery_events",
            localField: "shipmentId",
            foreignField: "shipmentId",
            as: "deliveryEvents"
        }
    },
    {
        $project: {
            _id: 0,
            trackingNumber: 1,
            originHub: 1,
            destinationHub: 1,
            status: 1,
            deliveryEvents: 1
        }
    },
    {
        $sort: { trackingNumber: 1 }
    }
]);

// PIPELINE 2: Customers with their shipments

db.customers.aggregate([
    {
        $lookup: {
            from: "shipments",
            localField: "customerId",
            foreignField: "customerId",
            as: "shipments"
        }
    },
    {
        $project: {
            _id: 0,
            customerName: 1,
            city: 1,
            shipmentCount: { $size: "$shipments" },
            shipments: 1
        }
    },
    {
        $sort: { customerName: 1 }
    }
]);

// PIPELINE 3: Carriers with average delivery delay

db.carriers.aggregate([
    {
        $lookup: {
            from: "shipments",
            localField: "carrierId",
            foreignField: "carrierId",
            as: "shipments"
        }
    },
    {
        $project: {
            _id: 0,
            carrierName: 1,
            shipmentCount: { $size: "$shipments" },
            averageDelayDays: {
                $avg: {
                    $map: {
                        input: {
                            $filter: {
                                input: "$shipments",
                                as: "s",
                                cond: {
                                    $and: [
                                        { $ne: ["$$s.actualDelivery", null] },
                                        { $ne: ["$$s.promisedDelivery", null] }
                                    ]
                                }
                            }
                        },
                        as: "s",
                        in: {
                            $dateDiff: {
                                startDate: "$$s.promisedDelivery",
                                endDate: "$$s.actualDelivery",
                                unit: "day"
                            }
                        }
                    }
                }
            }
        }
    },
    {
        $sort: { averageDelayDays: -1 }
    }
]);9