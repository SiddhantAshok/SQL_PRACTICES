---LECTURE 41 : INDEXED VIEWS ---
Use SampleDB
Go

--Drop table tblProduct
--Drop table tblProductSales

Create Table tblProduct
(
	ProductId int primary key,
	Name nvarchar(20),
	UnitPrice int
)

Insert into tblProduct Values(1, 'Books', 20)
Insert into tblProduct Values(2, 'Pens', 14)
Insert into tblProduct Values(3, 'Pencils', 11)
Insert into tblProduct Values(4, 'Clips', 10)


Create Table tblProductSales
(
	ProductId int,
	QuantitySold int
)

Insert into tblProductSales values(1, 10)
Insert into tblProductSales values(3, 23)
Insert into tblProductSales values(4, 21)
Insert into tblProductSales values(2, 12)
Insert into tblProductSales values(1, 13)
Insert into tblProductSales values(3, 12)
Insert into tblProductSales values(4, 13)
Insert into tblProductSales values(1, 11)
Insert into tblProductSales values(2, 12)
Insert into tblProductSales values(1, 14)

Select * from tblProduct
Select * from tblProductSales

--Script to create view vWTotalSalesByProduct
Create View vWTotalSalesByProduct
with SchemaBinding
as
Select Name, SUM(ISNULL((QuantitySold * UnitPrice), 0)) as TotalSales,
COUNT_BIG(*) as TotalTransactions
from dbo.tblProductSales
join dbo.tblProduct
on dbo.tblProduct.ProductId = dbo.tblProductSales.ProductId
group by [Name]

--If you want to create an Index, on a view, the following rules should be followed by the view. For the complete list of all rules, please check MSDN.
--1. The view should be created with SchemaBinding option


--2. If an Aggregate function in the SELECT LIST, references an expression, and if there is a possibility for that expression to become NULL, then, a replacement value should be specified. In this example, we are using, ISNULL() function, to replace NULL values with ZERO.

--3. If GROUP BY is specified, the view select list must contain a COUNT_BIG(*) expression

--4. The base tables in the view, should be referenced with 2 part name. In this example, tblProduct and tblProductSales are referenced using dbo.tblProduct and dbo.tblProductSales respectively.

Select * from vWTotalSalesByProduct


--Now, let's create an Index on the view:
create Unique Clustered Index UIX_vWTotalSalesByProduct_Name on vWTotalSalesByProduct(Name)

--Since, we now have an index on the view, the view gets materialized. The data is stored in the view. So when we execute Select * from vWTotalSalesByProduct, the data is retrurned from the view itself, rather than retrieving data from the underlying base tables.

--Indexed views, can significantly improve the performance of queries that involves JOINS and Aggeregations. The cost of maintaining an indexed view is much higher than the cost of maintaining a table index.

--Indexed views are ideal for scenarios, where the underlying data is not frequently changed. Indexed views are more often used in OLAP systems, because the data is mainly used for reporting and analysis purposes. Indexed views, may not be suitable for OLTP systems, as the data is frequently addedd and changed.


---LECTURE 42 : VIEW LIMITATIONS ---

--	1. You cannot pass parameters to a view. Table valued functions are an excellent replacement for parameterized views.
--		You can also use Where clause with the View.

--	2. Rules and Defaults cannot be associated with the views.


--	3. The ORDER BY clause is invalid in views unless TOP or FOR XML is also specified.

--	4. View cannot be based on temporary tables.

Create Table ##TestTempTable
(
	[Id] int,
	[Name] nvarchar(20),
	[Gender] nvarchar(10)
)

Insert into ##TestTempTable values (101, 'Martin', 'Male')
Insert into ##TestTempTable values (102, 'Joe', 'Female')
Insert into ##TestTempTable values (103, 'Pam', 'Female')
Insert into ##TestTempTable values (104, 'James', 'Male')

Create View vWOnTempTable
as
Select Id, Name, Gender from ##TestTempTable


---LECTURE 43 : TRIGGERS ---

--In SQL server there are 3 types of triggers
--	1. DML triggers
--	2. DDL triggers
--	3. Logon triggers

--	DML triggers are fired automatically in response to DML events(INSERT, UPDATE & DELETE)

--DML triggers can be further classified into 2 types
--	1. After triggers(Sometimes called as FOR triggers)
--	2. Instead of triggers

--After triggers, as the name says, fires after the triggering action. The INSERT, UPDATE, and DELETE statements, causes an after trigger to fire after the respective statements complete execution.

--INSTEAD of triggers, fires instead of the triggering action. The INSERT, UPDATE, and DELETE statements, can cause an INSTEAD OF trigger to fire INSTEAD OF the respective statement execution.



Create Table tblEmployeeAudit
(
	Id int identity(1,1) primary key,
	AuditData nvarchar(1000)
)

Select * from tblEmployeeAudit
Select * from tblEmployee

Alter Trigger tr_tblEmployee_ForInsert
On tblEmployee
FOR INSERT
As
Begin
	--Select * from inserted
	Declare @Id int
	Select @Id = Id from inserted
	
	insert into tblEmployeeAudit values (CONCAT('New employee with Id = ', Cast(@Id as nvarchar(5)), ' is added at ', Cast(GetDate() as nvarchar(20))))
End

--In the trigger, we are getting the id from inserted table. So, what is this inserted table? INSERTED table, is a special table used by DML triggers. 
--When you add a new row into tblEmployee table, a copy of the row will also be made into inserted table, which only a trigger can access. You cannot access this table outside the context of the trigger.


sp_help tblEmployee

Create Trigger tr_tblEmployee_ForDelete
On tblEmployee
For Delete
As
Begin
	Declare @Id int
	Select @Id = Id from deleted

	insert into tblEmployeeAudit values (Concat('An existing employee with Id = ', Cast(@Id as nvarchar(5)), ' is deleted at ', Cast(GetDate() as nvarchar(20))))
End

Insert into tblEmployee values ('Jack', 'Male', 5000, 'New Orleans', 1)
Insert into tblEmployee values ('Mosh', 'Male', 4100, 'Hisrat', 2)
Insert into tblEmployee values ('Dave', 'Male', 5700, 'New York', 1)

Delete from tblEmployee where Id = 109
