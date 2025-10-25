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
    Address_ID INT NULL,     -- Must be nullable for ON DELETE SET NULL
    Manager_ID INT NULL      -- Declared but not constrained yet
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

-- Updated Data Populations

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