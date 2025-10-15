USE master;
GO

CREATE DATABASE SKSNationalBank;
GO
 
 USE SKSNationalBank;
 GO

 CREATE TABLE Branch (
 Branch_ID	INT		PRIMARY KEY		NOT NULL	IDENTITY,
 Branch_Name	VARCHAR(50)		UNIQUE		NOT NULL,
 Branch_City	VARCHAR(150)	NOT NULL,
 Total_Deposits		DECIMAL(18,2) NULL,
 Total_Loan		DECIMAL(18,2)		NULL
 );

  CREATE TABLE Location (
 Location_ID	INT		PRIMARY KEY		NOT NULL	IDENTITY,
 Branch_ID		INT		REFERENCES Branch (Branch_ID)		NOT NULL, 
 Location_Name	VARCHAR(50),
 Location_Address	VARCHAR(100)	NOT NULL,
 City	VARCHAR(100)	NOT NULL,
 Is_Branch	BIT		NOT NULL
 );

 CREATE TABLE Employees (
 Employee_ID	INT		PRIMARY KEY		NOT NULL	IDENTITY,
 First_Name		VARCHAR(120)	NOT NULL,
 Last_Name		VARCHAR(120)	NOT NULL,
 Street		VARCHAR(200)	NULL,
 City	VARCHAR(50),
 Province	VARCHAR(50),
 Postal_Code	NVARCHAR(50),
 Start_Date		DATE,
 Manager_ID		INT		NULL	REFERENCES Employees (Employee_ID)
 );

 CREATE TABLE EmployeeLocation (
 Employee_ID	INT		REFERENCES Employees (Employee_ID)	NOT NULL,
 Location_ID	INT		REFERENCES Location (Location_ID)	NOT NULL
 );

 CREATE TABLE EmployeeType (
 Type_ID	INT		PRIMARY KEY		NOT NULL	IDENTITY,
 Type_Name	VARCHAR(50)
 );

 CREATE TABLE Loan (
 Loan_ID	INT		PRIMARY KEY		NOT NULL	IDENTITY,
 Branch_ID		INT		REFERENCES Branch (Branch_ID),
 Loan_Amount	DECIMAL(18,2)		NOT NULL,
 Start_Date		DATE	NOT NULL
 );

 CREATE TABLE LoanPayments (
 Loan_ID	INT		REFERENCES Loan (Loan_ID),
 Payment_No		INT		PRIMARY KEY		NOT NULL	IDENTITY,
 Payment_Date	DATE,
 Amount		DECIMAL(18,2)
 );

 CREATE TABLE HolderRole (
 Role_ID	INT		PRIMARY KEY		NOT NULL	IDENTITY,
 Role_Description	VARCHAR(50)
 );
 
 CREATE TABLE Customer (
 Customer_ID	INT		PRIMARY KEY		NOT NULL	IDENTITY,
 First_Name		VARCHAR(50)		NOT NULL,
 Last_Name		VARCHAR(50)		NOT NULL,
 Street		NVARCHAR(100),
 City	VARCHAR(20),
 Province	VARCHAR(20),
 Postal_Code	VARCHAR(50)
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

