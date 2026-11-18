# Day 5 – Database Design, Normalisation and Data Definition

This folder contains the Day 5 assignment work for the **Hexaware Mavericks Segue 2026 – Python Track**. The tasks cover relational database design and MongoDB document operations across three business domains.

## Folder structure

```text
Day_5/
├── README.md
├── SQL_Server/
│   ├── Set1_Retail_Inventory.sql
│   ├── Set2_Bank_Accounts.sql
│   └── Set3_Hospital_Records.sql
├── MongoDB/
│   ├── Set1_Retail_Reviews.js
│   ├── Set2_Bank_Activity.js
│   └── Set3_Hospital_Records.js
└── ER_Diagrams/
    └── Day5_Day6_ER_Diagrams.pdf
```

## Assignment sets

### Set 1 – Retail Inventory and Product Reviews

**Problem:** Organise retail inventory data and customer product reviews while reducing data redundancy and maintaining data integrity.

**Approach:**
- Designed relational tables for categories, suppliers, warehouses, products and inventory.
- Applied normalisation principles up to 3NF and defined primary keys, foreign keys and integrity constraints.
- Added sample records and demonstrated constraint validation, updates and deletions.
- Created a MongoDB reviews collection with schema validation and demonstrated insert, find, update and delete operations.

### Set 2 – Bank Branch Accounts and Customer Activity

**Problem:** Structure banking data for customers, branches, managers, accounts and customer-account relationships, and store customer activity events.

**Approach:**
- Identified entities and relationships and considered candidate and composite keys.
- Designed SQL Server tables with identity columns, keys, constraints and referential actions.
- Added sample data and demonstrated filtering and DELETE, TRUNCATE and DROP operations.
- Created a capped MongoDB activity collection, inserted activity documents and queried recent login events.

### Set 3 – Hospital Patient Records and Clinical Notes

**Problem:** Organise hospital patient, doctor, department, visit and billing information, while supporting flexible clinical notes.

**Approach:**
- Designed separate relational tables for departments, patients, doctors, visits and billing.
- Applied normalisation and defined primary keys, foreign keys and other constraints.
- Demonstrated table alteration, renaming, constraint removal and data queries.
- Created a MongoDB clinical-notes collection with document validation and examples of variable-shaped notes.

## Technologies and concepts

- **SQL Server:** relational modelling, normalisation, 3NF/BCNF concepts, primary and foreign keys, constraints, identity columns, DDL and DML operations.
- **MongoDB:** collections, documents, JSON Schema validation, capped collections and CRUD operations.
- **ER modelling:** entities, attributes and relationships for each assignment set.

## How to run

1. Open the required `.sql` file in SQL Server Management Studio or Azure Data Studio and connect to your SQL Server instance.
2. Run each SQL script against a fresh environment, because the scripts create databases and tables.
3. Open the corresponding `.js` file in MongoDB Compass or `mongosh`, connect to MongoDB, and run the script.
4. Review the output of the queries and CRUD operations.

**Note:** Run each setup script only once in a fresh database/collection environment unless you first remove the objects it creates. The documentation describes the implementation approach; verify execution in your own SQL Server and MongoDB environment before reporting that a script has been tested.
