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