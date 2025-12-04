USE master;
GO

USE SKSNationalBank;
GO

/* 1) JSON COLUMN ON CUSTOMER + SAMPLE DATA*/

-- Add JSON column only if it doesn't already exist
IF COL_LENGTH('dbo.Customer', 'Extra_Info') IS NULL
BEGIN
    ALTER TABLE dbo.Customer
    ADD Extra_Info NVARCHAR(MAX) NULL
        CONSTRAINT CK_Customer_Extra_Info_JSON
        CHECK (Extra_Info IS NULL OR ISJSON(Extra_Info) = 1);
END;
GO

-- Sample JSON data for a couple of customers
-- Adjust Customer_ID values if needed
UPDATE dbo.Customer
SET Extra_Info = N'{
    "preferredContact": "email",
    "marketingOptIn": true,
    "notes": "Uses online and mobile banking often"
}'
WHERE Customer_ID = 1;

UPDATE dbo.Customer
SET Extra_Info = N'{
    "preferredContact": "phone",
    "marketingOptIn": false,
    "notes": "Prefers in-branch appointments"
}'
WHERE Customer_ID = 2;
GO


/* 2) SPATIAL COLUMN ON BRANCH + SAMPLE DATA*/

-- Add GEOGRAPHY column for branch location if it doesn't exist
IF COL_LENGTH('dbo.Branch', 'Branch_Location') IS NULL
BEGIN
    ALTER TABLE dbo.Branch
    ADD Branch_Location GEOGRAPHY NULL;
END;
GO

-- Sample coordinates for branches (Calgary-ish points)
-- Make sure Branch_ID 1 and 2 exist (they do in your data)
UPDATE dbo.Branch
SET Branch_Location = geography::Point(51.0447, -114.0719, 4326)  -- Downtown
WHERE Branch_ID = 1;

UPDATE dbo.Branch
SET Branch_Location = geography::Point(51.0700, -114.0000, 4326)  -- Another sample
WHERE Branch_ID = 2;
GO


/*  3) TEST QUERIES*/

-- Check JSON data
SELECT Customer_ID, First_Name, Last_Name, Extra_Info
FROM dbo.Customer;

-- Check spatial data as text (WKT)
SELECT Branch_ID,
       Branch_Name,
       Branch_Location.ToString() AS Location_WKT
FROM dbo.Branch;
GO
