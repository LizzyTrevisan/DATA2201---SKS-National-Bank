USE master;
GO

USE SKSNationalBank;
GO

-- Create Audit table (only if it doesn't already exist)
IF OBJECT_ID('dbo.Audit', 'U') IS NOT NULL
    DROP TABLE dbo.Audit;
GO

CREATE TABLE dbo.Audit (
    Audit_ID INT PRIMARY KEY IDENTITY(1,1),
    Action_Description VARCHAR(255) NOT NULL,
    Action_Time DATETIME DEFAULT GETDATE()
);
GO

/* Trigger 1: Manager change on Employees */
CREATE TRIGGER trg_Audit_ManagerChange
ON dbo.Employees
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.Audit (Action_Description)
    SELECT 'Manager changed for Employee_ID: ' + CAST(i.Employee_ID AS VARCHAR(10)) +
           '. Old Manager: ' + CAST(d.Manager_ID AS VARCHAR(10)) +
           ', New Manager: ' + CAST(i.Manager_ID AS VARCHAR(10))
    FROM inserted i
    JOIN deleted d ON i.Employee_ID = d.Employee_ID
    WHERE i.Manager_ID <> d.Manager_ID;
END;
GO

/* Trigger 2: High-value loan created */
CREATE TRIGGER trg_Audit_LargeLoan
ON dbo.Loan
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.Audit (Action_Description)
    SELECT 'High-value loan created. Loan_ID: ' + CAST(Loan_ID AS VARCHAR(10)) +
           ', Amount: ' + CAST(Loan_Amount AS VARCHAR(20))
    FROM inserted
    WHERE Loan_Amount > 100000;
END;
GO

/* Trigger 3: Overdraft recorded */
CREATE TRIGGER trg_Audit_Overdraft
ON dbo.Overdraft
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.Audit (Action_Description)
    SELECT 'Overdraft recorded for Account_ID: ' + CAST(Account_ID AS VARCHAR(10)) +
           ', Check Number: ' + Check_Number +
           ', Amount: ' + CAST(Amount AS VARCHAR(20))
    FROM inserted;
END;
GO

/*TEST STATEMENTS*/

-- Test Manager Change
UPDATE dbo.Employees
SET Manager_ID = 2
WHERE Employee_ID = 1;

-- Test Large Loan
INSERT INTO dbo.Loan (Branch_ID, Loan_Amount, Start_Date)
VALUES (1, 250000, GETDATE());

-- Test Overdraft
INSERT INTO dbo.Overdraft (Account_ID, Amount, Check_Number)
VALUES (1, 500, 'CHK12345');

-- See Audit log
SELECT * FROM dbo.Audit ORDER BY Audit_ID DESC;
