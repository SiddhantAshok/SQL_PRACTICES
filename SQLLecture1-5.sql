
--Create DB
Create Database SampleDB

--Alter DB
Alter Database Sample2 Modify Name = SampleNew

-- Rename Database using System defined Stored Procedure
Execute sp_renameDB 'SampleNew','NewSample'


-----------
use ICAIADV_12_JAN_2021
Go
Execute sp_helpIndex 'RESULT_EXAMINATION'			-- System SP to get info of all the indexes present inside the table

select * from RESULT_EXAMINATION

Execute sp_help 'RESULT_EXAMINATION'	-- System SP to get information about the particular table


--Drop/Delete the database
Alter Database Sample2 Set Single_User With Rollback Immediate --Normally DB's are in Multi_User mode. So to delete/drop a Db first put Db in Single_User mode and roll back all current active session/transactions for that DB
Drop Database Sample2


---Creating and Working with tables

use SampleDB
Go
create table tblPerson(
	ID int Primary Key not null,
	[Name] nvarchar(50) not null,
	Email nvarchar(50) not null,
	GenderId int 
)


create table tblGender(
	ID int Primary key not null,
	Gender nvarchar(50) not null
)

--Alter table to add the constratint to the table
Alter table tblPerson 
add constraint tblGender_GenderId_FK 
Foreign key (GenderId) references tblGender(ID)

select * from tblGender
Insert into tblGender (ID, Gender) Values (1, 'Male')
Insert into tblGender (ID, Gender) Values (2, 'Female')
Insert into tblGender (ID, Gender) Values (3, 'Unknown')


Delete tblPerson
select * from tblPerson

Insert into tblPerson (ID, Name, Email, GenderId) Values (1, 'John', 'john@com', 1)
Insert into tblPerson (ID, Name, Email) Values (2, 'Johny', 'johny@com')
Insert into tblPerson (ID, Name, Email, GenderId) Values (3, 'Sara', 'sara@com', 2)
Insert into tblPerson (ID, Name, Email, GenderId) Values (4, 'Mike', 'mike@com', NULL)

--Add default value constraint for the column in table
Alter table tblPerson 
add Constraint tblPerson_GenderId_Default 
Default 3 for GenderId

--Drop the constraint from the table
Alter table tblPerson
drop constraint tblPerson_GenderId_Default 

--Create table with default constraint on column and foreign key relation
Create table tblEmp(
	ID int primary key,
	empName varchar(50) not null,
	gender int Default 3,
	Foreign key (gender) references tblGender(ID)
)

drop table tblEmp


select * from tblGender
select * from tblPerson

delete from tblGender where ID = 2

--There are 4 possible ways to handle the deletion of tuple that contain Foreign key relation : 
	--1. No Action(Raise error, terminate query) 
	--2. Cascade(delete the tuple in primary table and foreign key table both) 
	--3. Set NULL(set the null value) 
	--4. Set Default(set the default value from default constraint)