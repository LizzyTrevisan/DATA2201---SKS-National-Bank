USE master
GO

USE SKSNationalBank
GO

CREATE TABLE Audit (
    Audit_ID INT PRIMARY KEY IDENTITY(1,1),
    Action_Description VARCHAR(255) NOT NULL,
    Action_Time DATETIME DEFAULT GETDATE()
);

CREATE TRIGGER trg_Audit_ManagerChange
ON Employees
AFTER UPDATE
AS
BEGIN
    INSERT INTO Audit (Action_Description)
    SELECT 'Manager changed for Employee_ID: ' + CAST(i.Employee_ID AS VARCHAR) +
           '. Old Manager: ' + CAST(d.Manager_ID AS VARCHAR) +
           ', New Manager: ' + CAST(i.Manager_ID AS VARCHAR)
    FROM inserted i
    JOIN deleted d ON i.Employee_ID = d.Employee_ID
    WHERE i.Manager_ID <> d.Manager_ID;
END;

CREATE TRIGGER trg_Audit_LargeLoan
ON Loan
AFTER INSERT
AS
BEGIN
    INSERT INTO Audit (Action_Description)
    SELECT 'High-value loan created. Loan_ID: ' + CAST(Loan_ID AS VARCHAR) +
           ', Amount: ' + CAST(Loan_Amount AS VARCHAR)
    FROM inserted
    WHERE Loan_Amount > 100000;
END;

CREATE TRIGGER trg_Audit_Overdraft
ON Overdraft
AFTER INSERT
AS
BEGIN
    INSERT INTO Audit (Action_Description)
    SELECT 'Overdraft recorded for Account_ID: ' + CAST(Account_ID AS VARCHAR) +
           ', Check Number: ' + Check_Number +
           ', Amount: ' + CAST(Amount AS VARCHAR)
    FROM inserted;
END;

-- Test Manager Change
UPDATE Employees SET Manager_ID = 2 WHERE Employee_ID = 1;

-- Test Large Loan
INSERT INTO Loan (Branch_ID, Loan_Amount, Start_Date)
VALUES (1, 250000, GETDATE());

-- Test Overdraft
INSERT INTO Overdraft (Account_ID, Amount, Check_Number)
VALUES (1, 500, 'CHK12345');