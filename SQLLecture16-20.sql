---LECTURE 16 : COALESCE FUNCTION ---

--COALESCE() FUNCTION : Returns the first NON NULL value

use SampleDB
Go

Create table tblFullNames
(
	Id int primary key identity(1,1),
	FirstName varchar(50),
	MiddleName varchar(50),
	LastName varchar(50)
)


Insert into tblFullNames values('Sam', NULL, NULL)
Insert into tblFullNames values(NULL, 'Todd', 'Tanzan')
Insert into tblFullNames values(NULL , NULL, 'Sara')
Insert into tblFullNames values('Ben', 'Parker', NULL)
Insert into tblFullNames values('James', 'Nick', 'Nancy')


Select * from tblFullNames

--In nutshell COALESCE returns the FIRST non-null value from the given column names or row.
Select COALESCE(FirstName, MiddleName, LastName) as Names from tblFullNames


---LECTURE 17 : UNION AND UNIOIN ALL ---

--UNION and UNION ALL operators in SQL Server, are used to combine the result-sett of two or more SELECT queries.
--NOTE - For UNION and UNION ALL to work, the Number, Data types, and the order of the columns in the select statements should be same.

Create table tblIndiaCustomers
(
	Id int primary key identity(1,1),
	[Name] varchar(50),
	Email varchar(50)
)


Create table tblUKCustomers
(
	Id int primary key identity(1,1),
	[Name] varchar(50),
	Email varchar(50)
)

Insert into tblIndiaCustomers values ('Raj', 'R@R.com')
Insert into tblIndiaCustomers values ('Sam', 'S@S.com')

Insert into tblUKCustomers values ('Ben', 'B@B.com')
Insert into tblUKCustomers values ('Sam', 'S@S.com')

Select * from tblIndiaCustomers
Select * from tblUKCustomers


Select Name, Email from tblIndiaCustomers
UNION
Select Name, Email from tblUKCustomers

Select Name, Email from tblIndiaCustomers
UNION ALL
Select Name, Email from tblUKCustomers

--Difference between UNION and UNION ALL
-- 1. UNION removes duplicate rows, where as UNION ALL does not
-- 2. UNION has to perform distinct sort to remove duplicates, which makes it less faster than UNION ALL

--NOTE: Estimated query execution plan - CTRL + L

Select * from tblIndiaCustomers
UNION ALL
Select * from tblUKCustomers
Order By Name

--JOINS vs UNION : Inshort UNION combines rows from 2 or more table, where JOINS combine columns from 2 or more table.