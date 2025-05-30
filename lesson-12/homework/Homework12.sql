--Homework. Lesson 12
/*1)Write a solution to report the first name, last name, city, and state of each person in 
the Person table. If the address of a personId is not present in the Address table, 
report null instead.*/
SELECT Person.firstName,Person.lastName,Address.city,Address.state FROM Person
LEFT JOIN Address
ON Person.personId=Address.personId

--2)Write a solution to find the employees who earn more than their managers.
SELECT emp.name FROM Employee AS emp
LEFT JOIN Employee AS man
ON emp.managerId=man.id
WHERE emp.salary>man.salary

--3)Write a solution to report all the duplicate emails.
SELECT email 
--COUNT(email) 
FROM Person
GROUP BY email
HAVING COUNT(email)>=2

--4)Write a solution to delete all duplicate emails, keeping only one unique email with the smallest id.
DELETE FROM person
WHERE ID NOT IN (
SELECT MIN(ID)
FROM person
GROUP BY email)

--5)Find those parents who has only girls.
SELECT DISTINCT girls.ParentName FROM boys
FULL JOIN girls
ON boys.ParentName=girls.ParentName
WHERE boys.name IS NULL

/*6)Find total Sales amount for the orders which weights more than 50 for each customer 
along with their least weight.(from TSQL2012 database, Sales.Orders Table)*/
SELECT  
ord.custid
,MIN(ord.freight) AS min_weight
--,Orddetail.unitprice
--,Orddetail.qty 
, SUM(CASE WHEN freight>=50 THEN unitprice*qty
    ELSE 0 END) AS Total_Sale
FROM Sales.Orders AS ord
JOIN
[Sales].[OrderDetails] AS Orddetail
ON ord.orderid=Orddetail.orderid
GROUP BY custid
ORDER BY custid

--7)Carts
SELECT ISNULL(cart1.Item,' ') AS item1,
ISNULL(Cart2.Item, ' ') AS item2
FROM Cart1
FULL JOIN Cart2
ON Cart1.Item=Cart2.Item

--8)Write a solution to find all customers who never order anything.
SELECT Customers.name FROM Customers
LEFT JOIN Orders
ON Customers.id=Orders.customerId
WHERE Orders.id IS NULL

--9)Write a solution to find the number of times each student attended each exam.
SELECT Students.student_id,Students.student_name,Subjects.subject_name,
COUNT(Examinations.subject_name) as attended_exams 
FROM Students
CROSS JOIN Subjects
LEFT JOIN Examinations
ON Students.student_id=Examinations.student_id AND Subjects.subject_name = Examinations.subject_name
GROUP BY Students.student_id,Students.student_name,Subjects.subject_name
ORDER BY Students.student_id



