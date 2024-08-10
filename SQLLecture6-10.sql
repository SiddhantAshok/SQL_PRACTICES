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


