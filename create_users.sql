USE MASTER;
 
GO
 
/*1. Create a login and user named “customer_group_[?]” where [?] is your group letter. 
(For example, “customer_group_A”.)
- Their password should be “customer”.*/
 
/*CUSTOMER */
 
IF EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'customer_group_L')
	DROP LOGIN customer_group_L;
GO
 
 
CREATE LOGIN customer_group_L
	WITH PASSWORD = 'customer',
	DEFAULT_DATABASE=SKSNationalBank,
	CHECK_EXPIRATION= ON,
	CHECK_POLICY= ON;
GO
 
USE SKSNationalBank;
GO
 
IF EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'customer_group_L')
	DROP USER customer_group_L;
GO
 
CREATE USER customer_group_L FOR LOGIN customer_group_L;
GO
 
/* - Their user account should only be able to read tables that are related to customers, based on your ERD. 
(For example, tables related to customer information, accounts, loans, and payments). */
 
GRANT SELECT ON dbo.Customer TO customer_group_L;
GRANT SELECT ON dbo.Accounts TO customer_group_L;
GRANT SELECT ON dbo.AccountHolders TO customer_group_L;
GRANT SELECT ON dbo.CustomerLoans TO customer_group_L;
GRANT SELECT ON dbo.Loan TO customer_group_L;
GRANT SELECT ON dbo.LoanPayments TO customer_group_L;
GRANT SELECT ON dbo.Overdraft TO customer_group_L;
GRANT SELECT ON dbo.SavingsAccount TO customer_group_L;
GRANT SELECT ON dbo.CheckingAccount TO customer_group_L;
GO
 
/*----------------------------------------------------------------------------------------------------------------*/
 
/* ACCOUNTANT */
/* 2. Create a login and user named “accountant_group_[?]” where [?] is your group letter. 
(For example, “accountant_group_B”.)
- Their password should be “accountant”.*/
USE master;
GO
 
 IF EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'accountant_group_L')
    DROP LOGIN accountant_group_L;
GO

 
CREATE LOGIN accountant_group_L
	WITH PASSWORD='accountant',
	DEFAULT_DATABASE=SKSNationalBank,
	CHECK_EXPIRATION= ON,
	CHECK_POLICY= ON;
GO
 
USE SKSNationalBank;
GO
 
 IF EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'accountant_group_L')
    DROP USER accountant_group_L;
GO

 
CREATE USER accountant_group_L FOR LOGIN accountant_group_L;
GO
 
 
/*- Their user account should be able to read all tables.
 
 
- Their user account should not be able to update, insert or delete in tables that are related to accounts, 
payments and loans, based on your ERD. 
Those permissions should be revoked.
*/
 
GRANT SELECT
ON SCHEMA::dbo
TO accountant_group_L;
GO
 
GRANT INSERT, UPDATE, DELETE ON dbo.Location         TO accountant_group_L;
GRANT INSERT, UPDATE, DELETE ON dbo.Branch           TO accountant_group_L;
GRANT INSERT, UPDATE, DELETE ON dbo.Address          TO accountant_group_L;
GRANT INSERT, UPDATE, DELETE ON dbo.EmployeeType     TO accountant_group_L;
GRANT INSERT, UPDATE, DELETE ON dbo.Employees        TO accountant_group_L;
GRANT INSERT, UPDATE, DELETE ON dbo.HolderRole       TO accountant_group_L;
GRANT INSERT, UPDATE, DELETE ON dbo.Customer         TO accountant_group_L;
GRANT INSERT, UPDATE, DELETE ON dbo.EmployeeCustomer TO accountant_group_L;

 
 
 
REVOKE INSERT, UPDATE, DELETE ON dbo.Accounts FROM accountant_group_L;
REVOKE INSERT, UPDATE, DELETE ON dbo.AccountHolders FROM accountant_group_L;
REVOKE INSERT, UPDATE, DELETE ON dbo.SavingsAccount FROM accountant_group_L;
REVOKE INSERT, UPDATE, DELETE ON dbo.CheckingAccount FROM accountant_group_L;
REVOKE INSERT, UPDATE, DELETE ON dbo.Loan FROM accountant_group_L;
REVOKE INSERT, UPDATE, DELETE ON dbo.LoanPayments FROM accountant_group_L;
REVOKE INSERT, UPDATE, DELETE ON dbo.CustomerLoans FROM accountant_group_L;
REVOKE INSERT, UPDATE, DELETE ON dbo.Overdraft FROM accountant_group_L;
 
/* - Provide SQL statements that test the enforcement of the privileges on the two users created above.*/
 
/*customer_group_L TESTS: 
WHERE SELECT SHOULD BE OK*/
 
PRINT 'Testing customer_group_L';
EXECUTE AS USER = 'customer_group_L';
 
SELECT * FROM dbo.Customer;
 
/*AND INSERT SHOULD FAIL.*/ 
	BEGIN TRY
		INSERT INTO dbo.Customer (Address_ID, First_Name, Last_Name)
		VALUES (NULL, 'Testing', 'Customer');
		PRINT 'Error: insertion not succeeded.';
	END TRY
	BEGIN CATCH
		PRINT 'Insertion Failed, customer_group_L has no authorization to Insert data. ' + 
		ERROR_MESSAGE();
	END CATCH
REVERT;
GO
 
/*ACCOUNTANT*/
 
PRINT 'Testing accountant_group_L';
EXECUTE AS USER = 'accountant_group_L';
 
/* SELECT STATEMENTS SHOUDLD WORK*/
SELECT * FROM dbo.Employees;
 
/*INSERT allowed on Address Table:*/ 
	BEGIN TRY
		INSERT INTO dbo.Address (Street, City, Province, Postal_Code)
		VALUES ('Street 12345', 'Calgary', 'AB', 'T2T 1T1');
		PRINT 'Insertion succeeded.';
	END TRY
	BEGIN CATCH
		PRINT ' Error: not allowed. ' + 
		ERROR_MESSAGE();
	END CATCH;
 
/*INSERT into Accounts NOT allowed:*/
	BEGIN TRY
		INSERT INTO dbo.Accounts (Branch_ID, Account_Balance, Last_Access_Date)
		VALUES (1, 2999.99, GETDATE());
		PRINT 'Error: insertion not succeeded.';
	END TRY
	BEGIN CATCH
		PRINT 'Insertion not allowed into Accounts by accountant_group_L. ' + ERROR_MESSAGE();
	END CATCH;
REVERT;
 