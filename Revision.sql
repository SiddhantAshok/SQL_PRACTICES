use SampleDB
Go

Alter Database SampleDB Modify Name = NewSampleDB

Select * from tblAudit


--Alter and Drop

Create database SamplesTwo
Alter Database SamplesTwo Modify Name = SamplesThree

Execute sp_renameDB 'SamplesThree','SamplesTwo'

Alter Database SamplesTwo Set Single_User with Rollback Immediate

Drop Database SamplesTwo

--Create Table EmployeeSamples
Create Database EmployeeSamples

Use EmployeeSamples
Go

Create Table EmployeeSamples
(
	Id int primary key identity(1,1),
	[Name] nvarchar(50) not null,
	[Email] nvarchar(100) not null,
	[GenderId] int,
	[City] nvarchar(50),
	[Salary] int,
	Foreign key (GenderId) references tblGender(Id)
)



Insert into EmployeeSamples values ('Siddhant', 'sid@gmail.com', 'New York', 35000)
Insert into EmployeeSamples values ('Siddhi', 'siddhi@gmail.com', 'New York', 34000)
Insert into EmployeeSamples values ('Ben', 'ben@gmail.com', 'London', 32000)

Select * from EmployeeSamples

Create Table tblGender
(
	ID int primary key identity(1,1),
	Gender nvarchar(20)
)

Exec sp_rename 'EmployeeSamples','tblEmployeeSamples'

Alter Table tblEmployeeSamples
Add Constraint FK_tblEmployeeSamples_tblGender foreign key (GenderID) references Gender(ID)

sp_help tblEmployeeSamples


Insert into tblGender values ('Male')
Insert into tblGender values ('Female')
Insert into tblGender values ('Others')

Insert into tblEmployeeSamples values ('Siddhant', 'sid@gmail.com', 1, 'New York', 35000)
Insert into tblEmployeeSamples values ('Siddhi', 'siddhi@gmail.com', 2, 'New York', 34000)
Insert into tblEmployeeSamples values ('Ben', 'ben@gmail.com', 3, 'London', 32000)

Select * from tblEmployeeSamples
Select * from tblGender

Select [Name], Gender from tblEmployeeSamples join tblGender on tblGender.ID = tblEmployeeSamples.GenderId

--Default Constraint
Use EmployeeSamples
Go
Select * from tblEmployeeSamples

Insert into tblEmployeeSamples([Name], Email, City, Salary ) values ('Sara', 'sara@gmail.com', 'New Orleans', 31000)

Alter table tblEmployeeSamples
Add Constraint Default_tblEmployeeSamples_GenderId
Default 1 for GenderId

Update tblEmployeeSamples set GenderId = 2 where Id = 5

SELECT name 
FROM sys.default_constraints 
WHERE parent_object_id = OBJECT_ID('tblEmployeeSamples') 
AND parent_column_id = (
    SELECT column_id 
    FROM sys.columns 
    WHERE name = 'GenderId' 
    AND object_id = OBJECT_ID('tblEmployeeSamples')
);

ALTER TABLE tblEmployeeSamples
DROP CONSTRAINT Default_tblEmployeeSamples_GenderId;

Alter table tblEmployeeSamples
Add Constraint Default_tblEmployeeSamples_GenderId
Default 3 for GenderId