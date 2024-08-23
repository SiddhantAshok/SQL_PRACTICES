---LECTURE 31 : INLINE TABLE VALUED FUNCTIONS ---

use SampleDB
Go

--SCALAR FUNCITON : RETURNS A SCALAR VALUE [Single output, multiple output parameter, returns integer value]
--INLINE TABLE VALUED FUNCTION : RETURNS A TABLE


Select * from tblEmployeeDateOfBirth

--Alter table to add the columns
ALTER TABLE tblEmployeeDateOfBirth
ADD Gender VARCHAR(20),
DepartmentId INT,
CONSTRAINT FK_Department FOREIGN KEY (DepartmentId) REFERENCES tblDepartment(Id);

Update tblEmployeeDateOfBirth set Gender = 'Male', DepartmentId = 2 where Id = 3

Select * from tblDepartment

--Inline table valued function SYNTAX

--CREATE FUNCTION fnEmployeesByGender(@Gender nvarchar(10))
--RETURNS TABLE
--AS
--BEGIN
--	--Function Definition
--	Return Table
--END


CREATE FUNCTION fnEmployeesByGender(@Gender nvarchar(10))
RETURNS TABLE
AS
Return (Select Id, [Name], DateOfBirth, Gender, DepartmentId from tblEmployeeDateOfBirth where Gender = @Gender)

Select * from fnEmployeesByGender('Male')

--The Inlined table valued function
--	1. returns table
--	2. body is not encapsulated in BEGIN and END
--	3. Schema of table depends upon select statement inline with return

--Where can we use Inline Table Valued Functions ?
--	1.	Inline Table Valued functions can be used to achieve the functionality of parameterized views.
--	2.	The table returned by the table valued function, can also be used in joins with other tables.

Select Gender, Count(Id) from tblEmployeeDateOfBirth Group By Gender

--You can treat an inline table valued function as a table itself, below we used the function in join statement
Select [Name], Gender, DepartmentName from fnEmployeesByGender('Male') as E JOIN tblDepartment as D on D.Id = E.Id

---LECTURE 32 : MULTI STATEMENT TABLE VALUED FUNCTIONS ---

--Multi statement table valued functions are very similar to inline table valued functions, with a few differences.
Select * from tblEmployeeDateOfBirth
Insert into tblEmployeeDateOfBirth (ID, [Name], DateOfBirth, Gender, DepartmentId) values(5,'Todd', '1996-12-27 12:15:09.250', 'Male', 1)
SET Identity_Insert tblEmployeeDateOfBirth OFF


--sp_help tblEMployeeDateOfBirth
update tblEmployeeDateOfBirth set Id = 5 where [Name] = 'Todd'
Delete from tblEmployeeDateOfBirth where Id = 1003

--Inline Table Valued Function
Create Function fn_ILTVF_GetEmployees()
Returns Table
as
Return (Select Id, [Name], CAST(DateOfBirth as Date) as DOB from tblEmployeeDateOfBirth)

Select * from dbo.fn_ILTVF_GetEmployees()	--returns table
Update dbo.fn_ILTVF_GetEmployees() set [Name] = 'Samual' where Id = 1		--Updates the underlying table

--Multi-statement table valued function
CREATE FUNCTION fn_MSTVF_GetEmployees()
Returns @Table Table (Id int, [Name] nvarchar(20), DOB Date)
As
Begin
	Insert into @Table
	Select Id, [Name], CAST(DateofBirth as Date) from tblEmployeeDateOfBirth

	Return
End

Select * from dbo.fn_MSTVF_GetEmployees()		--returns table
Update dbo.fn_MSTVF_GetEmployees() set [Name] = 'Sam' where Id = 1		--Cannot update the underlying table

Select * from dbo.fnEmployeesByGender('Male')


--Differnce between Inline Table Valued functions and Multi-statement table valued functions --
--1. In an inline table valued function, the RETURNS clause cannot contain the structure of the table, the function returns. Where as, with the multi-statement table valued function, we specify the structure of the table that gets returned.
--2. Inline Table valued function cannot have BEGIN and END block, where as the multi-statement function can have.
--3. Inline table valued functions are better for performance, than multi-statement table valued functions. If the given task, can be achieved using an inline table valued function, always prefer to use them, over multi-statement table valued functions.
--4. It's possible to update the underlying table, using an inline table valued function, but not possible using multi-statement table valued function.

--Reason for improved performance of an inline table valued function : Internally, SQL Server treats an inline table valued function much like it would a view and treats a multi-statement table valued function similar to how it would a stored procedure.

---LECTURE 33 : IMPORTANT CONVEPTS RELATED TO FUNCTIONS ---

--Deterministic and Nondeterministic Functions:
--Deterministic functions always return the same result any time they are called with a specific set of input values and given the same state of the database. 
--Examples: Sum(), AVG(), Square(), Power() and Count()

--Note: All aggregate functions are deterministic functions.

--Nondeterministic functions may return different results each time they are called with a specific set of input values even if the database state that they access remains the same.
--Examples: GetDate() and CURRENT_TIMESTAMP

--Rand() function is a Non-deterministic function, but if you provide the seed value, the function becomes deterministic, as the same value gets returned for the same seed value.


--Encrypting a function definiton using WITH ENCRYPTION OPTION:
--We have learnt how to encrypt Stored procedure text using WITH ENCRYPTION OPTION in Part 18 of this video series. Along the same lines, you can also encrypt a function text. Once, encrypted, you cannot view the text of the function, using sp_helptext system stored procedure. If you try to, you will get a message stating 'The text for object is encrypted.' There are ways to decrypt, which is beyond the scope of this video.

--WITH ENCRYPTION : nobody can look into the definition of the funciton [sp_helptext function_name] doesn't work.
--WITH SCHEMABINDING : now the user cannot delete the underlying table and make changes to the used underlying schema.

--Now, let's CREATE the function to use WITH ENCRYPTION OPTION and WIth SchemaBinding
--Alter Function fn_GetEmployeeNameById(@Id int)
--Returns nvarchar(20)
--With Encryption
--With SchemaBinding
--as
--Begin
-- Return (Select Name from tblEmployees Where Id = @Id)
--End


 ---LECTURE 34 : TEMPORARY TABLES ---

 --Temporary table gets created TempDB and are automatically deleted, when they are no longer used.
 --Local Temporary Table :
 --A local temporary table is available, only for the connection that has created the table.
 --A local temporary table is automatically dropped. When the connection that has created it , is closed.
 --If the user wants to explicitly drop the temporary table, he can do so using DROP TABLE #PersonDetails

 Create table #PersonDetails(
 Id int,
 [Name] nvarchar(20)
 )

 Insert into #PersonDetails values(1, 'Mike')
 Insert into #PersonDetails values(2, 'John')
 Insert into #PersonDetails values(3, 'Todd')

 Select * from #PersonDetails

 --Query the sysobjects system table in TEMPDB. The name of the table, is suffixed with lot of underscores and a random number. For this reason you have to use the LIKE operator in the query.
 Select name from tempdb..sysobjects where name Like '#PersonDetails%'

 --Select name from SampleDB..sysobjects where name Like 'tbl%'

 Select * from #PersonDetails


--If the temporary table, is created inside the stored procedure, it get's dropped automatically upon the completion of storred procedure execution.
--It is also possible for different connections, to create a local temporary table with the same name. For ex: User1 and User2, both can create a local temporary table with the same name #PersonDetails.

--Global Temporary Table : 
--To create a Global Temporary table, prefix the name of the table with 2 pound(##) symbols
Create table ##EmployeeDetails
(
	Id int,
	[Name] nvarchar(20)
)

--Global temporary tables are visible to all the connections of the sql server, and are only destroyed when the last connection referencing the table is closed.
--Multiple users, accross multiple connections can have local temporary tables with the same name, but a global table name has to be unique, and if you inspect the name of the global temp table, in the object explorer, there will be no random numbers suffixed at the end of the table name.

---LECTURE 35 : INDEXES ---

--Indexes are used by queries to find data from tables quickly. Indexes are created on tables and views. Index on a table or a view, is very similar to an index that we find in a book.

SELECT * FROM tblEmployee

Create table tblEmployeeSalary
(
	Id int,
	[Name] nvarchar(50),
	Salary int,
	Gender nvarchar(10)
)

Select * from tblEmployeeSalary

Insert into tblEmployeeSalary(Id, [Name], Salary, Gender) values (1,'Sam', 2500, 'Male')
Insert into tblEmployeeSalary(Id, [Name], Salary, Gender) values (2,'Pam', 6500, 'Female')
Insert into tblEmployeeSalary(Id, [Name], Salary, Gender) values (3,'John', 4500, 'Male')
Insert into tblEmployeeSalary(Id, [Name], Salary, Gender) values (4,'Sara', 5500, 'Female')
Insert into tblEmployeeSalary(Id, [Name], Salary, Gender) values (5,'Todd', 3100, 'Male')

Select * from tblEmployeeSalary where Salary > 2500 and Salary < 5000

--create index signature
--CREATE INDEX IX_tableName_ColumnName On tableName (ColumnName ASCorDESC)

Create Index IX_tblEmployeeSalary_Salary On tblEmployeeSalary (Salary ASC)

sp_HelpIndex tblEmployeeSalary

--Drop index tblEmployeeSalary.IX_tblEmployeeSalary_Salary
