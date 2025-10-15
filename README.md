# DATA2201 – Relational Databases Project: SKS National Bank - Group L

## 🚀 CASE STUDY

You are an employee of BVC Technology Group and have been hired by SKS National Bank to build a new database system for their entire banking operations. Here are the requirements given to you from the project liaison at SKS National Bank:
SKS National Bank is organized into branches. Each branch is in a particular city and is identified by a unique name. Each branch keeps a total of all the deposits and loan amounts.
Bank customers have a name, a customer ID, and a home address. A customer may have a chequing account, a savings account, and may take out loans. Customers may have personal bankers or loan officers that they always work with.
Bank employees (including personal bankers and loan officers) have unique employee IDs. Each employee has a manager, a start date, a name, a home address, and a set of locations where they work. A location may be a bank branch or an office that is not in a branch.
Chequing and savings accounts can be held by more than one customer (for example, spouses can have joint accounts) and a customer can have more than one account. Each account has a balance and the most recent date that the account was accessed by the customer. Savings accounts have an associated interest rate. Chequing accounts keep track of dates, amounts, and check numbers for overdrafts.
A loan originates at a particular branch and can be held by one or more customers. The bank tracks the loan amount and payments. A loan payment number does not uniquely identify a particular payment among all loans, but it does identify a particular payment for a specific loan. The date and amount are recorded for each payment.

Project Overview

### PHASES 1 & 2
- **Database Design and Implementation
- **Advanced Database Operations

### Phase 1: Database Design and Implementation


Phase 1 is about designing your database and implementing it with initial data and basic features.

### Entity Relationship Diagram

Create a well-designed and detailed ERD or relational schema that meets all the requirements of the case study above. The ERD or relational schema should include the following information:

- **Tables with names and attributes**
- **Indications of which columns are primary or foreign keys.**
- **Relationships between tables, including ordinality.**
- **Any special constraints that should be noted.**
- **Check each of the entities for normalization to avoid and eliminate anomalies.**


LINK BELOW:
(https://lucid.app/lucidchart/9110e2ea-a1a2-460c-b788-3334b2fe15ab/edit?viewport_loc=563%2C-4955%2C5982%2C2968%2C0_0&invitationId=inv_528b72bf-e646-4658-a96c-45496d095986)

![DATA2201- SKS National Bank.png](https://raw.githubusercontent.com/LizzyTrevisan/DATA2201---SKS-National-Bank/refs/heads/main/DATA2201-%20%20SKS%20National%20Bank.png)



###Database Creation

Using the ERD or relational schema, create a database and set of tables. Create an SQL file named “create_database.sql”. This file should perform the following actions:

- **Delete the database if it already exists.
- **Create the database.
- **Create all tables based on your design.
- **Create the appropriate primary and foreign keys.
- **Create the appropriate constraints and relationships

  

###Database Population

With your newly created and empty database, populate it with sample data. Create an SQL file named “populate_database.sql”. This file should perform the following actions:

- **Populate each table in the database with sample data.**
- **Include at least 5 rows of data per table (if possible).**
- **Use primary keys and foreign keys appropriately.**
- **The sample data should act as test cases for your prepared queries.**


###Prepared Queries

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


###Phase 2: Advanced Database Operations

Phase 2 is about implementing advanced database operations onto the database you created in Phase 1.

##Users and Privileges

## ⚡Create different levels of users and assign appropriate privileges. Create an SQL file named “create_users.sql”. This file should perform the following actions:

1. **Create a login and user named “customer_group_[?]” where [?] is your group letter. (For example, “customer_group_A”.)**
   
- **Their password should be “customer”.**
- **Their user account should only be able to read tables that are related to customers, based on your ERD. (For example, tables related to customer information, accounts, loans, and payments).**

2. **Create a login and user named “accountant_group_[?]” where [?] is your group letter. (For example, “accountant_group_B”.)**
-**Their password should be “accountant”.

- **Their user account should be able to read all tables.**

- **Their user account should not be able to update, insert or delete in tables that are related to accounts, payments and loans, based on your ERD. Those permissions should be revoked.**

- **Provide SQL statements that test the enforcement of the privileges on the two users created above.**

##Triggers

##Create triggers to monitor the different activities on your database. Create an SQL file named “create_triggers.sql”. This file should perform the following actions:

1. **Create a new table called “Audit” to track changes made in the database. At minimum, this table should contain the following 3 pieces of information:

- **Primary key.**

- **An explanation of exactly what happened in the database.**

- **Timestamp.**

##Create 3 triggers of your choice that meet the following minimum requirements:

- **Each trigger should log an entry into the Audit table.**

- **Each trigger should provide meaningful information to the database administrator at SKS National Bank.**

- **Provide SQL statements that test each of the 3 triggers.**


##JSON and Spatial Data

## Support JSON and spatial data in your database. Create an SQL file named “create_json_spatial.sql”. This file should perform the following actions:

- **Add one column with the JSON data type to any table of your choice. Populate it with sample data.**

- **Add one column to a table to store the spatial information of the bank’s branches. Populate it with sample data.**

4. **Open your browser**
   Navigate to `http://localhost:5173`

## Backup

##Create a backup (.bak file) of your final database after all the above features have been implemented. Include this backup file as part of your submission.

- **Final ERD**

- **Update your ERD to create a final version that includes all new tables and columns from Phase 2 and any feedback you received from the instructor from Phase 1.**

##Presentation

- **At a date and time specified at the end of the course each group will present their project to the rest of the class. In approximately 5 minutes: explain your final ERD, present and explain the Audit table and three triggers working correctly, and discuss the most important lesson that was learned in this project (for example, if your group had to start the project over, what would they do differently or the same?). All group members must participate.**

- **You do not need to prepare any form of slideshow. If there is a reason that a member or the entire group cannot make the presentation, please speak with the instructor as soon as possible to discuss alternative arrangements.**

##Submission Instructions

Submit 5 files:

- **create_users.sql**

- **create_triggers.sql**

- **create_json_spatial.sql**

- **A backup (.bak) of your final database.**

- **Final ERD as an image file, PDF, or Word document.**

- **Include each group member’s name in each file.**

- **Properly reference any outside resources that you use.**


**Built with ❤️ for the Bow Valley College Software Development Department**
