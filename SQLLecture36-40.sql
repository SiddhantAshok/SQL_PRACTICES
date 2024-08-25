---LECTURE 36 : CLUSTERED AND NONCLUSTERED INDEX ---

--CLUSTERED INDEX
--A Clustered index determines the physical order of data in a table. For this reason, a table can have only one clustered index.

--Note that Id column is marked as primary. Primary key, constraint create clustered indexes automatically if no clustered index already exists on the table.
--To confirm: Execute sp_helpindex tblEmployeeDetails

Use SampleDB
Go

Create table tblEmpDetials
(
	Id int,
	[Name] nvarchar(50),
	Salary int,
	Gender nvarchar(10),
	City nvarchar(50)
)

Insert into tblEmpDetials values(3, 'John', 4500,'Male', 'New York')
Insert into tblEmpDetials values(1, 'Sam', 2500,'Male', 'London')
Insert into tblEmpDetials values(4, 'Sara', 5500,'Female', 'Tokyo')
Insert into tblEmpDetials values(5, 'Todd', 3100,'Male', 'Toronto')
Insert into tblEmpDetials values(2, 'Pam', 6500,'Female', 'Sydney')

Insert into tblEmpDetials values(6, 'Zack', 1500,'Male', 'Sydney')
Insert into tblEmpDetials values(7, 'Pamela', 1500,'Female', 'Sydney')

Select * from tblEmpDetials

sp_Help tblDepartment
sp_help tblEmpDetials

--A clustered index is analogues to a telephone directory, where the data is arranged by the last name. We just learnt that,
--a table can have only one clustered indeex. However, the index can contain multiple columns (a composite index),
--like the way a telephone directory is organized by last name and first name.

--Create a Composite clustered index on the Gender and Salary columns
Create Clustered Index IX_tblEmpDetials_Gender_Salary on tblEmpDetials (Gender DESC, Salary ASC)

--A table can have only one clustered  index and it determines the order of the data that gets stored and help the fast retrieval of data.


--NONCLUSTERED INDEX
--A NONCLUSTERED INDEX is analogous t oan index in a textbook. The data is stored in one place, the index in another place. The index will have pointers to the storage location of the data.
--Since, the nonclustered index is stored seperately from the actual data, a table can have more than one non clustered index, 
--just like how a book can have an index by chapters at the beginning and another index by common terms at the end.

--In the index itself, the data is stored in an ascending or descending order of the index key, which doesn't in any way influence the storage of data in the table.

Create NonClustered Index IX_tblEmpDetails_Name on tblEmpDetials([Name] ASC)
Create NonClustered Index IX_tblEmpDetails_City on tblEmpDetials([City] DESC)

--Differences
--	1. ONLY ONE CLUSTERED INDEX per table, where as you can have more than one non clustered index
--	2. CLUSTERED INDEX IS FASTER than a non clustered index, because, the clustered index has to refer back to the table, if the selected column is not present in the index.
--	3. CLUSTERED INDEX DETEREMINES THE STORAGE ORDER of rows in the table, and hence doesn't require additional disk space, but where as a Non-Clustered index stored separately from the tabl, additional storage space is required.

---LECTURE 37 : UNIQUE AND NON UNIQUE INDEXES ---

Create table [tblEmpDetails]
(
	[Id] int Primary Key,
	[FirstName] nvarchar(50),
	[LastName] nvarchar(50),
	[Salary] int,
	[Gender] nvarchar(10),
	[City] nvarchar(50)
)

sp_helpIndex tblEmpDetails

Insert into tblEmpDetails Values(1, 'Mike', 'Sandoz', 4500, 'Male', 'New York')
Insert into tblEmpDetails Values(1, 'Michael', 'Parcel', 5500, 'Male', 'New York')

Insert into tblEmpDetails Values(2, 'Spike', 'Saul', 6500, 'Male', 'New York')
Insert into tblEmpDetails Values(3, 'Mikey', 'Mouse', 7500, 'Male', 'New York')

--UNIQUE INDEX
--Unique index is used to enforce uniqueness of key values in the index.
--NOTE : By default, PRIMARY KEY constraint, creates a unique clustered index.

--UNIQUESNESS is a property of an index, and both clustered and non-clustered indexes can be UNIQUE.

--CREATE UNIQUE NONCLUSTERED INDEX UIX_tblEmpDetails_FirstName_LastName On tblEmpDetails(FirstName ASC, LastName ASC)
--CREATE NONCLUSTERED INDEX UIX_tblEmpDetails_Gender On tblEmpDetails(Gender ASC)
--CREATE CLUSTERED INDEX IX_tblEmpDetails_Salary on tblEmpDetails(Salary ASC)

--DIFFERENCE BETWEEN UNIQUE CONSTRAINT AND UNIQUE INDEX
--There are no major differeces between a unique constraint and unique index. In fact when you add a unique constraint, a unique index gets created behind the scenes.


Alter table tblEmpDetails
Add Constraint UQ_tblEmpDetails_City
UNIQUE (City)

--Or
Alter table tblEmpDetails
Add Constraint UQ_tblEmpDetails_City
UNIQUE Clustered (City)

