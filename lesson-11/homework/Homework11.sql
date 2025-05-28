--Homework. Lesson 11.
--Easy-Level Tasks (7)
--1)Show all orders placed after 2022 along with the names of the customers who placed them.
SELECT Orders.OrderID,Customers.FirstName,Customers.LastName,Orders.OrderDate FROM Orders
JOIN Customers
ON Orders.CustomerID=Customers.CustomerID
WHERE YEAR(Orders.OrderDate)>'2022'

--2)Display the names of employees who work in either the Sales or Marketing department.
SELECT Employees.Name,Departments.DepartmentName FROM Employees
JOIN Departments
ON Employees.DepartmentID=Departments.DepartmentID
WHERE Departments.DepartmentName='Sales' or Departments.DepartmentName='Marketing'

--3)Show the highest salary for each department.
SELECT Departments.DepartmentName, MAX(employees.salary) AS Max_sal_each_dpt FROM Departments
JOIN Employees
ON Departments.DepartmentID=Employees.DepartmentID
GROUP BY Departments.DepartmentName

--4)List all customers from the USA who placed orders in the year 2023.
SELECT Customers.FirstName,Customers.LastName,Orders.OrderID,Orders.OrderDate FROM Customers
JOIN Orders
ON Customers.CustomerID=Orders.CustomerID
WHERE Customers.Country='USA' AND YEAR(Orders.OrderDate)=2023

--5)Show how many orders each customer has placed.
SELECT Customers.FirstName,Customers.LastName, COUNT(orders.orderid) as totalorders FROM Orders
JOIN Customers
ON Customers.CustomerID=Orders.CustomerID
GROUP BY  Customers.FirstName,Customers.LastName

--6)Display the names of products that are supplied by either Gadget Supplies or Clothing Mart.
SELECT Products.ProductName,Suppliers.SupplierName FROM Products
JOIN Suppliers
ON Products.SupplierID=Suppliers.SupplierID
WHERE Suppliers.SupplierName='Gadget Supplies' or Suppliers.SupplierName='Clothing Mart'

--7)For each customer, show their most recent order. Include customers who haven't placed any orders.
SELECT Customers.FirstName,Customers.LastName,MAX(orders.orderdate) as most_recent_ord FROM Customers
LEFT JOIN Orders
ON Customers.CustomerID=Orders.CustomerID
GROUP BY Customers.FirstName,Customers.LastName
----------------------------------------------------------------------------------------------
--Medium-Level Tasks (6)
--8)Show the customers who have placed an order where the total amount is greater than 500.
SELECT Customers.FirstName,Customers.LastName,Orders.TotalAmount as OrderTotal FROM Orders
JOIN Customers
ON Customers.CustomerID=Orders.CustomerID
WHERE Orders.TotalAmount>500

--9)List product sales where the sale was made in 2022 or the sale amount exceeded 400.
SELECT Products.ProductName,Sales.SaleDate,Sales.SaleAmount FROM Products
JOIN Sales
ON Products.ProductID=Sales.ProductID
WHERE YEAR(Sales.SaleDate)='2022' or Sales.SaleAmount>400

--10) Display each product along with the total amount it has been sold for.
SELECT Products.ProductName,SUM(Sales.saleamount) as totalsalesamount FROM Sales
JOIN Products
ON Products.ProductID=Sales.ProductID
GROUP BY  Products.ProductName

--11)Show the employees who work in the HR department and earn a salary greater than 60000.
SELECT Employees.Name,Departments.DepartmentName,Employees.Salary FROM Employees
JOIN Departments
ON Employees.DepartmentID=Departments.DepartmentID
WHERE Departments.DepartmentName='Human Resources' AND Employees.Salary>60000

--12)List the products that were sold in 2023 and had more than 100 units in stock at the time.
SELECT Products.ProductName,Sales.SaleDate,Products.StockQuantity FROM Products
JOIN Sales
ON Products.ProductID=Sales.ProductID
WHERE YEAR(Sales.SaleDate)='2023' and Products.StockQuantity>100

--13) Show employees who either work in the Sales department or were hired after 2020.
SELECT Employees.Name,Departments.DepartmentName,Employees.HireDate FROM Employees
JOIN Departments
ON Employees.DepartmentID=Departments.DepartmentID
WHERE Departments.DepartmentName='Sales' or YEAR(employees.hiredate)>2020
----------------------------------------------------------------------------------------------
--Hard-Level Tasks (7)
--14)List all orders made by customers in the USA whose address starts with 4 digits.
SELECT 
	Customers.FirstName,
	Customers.LastName,
	Orders.OrderID,
	Customers.Address,
	Orders.OrderDate
FROM Customers
JOIN Orders
ON Customers.CustomerID=Orders.CustomerID
WHERE Customers.Country='USA' AND Customers.Address LIKE '[0-9][0-9][0-9][0-9]%'

--15) Display product sales for items in the Electronics category or where the sale amount exceeded 350.
SELECT Products.ProductName,Products.Category,Sales.SaleAmount FROM Products
JOIN Sales
ON Products.ProductID=Sales.ProductID
WHERE Products.Category=1 OR Sales.SaleAmount>350

--16)Show the number of products available in each category.
SELECT Categories.CategoryName, COUNT(Products.productname) as productcount FROM Products
JOIN Categories
ON Categories.CategoryID=Products.Category
WHERE Products.stockquantity > 0
GROUP BY Categories.CategoryName

--17) List orders where the customer is from Los Angeles and the order amount is greater than 300.
SELECT Customers.FirstName,Customers.LastName,Customers.City,Orders.OrderID,Orders.TotalAmount FROM Customers
JOIN Orders
ON Customers.CustomerID=Orders.CustomerID
WHERE Customers.City='Los Angeles' and Orders.TotalAmount>300

--18)Display employees who are in the HR or Finance department, or whose name contains at least 4 vowels.
SELECT Employees.Name,Departments.DepartmentName FROM Employees
JOIN Departments
ON Employees.DepartmentID=Departments.DepartmentID 
WHERE Departments.DepartmentName='Human Resources' or Departments.DepartmentName='Finance' 
or Employees.Name like '%[A,E,O,I,U]%[A,E,O,I,U]%[A,E,O,I,U]%[A,E,O,I,U]%'

--19)Show employees who are in the Sales or Marketing department and have a salary above 60000.
SELECT Employees.Name,Departments.DepartmentName,Employees.Salary FROM Employees
JOIN Departments
ON Employees.DepartmentID=Departments.DepartmentID AND Employees.Salary>60000
WHERE Departments.DepartmentName='Sales' or Departments.DepartmentName='Marketing'
