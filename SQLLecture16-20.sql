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

