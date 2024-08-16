---LECTURE 21 : ADVANTAGES OF STORED PROCEDURES ---

--PERFORMANCE
--1. EXECUTION PLAN RETENTION AND REUSABILITY OF EXECUTION PLAN (Even a slight change in ad-hoc queries can tend to create new execution plan but that's not the case with SP's)
--2. REDUCES NETWORK TRAFFIC (Unlike ad-hoc queries only the Stored procedures name and it's parameters gets transferred over the network.)

--MAINTAINABILITY
--3. Code reusability and better maintainability (change at 1 place reflect at every place.)

--SECURITY
--4. SP's provide better security : by giving user the access to SP and not to the table and its data itself.
--5. Avoids SQL Injection attack


---LECTURE 22 : BUILT-IN STRING FUNCTIONS ---

use SampleDB
Go

Select * from tblEmployee

Select ASCII('A')	--65
Select ASCII('ABC')	--65 because first char is A
Select ASCII('a')	--97

Select CHAR(65)		--A
Select CHAR(97)		--a

Declare @Start int
Set @Start = 65
WHILE(@Start <= 90)
Begin
	Print Char(@Start)
	Set @Start = @Start + 1
End

Select LTRIM('	Hello')
Select RTRIM('Hello		')
Select LTRIM(RTRIM('		Hello		'))
--Select TRIM('		Hello		')

Select LOWER('HELLO')
Select UPPER('hello')


Select Reverse('	Hello	')
Select Reverse(LTrim(RTrim('	Hello	')))

Select * from tblEmployee
Select [Name], LEN([Name]) as [Total Characters] from tblEmployee


---LECTURE 23 : FEW MORE STRING FUNCITONS - LEFT(), RIGHT(), CHARINDEX(), SUBSTRING() etc ---
Select Left('ABCDEF', 3)
Select Right('ABCDEF', 3)
Select CHARINDEX('@','Sara@aaa.com',1)

Select SUBSTRING('ABCDEFGH', 1, 4)


Select SUBSTRING('Silvester@aaa.com', 1, CHARINDEX('@','Silvester@aaa.com',2) - 1)	--extract name from email id

Select SUBSTRING('Silvester@aaa.com', CHARINDEX('@', 'Silvester@aaa.com', 2)+ 1, LEN('Silvester@aaa.com') - CHARINDEX('@', 'Silvester@aaa.com', 2))
Select SUBSTRING('Silvest@aaa.com', CHARINDEX('@', 'Silvest@aaa.com', 2)+ 1, LEN('Silvest@aaa.com') - CHARINDEX('@', 'Silvest@aaa.com', 2))



Select * from tblPerson
Select * from tblGender

sp_help tblPerson

Insert into tblGender values(3, 'Unknown')


Insert into tblPerson values(1,'Sara', 'sara@aaa.com', 2)
Insert into tblPerson values(2,'Pam', 'pam@aaa.com', 2)
Insert into tblPerson values(3,'Todd', 'todd@aaa.com', 1)
Insert into tblPerson values(4,'Russel', 'russel@bbb.com', 1)
Insert into tblPerson values(5,'Ben', 'ben@bbb.com', 1)
Insert into tblPerson values(6,'Valarie', 'valarie@bbb.com', 2)
Insert into tblPerson values(7,'Hudson', 'hudson@ccc.com', 3)
Insert into tblPerson values(8,'Sam', 'sam@ccc.com', 1)

Select * from tblPerson

Select SUBSTRING(Email, CHARINDEX('@', Email)+ 1, LEN(Email) - CHARINDEX('@', Email)) as EmailDomain, Count(Email) as Total from tblPerson 
Group by SUBSTRING(Email, CHARINDEX('@', Email)+ 1, LEN(Email) - CHARINDEX('@', Email))
