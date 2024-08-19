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

