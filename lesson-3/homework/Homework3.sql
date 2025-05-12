--Homework. Lesson_3
--Easy-Level Tasks (10)
--------------------------------------------------------------------------------------------
--1)Define and explain the purpose of BULK INSERT in SQL Server
BULK INSERT is a Transact-SQL (T-SQL) command in SQL Server used to import large volumes of data 
from a data file (typically in formats like .txt, .csv, etc.) directly into a SQL Server table 
quickly and efficiently.

--2)List four file formats that can be imported into SQL Server.
List four file formats that can be imported into SQL Server:
1) CSV (Comma-Separated Values)
2) TXT (Plain Text Files)
3) XML (eXtensible Markup Language)
4) JSON (JavaScript Object Notation)

--3)Create a table Products with columns: ProductID (INT, PRIMARY KEY), ProductName (VARCHAR(50)), Price (DECIMAL(10,2)).
create table Products (ProductID int primary key, ProductName varchar(50), Price decimal(10,2))

--4)Insert three records into the Products table using INSERT INTO.
insert into Products (ProductID, ProductName, Price) values
(1, 'Samsung Galaxy A56', 600)
,(2, 'Laptop', 800)
,(3, 'Wireless mouse', 19.99)

--5)Explain the difference between NULL and NOT NULL.
NULL – means data is missing or unknown; the column can be left empty.
NOT NULL – means data is required; the column cannot be left empty.

--6)Add a UNIQUE constraint to the ProductName column in the Products table.
alter table products
add unique (ProductName)

--7)Write a comment in a SQL query explaining its purpose.
-- This query selects all students who are older than 22
select StudentID, FirstName, LastName, Age
from Students
where Age > 22

--8)Create a table Categories with a CategoryID as PRIMARY KEY and a CategoryName as UNIQUE.
create table Categories (CategoryID int primary key, CategoryName varchar(50) unique)

--9)Explain the purpose of the IDENTITY column in SQL Server.
Identity column of a table is a column whose value increases automatically. The value in 
an identity column is created by the server. A user generally cannot insert a value into an 
identity column. Identity column can be used to uniquely identify the rows in the table.

---------------------------------------------------------------------------------------------
--Medium-Level Tasks (10)
--10)Use BULK INSERT to import data from a text file into the Products table.
Bulk insert [Homework].dbo.[Products]
from 'D:\123.txt'
with (
firstrow=2,
fieldterminator=',',
rowterminator='\n'
)

--11)Create a FOREIGN KEY in the Products table that references the Categories table
alter table products
add categoryID int foreign key references categories(categoryID)

--12)Explain the differences between PRIMARY KEY and UNIQUE KEY

PRIMARY KEY
-A PRIMARY KEY is used to uniquely identify each row in a table.
-It cannot contain NULL values.
-Each table can have only one PRIMARY KEY.

UNIQUE KEY
-A UNIQUE KEY ensures that all values in a column (or a group of columns) are distinct.
-It can contain NULL values (usually one NULL per column, depending on the database system).
-A table can have multiple UNIQUE keys.
-It is used when you want to enforce uniqueness, but it’s not the primary identifier.

--13)Add a CHECK constraint to the Products table ensuring Price > 0.
alter table products
add check (Price>0)

--14)Modify the Products table to add a column Stock (INT, NOT NULL).
alter table Products
add Stock int not null default 0

--15)Use the ISNULL function to replace NULL values in Price column with a 0.
select 
    ProductID,
    ProductName,
    ISNULL(Price, 0) as Price,
    Stock
from Products
 
 --16)Describe the purpose and usage of FOREIGN KEY constraints in SQL Server.
 A FOREIGN KEY constraint is used to enforce referential integrity between two tables. It creates 
 a relationship between a column (or columns) in one table (called the students) and a PRIMARY KEY
 or UNIQUE key in another table (called the teachers).

A FOREIGN KEY:
-Ensures that a value in the students table must exist in the teachers table.
-Prevents orphan records (students records that reference non-existent teachers rows).
-Helps maintain data consistency across related tables.

------------------------------------------------------------------------------------------------
--Hard-Level Tasks (10)
--17)Write a script to create a Customers table with a CHECK constraint ensuring Age >= 18.
create table Customers (
CustomerID int primary key,
CustomerName varchar(100) not null,
Age int check (Age >= 18)
)

--18)Create a table with an IDENTITY column starting at 100 and incrementing by 10.
create table Orders (
OrderID int identity(100, 10) primary key,
CustomerName varchar(100),
OrderDate date
)

--19)Write a query to create a composite PRIMARY KEY in a new table OrderDetails.
create table OrderDetails (
OrderID int,
ProductID int,
Quantity int not null,
Price decimal(10, 2),
primary key(OrderID, ProductID)
)

--20)Explain the use of COALESCE and ISNULL functions for handling NULL values.
--ISNULL
-The isnull function takes two arguments.
-It checks if the first value is null. If it is, it returns the second value.
-Syntax: isnull(expression, replacement_value)
-Example:
 isnull(Price, 0) – if Price is NULL, it will return 0.
 isnull always returns the data type of the first argument.

--COALESCE
-The coalesce function can take two or more arguments.
-It returns the first non-null value from the list.
-Syntax: coalesce(value1, value2, value3, ...)
-Example:
 coalesce(DiscountPrice, RegularPrice, 0) – returns the first value that is not null.
 coalesce returns the value with the highest data type precedence among the inputs.

--21)Create a table Employees with both PRIMARY KEY on EmpID and UNIQUE KEY on Email.
create table Employees (
EmpID int primary key,
FirstName varchar(50),
LastName varchar(50),
Email varchar(100) unique
)

--22)Write a query to create a FOREIGN KEY with ON DELETE CASCADE and ON UPDATE CASCADE options.
create table Orders (
OrderID int primary key,
CustomerID int,
OrderDate date,
foreign key (CustomerID) references Customers(CustomerID)
on delete cascade
on update cascade
)
