--Homework. Lesson 13
--Easy Tasks
/*1)You need to write a query that outputs "100-Steven King", meaning 
emp_id + first_name + last_name in that format using employees table.*/

SELECT CONCAT(Employee_id,'-',FIRST_NAME,' ',LAST_NAME) AS Emp_info
FROM Employees

/*2)Update the portion of the phone_number in the employees table, within the phone number 
the substring '124' will be replaced by '999'. */

SELECT REPLACE(SUBSTRING(phone_number,CHARINDEX('124',phone_number),LEN(phone_number)),'124','999')
FROM Employees

/*3)That displays the first name and the length of the first name for all employees whose name 
starts with the letters 'A', 'J' or 'M'. Give each column an appropriate label. Sort the 
results by the employees' first names.(Employees) */

SELECT first_name,
--PATINDEX('A%',first_name) AS first_A,
--PATINDEX('J%',first_name) AS first_J,
--PATINDEX('M%',first_name) AS first_M,
LEN(first_name) AS len_first_name
FROM Employees
WHERE PATINDEX('A%',first_name)<>0 OR PATINDEX('J%',first_name)<>0 OR PATINDEX('M%',first_name)<>0
ORDER BY first_name

--4)Write an SQL query to find the total salary for each manager ID.(Employees table)

SELECT MANAGER_ID, 
SUM(SALARY) AS Tot_salary 
FROM Employees
WHERE MANAGER_ID <> 0
GROUP BY MANAGER_ID

/* 5)Write a query to retrieve the year and the highest value from the columns Max1, Max2, 
and Max3 for each row in the TestMax table. */

SELECT Year1 AS Year,
CASE WHEN Max1>Max2 AND Max1>Max3 THEN Max1
	 WHEN Max2>Max1 AND Max2>Max3 THEN Max2
	 ELSE Max3 END AS Highest_value
FROM TestMax

--6)Find me odd numbered movies and description is not boring.(cinema)

SELECT *,
CHARINDEX('boring',description) AS description
FROM cinema
WHERE id%2 = 1 AND CHARINDEX('boring',description) = 0

/*7)You have to sort data based on the Id but Id with 0 should always be the last row. 
Now the question is can you do that with a single order by column.(SingleOrder) */

SELECT *
--CASE WHEN Id = 0 THEN 1
--	 ELSE 2 END
FROM SingleOrder
ORDER BY CASE WHEN Id = 0 THEN 1
	 ELSE 2 END desc  

/*8)Write an SQL query to select the first non-null value from a set of columns. If the first
column is null, move to the next, and so on. If all columns are null, return null.(person) */

SELECT id,
CASE WHEN ssn IS NOT NULL THEN ssn
	 WHEN ssn IS NULL AND passportid IS NOT NULL THEN passportid
	 WHEN itin IS NOT NULL THEN itin
	 ELSE NULL END AS first_non_null
FROM person
--2-usul
--SELECT Id,
--COALESCE(ssn,passportid,itin) AS first_non_null     
--FROM person
------------------------------------------------------------------------------------------------
--Medium Tasks
--1)Split column FullName into 3 part ( Firstname, Middlename, and Lastname).(Students Table)
SELECT *,
SUBSTRING(fullname,1,CHARINDEX(' ',fullname)-1) AS first_name,
SUBSTRING(FullName,CHARINDEX(' ',fullname,CHARINDEX(' ',fullname)+1)+1,LEN(Fullname)) AS Last_name,
SUBSTRING(FullName,CHARINDEX(' ',Fullname),CHARINDEX(' ',fullname,CHARINDEX(' ',fullname)+1)-CHARINDEX(' ',Fullname)) AS MiddleName
FROM Students

/*2)For every customer that had a delivery to California, provide a result set of the customer 
orders that were delivered to Texas. (Orders Table) */

SELECT CA.CustomerID,CA.OrderID
FROM Orders AS CA
JOIN Orders AS TX
ON CA.CustomerID=TX.CustomerID
WHERE TRIM(CA.DeliveryState) = 'CA' AND TRIM(TX.DeliveryState) = 'TX'

--3)Write an SQL statement that can group concatenate the following values.(DMLTable)
SELECT 
STRING_AGG(String,' ') AS group_table
FROM DMLTable

/*4)Find all employees whose names (concatenated first and last) contain the letter "a" 
at least 3 times. */
SELECT 
CONCAT_WS(' ',FIRST_NAME,LAST_NAME) AS Full_Name
--LEN(CONCAT_WS(' ',FIRST_NAME,LAST_NAME)) - LEN(REPLACE(CONCAT_WS(' ',FIRST_NAME,LAST_NAME),'A',''))
FROM Employees
WHERE LEN(CONCAT_WS(' ',FIRST_NAME,LAST_NAME)) - LEN(REPLACE(CONCAT_WS(' ',FIRST_NAME,LAST_NAME),'A',''))>=3

/*5)The total number of employees in each department and the percentage of those employees 
who have been with the company for more than 3 years(Employees) */

SELECT DEPARTMENT_ID, 
COUNT(EMPLOYEE_ID) AS NUM_EMP,
COUNT(CASE WHEN HIRE_DATE < DATEADD(YEAR, -3, GETDATE()) THEN 1 END) AS EMPLOYEES_OVER_3_YEARS,
ROUND(COUNT(CASE WHEN HIRE_DATE < DATEADD(YEAR, -3, GETDATE()) THEN 1 END) * 100.0 / COUNT(*), 2) AS PERCENT_OVER_3_YEARS
FROM Employees
WHERE DEPARTMENT_ID <> 0
GROUP BY DEPARTMENT_ID  

/*6)Write an SQL statement that determines the most and least experienced Spaceman ID 
by their job description.(Personal) */

SELECT a.JobDescription,MIN(B.MISSIONCOUNT) AS Least_exp, MAX(B.MissionCount) AS Most_exp
FROM Personal AS a
INNER JOIN Personal AS b
ON a.JobDescription=b.JobDescription
GROUP BY A.JobDescription

------------------------------------------------------------------------------------------------
--Difficult Task
/*1)Write an SQL query that separates the uppercase letters, lowercase letters, numbers, 
and other characters from the given string 'tf56sd#%OqH' into separate columns. */

DECLARE @letter VARCHAR(50) =  'tf56sd#%OqH'
DECLARE @uppercase VARCHAR(50) = ''
DECLARE @lowercase VARCHAR(50) = ''
DECLARE @numbers VARCHAR(50) = ''
DECLARE @others VARCHAR(50)= ''
DECLARE @count INT = 1

WHILE @count <= LEN(@letter)
BEGIN
IF ASCII(SUBSTRING(@letter,@count,1)) BETWEEN 65 AND 90 
	BEGIN 
	SET @uppercase = @uppercase + SUBSTRING(@letter,@count,1)
	END
	ELSE IF ASCII(SUBSTRING(@letter,@count,1)) BETWEEN 97 AND 122
	BEGIN 
	SET @lowercase = @lowercase + SUBSTRING(@letter,@count,1)
	END
	ELSE IF ASCII(SUBSTRING(@letter,@count,1)) BETWEEN 48 AND 57
	BEGIN 
	SET @numbers = @numbers + SUBSTRING(@letter,@count,1)
	END
	ELSE IF ASCII(SUBSTRING(@letter,@count,1)) BETWEEN 33 AND 47
	BEGIN
	SET @others = @others + SUBSTRING(@letter,@count,1)
	END
SET @count = @count + 1
END
SELECT @letter,@uppercase AS Uppercase,@lowercase AS Lowercase,@numbers AS Numbers,@others AS Others
/*2)Write an SQL query that replaces each row with the sum of its value and the previous 
rows' value. (Students table) */
SELECT 
    A.StudentID,
    A.FullName,
    SUM(B.Grade) AS Grade
FROM Students A
INNER JOIN Students B ON B.StudentID <= A.StudentID
GROUP BY A.StudentID, A.FullName
ORDER BY A.StudentID

/*3)You are given the following table, which contains a VARCHAR column that contains 
mathematical equations. Sum the equations and provide the answers in the output.(Equations) */

select * from Equations
select *,
SUBSTRING(equation,1,charindex('+',equation)) as plus,
substring(equation,1,charindex('-',Equation)) as minus    --chala
from Equations



--4)Given the following dataset, find the students that share the same birthday.(Student Table)
SELECT a.StudentName,a.Birthday,b.StudentName AS pair_st_name
FROM Student AS a
INNER JOIN Student AS b
ON a.StudentName <> b.StudentName AND DAY(a.Birthday)=DAY(b.Birthday) AND MONTH(a.birthday)=MONTH(b.Birthday)
ORDER BY MONTH(a.birthday),DAY(a.Birthday)

/*5)You have a table with two players (Player A and Player B) and their scores. If a pair of
players have multiple entries, aggregate their scores into a single row for each unique pair
of players. Write an SQL query to calculate the total score for each unique 
player pair(PlayerScores) */

SELECT
CASE WHEN PlayerA < PlayerB THEN PlayerA
	 ELSE PlayerB END AS PLAYER1,
CASE WHEN PlayerA < PlayerB THEN PlayerB
	 ELSE PlayerA END AS PLAYER2,
SUM(score) AS TotalScore
FROM PlayerScores
GROUP BY PlayerA,PlayerB
ORDER BY CASE WHEN PlayerA < PlayerB THEN PlayerA
	 ELSE PlayerB END,
CASE WHEN PlayerA < PlayerB THEN PlayerB
	 ELSE PlayerA END

