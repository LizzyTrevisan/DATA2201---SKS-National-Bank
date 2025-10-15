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

![DATA2201- SKS National Bank.png](https://raw.githubusercontent.com/LizzyTrevisan/DATA2201---SKS-National-Bank/refs/heads/main/DATA2201-%20%20SKS%20National%20Bank.png)



## Database Creation

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
CREATE DATABASE SKS_National_Bank;
GO

USE SKS_National_Bank;
GO

CREATE TABLE Branches (
    BranchID INT PRIMARY KEY,
    BranchName VARCHAR(100),
    City VARCHAR(100),
    TotalDeposits DECIMAL(18,2),
    TotalLoans DECIMAL(18,2)
);

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    StartDate DATE,
    ManagerID INT NULL,
    FOREIGN KEY (ManagerID) REFERENCES Employees(EmployeeID)
);

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Address VARCHAR(255)
);
CREATE TABLE EmplyeeCustomer (
 Employee_ID	INT		REFERENCES Employees (Employee_ID),
 Customer_ID	INT		REFERENCES Customer (Customer_ID)
 );

 CREATE TABLE CustomerLoans (
 Loan_ID	INT		REFERENCES Loan (Loan_ID),
 Customer_ID	INT		REFERENCES Customer (Customer_ID)
 );

CREATE TABLE Accounts (
 Account_ID		INT		PRIMARY KEY		NOT NULL	IDENTITY,
 Location_ID	INT	REFERENCES Location (Location_ID),
 Account_Balance	DECIMAL(18,2)	NOT NULL,
 Last_Access_Date		DATETIME NULL
 );

 CREATE TABLE AccountHolders (
 Account_ID		INT		REFERENCES Accounts (Account_ID)	NOT NULL,
 Customer_ID	INT		REFERENCES Customer (Customer_ID)	NOT NULL,
 Holder_ID		INT REFERENCES HolderRole (Role_ID)		NOT NULL
 );

 CREATE TABLE SavingsAccount (
 Account_ID		INT		PRIMARY KEY		REFERENCES Accounts (Account_ID)	NOT NULL,
 Interest_Rate	DECIMAL(5,2)
 );

 CREATE TABLE CheckingAccount (
 Account_ID		INT		PRIMARY KEY REFERENCES Accounts (Account_ID)	NOT NULL	IDENTITY,
 );

 CREATE TABLE Overdraft (
 Account_ID		INT REFERENCES Accounts (Account_ID)	NOT NULL,
 Date	DATE,
 Amount		DECIMAL(18,2),
 Check_Number	VARCHAR(50)		NOT NULL
 );
  
  
## Database Population

With your newly created and empty database, populate it with sample data. Create an SQL file named “populate_database.sql”. This file should perform the following actions:

- **Populate each table in the database with sample data.**
- **Include at least 5 rows of data per table (if possible).**
- **Use primary keys and foreign keys appropriately.**
- **The sample data should act as test cases for your prepared queries.**

### 🟣 `.sql`
```markdown
[📄 Download Database Script (SQL)](https://raw.githubusercontent.com/LizzyTrevisan/DATA2201---SKS-National-Bank/67fc27668354c8a38b11716593cf1249fd9e0935/DATA2201-%20%20SKS%20National%20Bank.sql)

``` Populating Database
-- 

USE SKSNationalBank;
GO

 /* Populating Database*/
 
/* ------------
   BRANCHES
   These represent different locations across the city.
   I added slightly different total deposits/loans per branch
   just to simulate different branch sizes.
--------------*/
INSERT INTO Branch (Branch_Name, Branch_City, Total_Deposits, Total_Loan)
VALUES
 ('Downtown',     'Calgary',  2500000.00, 1200000.00),
 ('Sunridge',     'Calgary',  1500000.00,  800000.00),
 ('Kensington',   'Calgary',  1800000.00,  950000.00),
 ('South Trail',  'Calgary',  2100000.00, 1100000.00),
 ('Shawnessy',    'Calgary',  1300000.00,  600000.00);

/* -----------------------------
   LOCATIONS 
   (These are all tied to a Branch_ID)
------------------------------*/
INSERT INTO Location (Branch_ID, Location_Name, Location_Address, City, Is_Branch)
VALUES
 (1,'Downtown Main','100 1 St SE','Calgary', 1),
 (1,'DT Office A',  '200 2 St SE','Calgary', 0),
 (2,'Sunridge Main','2500 36 St NE','Calgary',1),
 (3,'Kensington Main','1120 Kensington Rd NW','Calgary',1),
 (4,'South Trail Main','4300 130 Ave SE','Calgary',1),
 (5,'Shawnessy Main','70 Shawville Blvd SE','Calgary',1),
 (5,'Shawnessy Office','85 Shawville Blvd SE','Calgary',0);

/* ---------------
   EMPLOYEES 
   (as per schema, Manager_ID can be NULL first, then can reference)
   Manager_ID links employees to their supervisor.
   First one (Avery) is top-level, others report under.
---------------*/
INSERT INTO Employees (First_Name, Last_Name, Street, City, Province, Postal_Code, Start_Date, Manager_ID)
VALUES
 ('Avery','Ng','12 7 Ave SE','Calgary','AB','T2G 0J8','2020-01-15', NULL),       
 ('Mason','Roy','33 9 Ave SE','Calgary','AB','T2G 1K2','2021-05-20', 1),
 ('Jules','Kang','4804 130 Ave SE','Calgary','AB','T2Z 4J2','2019-09-03', 1),
 ('Sam','Lopez','411 36 St NE','Calgary','AB','T2A 6K3','2022-03-12', 2),
 ('Riley','Chan','120 Kensington Rd','Calgary','AB','T2N 3P5','2023-06-01', 2),
 ('Noah','Kahan','75 Shawville Blvd','Calgary','AB','T2Y 3W5','2018-11-30', 3);

/* -------------------
   EMPLOYEE LOCATION 
   This connects which employees work at which branches.
   Some work at more than one.
------------------*/
INSERT INTO EmployeeLocation (Employee_ID, Location_ID)
VALUES
 (1,1),(2,1),(2,3),(3,5),(3,6),
 (4,3),(4,2),(5,4),(6,6),(6,7);

/* -----------
   EMPLOYEE TYPES
   (Just a few different roles to add variety)
----------------*/
INSERT INTO EmployeeType (Type_Name)
VALUES ('Personal Banker'),('Loan Officer'),('Teller'),('Branch Manager'),('Back Office');

/* ------------
   HOLDER ROLES 
   These describe what kind of relationship a person has
   to an account 
---------------*/
INSERT INTO HolderRole (Role_Description)
VALUES ('Primary'),('Joint'),('Power of Attorney'),('Trustee'),('Authorized Signer');

/* ---------
   CUSTOMERS 
------------*/
INSERT INTO Customer (First_Name, Last_Name, Street, City, Province, Postal_Code)
VALUES
 ('Ella','Martinez','101 Riverfront Ave SE','Calgary','AB','T2G 4M9'),
 ('Kai','Williams','2200 36 St NE','Calgary','AB','T1Y 5S3'),
 ('Mila','Kunis','15 Kensington Rd NW','Calgary','AB','T2N 3P8'),
 ('Leo','Brown','512 130 Ave SE','Calgary','AB','T2Z 0G4'),
 ('Zoe','Park','88 Shawville Blvd SE','Calgary','AB','T2Y 3W4'),
 ('Aria','Smith','900 6 Ave SW','Calgary','AB','T2P 0V7');

/* ---------------------
   EMPLOYEE and CUSTOMER
-----------------------*/
INSERT INTO EmployeeCustomer (Employee_ID, Customer_ID)
VALUES
 (2,1),(2,2),(3,3),(4,4),(5,5),(6,6);

/* -----------
   ACCOUNTS
-------------*/
INSERT INTO Accounts (Location_ID, Account_Balance, Last_Access_Date)
VALUES
 (1,  5200.00, '2025-09-15 10:25'),
 (3,  8450.75, '2025-09-20 14:10'),
 (4, 12500.25, '2025-09-25 09:00'),
 (5,  2300.00, '2025-09-28 16:45'),
 (6,  9800.10, '2025-09-29 11:30'),
 (2,  4100.50, '2025-09-22 13:25'),
 (7,  7600.00, '2025-09-26 08:40'),
 (1,  300.00,  '2025-09-30 17:05'),
 (5,  455.20,  '2025-09-18 12:00'),
 (6,  15750.00,'2025-09-19 15:45');

/* ----------------
   ACCOUNT HOLDERS 
   Customers linked to their accounts using Holder IDs.
   I also decided to make some joint acct, to keep it realistic
-----------------*/
-- Assume Account_IDs from 1..10 in the order inserted above
INSERT INTO AccountHolders (Account_ID, Customer_ID, Holder_ID)
VALUES
 (1,1,1),                         -- Ella primary
 (2,2,1),                         -- Kai primary
 (3,3,1), (3,4,2),                -- Mila primary, Leo joint
 (4,4,1),
 (5,5,1), (5,6,2),                -- Zoe primary, Aria joint
 (6,1,2),                         -- Ella joint on a second acct
 (7,2,2),
 (8,6,1),
 (9,3,1),
 (10,5,1);

/* ---------------
   SAVINGS ACCOUNTS
-----------------*/
INSERT INTO SavingsAccount (Account_ID, Interest_Rate)
VALUES
 (1, 1.25),
 (3, 1.75),
 (5, 2.10),
 (7, 1.50),
 (9, 2.00),
 (10,1.60);

/* -------------------
   CHECKING ACCOUNTS
   Note: the Account_ID here also comes from Accounts table.
   Because of the IDENTITY setup, we have to use IDENTITY_INSERT
   so SQL lets us pick specific IDs. Otherwise, it would auto-number..
------------------*/
SET IDENTITY_INSERT CheckingAccount ON;

INSERT INTO CheckingAccount (Account_ID)
VALUES
 (2), (4), (6), (8), (10);

SET IDENTITY_INSERT CheckingAccount OFF;

/* --------------
   OVERDRAFTS 
   (These are tied to checking accounts only)
------------------*/
INSERT INTO Overdraft (Account_ID, Date, Amount, Check_Number)
VALUES
 (2,'2025-09-10', 125.00, 'CHK-10021'),
 (4,'2025-09-12',  60.00, 'CHK-10055'),
 (6,'2025-09-18', 200.00, 'CHK-10102'),
 (8,'2025-09-27',  35.50, 'CHK-10144'),
 (10,'2025-09-29', 80.00, 'CHK-10188');

/* -------
   LOANS
----------*/
INSERT INTO Loan (Branch_ID, Loan_Amount, Start_Date)
VALUES
 (1, 250000.00,'2024-05-01'),
 (2,  35000.00,'2024-11-15'),
 (3,  18000.00,'2025-02-10'),
 (4,  55000.00,'2025-04-05'),
 (5, 120000.00,'2025-06-20');

/* -------------------
   CUSTOMER and LOANS
--------------------*/
-- Link multiple customers to some loans (joint loans)
INSERT INTO CustomerLoans (Loan_ID, Customer_ID)
VALUES
 (1,1),(1,6),   -- ex. joint mortgage
 (2,2),
 (3,3),
 (4,4),(4,5),   -- ex. joint car loan
 (5,5);

/* -------------
   LOAN PAYMENTS
-----------------*/
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
