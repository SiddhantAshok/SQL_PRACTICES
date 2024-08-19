---LECTURE 31 : INLINE TABLE VALUED FUNCTIONS ---

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

