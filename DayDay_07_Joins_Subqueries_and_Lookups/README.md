# Day 7 -- Joins, Subqueries and Lookups

**Student:** BARSATH ALI N

## Project overview

This project demonstrates relational joins and subqueries in Microsoft
SQL Server and document joins using MongoDB aggregation `$lookup`. It
contains three business case studies:

1.  Set 1 -- Logistics Shipment Analysis
2.  Set 2 -- Bank Loan Portfolio
3.  Set 3 -- Retail Returns and Refunds

## Technology stack

-   Microsoft SQL Server 2022
-   MongoDB 7.0
-   Docker Engine
-   Visual Studio Code
-   SQL Server (mssql) and MongoDB for VS Code extensions

## Folder structure

``` text
DayDay_07_Joins_Subqueries_and_Lookups/
├── SQL_Server/
│   ├── Set1_Logistics.sql
│   ├── Set2_Bank_Loans.sql
│   └── Set3_Retail_Returns.sql
├── MongoDB/
│   ├── Set1_Logistics.js
│   ├── Set2_Bank_Loans.js
│   └── Set3_Retail_Returns.js
├── Day_7_Documentation.md
└── README.md
```

MongoDB Playground files are execution workspaces. Keep the reusable
`.js` scripts in the `MongoDB/` folder.

## Set 1 -- Logistics Shipment Analysis

**Databases:** `NexoraLogisticsDB` (SQL Server), `NexoraLogisticsMongo`
(MongoDB).

SQL tables: `Hubs`, `Customers`, `Carriers`, `Employees`, `Shipments`,
and `DeliveryEvents`.

The ten SQL business queries cover delayed shipments, hubs without
outbound shipments, employee-supervisor relationships (self join),
outbound shipment counts, shipment/customer/hub details, customers who
shipped to every hub (`NOT EXISTS`), carrier delay comparisons (CTE and
`ALL`), customers with shipments, carriers handling delayed shipments,
and second-highest distinct shipping cost per hub (`OUTER APPLY`).
Additional examples demonstrate `IN`, `EXISTS`, `ANY`, and `ALL`.

MongoDB collections: `customers`, `carriers`, `shipments`, and
`delivery_events`. Three pipelines join shipments to delivery events,
customers to shipments, and carriers to shipment delay information.

**Verified MongoDB counts:** Customers 4, Carriers 3, Shipments 5,
Delivery Events 5; 17 documents total.

## Set 2 -- Bank Loan Portfolio

**Databases:** `NexoraBankLoansDB` (SQL Server), `NexoraBankLoansMongo`
(MongoDB).

SQL tables: `Branches`, `Customers`, `Loans`, `LoanGuarantors`,
`Repayments`, and `LoanInstallments`.

The ten SQL queries cover overdue installments, customers with loans in
multiple branches, guarantors who are also borrowers, branches without
loans, loan details with customer and branch data, branch exposure using
a correlated subquery and a join, loans without recent repayments,
branch maximum-loan comparisons using a CTE, and `ALL` comparisons.
Date-based examples use 18 November 2026 as the reference date.

MongoDB collections: `customers`, `branches`, `loans`, and `repayments`.
Three pipelines join loans to customers, customers to loans and total
exposure, and loans to their latest repayment.

**Verified MongoDB counts:** Customers 6, Branches 6, Loans 10,
Repayments 10; 32 documents total.

## Set 3 -- Retail Returns and Refunds

**Databases:** `NexoraRetailReturnsDB` (SQL Server),
`NexoraRetailReturnsMongo` (MongoDB).

SQL tables: `Customers`, `Products`, `Orders`, `OrderItems`,
`ReturnReasons`, `Returns`, and `Refunds`.

The ten SQL queries cover return details with customer and product
information, products never returned, customer return counts, refund
totals by method, return counts by reason, customers with returns
(`EXISTS`), refunds above average, products with above-average returned
quantities, orders containing returned products, and return/refund
details.

MongoDB collections: `customers`, `products`, `orders`, `returns`,
`return_reasons`, and `refunds`. Three pipelines join returns to
customer/order details, returns to product/reason details, and returns
to refund information.

**Verified MongoDB counts:** Customers 6, Products 8, Orders 10, Returns
10, Return Reasons 5, Refunds 7; 46 documents total.

## How to run SQL scripts

1.  Start the SQL Server Docker container.
2.  Open the relevant `.sql` file in VS Code.
3.  Connect through the SQL Server extension to `localhost,1433`.
4.  Save the file, select the full script, and execute it (F5 or the
    Execute command).
5.  Inspect both Results and Messages.

## How to run MongoDB scripts

1.  Start the MongoDB container.
2.  Connect using `mongodb://localhost:27018`.
3.  Open the relevant `.js` script.
4.  Copy it into a dedicated MongoDB Playground or execute it in a
    connected `mongosh` session.
5.  Run the script and inspect aggregation results and collection-count
    output.
6.  Keep one Playground per set to avoid mixing execution workspaces.

## Concepts demonstrated

-   **INNER JOIN:** returns rows with matches in both sources.
-   **LEFT JOIN:** preserves all rows from the left source, including
    unmatched rows.
-   **FULL OUTER JOIN:** preserves matched and unmatched rows from both
    sources.
-   **SELF JOIN:** joins a table to itself, used for employee-supervisor
    data.
-   **Subqueries:** nested and correlated queries that provide values or
    row sets to an outer query.
-   **EXISTS / NOT EXISTS:** test whether related rows exist or do not
    exist.
-   **IN / ANY / ALL:** compare values against a set.
-   **CTE:** names an intermediate query result.
-   **OUTER APPLY:** evaluates a related table expression for each outer
    row.
-   **MongoDB `$lookup`:** performs a left outer join between
    collections; pipeline lookups can use `let`, `$expr`, sorting, and
    limiting.

## Verification summary

  -----------------------------------------------------------------------
  Set               SQL result sets            MongoDB  MongoDB documents
                          displayed        collections 
  -------------- ------------------ ------------------ ------------------
  Logistics                      14                  4                 17

  Bank Loans                     10                  4                 32

  Retail Returns                 10                  6                 46
  -----------------------------------------------------------------------

The SQL result-set counts describe result grids observed in the editor,
not table counts.

## Important notes

-   Each SQL script drops and recreates its own tables before inserting
    sample data. Re-running it resets those tables in its database.
-   Each MongoDB script drops and recreates its own collections before
    inserting sample documents. Re-running it resets those collections
    in its database.
-   Check the selected database and connection before execution.
-   Keep the three sets in separate files. Avoid duplicate filenames and
    filenames with leading spaces.
-   Capture execution screenshots if required for submission.
