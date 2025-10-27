USE SKSNationalBank;
GO
SET NOCOUNT ON;
GO

/* 1) GetAllBranches
   Purpose: Quick list of every branch with its deposits and loans.*/

CREATE OR ALTER PROCEDURE dbo.GetAllBranches
AS
BEGIN
    SELECT Branch_ID, Branch_Name, Branch_City, Total_Deposits, Total_Loan
    FROM dbo.Branch
    ORDER BY Branch_Name;
END
GO
-- Test
EXEC dbo.GetAllBranches;
GO


/*  2) GetEmployeeDetails
   Purpose: For a given employee, show their name, job title,
            start date, and their manager’s name (if any).*/

CREATE OR ALTER PROCEDURE dbo.GetEmployeeDetails
    @EmployeeID INT
AS
BEGIN
    SELECT  e.Employee_ID,
            e.First_Name + ' ' + e.Last_Name AS EmployeeName,
            et.Type_Name AS JobTitle,
            e.Start_Date,
            COALESCE(m.First_Name + ' ' + m.Last_Name, '(no manager)') AS ManagerName
    FROM dbo.Employees e
    INNER JOIN dbo.EmployeeType et ON et.Type_ID = e.Type_ID
    LEFT  JOIN dbo.Employees    m ON m.Employee_ID = e.Manager_ID
    WHERE e.Employee_ID = @EmployeeID;
END
GO
-- Test
EXEC dbo.GetEmployeeDetails @EmployeeID = 2;
GO


/* 3) GetCustomersByEmployee
   Purpose: List all customers served by one employee (advisor).*/

CREATE OR ALTER PROCEDURE dbo.GetCustomersByEmployee
    @EmployeeID INT
AS
BEGIN
    SELECT c.Customer_ID,
           c.First_Name + ' ' + c.Last_Name AS CustomerName
    FROM dbo.EmployeeCustomer ec
    INNER JOIN dbo.Customer c ON c.Customer_ID = ec.Customer_ID
    WHERE ec.Employee_ID = @EmployeeID
    ORDER BY CustomerName;
END
GO
-- Test
EXEC dbo.GetCustomersByEmployee @EmployeeID = 2;
GO


/* 4) GetCustomerAccountSummary
   Purpose: For one customer, list all their accounts and balances,
            then return a simple total across those accounts.*/

CREATE OR ALTER PROCEDURE dbo.GetCustomerAccountSummary
    @CustomerID INT
AS
BEGIN
    -- List each account the customer is tied to (primary or joint)
    SELECT ah.Account_ID,
           a.Branch_ID,
           a.Account_Balance,
           a.Last_Access_Date,
           ah.Holder_ID
    FROM dbo.AccountHolders ah
    INNER JOIN dbo.Accounts a ON a.Account_ID = ah.Account_ID
    WHERE ah.Customer_ID = @CustomerID
    ORDER BY ah.Account_ID;

    -- Quick total balance across those accounts
    SELECT SUM(a.Account_Balance) AS TotalBalance
    FROM dbo.AccountHolders ah
    INNER JOIN dbo.Accounts a ON a.Account_ID = ah.Account_ID
    WHERE ah.Customer_ID = @CustomerID;
END
GO
-- Test
EXEC dbo.GetCustomerAccountSummary @CustomerID = 1;
GO


/*5) GetBranchAccounts
   Purpose: Show all accounts that belong to a specific branch.*/

CREATE OR ALTER PROCEDURE dbo.GetBranchAccounts
    @BranchID INT
AS
BEGIN
    SELECT a.Account_ID,
           b.Branch_Name,
           a.Account_Balance,
           a.Last_Access_Date
    FROM dbo.Accounts a
    INNER JOIN dbo.Branch b ON b.Branch_ID = a.Branch_ID
    WHERE a.Branch_ID = @BranchID
    ORDER BY a.Account_ID;
END
GO
-- Test
EXEC dbo.GetBranchAccounts @BranchID = 1;
GO


/*6) GetLoanDetails
   Purpose: For a given loan, show the branch, amount, start date,
            and the borrower name(s). One row per borrower.*/

CREATE OR ALTER PROCEDURE dbo.GetLoanDetails
    @LoanID INT
AS
BEGIN
    SELECT  l.Loan_ID,
            b.Branch_Name,
            l.Loan_Amount,
            l.Start_Date,
            c.Customer_ID,
            c.First_Name + ' ' + c.Last_Name AS BorrowerName
    FROM dbo.Loan l
    INNER JOIN dbo.Branch b         ON b.Branch_ID = l.Branch_ID
    INNER JOIN dbo.CustomerLoans cl ON cl.Loan_ID  = l.Loan_ID
    INNER JOIN dbo.Customer c       ON c.Customer_ID = cl.Customer_ID
    WHERE l.Loan_ID = @LoanID
    ORDER BY BorrowerName;
END
GO
-- Test
EXEC dbo.GetLoanDetails @LoanID = 1;
GO


/* 7) GetLoanPayments
   Purpose: Show the full payment history for a loan,
            then a quick total paid so far.*/

CREATE OR ALTER PROCEDURE dbo.GetLoanPayments
    @LoanID INT
AS
BEGIN
    -- Payment list in date order
    SELECT lp.Payment_No,
           lp.Payment_Date,
           lp.Amount
    FROM dbo.LoanPayments lp
    WHERE lp.Loan_ID = @LoanID
    ORDER BY lp.Payment_Date;

    -- Total paid
    SELECT SUM(lp.Amount) AS TotalPaid
    FROM dbo.LoanPayments lp
    WHERE lp.Loan_ID = @LoanID;
END
GO
-- Test
EXEC dbo.GetLoanPayments @LoanID = 1;
GO


/*8) GetOverdraftHistory
   Purpose: Show overdraft records for amounts >= a threshold,
            newest first. Helpful for spotting bigger events.*/

CREATE OR ALTER PROCEDURE dbo.GetOverdraftHistory
    @MinAmount DECIMAL(18,2)
AS
BEGIN
    SELECT o.Account_ID,
           o.Date,
           o.Amount,
           o.Check_Number
    FROM dbo.Overdraft o
    WHERE o.Amount >= @MinAmount
    ORDER BY o.Date DESC, o.Amount DESC;
END
GO
-- Test
EXEC dbo.GetOverdraftHistory @MinAmount = 75.00;
GO


/* 9) fn_TotalBalanceForCustomer (Scalar UDF)
   Purpose: Return a single number = total of all balances
            across accounts linked to the given customer.*/

CREATE OR ALTER FUNCTION dbo.fn_TotalBalanceForCustomer
(
    @CustomerID INT
)
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @total DECIMAL(18,2);

    SELECT @total = SUM(a.Account_Balance)
    FROM dbo.AccountHolders ah
    INNER JOIN dbo.Accounts a ON a.Account_ID = ah.Account_ID
    WHERE ah.Customer_ID = @CustomerID;

    RETURN ISNULL(@total, 0);
END
GO
-- Test
SELECT dbo.fn_TotalBalanceForCustomer(1) AS TotalForCustomer1;
GO


/* 10) GetBranchPerformanceSummary
   Purpose: One row per branch with:
            - Total_Deposits & Total_Loan (stored on Branch)
            - Avg account balance (computed)
            - How many accounts the branch has */

CREATE OR ALTER PROCEDURE dbo.GetBranchPerformanceSummary
AS
BEGIN
    SELECT  b.Branch_ID,
            b.Branch_Name,
            b.Total_Deposits,
            b.Total_Loan,
            AVG(CAST(a.Account_Balance AS DECIMAL(18,2))) AS AvgAccountBalance,
            COUNT(a.Account_ID)                           AS AccountCount
    FROM dbo.Branch b
    LEFT JOIN dbo.Accounts a ON a.Branch_ID = b.Branch_ID
    GROUP BY b.Branch_ID, b.Branch_Name, b.Total_Deposits, b.Total_Loan
    ORDER BY b.Branch_Name;
END
GO
-- Test
EXEC dbo.GetBranchPerformanceSummary;
GO
