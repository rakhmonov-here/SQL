--Homework. Lesson 10.
--Easy-Level Tasks (10)
--1)Using the Employees and Departments tables, write a query to return the names and salaries of employees whose salary is greater than 50000, along with their department names.
select employees.Name,employees.salary,departments.departmentname from employees
left join departments
on employees.departmentid=departments.departmentid
where employees.salary>50000

--2)Using the Customers and Orders tables, write a query to display customer names and order dates for orders placed in the year 2023.
select cust.firstname,cust.lastname,ord.orderdate from customers as cust
left join orders as ord
on cust.customerid=ord.customerid
where ord.orderdate between '01/01/2023' and '12/31/2023'

--3)Using the Employees and Departments tables, write a query to show all employees along with their department names. Include employees who do not belong to any department.
select emp.name,dept.departmentname from employees as emp
left join departments as dept
on emp.departmentid=dept.departmentid

--4)Using the Products and Suppliers tables, write a query to list all suppliers and the products they supply. Show suppliers even if they don’t supply any product.
select sup.suppliername, prod.productname from suppliers as sup
left join products as prod
on prod.supplierid=sup.supplierid

--5)Using the Orders and Payments tables, write a query to return all orders and their corresponding payments. Include orders without payments and payments not linked to any order.
select ord.orderid,ord.orderdate,pay.paymentdate,pay.amount from orders as ord
full join payments as pay
on ord.orderid=pay.orderid

--6)Using the Employees table, write a query to show each employee's name along with the name of their manager.
select emp.name as employeename,man.name as managername from employees as emp
left join employees as man
on man.employeeid=emp.managerid

--7)Using the Students, Courses, and Enrollments tables, write a query to list the names of students who are enrolled in the course named 'Math 101'.
select stud.name,cours.coursename from students as stud
join enrollments as enroll
on stud.studentid=enroll.studentid
join courses as cours
on enroll.courseid=cours.courseid
where cours.coursename = 'Math 101'

--8)Using the Customers and Orders tables, write a query to find customers who have placed an order with more than 3 items. Return their name and the quantity they ordered.
select cust.firstname,cust.lastname,ord.quantity from customers as cust
join orders as ord
on cust.customerid=ord.customerid
where ord.quantity>3

--9)Using the Employees and Departments tables, write a query to list employees working in the 'Human Resources' department.
select emp.name,dept.departmentname from employees as emp
join departments as dept
on emp.departmentid=dept.departmentid
where dept.departmentname='Human Resources'
----------------------------------------------------------------------------------------------
--Medium-Level Tasks (9)
--10)Using the Employees and Departments tables, write a query to return department names that have more than 5 employees.
select dept.departmentname,count(emp.name) as Employeecount from employees as emp
left join departments as dept
on dept.departmentid=emp.departmentid
group by dept.departmentname
having count(emp.name)>5

--11)Using the Products and Sales tables, write a query to find products that have never been sold.
select prod.productid, prod.productname from products as prod
left join  sales as sal
on prod.productid=sal.productid
where sal.saledate is null

--12)Using the Customers and Orders tables, write a query to return customer names who have placed at least one order.
select cust.firstname,cust.lastname,count(ord.orderdate) as totalorders from customers as cust
left join orders as ord
on cust.customerid=ord.customerid
group by cust.firstname,cust.lastname
having count(distinct ord.orderdate)<>0

--13)Using the Employees and Departments tables, write a query to show only those records where both employee and department exist (no NULLs).
--1-usul (inner join)
select emp.name,dept.departmentname from employees as emp
join departments as dept
on emp.departmentid=dept.departmentid
--2-usul(left join)
select emp.name,dept.departmentname from employees as emp
left join departments as dept
on emp.departmentid=dept.departmentid
where dept.departmentname is not null

--14)Using the Employees table, write a query to find pairs of employees who report to the same manager.
select a.name,b.name,b.managerid from employees as a
left join employees as b
on a.managerid=b.employeeid
where b.managerid is not null

--15)Using the Orders and Customers tables, write a query to list all orders placed in 2022 along with the customer name.
select ord.orderid,ord.orderdate,cust.firstname,cust.lastname from orders as ord
left join customers as cust
on ord.customerid=cust.customerid
where ord.orderdate between '01/01/2022' and '12/31/2022'

--16)Using the Employees and Departments tables, write a query to return employees from the 'Sales' department whose salary is above 60000.
select emp.name,emp.salary,dept.departmentname from employees as emp
left join departments as dept
on emp.departmentid=dept.departmentid
where dept.departmentname='Sales' and emp.salary>60000

--17)Using the Orders and Payments tables, write a query to return only those orders that have a corresponding payment.
select ord.orderid,ord.orderdate,pay.paymentdate,pay.amount from orders as ord
left join payments as pay
on ord.orderid=pay.orderid
where pay.paymentdate is not null

--18)Using the Products and Orders tables, write a query to find products that were never ordered.
select prod.productid,prod.productname from products as prod
left join  orders as ord
on prod.productid=ord.productid
where orderid is null
-------------------------------------------------------------------------------------------------
--Hard-Level Tasks (9)
--19)Using the Employees table, write a query to find employees whose salary is greater than the average salary in their own departments.
select a.Name,a.Salary from employees as a
left join employees as b
on a.DepartmentID=b.DepartmentID
group by a.Name,a.Salary,b.DepartmentID
having a.Salary>avg(b.Salary) 

--20)Using the Orders and Payments tables, write a query to list all orders placed before 2020 that have no corresponding payment.
select ord.OrderID,ord.OrderDate from Orders as ord
left join Payments as pay
on ord.OrderID=pay.OrderID
where ord.OrderDate < '01/01/2020' and pay.PaymentDate is null

--21)Using the Products and Categories tables, write a query to return products that do not have a matching category.
select prod.ProductID,prod.ProductName from Products as prod
left join Categories as cat
on prod.Category=cat.CategoryID
where cat.CategoryID is null

--22)Using the Employees table, write a query to find employees who report to the same manager and earn more than 60000.
select a.name,b.name,b.managerid,b.Salary from employees as a
left join employees as b
on a.managerid=b.employeeid
where b.managerid is not null and b.Salary>60000

--23)Using the Employees and Departments tables, write a query to return employees who work in departments which name starts with the letter 'M'.
select emp.Name,dept.departmentname from Employees as emp
left join Departments as dept
on emp.DepartmentID=dept.DepartmentID
where dept.DepartmentName like 'M%'

--24)Using the Products and Sales tables, write a query to list sales where the amount is greater than 500, including product names.
select sal.saleid,prod.ProductName,sal.saleamount from Products as prod
left join Sales as sal
on prod.ProductID=sal.ProductID
where sal.SaleAmount>500

--25)Using the Students, Courses, and Enrollments tables, write a query to find students who have not enrolled in the course 'Math 101'.
select Students.StudentID,Students.Name from Students
left join Enrollments
on Students.StudentID=Enrollments.StudentID
left join Courses
on Enrollments.CourseID=Courses.CourseID
where Courses.CourseName<>'Math 101'

--26)Using the Orders and Payments tables, write a query to return orders that are missing payment details.
select Orders.OrderID,Orders.OrderDate,Payments.PaymentID from Orders
left join Payments
on Orders.OrderID=Payments.OrderID
where Payments.PaymentID is null

--27)Using the Products and Categories tables, write a query to list products that belong to either the 'Electronics' or 'Furniture' category.
select Products.ProductID,Products.ProductName,Categories.CategoryName from Products
left join Categories
on Products.Category=Categories.CategoryID
where Categories.CategoryName='electronics' or Categories.CategoryName='Furniture'


