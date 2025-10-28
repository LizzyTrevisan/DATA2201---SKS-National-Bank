# DATA2201 – Relational Databases Project: SKS National Bank - Group L

## 🚀 CASE STUDY

You are an employee of BVC Technology Group and have been hired by SKS National Bank to build a new database system for their entire banking operations. Here are the requirements given to you from the project liaison at SKS National Bank:</br></br>
SKS National Bank is organized into branches. Each branch is in a particular city and is identified by a unique name. Each branch keeps a total of all the deposits and loan amounts.</br></br>
Bank customers have a name, a customer ID, and a home address. A customer may have a chequing account, a savings account, and may take out loans. Customers may have personal bankers or loan officers that they always work with.</br></br>
Bank employees (including personal bankers and loan officers) have unique employee IDs. Each employee has a manager, a start date, a name, a home address, and a set of locations where they work. A location may be a bank branch or an office that is not in a branch</br></br>
Chequing and savings accounts can be held by more than one customer (for example, spouses can have joint accounts) and a customer can have more than one account. Each account has a balance and the most recent date that the account was accessed by the customer. Savings accounts have an associated interest rate. Chequing accounts keep track of dates, amounts, and check numbers for overdrafts.</br></br>
A loan originates at a particular branch and can be held by one or more customers. The bank tracks the loan amount and payments. A loan payment number does not uniquely identify a particular payment among all loans, but it does identify a particular payment for a specific loan. The date and amount are recorded for each payment.</br></br>

## Project Overview

### PHASES 1 & 2
- **Database Design and Implementation**
- **Advanced Database Operations**

# Phase 1: Database Design and Implementation

Phase 1 is about designing your database and implementing it with initial data and basic features.

## Entity Relationship Diagram

Create a well-designed and detailed ERD or relational schema that meets all the requirements of the case study above. The ERD or relational schema should include the following information:

- **Tables with names and attributes**
- **Indications of which columns are primary or foreign keys.**
- **Relationships between tables, including ordinality.**
- **Any special constraints that should be noted.**
- **Check each of the entities for normalization to avoid and eliminate anomalies.**


LINK BELOW: </br>
(https://lucid.app/lucidchart/9110e2ea-a1a2-460c-b788-3334b2fe15ab/edit?viewport_loc=563%2C-4955%2C5982%2C2968%2C0_0&invitationId=inv_528b72bf-e646-4658-a96c-45496d095986)

![DATA2201- SKS National Bank.png](https://raw.githubusercontent.com/LizzyTrevisan/DATA2201---SKS-National-Bank/refs/heads/main/Final%20version%20ERD.%20for%20DATA2201-%20%20SKS%20National%20Bank.jpeg)



**Database Creation**

Using the ERD or relational schema, create a database and set of tables. Create an SQL file named “create_database.sql”. This file should perform the following actions:

- **Delete the database if it already exists.**
- **Create the database.**
- **Create all tables based on your design.**
- **Create the appropriate primary and foreign keys.**
- **Create the appropriate constraints and relationships**


## 💾 Database Creation Script – SKS National Bank

Below is the full SQL script that creates the database structure for **SKS National Bank**.

```sql
-- 
USE master;
GO

CREATE DATABASE SKSNationalBank;
GO
 
USE SKSNationalBank;
GO

-- Updated Tables:

-- Location Table
CREATE TABLE Location (
    Location_ID INT PRIMARY KEY NOT NULL IDENTITY(1,1),
    Location_Name VARCHAR(50),
    Location_Address VARCHAR(100) NOT NULL,
    City VARCHAR(100) NOT NULL,
    Is_Branch BIT NOT NULL DEFAULT 0
);

-- Branch Table
CREATE TABLE Branch (
    Branch_ID INT PRIMARY KEY NOT NULL IDENTITY(1,1),
    Branch_Name VARCHAR(50) UNIQUE NOT NULL,
    Branch_City VARCHAR(150) NOT NULL,
    Total_Deposits DECIMAL(18,2) NULL,
    Total_Loan DECIMAL(18,2) NULL,
    Location_ID INT NOT NULL,
    FOREIGN KEY (Location_ID) REFERENCES Location(Location_ID)
);

-- Address Table
CREATE TABLE Address (
    Address_ID INT PRIMARY KEY NOT NULL IDENTITY(1,1),
    Street VARCHAR(200) NULL,
    City VARCHAR(150) NOT NULL,
    Province VARCHAR(100) NOT NULL,
    Postal_Code VARCHAR(100) NOT NULL
);

-- Employee Type Table
CREATE TABLE EmployeeType (
    Type_ID INT PRIMARY KEY NOT NULL IDENTITY(1,1),
    Type_Name VARCHAR(50) NOT NULL
);

-- Employees Table
CREATE TABLE Employees (
    Employee_ID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    First_Name VARCHAR(120) NOT NULL,
    Last_Name VARCHAR(120) NOT NULL,
    Start_Date DATE DEFAULT GETDATE(),
    Type_ID INT NOT NULL,
    Address_ID INT NULL,     
    Manager_ID INT NULL     
);

-- Add foreign keys that reference other tables
ALTER TABLE Employees
ADD CONSTRAINT FK_Type_ID FOREIGN KEY (Type_ID) REFERENCES EmployeeType(Type_ID);

ALTER TABLE Employees
ADD CONSTRAINT FK_Address_ID FOREIGN KEY (Address_ID) REFERENCES Address(Address_ID) ON DELETE SET NULL;

ALTER TABLE Employees
ADD CONSTRAINT FK_Manager FOREIGN KEY (Manager_ID) REFERENCES Employees(Employee_ID) ON DELETE NO ACTION;

-- EmployeeLocation Table
CREATE TABLE EmployeeLocation (
    Employee_ID INT NOT NULL,
    Location_ID INT NOT NULL,
    PRIMARY KEY (Employee_ID, Location_ID),
    FOREIGN KEY (Employee_ID) REFERENCES Employees(Employee_ID),
    FOREIGN KEY (Location_ID) REFERENCES Location(Location_ID)
);

-- Loan Table
CREATE TABLE Loan (
    Loan_ID INT PRIMARY KEY NOT NULL IDENTITY(1,1),
    Branch_ID INT NOT NULL,
    Loan_Amount DECIMAL(18,2) NOT NULL CHECK (Loan_Amount >= 0),
    Start_Date DATE NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (Branch_ID) REFERENCES Branch(Branch_ID)
);

-- LoanPayments Table
CREATE TABLE LoanPayments (
    Loan_ID INT NOT NULL,
    Payment_No INT NOT NULL IDENTITY(1,1),
    Payment_Date DATE DEFAULT GETDATE(),
    Amount DECIMAL(18,2) CHECK (Amount >= 0),
    PRIMARY KEY (Loan_ID, Payment_No),
    FOREIGN KEY (Loan_ID) REFERENCES Loan(Loan_ID)
);

-- HolderRole Table
CREATE TABLE HolderRole (
    Role_ID INT PRIMARY KEY NOT NULL IDENTITY(1,1),
    Role_Description VARCHAR(50) NOT NULL
);

-- Customer Table
CREATE TABLE Customer (
    Customer_ID INT PRIMARY KEY NOT NULL IDENTITY(1,1),
    Address_ID INT  NULL,
    First_Name VARCHAR(50) NOT NULL,
    Last_Name VARCHAR(50) NOT NULL,
    FOREIGN KEY (Address_ID) REFERENCES Address(Address_ID) ON DELETE SET NULL
);

-- EmployeeCustomer Table
CREATE TABLE EmployeeCustomer (
    Employee_ID INT NOT NULL,
    Customer_ID INT NOT NULL,
    PRIMARY KEY (Employee_ID, Customer_ID),
    FOREIGN KEY (Employee_ID) REFERENCES Employees(Employee_ID),
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID)
);

-- CustomerLoans Table
CREATE TABLE CustomerLoans (
    Loan_ID INT NOT NULL,
    Customer_ID INT NOT NULL,
    PRIMARY KEY (Loan_ID, Customer_ID),
    FOREIGN KEY (Loan_ID) REFERENCES Loan(Loan_ID),
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID)
);

-- Accounts Table
CREATE TABLE Accounts (
    Account_ID INT PRIMARY KEY NOT NULL IDENTITY(1,1),
    Branch_ID INT NOT NULL,
    Account_Balance DECIMAL(18,2) NOT NULL CHECK (Account_Balance >= 0),
    Last_Access_Date DATETIME NULL,
    FOREIGN KEY (Branch_ID) REFERENCES Branch(Branch_ID)
);

-- AccountHolders Table
CREATE TABLE AccountHolders (
    Account_ID INT NOT NULL,
    Customer_ID INT NOT NULL,
    Holder_ID INT NOT NULL,
    PRIMARY KEY (Account_ID, Customer_ID),
    FOREIGN KEY (Account_ID) REFERENCES Accounts(Account_ID),
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID),
    FOREIGN KEY (Holder_ID) REFERENCES HolderRole(Role_ID)
);

-- SavingsAccount Table
CREATE TABLE SavingsAccount (
    Account_ID INT PRIMARY KEY NOT NULL,
    Interest_Rate DECIMAL(5,2) CHECK (Interest_Rate >= 0),
    FOREIGN KEY (Account_ID) REFERENCES Accounts(Account_ID)
);

-- CheckingAccount Table
CREATE TABLE CheckingAccount (
    Account_ID INT PRIMARY KEY NOT NULL,
    FOREIGN KEY (Account_ID) REFERENCES Accounts(Account_ID)
);

-- Overdraft Table
CREATE TABLE Overdraft (
    Account_ID INT NOT NULL,
    Date DATE DEFAULT GETDATE(),
    Amount DECIMAL(18,2) CHECK (Amount >= 0),
    Check_Number VARCHAR(50) NOT NULL,
    PRIMARY KEY (Account_ID, Check_Number),
    FOREIGN KEY (Account_ID) REFERENCES Accounts(Account_ID)
);

 USE SKSNationalBank;
GO
```



## Database Population

With your newly created and empty database, populate it with sample data. Create an SQL file named “populate_database.sql”. This file should perform the following actions:

- **Populate each table in the database with sample data.**
- **Include at least 5 rows of data per table (if possible).**
- **Use primary keys and foreign keys appropriately.**
- **The sample data should act as test cases for your prepared queries.**


*Updated Data Population*

```

-- Addresses for Employees and Customers
INSERT INTO Address (Street, City, Province, Postal_Code)
VALUES
 ('12 7 Ave SE','Calgary','AB','T2G 0J8'),   -- 1
 ('33 9 Ave SE','Calgary','AB','T2G 1K2'),   -- 2
 ('4804 130 Ave SE','Calgary','AB','T2Z 4J2'),-- 3
 ('411 36 St NE','Calgary','AB','T2A 6K3'),  -- 4
 ('120 Kensington Rd','Calgary','AB','T2N 3P5'),-- 5
 ('75 Shawville Blvd','Calgary','AB','T2Y 3W5'),-- 6
 ('101 Riverfront Ave SE','Calgary','AB','T2G 4M9'),-- 7
 ('2200 36 St NE','Calgary','AB','T1Y 5S3'), -- 8
 ('15 Kensington Rd NW','Calgary','AB','T2N 3P8'),-- 9
 ('512 130 Ave SE','Calgary','AB','T2Z 0G4'),-- 10
 ('88 Shawville Blvd SE','Calgary','AB','T2Y 3W4'),-- 11
 ('900 6 Ave SW','Calgary','AB','T2P 0V7');  -- 12

-- Employee Types
INSERT INTO EmployeeType (Type_Name)
VALUES ('Personal Banker'),('Loan Officer'),('Teller'),('Branch Manager'),('Back Office');

-- Employees
INSERT INTO Employees (First_Name, Last_Name, Start_Date, Type_ID, Address_ID, Manager_ID)
VALUES
 ('Avery','Ng','2020-01-15', 4, 1, NULL),       
 ('Mason','Roy','2021-05-20', 1, 2, 1),
 ('Jules','Kang','2019-09-03', 2, 3, 1),
 ('Sam','Lopez','2022-03-12', 3, 4, 2),
 ('Riley','Chan','2023-06-01', 1, 5, 2),
 ('Noah','Kahan','2018-11-30', 5, 6, 3);

-- Locations
INSERT INTO Location (Location_Name, Location_Address, City, Is_Branch)
VALUES
 ('Downtown Main','100 1 St SE','Calgary', 1),
 ('DT Office A',  '200 2 St SE','Calgary', 0),
 ('Sunridge Main','2500 36 St NE','Calgary',1),
 ('Kensington Main','1120 Kensington Rd NW','Calgary',1),
 ('South Trail Main','4300 130 Ave SE','Calgary',1),
 ('Shawnessy Main','70 Shawville Blvd SE','Calgary',1),
 ('Shawnessy Office','85 Shawville Blvd SE','Calgary',0);

-- Branches
INSERT INTO Branch (Branch_Name, Branch_City, Total_Deposits, Total_Loan, Location_ID)
VALUES
 ('Downtown',     'Calgary',  2500000.00, 1200000.00, 1),
 ('Sunridge',     'Calgary',  1500000.00,  800000.00, 3),
 ('Kensington',   'Calgary',  1800000.00,  950000.00, 4),
 ('South Trail',  'Calgary',  2100000.00, 1100000.00, 5),
 ('Shawnessy',    'Calgary',  1300000.00,  600000.00, 6);

-- Employee Location
INSERT INTO EmployeeLocation (Employee_ID, Location_ID)
VALUES
 (1,1),(2,1),(2,3),(3,5),(3,6),
 (4,3),(4,2),(5,4),(6,6),(6,7);

-- Holder Roles
INSERT INTO HolderRole (Role_Description)
VALUES ('Primary'),('Joint'),('Power of Attorney'),('Trustee'),('Authorized Signer');

-- Customers
INSERT INTO Customer (Address_ID, First_Name, Last_Name)
VALUES
 (7, 'Ella', 'Martinez'),
 (8, 'Kai', 'Williams'),
 (9, 'Mila', 'Kunis'),
 (10, 'Leo', 'Brown'),
 (11, 'Zoe', 'Park'),
 (12, 'Aria', 'Smith');

-- Employee-Customer Relationships
INSERT INTO EmployeeCustomer (Employee_ID, Customer_ID)
VALUES
 (2,1),(2,2),(3,3),(4,4),(5,5),(6,6);

-- Accounts (using Branch_IDs)
INSERT INTO Accounts (Branch_ID, Account_Balance, Last_Access_Date)
VALUES
 (1,  5200.00, '2025-09-15 10:25'),
 (2,  8450.75, '2025-09-20 14:10'),
 (3, 12500.25, '2025-09-25 09:00'),
 (4,  2300.00, '2025-09-28 16:45'),
 (5,  9800.10, '2025-09-29 11:30'),
 (1,  4100.50, '2025-09-22 13:25'),
 (2,  7600.00, '2025-09-26 08:40'),
 (3,   300.00, '2025-09-30 17:05'),
 (4,   455.20, '2025-09-18 12:00'),
 (5, 15750.00, '2025-09-19 15:45');

-- Account Holders
INSERT INTO AccountHolders (Account_ID, Customer_ID, Holder_ID)
VALUES
 (1,1,1),
 (2,2,1),
 (3,3,1), (3,4,2),
 (4,4,1),
 (5,5,1), (5,6,2),
 (6,1,2),
 (7,2,2),
 (8,6,1),
 (9,3,1),
 (10,5,1);

-- Savings Accounts
INSERT INTO SavingsAccount (Account_ID, Interest_Rate)
VALUES
 (1, 1.25),
 (3, 1.75),
 (5, 2.10),
 (7, 1.50),
 (9, 2.00),
 (10,1.60);

-- Checking Accounts
INSERT INTO CheckingAccount (Account_ID)
VALUES (2), (4), (6), (8), (10);

-- Overdrafts
INSERT INTO Overdraft (Account_ID, Date, Amount, Check_Number)
VALUES
 (2,'2025-09-10', 125.00, 'CHK-10021'),
 (4,'2025-09-12',  60.00, 'CHK-10055'),
 (6,'2025-09-18', 200.00, 'CHK-10102'),
 (8,'2025-09-27',  35.50, 'CHK-10144'),
 (10,'2025-09-29', 80.00, 'CHK-10188');

-- Loans
INSERT INTO Loan (Branch_ID, Loan_Amount, Start_Date)
VALUES
 (1, 250000.00,'2024-05-01'),
 (2,  35000.00,'2024-11-15'),
 (3,  18000.00,'2025-02-10'),
 (4,  55000.00,'2025-04-05'),
 (5, 120000.00,'2025-06-20');

-- Customer Loans
INSERT INTO CustomerLoans (Loan_ID, Customer_ID)
VALUES
 (1,1),(1,6),
 (2,2),
 (3,3),
 (4,4),(4,5),
 (5,5);

-- Loan Payments
INSERT INTO LoanPayments (Loan_ID, Payment_Date, Amount)
VALUES
 (1,'2024-06-01',1800.00),
 (1,'2024-07-01',1800.00),
 (2,'2024-12-01', 500.00),
 (3,'2025-03-01', 300.00),
 (4,'2025-05-01', 750.00),
 (4,'2025-06-01', 750.00),
 (5,'2025-07-15',1500.00),
 (5,'2025-08-15',1500.00);

```

## Prepared Queries

Prepare relevant queries for your populated database. Create an SQL file named “prepared_queries.sql”. This file should contain 10 queries that meet the following requirements:

- **Each query is in a stored procedure or user-defined function format.**
- **Each query performs a meaningful action based on the case study.**
- **Each query includes a comment that describes the purpose of the query.**
- **Each query has a separate SQL statement that tests the query.**

[🧮 Prepared Queries](https://raw.githubusercontent.com/LizzyTrevisan/DATA2201---SKS-National-Bank/refs/heads/main/prepared_queries.sql)

```
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

```

  
## 🛠️ Submission Instructions

Submit 4 files:

- **ERD as an image file, PDF, or Word document.**

- **create_database.sql**

- **populate_database.sql**

- **prepared_queries.sql**

- **Include each group member’s name in each file.**
- **Properly reference any outside resources that you use.**


# Phase 2: Advanced Database Operations

Phase 2 is about implementing advanced database operations onto the database you created in Phase 1.

## Users and Privileges

### ⚡Create different levels of users and assign appropriate privileges. Create an SQL file named “create_users.sql”. This file should perform the following actions:

1. Create a login and user named “customer_group_[?]” where [?] is your group letter. (For example, “customer_group_A”.)
   
- **Their password should be “customer”.**
- **Their user account should only be able to read tables that are related to customers, based on your ERD. (For example, tables related to customer information, accounts, loans, and payments).**

2. Create a login and user named “accountant_group_[?]” where [?] is your group letter. (For example, “accountant_group_B”.)
-**Their password should be “accountant”.**

- **Their user account should be able to read all tables.**

- **Their user account should not be able to update, insert or delete in tables that are related to accounts, payments and loans, based on your ERD. Those permissions should be revoked.**

- **Provide SQL statements that test the enforcement of the privileges on the two users created above.**

## Triggers

### Create triggers to monitor the different activities on your database. Create an SQL file named “create_triggers.sql”. This file should perform the following actions:

1. Create a new table called “Audit” to track changes made in the database. At minimum, this table should contain the following 3 pieces of information:

- **Primary key.**

- **An explanation of exactly what happened in the database.**

- **Timestamp.**

### Create 3 triggers of your choice that meet the following minimum requirements:

- **Each trigger should log an entry into the Audit table.**

- **Each trigger should provide meaningful information to the database administrator at SKS National Bank.**

- **Provide SQL statements that test each of the 3 triggers.**


### JSON and Spatial Data

### Support JSON and spatial data in your database. Create an SQL file named “create_json_spatial.sql”. This file should perform the following actions:

- **Add one column with the JSON data type to any table of your choice. Populate it with sample data.**

- **Add one column to a table to store the spatial information of the bank’s branches. Populate it with sample data.**

## Backup

### Create a backup (.bak file) of your final database after all the above features have been implemented. Include this backup file as part of your submission.

- **Final ERD**

- **Update your ERD to create a final version that includes all new tables and columns from Phase 2 and any feedback you received from the instructor from Phase 1.**

## Presentation

- **At a date and time specified at the end of the course each group will present their project to the rest of the class. In approximately 5 minutes: explain your final ERD, present and explain the Audit table and three triggers working correctly, and discuss the most important lesson that was learned in this project (for example, if your group had to start the project over, what would they do differently or the same?). All group members must participate.**

- **You do not need to prepare any form of slideshow. If there is a reason that a member or the entire group cannot make the presentation, please speak with the instructor as soon as possible to discuss alternative arrangements.**

## Submission Instructions

Submit 5 files:

- **create_users.sql**

- **create_triggers.sql**

- **create_json_spatial.sql**

- **A backup (.bak) of your final database.**

- **Final ERD as an image file, PDF, or Word document.**

- **Include each group member’s name in each file.**

- **Properly reference any outside resources that you use.**


**Built with ❤️ for the Bow Valley College Software Development Department**
