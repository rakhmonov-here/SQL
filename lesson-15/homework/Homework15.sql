--Homework. Lesson 15
--Level 1. Basic Subqueries
--1)Retrieve employees who earn the minimum salary in the company. Tables: employees (columns: id, name, salary)

SELECT id,name,salary FROM Employees
WHERE salary = (SELECT MIN(salary) FROM Employees)

--2)Retrieve products priced above the average price. Tables: products (columns: id, product_name, price)

SELECT id,product_name,price FROM products
WHERE price>(SELECT AVG(price) FROM products)
----------------------------------------------------------------------------------------------------------------
--Level 2. Nested Subqueries with Conditions
--3)Find Employees in Sales Department Task: Retrieve employees who work in the "Sales" department.

SELECT*FROM employees
WHERE department_id IN (SELECT department_id FROM departments WHERE employees.department_id=departments.id AND department_name='Sales')

--4)Retrieve customers who have not placed any orders.

SELECT * FROM customers
WHERE customer_id NOT IN (SELECT order_id FROM orders WHERE customers.customer_id=orders.customer_id)
---------------------------------------------------------------------------------------------------------------
--Level 3. Aggregation and Grouping in Subqueries
--5) Retrieve products with the highest price in each category.

SELECT * FROM products AS a
WHERE price = (SELECT MAX(price) FROM products AS b WHERE a.category_id=b.category_id)

--6)Retrieve employees working in the department with the highest average salary. 

SELECT  TOP 1 WITH TIES *,(SELECT AVG(Salary) FROM employees WHERE departments.id=employees.department_id) AS avg_salary FROM departments
ORDER BY avg_salary DESC

-------------------------------------------------------------------------------------------------------------
--Level 4. Correlated Subqueries
--7)Retrieve employees earning more than the average salary in their department.

SELECT * FROM employees AS a
WHERE salary > (SELECT AVG(salary) FROM employees AS b WHERE a.department_id=B.department_id)

--8)Retrieve students who received the highest grade in each course.

SELECT students.student_id, 
students.name,
a.course_id,
a.grade
FROM grades AS a
INNER JOIN students
ON a.student_id=students.student_id
WHERE a.grade = (SELECT MAX(b.grade) from grades AS b WHERE a.course_id=b.course_id)
ORDER BY a.course_id

----------------------------------------------------------------------------------------------------------------
--Level 5. ubqueries with Ranking and Complex Conditions
--9) Retrieve products with the third-highest price in each category.

SELECT * FROM products AS a
WHERE 3 = (SELECT COUNT(DISTINCT price) FROM products AS b WHERE a.price<=b.price)

--10)Retrieve employees with salaries above the company average but below the maximum in their department.

SELECT * FROM employees AS a
WHERE salary>(SELECT AVG(salary) FROM employees) AND 
salary<(SELECT MAX(salary) FROM employees AS b WHERE a.department_id=b.department_id)
