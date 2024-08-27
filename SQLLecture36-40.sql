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

Insert into tblEmpDetails(Id,[FirstName],[LastName], Salary, Gender, City ) Values(1,'Mike', 'Sandoz', 4500, 'Male', 'New York')
Insert into tblEmpDetails(Id,[FirstName],[LastName], Salary, Gender, City ) Values(2,'Michael', 'Parcel', 5500, 'Male', 'New Delhi')
						  
Insert into tblEmpDetails(Id,[FirstName],[LastName], Salary, Gender, City ) Values(3,'Spike', 'Saul', 6500, 'Male', 'Canada')
Insert into tblEmpDetails(Id,[FirstName],[LastName], Salary, Gender, City ) Values(4,'Mikey', 'Mouse', 4500, 'Male', 'Brazile')

Select * from tblEmpDetails

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

---LECTURE 38 : ADVANTAGES AND DISADVANTAGES OF INDEXES ---

--Advantages
--As we have learnt that, indexes are used by queris to find the data quickly.

Select * from tblEmpDetails

Select Salary, Sum(Salary), Gender from tblEmpDetails Group By Salary, Gender

--Indexes can help not even retrieval but also in Delete, Update, Order By and Group by queries

--Disadvantages
--ADDITIONAL DISK SPACE : Only in case of Non Clutered indexes.
--INSERT UPDATE AND DELETE STATEMENT CAN BECOME SLOW : Incase of too many Non clustered Indexes the update,delete and insert statement will have to make changes in table and all the indexes as well which can slower the process.


--WHAT IS COVERING QUERY : If all the columns that you have requested in the select clause of query, are present in the index, then there is no need to lookup in the table again. The requested columns data can simply be returned from the index.
--A CLUSTERED INDEX, ALWAYS COVERS A QUERY, since it contains all of the data in a table. A composite index is an index on two or more columns. Both clustered and non-clustered indexes can be composite indexes. To a certain extent, a composite index, can cover a query.


---LECTURE 39 : VIEWS ---

--A view is nothing more than a saved SQL query. A view can also be considered as a virtual table.

--SQL Script to create tblEmployee table:
CREATE TABLE tblEmpInfo
(
  Id int Primary Key,
  Name nvarchar(30),
  Salary int,
  Gender nvarchar(10),
  DepartmentId int
)

--SQL Script to create tblDepartment table: 
CREATE TABLE tblEmpDept
(
 DeptId int Primary Key,
 DeptName nvarchar(20)
)

--Insert data into tblDepartment table
Insert into tblEmpDept values (1,'IT')
Insert into tblEmpDept values (2,'Payroll')
Insert into tblEmpDept values (3,'HR')
Insert into tblEmpDept values (4,'Admin')

--Insert data into tblEmployee table
Insert into tblEmpInfo values (1,'John', 5000, 'Male', 3)
Insert into tblEmpInfo values (2,'Mike', 3400, 'Male', 2)
Insert into tblEmpInfo values (3,'Pam', 6000, 'Female', 1)
Insert into tblEmpInfo values (4,'Todd', 4800, 'Male', 4)
Insert into tblEmpInfo values (5,'Sara', 3200, 'Female', 1)
Insert into tblEmpInfo values (6,'Ben', 4800, 'Male', 3)


Select [Name], Salary, Gender, DeptName from tblEmpInfo inner join tblEmpDept on tblEmpDept.DeptId = tblEmpInfo.DepartmentId

Create View vWEmployeesByDept
As 
Select [Name], Salary, Gender, DeptName from tblEmpInfo inner join tblEmpDept on tblEmpDept.DeptId = tblEmpInfo.DepartmentId

Select * from vWEmployeesByDept

sp_helptext vWEmployeesByDept

--Advantages of using a View
--	1. Views can be used to reduce the complexity of the database schema
--	2. Views can be used as a mechanism to implement row and column level security
--	3. Views can be used to present aggregated data and hide detailed data.

--Row level security [Shows only the IT employees data]
Create View vWITEmployees
As 
Select [Name], Salary, Gender, DeptName from tblEmpInfo inner join tblEmpDept on tblEmpDept.DeptId = tblEmpInfo.DepartmentId where tblEmpDept.DeptName = 'IT'

Select * from vWITEmployees

--Column level security [Shows only the general info, hides away the confidential information like Salary]
Create View vWNonConfidentialDataEmployees
As 
Select [Name], Gender, DeptName from tblEmpInfo inner join tblEmpDept on tblEmpDept.DeptId = tblEmpInfo.DepartmentId

Select * from vWNonConfidentialDataEmployees

--Aggregated Data
Create View vWSummarizedData
As
Select D.DeptName, Count(E.Id) as [Employee Count] from tblEmpInfo as E inner join tblEmpDept as D on D.DeptId = E.DepartmentId Group by D.DeptName

Select * from vWSummarizedData



