// Day 5 - Set 1: Retail Reviews

use("NexoraRetailMongo");

// Create collection with validation
if (db.getCollectionNames().includes("customer_reviews")) {
    db.customer_reviews.drop();
}

db.createCollection("customer_reviews", {
    validator: {
        $jsonSchema: {
            bsonType: "object",
            required: ["sku", "customerName", "rating", "reviewText"],
            properties: {
                sku: { bsonType: "string" },
                customerName: { bsonType: "string" },
                rating: { bsonType: "int", minimum: 1, maximum: 5 },
                reviewText: { bsonType: "string" },
                verified: { bsonType: "bool" },
                reviewDate: { bsonType: "date" }
            }
        }
    }
});

// Add sample reviews
db.customer_reviews.insertMany([
    // Keep all 10 review records from the previous code here
]);

// View all reviews
db.customer_reviews.find();

// Update one review
db.customer_reviews.updateOne(
    { sku: "NX-ELE-001", customerName: "Arun Kumar" },
    {
        $set: {
            rating: NumberInt(4),
            reviewText: "Updated review: Excellent display and performance."
        }
    }
);

// Remove one review
db.customer_reviews.deleteOne({
    sku: "NX-AUT-009",
    customerName: "Vijay S"
});