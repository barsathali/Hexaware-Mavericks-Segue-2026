
// Day 5 - Set 3: Hospital Clinical Notes

use("NexoraHospitalMongo");

// Create collection with validation
if (db.getCollectionNames().includes("clinical_notes")) {
    db.clinical_notes.drop();
}

db.createCollection("clinical_notes", {
    validator: {
        $jsonSchema: {
            bsonType: "object",
            required: ["patientId", "diagnosis"],
            properties: {
                patientId: { bsonType: "string" },
                diagnosis: { bsonType: "string" },
                doctor: { bsonType: "string" },
                notes: { bsonType: "string" },
                medicines: { bsonType: "array" },
                followUpDate: { bsonType: "date" },
                testResults: { bsonType: "object" }
            }
        }
    }
});

// Add notes with different structures
db.clinical_notes.insertMany([
    {
        patientId: "PAT001",
        diagnosis: "Blood Pressure",
        doctor: "Dr. Ravi",
        notes: "Patient needs regular monitoring.",
        medicines: ["Amlodipine"],
        followUpDate: new Date("2026-11-01")
    },
    {
        patientId: "PAT002",
        diagnosis: "Migraine",
        doctor: "Dr. Priya",
        notes: "Patient reported frequent headaches.",
        medicines: ["Pain relief tablets"],
        testResults: {
            bloodTest: "Normal",
            scan: "Not required"
        }
    },
    {
        patientId: "PAT003",
        diagnosis: "Joint Pain",
        doctor: "Dr. Kumar",
        notes: "Physiotherapy recommended.",
        followUpDate: new Date("2026-11-05")
    },
    {
        patientId: "PAT004",
        diagnosis: "Skin Allergy",
        doctor: "Dr. Meena",
        notes: "Apply prescribed cream twice daily.",
        medicines: ["Skin cream"]
    },
    {
        patientId: "PAT005",
        diagnosis: "Fever",
        doctor: "Dr. Anand",
        notes: "Rest and drink enough fluids.",
        medicines: ["Fever medicine"],
        testResults: {
            temperature: "Normal"
        }
    }
]);

// View all clinical notes
db.clinical_notes.find();

// Find notes by diagnosis
db.clinical_notes.find({
    diagnosis: "Migraine"
});
