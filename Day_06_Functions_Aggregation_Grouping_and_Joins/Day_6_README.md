# Day 6 – Functions, Aggregation, Grouping and Joins

This folder contains the Day 6 assignment work for the **Hexaware Mavericks Segue 2026 – Python Track**. The tasks focus on SQL reporting queries, SQL functions, grouping and aggregation, joins, and MongoDB aggregation pipelines across three business domains.

## Folder structure

```text
Day_6/
├── README.md
├── SQL_Server/
│   ├── Set1_Retail_Sales.sql
│   ├── Set2_Insurance_Reporting.sql
│   └── Set3_Telecom_Reporting.sql
└── MongoDB/
    ├── Set1_Retail_Sales.js
    ├── Set2_Insurance_Reporting.js
    └── Set3_Telecom_Reporting.js
```

## Assignment sets

### Set 1 – Retail Sales Reporting

**Problem:** Prepare retail sales reports to analyse product revenue, monthly sales, customer orders, basket value and payment information.

**Approach:**
- Created relational tables for customers, products, orders, order items and payments.
- Wrote reporting queries using joins, grouping, aggregate functions, filtering and sorting.
- Analysed top products by revenue, monthly sales, frequent customers, average basket value, unpaid orders, customers without orders, category revenue share and the highest-sales day.
- Used SQL functions such as `UPPER`, `CONCAT`, `DATEDIFF`, `FORMAT` and `ROUND`.
- Created MongoDB aggregation pipelines for monthly sales, top products and average basket value.

### Set 2 – Insurance Policy Reporting

**Problem:** Generate reports about insurance policies, premiums, customers, claims, agents and claim settlement.

**Approach:**
- Created relational tables for customers, insurance products, agents, policies and claims.
- Wrote queries to identify policies expiring within the next 30 days, premium by product, customers with multiple active policies, claim ratios, policies without claims, average premium by age band, monthly new policies and top agents.
- Used date, string and conditional functions, including `DATEADD`, `DATEDIFF` and `CASE`.
- Demonstrated the difference between `WHERE` and `HAVING`.
- Created MongoDB aggregation pipelines to analyse claims by status, average settlement time and common damage categories.

### Set 3 – Telecom Usage and Billing

**Problem:** Analyse telecom usage, subscriber plans, billing, revenue and network activity.

**Approach:**
- Created relational tables for subscribers, plans, call records and invoices.
- Wrote reports for minutes used by plan, data-limit excess, monthly revenue, overdue invoices, subscribers without usage, ARPU by circle, plan popularity and top data consumers.
- Used SQL functions and conditional logic to format invoice details and determine payment status.
- Demonstrated how `NULL` values affect aggregate functions such as `SUM` and `AVG`.
- Created MongoDB aggregation pipelines for hourly usage, average session length and the busiest cell tower.

## Technologies and concepts

- **SQL Server:** joins, aggregate functions, `GROUP BY`, `HAVING`, filtering, sorting, date functions, string functions, conditional expressions and NULL handling.
- **MongoDB:** aggregation pipelines using stages such as `$match`, `$group` and `$sort`.
- **Reporting:** sales analysis, insurance reporting, telecom usage and billing analysis.

## How to run

1. Open the required `.sql` file in SQL Server Management Studio or Azure Data Studio and connect to your SQL Server instance.
2. Run each SQL script against a fresh environment, because the scripts create databases and tables.
3. Open the corresponding `.js` file in MongoDB Compass or `mongosh`, connect to MongoDB, and run the script.
4. Review the query results and aggregation output for each assignment set.

**Note:** Run each setup script only once in a fresh database/collection environment unless you first remove the objects it creates. The README describes the implementation approach; verify execution in your own SQL Server and MongoDB environment before reporting that a script has been tested.
