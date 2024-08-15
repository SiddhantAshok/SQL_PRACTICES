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

---LECTURE 18 : STORED PROCEDURE ---
Select * from tblEmployee

Select Name,Gender from tblEmployee

--- SP without parameters
CREATE PROCEDURE sp_GetEmployees_tblEmployee
As
Begin
	Select Name, Gender from tblEmployee
End

Execute sp_GetEmployees_tblEmployee


--- SP with parameter
Create Procedure sp_GetEmployeesByGenderAndDepartment
@Gender nvarchar(20),
@DepartmentId int
As
Begin
	Select Name, Gender, DepartmentId from tblEmployee where Gender = @Gender and DepartmentId = @DepartmentId
End

Execute sp_GetEmployeesByGenderAndDepartment 'Male',1
--or	using below format of executing SP you can pass shuffeled arguments
Execute sp_GetEmployeesByGenderAndDepartment @DepartmentId = 1, @Gender = 'Male'

--use below System SP to get the definition of any User definded SP
sp_helptext sp_GetEmployeesByGenderAndDepartment

--Alter the SP
Alter Procedure sp_GetEmployees_tblEmployee
AS
BEGIN
	Select Name, Gender from tblEmployee order by Name
END

--Drop the stored procedure
DROP PROC sp_GetEmployees_tblEmployee

--to hide the contents of SP use encryption
Alter Procedure sp_GetEmployees_tblEmployee
With encryption
As
Begin
	Select Name, Gender from tblEmployee order by name
End

-- after altering the SP and adding the encryption in above query, now you cannot see the contents of below called SP
sp_helptext sp_GetEmployees_tblEmployee

---LECTURE 19 : STORED PROCEDURES WITH OUTPUT PARAMETERS ---
Create Procedure spGetEmployeesCountByGender
@Gender nvarchar(20),
@EmployeeCount int Output
As
Begin
	Select @EmployeeCount = Count(*) from tblEmployee where Gender = @Gender
End

Alter Procedure spGetEmployeesCountByGender
@Gender nvarchar(20),
@EmployeeCount int Output
As
Begin
	Select @EmployeeCount = Count(Id) from tblEmployee where Gender = @Gender
End

--Call/Execute an SP with output parameters
Declare @EmpCount int
Declare @EmpGender nvarchar(20) = 'Male'
Execute spGetEmployeesCountByGender @EmpGender, @EmpCount Output
if(@EmpCount Is Null)
	Print '@EmpCount is null'
else
	Print Concat( @EmpCount, ' is employee Count')

--passing the arguments without following the original parameter order
Declare @EmployeesCount int
Declare @EmployeesGender nvarchar(20) = 'Male'
Execute spGetEmployeesCountByGender @EmployeeCount = @EmployeesCount Output, @Gender = @EmployeesGender
if(@EmployeesCount Is Null)
	Print '@EmpCount is null'
else
	Print Concat( @EmployeesCount, ' is employee Count')

--Useful system stored procedure
--	sp_help : to view the information of schema of database, tables, triggers, SP's etc, else you can highlight the object and press Alt + F1
sp_help tblEmp

--	sp_helptext : View the text of the stored procedure
sp_helptext spGetEmployeesCountByGender
sp_helptext sp_help

--	sp_depends : view the dependencies of the SP's, tables or other objects
sp_depends tblEmployee
sp_depends spGetEmployeesCountByGender


---LECTURE 20 : SP's OUTPUT PARAMETERS or RETURN values ---

--SP to get Total Employee Count via output paramter
Create Procedure spGetTotalCount_tblEmployee
@EmployeeCount int output
As
Begin
	Select @EmployeeCount = Count(Id) from tblEmployee
End

Declare @Count int
Execute spGetTotalCount_tblEmployee @Count Output
Print Concat(@Count , ' employees')

--SP to get total employee count via return type
Create Procedure spGetTotalCount_tblEmployee1
As
Begin
	return (Select Count(*) from tblEmployee)
End

Declare @ECount int
Execute @ECount = spGetTotalCount_tblEmployee1
Print @ECount



--SP to get the name of the employee by Id via output parameter
Create Procedure spGetNameById
@Id int,
@Name nvarchar(50) output
As
Begin
	Select @Name = Name from tblEmployee where Id = @Id
End

Declare @Name nvarchar(20)
Execute spGetNameById 100, @Name output
Print Concat(@Name, ' is name of employee')

--SP to get name of the employee by id via return type [this throws an error cause return type can only be int value]
Create Procedure spGetNameById_tblEmployee
@Id int
As
Begin
	return (Select Name from tblEmployee where ID = @Id)
End

Declare @EmpName varchar(20)
Execute @EmpName = spGetNameById_tblEmployee 100
Print @EmpName

--Return type : 1. Only Integer datatype, 2. Only 1 Value, 3. Use to convery success or failure
--Output parameters : 1. Any Datatype, 2. More than 1 value, 3. Use to return values like name, count etc