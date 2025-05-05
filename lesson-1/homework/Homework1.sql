--Homework. Lesson_1
--Easy
----------------------------------------------------------------------------------------
Data is a collection of facts, such as numbers, words, measurements, observations or 
just descriptions of things.

A database is a collection of information that is organized so that it can easily be accessed, managed
and updated.

A relational database is a type of database that organizes data into one or more tables, with each table
consisting of a set of rows and columns. Each table has a unique key that can be used to establish
relationships with other tables.

A table is arrangement of data in rows and columns.
-----------------------------------------------------------------------------------------
1. High Availability and Disaster Recovery (HADR): SQL Server provides features like Always On Availability 
Groups, failover clustering, and log shipping to ensure minimal downtime and data protection in case of 
failures.
2. Security and Compliance: Built-in security features include Transparent Data Encryption (TDE), 
Always Encrypted, Row-Level Security, and Dynamic Data Masking to protect sensitive data and meet 
compliance requirements.
3. Performance and Scalability: Supports features like In-Memory OLTP, Query Store, and Columnstore 
Indexes to improve speed and handle large volumes of data efficiently.
4. Integration Services: Tools like SQL Server Integration Services (SSIS), SQL Server Reporting 
Services (SSRS), and SQL Server Analysis Services (SSAS) help with data integration, reporting, 
and analytics.
5. Support for Advanced Analytics: Enables in-database analytics using R and Python, and supports machine
learning and AI capabilities within the SQL Server environment.
-----------------------------------------------------------------------------------------
SQL Server supports two authentication modes, Windows authentication mode, and mixed mode.

Windows authentication is the default and is often referred to as integrated security because this 
SQL Server security model is tightly integrated with Windows. Specific Windows user and group accounts 
are trusted to log in to SQL Server.

The mixed mode supports authentication both by Windows and by SQL Server. User name and password pairs 
are maintained within SQL Server.
-----------------------------------------------------------------------------------------

--Medium
-----------------------------------------------------------------------------------------
create database SchoolDB
use SchoolDB
create table Students (StudentID int primary key, Name varchar (50), Age int)
select*from Students
-----------------------------------------------------------------------------------------
Differences between SQL Server, SSMS, and SQL:

SQL Server: A database engine used to store and manage data.

SSMS (SQL Server Management Studio): A graphical tool used to interact with SQL Server.

SQL (Structured Query Language): A language used to write queries to retrieve or modify data in 
the database.

Each plays a different role: SQL Server is the system, SSMS is the tool, and SQL is the language.
-----------------------------------------------------------------------------------------

--Hard
-----------------------------------------------------------------------------------------
1. DQL (Data Query Language) - Used to retrieve data from the database.
Command: Select
Example: Select*from Students

2.  DML (Data Manipulation Language) - Used to manipulate data stored in database tables 
(i.e., perform operations like insert, update, delete).
Command: Insert, Update, Delete
Example: Insert into Students (StudentID, Name, Age) values (1, 'Abduqodir', '20')

3. DDL (Data Definition Language) - Defines the structure of database objects like tables, schemas, indexes.
Command: Create, Alter, Drop, Truncate
Example: Create table Students ( StudentID int, Name varchar (50), Age int)

4. DCL (Data Control Language) - Manages permissions and access control.
Command: Grant, Revoke
Example: Grant select on Students to Abduqodir

5. TCL (Transaction Control Language) - Manages transactions in a database to ensure data integrity.
Command: Commit, Rollback, Savepoint
Example: Insert into Students (StudentID, Name, Age) values (2, 'Eldor', '28')
---------------------------------------------------------------------------------------
use SchoolDB
Insert into Students (StudentID, Name, Age) values
(1, 'Abduqodir', '20')
, (2, 'Eldor', '28')
, (3, 'Jaloliddin', '27')
select*from Students
---------------------------------------------------------------------------------------
1. Right-click on Databases → Click Restore Database
2. Choose Device
3. Click the ... (browse) button.
4. Click Add → Navigate and select the AdventureWorksDW2022.bak file.
5. Click OK to start the restore.
---------------------------------------------------------------------------------------
