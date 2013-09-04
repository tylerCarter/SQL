IF DB_ID('testdb') IS NULL
CREATE DATABASE testdb;

USE testdb;

IF OBJECT_ID('dbo.Employees', 'U') IS NOT NULL
	DROP TABLE dbo.Employees;
	
	
CREATE TABLE dbo.Employees
(
	empid		INT         NOT NULL,
	firstname	VARCHAR(30)	NOT NULL,
	lastname	VARCHAR(30)	NOT NULL,
	hiredate	DATE		NOT NULL,
	mgrid		INT			NULL,
	ssn			VARCHAR(20)	NOT NULL,
	salary		MONEY		NOT NULL
);

ALTER TABLE	dbo.Employees
	ADD CONSTRAINT PK_Employees
	PRIMARY KEY (empid);
	
ALTER TABLE dbo.Employees
	ADD CONSTRAINT UNQ_Employees_ssn
	UNIQUE(ssn);

IF OBJECT_ID('dbo.Orders', 'U') IS NOT NULL
	DROP TABLE dbo.Orders;
	
CREATE TABLE dbo.Orders
(
	orderid		INT			NOT NULL,
	empid		INT			NOT NULL,
	custid		VARCHAR(10)	NOT NULL,
	orderts		DATETIME	NOT NULL,
	qty			INT			NOT NULL,
	CONSTRAINT PK_Orders
		PRIMARY KEY(OrderID)
);

ALTER TABLE	dbo.Orders
	ADD CONSTRAINT FK_Orders_Employees
	FOREIGN KEY(empid)
	REFERENCES dbo.Employees(empid);
	
ALTER TABLE dbo.Employees
	ADD CONSTRAINT FK_Employees_Employees
	FOREIGN KEY(mgrid)
	REFERENCES dbo.Employees(empid);
	
ALTER TABLE dbo.Employees
	ADD CONSTRAINT CHR_Employees_salary
	CHECK(salary > 0);

ALTER TABLE dbo.Orders
	ADD CONSTRAINT DFS_Orders_orderts
	DEFAULT(CURRENT_TIMESTAMP) FOR orderts;