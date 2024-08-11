use SampleDB
Go


---LLECTURE 6 : CHECK CONSTRAINT ---

--ALter table to add new column
Alter table tblPerson
Add Age int
--Constraint [Constraint_Name]
--Default 25

select * from tblPerson

Insert into tblPerson values(5, 'Joey', 'joe@com', 1, NULL)
update tblPerson set age = 25 where ID = 5

--delete invalid age tuple
delete from tblPerson where age < 0


--Add check constraint for a column
Alter table tblPerson
Add Constraint CK_tblPerson_Age
Check (age > 0 and age < 150)

--Alter table tblPerson
--Drop Constraint CK_tblPerson_Age


---LECTURE 7 : IDENTITY COLUMN ---

Create table tblEmp1(
	ID int primary key Identity(1,1),
	[Name] varchar(50)
)

select * from tblEmp1

Insert into tblEmp1 values('John')
Insert into tblEmp1 values('Johny')
Insert into tblEmp1 values('Tom')
Insert into tblEmp1 values('Tom')

delete from tblEmp1 where ID = 3

Insert into tblEmp1(ID, Name) values(3, 'Tommy')

--An explicit value for the identity column in table 'tblEmp1' can only be specified when a column list is used and IDENTITY_INSERT is ON.
--To avoid the above erro we have to turn-on the Identity insert using below query
SET IDENTITY_INSERT tblEmp1 ON


Insert into tblEmp1 values('Sam')

--Explicit value must be specified for identity column in table 'tblEmp1' either when IDENTITY_INSERT is set to ON or when a replication user is inserting into a NOT FOR REPLICATION identity column.
--Once the data for identity column is inserted turn-off the identity insert using below query otherwise you'll get above error
SET IDENTITY_INSERT tblEmp1 OFF

Delete from tblEmp1
select * from tblEmp1

--On deleting all the rows/tuple from the table and you want to reset the identity value we can use DBCC command
DBCC CHECKIDENT('tblEmp1',RESEED,100)


---LECTURE 8 : LAST GENERATED IDENTITY COLUMN ---
Create table test1
(
	ID int Identity(100,1),
	Value nvarchar(20)
)

Create table test2
(
	ID int Identity(100,1),
	Value nvarchar(20)
)

insert into Test1 values('x')

select * from Test1
select * from test2

-- Get the last generated Idenetity column value using SCOPE_IDENTITY---
select SCOPE_IDENTITY()

select @@IDENTITY

-- Create trigger on table (on particular action which fires a trigger assigned action gets performed automatically)
Create Trigger TR_ForInsert on Test1 for Insert
As
Begin
	Insert into Test2 Values('YYYY')
End


insert into Test1 values('y')

select SCOPE_IDENTITY()

select @@IDENTITY

select IDENT_CURRENT('test1')


---LECTURE 9 : UNIQUE KEY CONTRAINT ---

delete from tblEmp1
select * from tblEmp1
Alter table tblEmp1
add email varchar(50)

Alter table tblEmp1
add constraint Unique_tblEmp1_email
UNIQUE (email)


Insert into tblEmp1	(Name, email) values('John', 'john@com')
Insert into tblEmp1	(Name, email) values('Johny', 'johny@com')
Insert into tblEmp1	(Name, email) values('Tom', 'tom@com')

---LECTURE 10 : SELECT STATEMENT ---
SELECT [ID]
      ,[Name]
      ,[Email]
      ,[GenderId]
      ,[Age]
  FROM [SampleDB].[dbo].[tblPerson]

GO

select * from SampleDB.dbo.tblPerson

delete from SampleDB.dbo.tblPerson

Alter table SampleDB.dbo.tblPerson
add City varchar(50) not null

Insert into  SampleDB.dbo.tblPerson (ID, Name, Email, GenderId, Age, City) Values (1, 'sam', 'sam@com', 1, 25, 'NY')

Drop table SampleDB.dbo.tblPerson

Use SampleDB 
Go
Create table tblPerson(
	ID int Primary key Identity(100, 1),
	[Name] varchar(50) not null,
	Email varchar(100) Unique not null,
	GenderId int Default 3,
	Age int Check (Age > 0 and Age < 150),
	City varchar(50) not null,
	Foreign key (GenderId) references tblGender(ID)
)

Select * from tblPerson

Insert into  SampleDB.dbo.tblPerson ( Name, Email, GenderId, Age, City) Values ('sam', 'sam@com', 1, 25, 'NY')
Insert into  SampleDB.dbo.tblPerson ( Name, Email, GenderId, Age, City) Values ('samual', 'samual@com', 1, 27, 'Canada')
Insert into  SampleDB.dbo.tblPerson ( Name, Email, GenderId, Age, City) Values ('joey', 'joey@com', 1, 35, 'NY')
Insert into  SampleDB.dbo.tblPerson ( Name, Email, GenderId, Age, City) Values ('tobey', 'tobey@com', 1, 15, 'Australia')
Insert into  SampleDB.dbo.tblPerson ( Name, Email, GenderId, Age, City) Values ('sara', 'sara@com', 2, 27, 'Russia')
Insert into  SampleDB.dbo.tblPerson ( Name, Email, GenderId, Age, City) Values ('zara', 'z@z', 2, 29, 'Srilanka')
Insert into  SampleDB.dbo.tblPerson ( Name, Email, GenderId, Age, City) Values ('kiara', 'kiara@com', 2, 17, 'Russia')
--Insert into  SampleDB.dbo.tblPerson ( Name, Email, GenderId, Age, City) Values ('ketty', 'ketty@com', 2, 170, 'Russia')

--below distinct is giving distinct values of City column
select Distinct City from tblPerson
--below distinct is giving distinct values combined City and Name column
select Distinct City, Name from tblPerson

--filter using where clause
select * from tblPerson where city = 'NY'
select * from tblPerson where city != 'NY' --or--
select * from tblPerson where city <> 'NY'


select * from tblPerson where Age = 25 or Age = 15 or Age = 35
--IN operator , in replacement of above query
select * from tblPerson where Age in (25, 15, 35)

select * from tblPerson where Age > 20 and Age < 30
--Between Operator, in replacement of above query
select * from tblPerson where Age Between 20 And 30 -- boundary conditions are inculsive

--Like operator
-- % wildcard
select * from tblPerson where City Like 'N%'	--Starting With N
select * from tblPerson where City Like '%Y'	--Ending With Y
select * from tblPerson where Email not Like 'sam%'  --Not Starting with sam

--Several wildcards we can use with like operator '%' '_' '[]' '[^]'
select * from tblPerson where Email Like '_@_'		-- _ is a single charater replacement, the query means there can be one charater before and one char after @.

--	 %		: Specifies zero or more characters
--	 _		: Specifies exactly one character
--	 []		: Any character with in the brackets
--	 [^]	: Not any character with in the brackets

select * from tblPerson where Name Like '[Zjt]%' and City Like 'N%'
select * from tblPerson where Name Like '[^Zjt]%'

select * from tblPerson where (City = 'Russia' or City = 'Canada') and Age > 20
select * from tblPerson where City In ('Russia' , 'Canada') and Age > 20
select * from tblPerson where City In ('Russia' , 'Canada') and Age < 20


--Sorted Rows
select * from tblPerson order by age
select top 2 * from tblPerson order by Name, age desc
select top 2 * from tblPerson order by age desc, Name

select top 50 Percent * from tblPerson order by age desc, Name

select top 1 * from tblPerson order by age desc
