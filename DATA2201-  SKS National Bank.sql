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
