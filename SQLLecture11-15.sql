---LECTURE 11 : GROUP BY ---

use SampleDB
Go

Create table tblEmployee
(
	ID int primary key identity(1,1),
	[Name] varchar(50) not null,
	Gender varchar(50) not null,
	Salary int not null,
	City varchar(50) not null
)

SELECT * FROM tblEmployee

Insert into tblEmployee values('Tom', 'Male', 4000, 'London')
Insert into tblEmployee values('Pam', 'Female', 3000, 'New York')
Insert into tblEmployee values('John', 'Male', 4500, 'London')
Insert into tblEmployee values('Sam', 'Male', 4500, 'London')
Insert into tblEmployee values('Todd', 'Male', 2800, 'Sydney')
Insert into tblEmployee values('Ben', 'Male', 7000, 'New York')
Insert into tblEmployee values('Sara', 'Female', 4800, 'Sydney')
Insert into tblEmployee values('Valarie', 'Female', 5500, 'New York')
Insert into tblEmployee values('James', 'Male', 6500, 'London')
Insert into tblEmployee values('Russel', 'Male', 8800, 'London')

Select Gender, City, SUM(salary) from tblEmployee group by Gender, City
Select Min(salary) from tblEmployee

Select Count(*) from tblEmployee


--Below query groups by multiple columns
Select Gender, City, SUM(salary) as TotalSalary, Count(ID) as [Total Employees] from tblEmployee group by Gender, City

-- Below 2 queries gives the same output, but former query gets the filtered data(Male employees data) than group by the City, and latter query groups all the rows according to city and then filters the data.
Select Gender, City, SUM(Salary) as [Total Salary], Count(ID) as [Total Employee] from tblEmployee where Gender = 'Male' group by Gender, City

Select Gender, City, SUM(Salary) as [Total Salary], Count(ID) as [Total Employee] from tblEmployee group by Gender, City Having Gender = 'Male'

--WHERE clause can be used with -	SELECT, INSERT and UPDATE statements where as HAVING clause can only be used with the SELECT statement.
--WHERE filters rows before aggregation(GROUPING), where as , HAVING filters groups, after the aggregations are performed.
--Aggregate functions cannot be used in the WHERE clause, unless it is in a sub query conatined in a HAVING clause, whereas, whereas, aggregate functions can be used in HAVING clause.


select * from tblEmployee where sum(salary) > 4000 -- this is aggreagate function in where clause which doesn't work

--- LECTURE 12 : JOINS ---
Create table tblDepartment
(
	Id int primary key identity(1,1),
	DepartmentName varchar(50) not null,
	[Location] varchar(50) not null,
	DepartmentHead varchar(50)
)

Alter table tblEmployee
add DepartmentId int

Alter table tblEmployee
add Constraint tbl_tblEmployee_DepartmentId
Foreign key (DepartmentId) references tblDepartment(Id)

Select * from tblEmployee
Select * from tblDepartment

Update tblEmployee set DepartmentId = 1 where [Name] In ('Tom','John','Ben','Valarie')
Update tblEmployee set DepartmentId = 2 where [Name] In ('Sam','Todd')
Update tblEmployee set DepartmentId = 3 where [Name] In ('Pam','Sara')

Insert into tblDepartment values('IT', 'London','Rick')
Insert into tblDepartment values('Payroll', 'Delhi','Ron')
Insert into tblDepartment values('HR', 'New York','Christie')
Insert into tblDepartment values('Other Department', 'Sydney','Cindrella')

Select Name, Gender, Salary, DepartmentName from tblEmployee inner join tblDepartment on tblEmployee.DepartmentId = tblDepartment.Id

Select Name, Gender, Salary, DepartmentName from tblEmployee left outer join tblDepartment on tblEmployee.DepartmentId = tblDepartment.Id

Select Name, Gender, Salary, DepartmentName from tblEmployee right outer join tblDepartment on tblEmployee.DepartmentId = tblDepartment.Id

--Inner Join : All matching rows from both the tables
--Left Join : Matching rows + Non-matching rows from left table
--Right Join : Matching rows + Non-matching rows form right table

--Full Outer Join : gives all the matching rows + rows from left table + rows from right table
Select Name, Gender, Salary, DepartmentName from tblEmployee Full outer join tblDepartment on tblEmployee.DepartmentId = tblDepartment.Id

--CROSS JOIN : doesn't have the on clause (no. of rows left table * no. of rows right table) CARTeSIAN PRODUCT of both tables
Select Name, Gender, Salary, DepartmentName from tblEmployee cross join tblDepartment

--Select ColumnList
--From LeftTable
--JoinType RightTable
--ON JoinCondition



