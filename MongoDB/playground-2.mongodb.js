
use("NexoraBankLoansMongo");

// Clear existing collections
db.loans.drop();
db.customers.drop();
db.branches.drop();
db.repayments.drop();

// 1. CUSTOMERS
db.customers.insertMany([
  { customerId: 1, customerName: "Arun Kumar", city: "Chennai" },
  { customerId: 2, customerName: "Priya Sharma", city: "Bengaluru" },
  { customerId: 3, customerName: "Rahul Verma", city: "Hyderabad" },
  { customerId: 4, customerName: "Meena Raj", city: "Mumbai" },
  { customerId: 5, customerName: "Karthik Das", city: "Pune" },
  { customerId: 6, customerName: "Divya Nair", city: "Delhi" }
]);

// 2. BRANCHES
db.branches.insertMany([
  { branchId: 1, branchName: "Chennai Main", city: "Chennai" },
  { branchId: 2, branchName: "Bengaluru Branch", city: "Bengaluru" },
  { branchId: 3, branchName: "Hyderabad Branch", city: "Hyderabad" },
  { branchId: 4, branchName: "Mumbai Central", city: "Mumbai" },
  { branchId: 5, branchName: "Delhi Branch", city: "Delhi" },
  { branchId: 6, branchName: "Pune Branch", city: "Pune" }
]);

// 3. LOANS
db.loans.insertMany([
  { loanId: 1, customerId: 1, branchId: 1, loanType: "Home Loan", loanAmount: 2500000, status: "Active" },
  { loanId: 2, customerId: 2, branchId: 2, loanType: "Personal Loan", loanAmount: 500000, status: "Active" },
  { loanId: 3, customerId: 3, branchId: 3, loanType: "Car Loan", loanAmount: 800000, status: "Active" },
  { loanId: 4, customerId: 4, branchId: 4, loanType: "Home Loan", loanAmount: 3000000, status: "Active" },
  { loanId: 5, customerId: 5, branchId: 6, loanType: "Education Loan", loanAmount: 600000, status: "Active" },
  { loanId: 6, customerId: 6, branchId: 5, loanType: "Personal Loan", loanAmount: 400000, status: "Active" },
  { loanId: 7, customerId: 1, branchId: 2, loanType: "Car Loan", loanAmount: 900000, status: "Active" },
  { loanId: 8, customerId: 3, branchId: 4, loanType: "Business Loan", loanAmount: 1500000, status: "Active" },
  { loanId: 9, customerId: 5, branchId: 1, loanType: "Personal Loan", loanAmount: 350000, status: "Closed" },
  { loanId: 10, customerId: 2, branchId: 3, loanType: "Education Loan", loanAmount: 700000, status: "Active" }
]);

// 4. REPAYMENTS
db.repayments.insertMany([
  { repaymentId: 1, loanId: 1, repaymentDate: ISODate("2026-09-01"), amountPaid: 25000 },
  { repaymentId: 2, loanId: 1, repaymentDate: ISODate("2026-10-01"), amountPaid: 25000 },
  { repaymentId: 3, loanId: 2, repaymentDate: ISODate("2026-10-05"), amountPaid: 12000 },
  { repaymentId: 4, loanId: 3, repaymentDate: ISODate("2026-08-15"), amountPaid: 18000 },
  { repaymentId: 5, loanId: 4, repaymentDate: ISODate("2026-09-10"), amountPaid: 30000 },
  { repaymentId: 6, loanId: 5, repaymentDate: ISODate("2026-10-12"), amountPaid: 10000 },
  { repaymentId: 7, loanId: 6, repaymentDate: ISODate("2026-07-20"), amountPaid: 9000 },
  { repaymentId: 8, loanId: 7, repaymentDate: ISODate("2026-09-15"), amountPaid: 15000 },
  { repaymentId: 9, loanId: 8, repaymentDate: ISODate("2026-08-25"), amountPaid: 22000 },
  { repaymentId: 10, loanId: 10, repaymentDate: ISODate("2026-10-01"), amountPaid: 11000 }
]);

// 5. LOOKUP 1: Loans with customer details
db.loans.aggregate([
  {
    $lookup: {
      from: "customers",
      localField: "customerId",
      foreignField: "customerId",
      as: "customerDetails"
    }
  },
  { $unwind: "$customerDetails" },
  {
    $project: {
      _id: 0,
      loanId: 1,
      loanType: 1,
      loanAmount: 1,
      customerName: "$customerDetails.customerName",
      customerCity: "$customerDetails.city"
    }
  }
]);

// 6. LOOKUP 2: Customers with loans and total loan exposure
db.customers.aggregate([
  {
    $lookup: {
      from: "loans",
      localField: "customerId",
      foreignField: "customerId",
      as: "loanDetails"
    }
  },
  {
    $project: {
      _id: 0,
      customerName: 1,
      city: 1,
      totalLoans: { $size: "$loanDetails" },
      totalLoanExposure: { $sum: "$loanDetails.loanAmount" },
      loanDetails: 1
    }
  }
]);

// 7. LOOKUP 3: Loans with their latest repayment
db.loans.aggregate([
  {
    $lookup: {
      from: "repayments",
      let: { currentLoanId: "$loanId" },
      pipeline: [
        {
          $match: {
            $expr: { $eq: ["$loanId", "$$currentLoanId"] }
          }
        },
        { $sort: { repaymentDate: -1 } },
        { $limit: 1 }
      ],
      as: "latestRepayment"
    }
  },
  {
    $project: {
      _id: 0,
      loanId: 1,
      loanType: 1,
      loanAmount: 1,
      latestRepayment: 1
    }
  }
]);

// 8. VERIFY COLLECTION COUNTS
printjson({
  Customers: db.customers.countDocuments(),
  Branches: db.branches.countDocuments(),
  Loans: db.loans.countDocuments(),
  Repayments: db.repayments.countDocuments()
});
