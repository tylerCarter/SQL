USE TSQLFundamentals2008;

SELECT empid, YEAR(orderdate) AS orderyear, COUNT(*) AS numorders
FROM Sales.Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate)
HAVING COUNT(*) > 1
ORDER BY empid, orderyear;

SELECT orderid, custid, empid, orderdate, freight
FROM Sales.Orders;

SELECT orderid, empid, orderdate, freight
FROM Sales.Orders
WHERE custid = 71;

SELECT empid, YEAR(orderdate) AS orderyear
FROM Sales.Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate);

SELECT
	empid,
	YEAR(orderdate) AS orderyear,
	SUM(freight) AS totalfreight,
	COUNT(*) AS numorders
FROM Sales.Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate);

--with mistake in SELECT: freight returns not single row
SELECT empid, YEAR(orderdate) AS orderyear, freight
FROM Sales.Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate);

SELECT 
	empid,
	YEAR(orderdate) AS orderyear,
	COUNT(DISTINCT custid) AS numcuts
FROM Sales.Orders
GROUP BY empid, YEAR(orderdate);

SELECT empid, YEAR(orderdate) AS orderyear
FROM Sales.Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate)
HAVING COUNT(*) > 1;

-- mistake: space between two column names
SELECT orderid orderdate
FROM Sales.Orders;

SELECT empid, YEAR(orderdate) AS orderyear, COUNT(*) AS numorders
FROM Sales.Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate)
HAVING COUNT(*) > 1;

--mistake: using aliases before SELECT
SELECT orderid, YEAR(orderdate) AS orderyear
FROM Sales.Orders
WHERE orderyear > 2006;

--upper mistake solution
SELECT orderid, YEAR(orderdate) AS orderyear
FROM Sales.Orders
WHERE YEAR(orderdate) > 2006;

--mistake: using alises before SELECT
SELECT empid, YEAR(orderdate) AS orderyear, COUNT(*) AS numorders
FROM Sales.Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate)
HAVING numorders > 1;

--upper mistake solution
SELECT empid, YEAR(orderdate) AS orderyear, COUNT(*) AS numorders
FROM Sales.Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate)
HAVING COUNT(*) > 1;

SELECT empid, YEAR(orderdate) AS orderyear
FROM Sales.Orders
WHERE custid = 71;

SELECT DISTINCT	empid, YEAR(orderdate) AS orderyear
FROM Sales.Orders
WHERE custid = 71;

SELECT *
FROM Sales.Shippers;

--mistake: reference to alias in the same query
SELECT orderid,
	YEAR(orderdate) AS orderyear,
	orderyear + 1 AS nextyear
FROM Sales.Orders;

--solution to upper mistake
SELECT orderid,
	YEAR(orderdate) AS orderyear,
	YEAR(orderdate) + 1 AS nextyear
FROM Sales.Orders;

SELECT empid, YEAR(orderdate) AS orderyear, COUNT(*) AS numorders
FROM Sales.Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate)
HAVING COUNT(*) > 1
ORDER BY empid, orderyear;

SELECT empid, firstname, lastname, country
FROM HR.Employees
ORDER BY hiredate;

--mistake: DISTINCT with ORDER BY, because there are many employees from same country
SELECT DISTINCT country
FROM HR.Employees
ORDER BY empid;

SELECT TOP(5) orderid, orderdate, custid, empid
FROM Sales.Orders
ORDER BY orderdate DESC;

SELECT TOP(1) PERCENT orderid, orderdate, custid, empid
FROM Sales.Orders
ORDER BY orderdate DESC;

SELECT TOP(5) orderid, orderdate, custid, empid
FROM Sales.Orders
ORDER BY orderdate DESC, orderid DESC;

SELECT TOP(5) WITH TIES orderid, orderdate, custid, empid
FROM Sales.Orders
ORDER BY orderdate DESC;

SELECT orderid, custid, val,
	SUM(val) OVER() AS totalvalue,
	SUM(val) OVER(PARTITION BY custid) AS custtotalvalue
FROM Sales.OrderValues;

SELECT orderid, custid, val,
	100. * val / SUM(val) OVER() AS pctall,
	100. * val / SUM(val) OVER(PARTITION BY custid) AS pctcust
FROM Sales.OrderValues;

SELECT orderid, custid, val,
	ROW_NUMBER() OVER(ORDER BY val) AS rownum,
	RANK() OVER(ORDER BY val) AS rank,
	DENSE_RANK() OVER(ORDER BY val) AS dense_rank,
	NTILE(10) OVER(ORDER BY val) AS ntile
FROM Sales.OrderValues
ORDER BY val;

SELECT orderid, custid, val,
	ROW_NUMBER() OVER(PARTITION BY custid
					  ORDER BY val) AS rownum
FROM Sales.OrderValues
ORDER BY custid, val;

--mistake: DISTINCT after OVER
SELECT DISTINCT val, ROW_NUMBER() OVER(ORDER BY val) AS rownum
FROM Sales.OrderValues;

SELECT val, ROW_NUMBER() OVER(ORDER BY val) AS rownum
FROM Sales.OrderValues
GROUP BY val;

SELECT orderid, empid, orderdate
FROM Sales.Orders
WHERE orderid IN(10248, 10249, 10250);

SELECT orderid, empid, orderdate
FROM Sales.Orders
WHERE orderid BETWEEN 10300 AND 10310;

SELECT empid, firstname, lastname
FROM HR.Employees
WHERE lastname LIKE N'D%';

SELECT orderid, empid, orderdate
FROM Sales.Orders
WHERE orderdate >= '20080101';

SELECT orderid, empid, orderdate
FROM Sales.Orders
WHERE orderdate >= '20080101'
	AND empid IN(1, 3, 5);
	
SELECT orderid, productid, qty, unitprice, discount,
	qty * unitprice * (1 - discount) AS val
FROM Sales.OrderDetails;

SELECT orderid, custid, empid, orderdate
FROM Sales.Orders
WHERE
		custid = 1
	AND empid IN(1, 3, 5)
	OR custid = 85
	AND empid IN(2, 4, 6);
	
SELECT orderid, custid, empid, orderdate
FROM Sales.Orders
WHERE
		(custid = 1
			AND empid IN(1, 3, 5))
		OR 
		(custid = 85
			AND empid IN(2, 4, 6));
			
SELECT productid, productname, categoryid, 
	CASE categoryid
		WHEN 1 THEN 'Beverages'
		WHEN 2 THEN 'Condiments'
		WHEN 3 THEN 'Confections'
		WHEN 4 THEN 'Dairy Products'
		WHEN 5 THEN 'Grains/Cereals'
		WHEN 6 THEN 'Meat/Poultry'
		WHEN 7 THEN 'Produce'
		WHEN 8 THEN 'Seafood'
		ELSE 'Unknown Category'
	END AS categoryname
FROM Production.Products;

SELECT orderid, custid, val,
	CASE NTILE(3) OVER(ORDER BY val)
		WHEN 1 THEN 'Low'
		WHEN 2 THEN 'Medium'
		WHEN 3 THEN 'High'
		ELSE 'Unknown'
	END AS titledesc
FROM Sales.OrderValues
ORDER BY val;

SELECT orderid, custid, val,
	CASE
		WHEN val < 1000.0 THEN 'Less than 1000'
		WHEN val BETWEEN 1000.0 AND 3000.0 THEN 'Between 1000 and 3000'
		WHEN val > 3000.0 THEN 'More than 3000'
		ELSE 'Unknown'
	END AS valuecategory
FROM Sales.OrderValues;

SELECT custid, country, region, city
FROM Sales.Customers
WHERE region = N'WA';

SELECT custid, country, region, city
FROM Sales.Customers
WHERE region <> N'WA';

-- предикант вернет UNKNOWN а не NULL
SELECT custid, country, region, city
FROM Sales.Customers
WHERE region = NULL;

SELECT custid, country, region, city
FROM Sales.Customers
WHERE region IS NULL;

SELECT custid, country, region, city
FROM Sales.Customers
WHERE region <> N'WA' OR region IS NULL;

-- mistake
SELECT 
	orderid,
	YEAR(orderdate) AS orderyear,
	orderyear + 1 AS nextyear
FROM Sales.Orders;

SELECT col1, col2
FROM dbo.T1
WHERE col1 <> 0 AND col2/col1 > 2;

SELECT col1, col2
FROM dbo.T1
WHERE
CASE
WHEN col1 = 0 THEN 'no' -- or 'yes' if row should be returned
WHEN col2/col1 > 2 THEN 'yes'
ELSE 'no'
END = 'yes';

SELECT col1, col2
FROM dbo.T1
WHERE col1 <> 0 and col2 > 2*col1;

SELECT name, description
FROM sys.fn_helpcollations();

SELECT empid, firstname, lastname
FROM HR.Employees
WHERE lastname = N'davis';

SELECT empid, firstname, lastname
FROM HR.Employees
WHERE lastname COLLATE Latin1_General_CS_AS = N'davis';

SELECT empid, firstname + N' ' + lastname AS fullname
FROM HR.Employees;

SELECT custid, country, region, city,
	country + N', ' + region + N', ' + city AS location
FROM Sales.Customers;

SET CONCAT_NULL_YIELDS_NULL OFF; -- don't change behavior
SET CONCAT_NULL_YIELDS_NULL ON;

SELECT custid, country, region, city,
	country + N',' + COALESCE(region, N'') + N',' + city AS location
FROM Sales.Customers;

SELECT SUBSTRING('abcde', 1, 3);

SELECT RIGHT('abcde', 3);

SELECT LEN(N'abcde');

SELECT LEN(N'abcde   ');

SELECT DATALENGTH(N'abcde');

SELECT DATALENGTH(N'abcde     ');

SELECT CHARINDEX(' ', 'Itzik Ben-Gan');

SELECT PATINDEX('%[0-9]%', 'abcd23efgh');

SELECT REPLACE('1-a 2-b', '-', ':');

SELECT empid, lastname,
	LEN(lastname) - LEN(REPLACE(lastname, 'e', '')) AS numoccur
FROM HR.Employees;

SELECT REPLICATE('abc', 3);

SELECT supplierid,
	RIGHT(REPLICATE('0', 9) + CAST(supplierid AS VARCHAR(10)), 10)
		AS srtsupplierid
FROM Production.Suppliers;

SELECT STUFF('xyz', 2, 1, 'abc');

SELECT UPPER('Itzik Ben-Gan');
SELECT LOWER('Itzik Ben-Gan');

SELECT RTRIM(LTRIM(' abc '));

SELECT empid, lastname
FROM HR.Employees
WHERE lastname LIKE N'D%';

SELECT empid, lastname
FROM HR.Employees
WHERE lastname LIKE N'_e%';

SELECT empid, lastname
FROM HR.Employees
WHERE lastname LIKE N'[ABC]%';

SELECT empid, lastname
FROM HR.Employees
WHERE lastname LIKE N'[A-E]%';

SELECT empid, lastname
FROM HR.Employees
WHERE lastname LIKE N'[^A-E]%';

SELECT orderid, custid, empid, orderdate
FROM Sales.Orders
WHERE orderdate = '20070212';

SELECT orderid, custid, empid, orderdate 
FROM Sales.Orders
WHERE orderdate = CAST('20070212' AS DATETIME);

SET LANGUAGE British;
SELECT CAST('02/12/2007' AS DATETIME);

SET LANGUAGE us_english;
SELECT CAST('02/12/2007' AS DATETIME);

SELECT CONVERT(DATETIME, '02/12/2007', 101);

SELECT CONVERT(DATETIME, '02/12/2007', 103);

SELECT orderid, custid, empid, orderdate
FROM Sales.Orders
WHERE orderdate >= '20070212'
	AND orderdate < '20070213';
	
SELECT CAST('12:30:15.123' AS DATETIME);

SELECT orderid, custid, empid, orderdate
FROM Sales.Orders
WHERE YEAR(orderdate) = 2007;

SELECT orderid, custid, empid, orderdate
FROM Sales.Orders
WHERE orderdate >= '20070101' AND orderdate < '20080101';

SELECT orderid, custid, empid, orderdate
FROM Sales.Orders
WHERE YEAR(orderdate) = 2007 AND MONTH(orderdate) = 2;

SELECT orderid, custid, empid, orderdate
FROM Sales.Orders
WHERE orderdate >= '20070201' AND orderdate < '20070301';

SELECT
	GETDATE()			AS [GETDATE],
	CURRENT_TIMESTAMP	AS [CURRENT_TIMESTAMP],
	GETUTCDATE()		AS [GETUTCDATE],
	SYSDATETIME()		AS [SYSDATETIME],
	SYSUTCDATETIME()	AS [SYSUTCDATETIME],
	SYSDATETIMEOFFSET()	AS [SYSDATETIMEOFFSET];
	
SELECT 
	CAST(SYSDATETIME() AS DATE) AS [current_date],
	CAST(SYSDATETIME() AS TIME) AS [current_time];
	
SELECT CAST('20090212' AS DATE);

SELECT CAST(SYSDATETIME() AS DATE);

SELECT CAST(SYSDATETIME() AS TIME);

SELECT CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112);

SELECT CAST(CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112) AS DATETIME);

SELECT CONVERT(CHAR(12), CURRENT_TIMESTAMP, 114);

SELECT CAST(CONVERT(CHAR(12), CURRENT_TIMESTAMP, 114) AS DATETIME);

SELECT SWITCHOFFSET(SYSDATETIMEOFFSET(), '-05:00');

SELECT SWITCHOFFSET(SYSDATETIMEOFFSET(), '+00:00');

SELECT TODATETIMEOFFSET(SYSDATETIMEOFFSET(), '-05:00');

SELECT TODATETIMEOFFSET(SYSDATETIME(), '-05:00');

SELECT DATEADD(YEAR, 1, '20090212');

SELECT DATEDIFF(DAY, '20080212', '20090212');

SELECT 
	DATEADD(
		day,
		DATEDIFF(DAY, '20010101', CURRENT_TIMESTAMP), '20010101');
		
SELECT
	DATEADD(
		month,
		DATEDIFF(month, '20010101', CURRENT_TIMESTAMP), '20010101');
		
SELECT
	DATEADD(
		month,
		DATEDIFF(month, '19991231', CURRENT_TIMESTAMP), '19991231');
		
SELECT DATEPART(month, '20090212');

SELECT
	DAY('20090212') AS theday,
	MONTH('20090212') AS themonth,
	YEAR('20090212') AS theyear;
	
SELECT DATENAME(MONTH, '20090212');

SELECT DATENAME(YEAR, '20090212');

SELECT ISDATE('20090212');

SELECT ISDATE('20090230');

USE TSQLFundamentals2008;
SELECT SCHEMA_NAME(schema_id) AS table_schema_name, name AS table_name
FROM sys.tables;

SELECT 
	name AS column_name,
	TYPE_NAME(system_type_id) AS column_type,
	max_length,
	collation_name,
	is_nullable
FROM sys.columns
WHERE object_id = OBJECT_ID(N'Sales.Orders');

SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = N'BASE TABLE';

SELECT
	COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH,
	COLLATION_NAME, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = N'Sales'
	AND TABLE_NAME = N'Orders';
	
EXEC sys.sp_tables;

EXEC sys.sp_help
@objname = N'Sales.Orders';

EXEC sys.sp_columns
	@table_name = N'Orders',
	@table_owner = N'Sales';
	
EXEC sys.sp_helpconstraint
	@objname = N'Sales.Orders';
	
SELECT
	SERVERPROPERTY('ProductLevel');
	
SELECT
	DATABASEPROPERTY(N'TSQLFundamentals2008', 'Collation');
	
SELECT
	OBJECTPROPERTY(OBJECT_ID(N'Sales.Orders'), 'TableHasPrimaryKey');
	
SELECT
	COLUMNPROPERTY(OBJECT_ID(N'Sales.Orders'), N'shipcountry', 'AllowsNull');
	
-- Exercises

--2.1
SELECT orderid, orderdate, custid, empid
FROM Sales.Orders
WHERE orderdate >= '20070601' AND orderdate < '20070701';

--2.2
SELECT orderid, orderdate, custid, empid
FROM Sales.Orders
WHERE orderdate = DATEADD(month, DATEDIFF(month, '19911231', orderdate), '19911231');

--2.3
SELECT empid, firstname, lastname
FROM HR.Employees
WHERE lastname LIKE '%a%a';

--2.4
SELECT orderid, SUM(qty * unitprice) AS totalvalue
FROM Sales.OrderDetails
GROUP BY orderid
HAVING SUM(qty * unitprice) > 10000
ORDER BY totalvalue DESC;

--2.5
SELECT TOP(3) shipcountry, AVG(freight) AS avgfreight
FROM Sales.Orders
WHERE orderdate >= '20070101' AND orderdate < '20080101'
GROUP BY shipcountry
ORDER BY avgfreight DESC;

--2.6
SELECT custid, orderdate, orderid,
	ROW_NUMBER() OVER(PARTITION BY custid ORDER BY orderdate, orderid) AS rownum
FROM Sales.Orders
ORDER BY custid, rownum;

--2.7
SELECT empid, firstname, titleofcourtesy,
	CASE titleofcourtesy
		WHEN 'Ms.' THEN 'Female'
		WHEN 'Mrs.' THEN 'Female'
		WHEN 'Mr.' THEN 'Male'
		ELSE 'Unknown'
	END AS gender
FROM HR.Employees;

--2.8
SELECT custid, region
FROM Sales.Customers
ORDER BY
	CASE WHEN region IS NULL THEN 1 ELSE 0 END, region;