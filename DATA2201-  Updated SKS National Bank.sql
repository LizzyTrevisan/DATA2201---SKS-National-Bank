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
