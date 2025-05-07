--Homework. Lesson_2
--Basic-level tasks(10)
----------------------------------------
create table Employees (EmpID int, Name varchar(50), Salary decimal(10,2))
insert into Employees (EmpID, Name, Salary) values
 (1, 'Sardor', '5000')
,(2, 'Barno', '3000')
,(3, 'Sobir', '4000')

update Employees
set salary= '7000'
where empid=1

delete from Employees
where empid=2
-------------------------------------------------------------
DELETE: Deletes specific rows based on condition
DROP: Deletes the entire table or database
TRUNCATE: Deletes all rows but retains table structure
-------------------------------------------------------------
alter table Employees
alter column Name varchar(100)

alter table Employees
Add Department varchar(50)

alter table Employees
alter column Salary float

create table Departments (DepartmentID int primary key, DepartmentName varchar(50))

Truncate table Employees
------------------------------------------------------------------------------------
--Intermediate-Level tasks (6)

insert into Departments
select 1, 'HR'
union all 
select 2, 'Sales'
union all
select 3, 'Marketing'
union all
select 4, 'Finance'
union all
select 5, 'IT'

update Employees
set Department='Management'
where salary>'5000'

truncate table Employees

alter table Employees
drop column Department

exec sp_rename 'Employees', 'StaffMembers'

drop table Departments
---------------------------------------------------------------------------------
--Advanced-Level Tasks (9)

create table Products (ProductID int primary key, ProductName varchar(100), Category varchar(50),
Price decimal(10,2), Description varchar(100))

alter table Products
add check (Price>0)

alter table Products
add StockQuantity int default 50

exec sp_rename 'Products.Category', 'ProductCategory', 'Column'

insert into Products (ProductID, ProductName, ProductCategory, Price, Description) values
(1, 'Al_fajr', 'Accessories', '300', 'Electronic watch')
,(2, 'HP Victus', 'Electronics', '1000', 'Gaming laptop')
,(3, 'EchoPlan', 'Toys&Games', '50', 'Building toys')
,(4, 'Samsung A56', 'Phones', '700', 'Smartphone with 5G')
,(5, 'Tergovchi', 'Books', '15', 'Detective book in Uzbek')

select*into Products_Backup from Products

exec sp_rename 'Products', 'Inventory'

alter table Inventory 
drop constraint CK__Products__Price__4316F928;

alter table Inventory 
alter column Price float;

alter table Inventory 
add constraint CK_Inventory_Price check (Price > 0);

alter table Inventory
add ProductCode int identity (1000,5)
--------------------------------------------------------------------------------