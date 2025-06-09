--Homework. Lesson 14
--Easy Tasks
--1)Write a SQL query to split the Name column by a comma into two separate columns: Name and Surname.(TestMultipleColumns)

SELECT
SUBSTRING(Name,1,CHARINDEX(',',Name)-1) AS Name,
SUBSTRING(Name, CHARINDEX(',',Name)+1,LEN(Name)) AS Surname
FROM TestMultipleColumns

--2)Write a SQL query to find strings from a table where the string itself contains the % character.(TestPercent)

SELECT*
FROM TestPercent
WHERE PATINDEX('%[%]%',Strs)<>0

--3)In this puzzle you will have to split a string based on dot(.).(Splitter)

SELECT Id,
CASE WHEN CHARINDEX('.',Vals)>0 THEN SUBSTRING(Vals,1,CHARINDEX('.',Vals)-1)
	 ELSE Vals END AS Word1,
CASE WHEN LEN(Vals) - LEN(REPLACE(Vals,'.','')) = 2 
THEN SUBSTRING(Vals,CHARINDEX('.',Vals)+1,CHARINDEX('.',Vals,CHARINDEX('.',Vals)+1)-CHARINDEX('.',Vals)-1)
	 WHEN LEN(Vals) - LEN(REPLACE(Vals,'.','')) = 1
THEN SUBSTRING(Vals,CHARINDEX('.',Vals)+1,LEN(Vals))
	 ELSE NULL END AS Word2,
CASE WHEN LEN(Vals) - LEN(REPLACE(Vals,'.','')) = 2 
THEN SUBSTRING(Vals,CHARINDEX('.',Vals,CHARINDEX('.',Vals)+1)+1,LEN(Vals))
	 ELSE NULL END AS Word3
FROM Splitter

--4)Write a SQL query to replace all integers (digits) in the string with 'X'.(1234ABC123456XYZ1234567890ADS)

DECLARE @letter VARCHAR(100) = '1234ABC123456XYZ1234567890ADS'
DECLARE @result VARCHAR(100) = @letter
DECLARE @count INT = 1

WHILE @count <= LEN(@letter)
BEGIN
IF ASCII(SUBSTRING(@letter,@count,1)) BETWEEN 48 AND 57
  BEGIN
  SET @result =  REPLACE(@result,SUBSTRING(@letter,@count,1),'X')
SET @count=@count+1
  END
ELSE
SET @count=@count+1
 END
SELECT @letter,@result

--5)Write a SQL query to return all rows where the value in the Vals column contains more than two dots (.).(testDots)
SELECT *
FROM testDots
WHERE LEN(Vals) - LEN(REPLACE(Vals,'.',''))>2

--6)Write a SQL query to count the spaces present in the string.(CountSpaces)
SELECT *, 
LEN(TRIM(texts))-LEN(REPLACE(TRIM(texts),' ',''))
FROM CountSpaces

--7)write a SQL query that finds out employees who earn more than their managers.(Employee)
SELECT a.Name
FROM Employee AS a
INNER JOIN Employee AS b
ON a.ManagerId = b.Id
WHERE a.Salary > b.Salary

/*8)Find the employees who have been with the company for more than 10 years, but less than 15 years. 
Display their Employee ID, First Name, Last Name, Hire Date, and the Years of Service 
(calculated as the number of years between the current date and the hire date).(Employees) */

SELECT EMPLOYEE_ID, FIRST_NAME,LAST_NAME,HIRE_DATE,
DATEDIFF(YEAR,HIRE_DATE,GETDATE()) AS Year_of_service
FROM Employees
WHERE DATEDIFF(YEAR,HIRE_DATE,GETDATE()) > 10 AND DATEDIFF(YEAR,HIRE_DATE,GETDATE()) < 15
----------------------------------------------------------------------------------------------------------------
--Medium Tasks
--1)Write a SQL query to separate the integer values and the character values into two different columns.(rtcfvty34redt)

DECLARE @letter VARCHAR(50) = 'rtcfvty34redt'
DECLARE @lowercase VARCHAR(50) = ' '
DECLARE @numbers VARCHAR(50) = ' '
DECLARE @count INT = 1

WHILE @count <= LEN(@letter)
BEGIN
IF ASCII(SUBSTRING(@letter,@count,1)) BETWEEN 48 AND 57
	BEGIN
SET @numbers = @numbers + SUBSTRING(@letter,@count,1)
	END
ELSE
	BEGIN
SET @lowercase = @lowercase + SUBSTRING(@letter,@count,1)
	END
SET @count = @count + 1
END
SELECT @letter AS text, @lowercase AS characters, @numbers AS numbers

/*2)write a SQL query to find all dates' Ids with higher temperature compared to its previous (yesterday's) 
dates.(weather) */
SELECT b.Id
FROM weather AS a
INNER JOIN weather AS b
ON a.RecordDate = DATEADD(Day,-1,b.RecordDate)
WHERE b.Temperature > a.Temperature

--3)Write an SQL query that reports the first login date for each player.(Activity)
SELECT player_id,
MIN(event_date) AS First_login_date
FROM Activity
GROUP BY player_id

--4)Your task is to return the third item from that list.(fruits)
SELECT*,
SUBSTRING(fruit_list,
CHARINDEX(',',fruit_list,CHARINDEX(',',fruit_list)+1)+1,
CHARINDEX(',',fruit_list,CHARINDEX(',',fruit_list,CHARINDEX(',',fruit_list)+1)+1)-CHARINDEX(',',fruit_list,CHARINDEX(',',fruit_list)+1)-1) AS Third_item
FROM fruits 

--5)Write a SQL query to create a table where each character from the string will be converted into a row.(sdgfhsdgfhs@121313131)

DECLARE @letter VARCHAR(100) ='sdgfhsdgfhs@121313131'
DECLARE @count INT = 1

WHILE @count<=LEN(@letter)
BEGIN
 PRINT SUBSTRING(@letter,@count,1) 
 SET @count=@count+1
END

/*6)You are given two tables: p1 and p2. Join these tables on the id column. The catch is: when the value 
of p1.code is 0, replace it with the value of p2.code.(p1,p2) */
--1)CASE WHEN BILAN
SELECT 
CASE WHEN p1.code = 0 THEN p2.code   
	 ELSE p1.code END
FROM p1
INNER JOIN p2
ON p1.id = p2.id
--2) REPLACE BILAN
SELECT 
REPLACE(p1.code,'0',p2.code)
FROM p1
INNER JOIN p2
ON p1.id = p2.id

--7)Write an SQL query to determine the Employment Stage for each employee based on their HIRE_DATE. The stages are defined as follows:
If the employee has worked for less than 1 year → 'New Hire'
If the employee has worked for 1 to 5 years → 'Junior'
If the employee has worked for 5 to 10 years → 'Mid-Level'
If the employee has worked for 10 to 20 years → 'Senior'
If the employee has worked for more than 20 years → 'Veteran'(Employees)

SELECT *,
CASE WHEN DATEDIFF(YEAR,HIRE_DATE,GETDATE())<1 THEN 'New Fire'
	 WHEN DATEDIFF(YEAR,HIRE_DATE,GETDATE())<5 THEN 'Junior'
	 WHEN DATEDIFF(YEAR,HIRE_DATE,GETDATE())<10 THEN 'Mid-level'
	 WHEN DATEDIFF(YEAR,HIRE_DATE,GETDATE())<20 THEN 'Senior'
	 ELSE 'Veteran' END AS Employement_stage
FROM Employees

--8)Write a SQL query to extract the integer value that appears at the start of the string in a column named Vals.(GetIntegers)
SELECT *,
CASE WHEN PATINDEX('[0-9]%',VALS) = 1 THEN SUBSTRING(VALS,1,PATINDEX('[0-9]%',VALS))
	 ELSE NULL END AS int_value
FROM GetIntegers

---------------------------------------------------------------------------------------------------------------
--Difficult Tasks
--1)In this puzzle you have to swap the first two letters of the comma separated string.(MultipleVals)

SELECT *,
stuff(stuff (Vals,2,2,substring(Vals,charindex(',',Vals)-1,1)),1,1,substring(Vals,charindex(',',Vals)+1,2)) AS swaped_vals
FROM MultipleVals

--2)Write a SQL query that reports the device that is first logged in for each player.(Activity)
SELECT device_id,player_id,
MIN(event_date) AS First_login_date
FROM Activity
GROUP BY player_id,device_id

/*3)You are given a sales table. Calculate the week-on-week percentage of sales per area for each financial week.
For each week, the total sales will be considered 100%, and the percentage sales for each day of the week 
should be calculated based on the area sales for that week.(WeekPercentagePuzzle) */
SELECT 
Area,
ISNULL(SalesLocal,0) AS SalesLocal,
ISNULL(SalesRemote,0) AS SalesRemote,
ISNULL(SalesLocal,0)+ISNULL(SalesRemote,0) AS TotalSales,
SUM(ISNULL(SalesLocal,0)+ISNULL(SalesRemote,0)) AS Total_week_sales
FROM WeekPercentagePuzzle
GROUP BY Area,SalesLocal,SalesRemote



