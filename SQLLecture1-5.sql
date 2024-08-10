
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

Alter table tblPerson add constraint tblGender_GenderId_FK Foreign key GenderId references tblGender(ID)