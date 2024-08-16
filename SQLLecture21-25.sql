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


---LECTURE 24 : MORE ON STRING FUNCTIONS REPLICATE(), SPACE(), PATINDEX(), REPLACE(), STUFF() etc ---

--REPLICATE()
Select REPLICATE('Siddhant ', 3)

Select * from tblPerson

-- Mask the email with * from charindex 3 to @
Select [Name], CONCAT(SUBSTRING(Email, 1, 2), REPLICATE('*', CHARINDEX('@',Email) - 3), SUBSTRING(Email, CHARINDEX('@', Email), LEN(Email)  - CHARINDEX('@', Email) + 1)) from tblPerson

-- Mask the email with 5 * (Star) symbols
Select [Name], CONCAT(SUBSTRING(Email, 1, 2), REPLICATE('*', 5), SUBSTRING(Email, CHARINDEX('@', Email), LEN(Email)  - CHARINDEX('@', Email) + 1)) from tblPerson


--SPACE()
Select Concat([Name], '     ', Email) from tblPerson -- not very much readable
Select Concat([Name], SPACE(5), Email) from tblPerson	-- this is more readable 

--PATINDEX()
Select [Name], Email, PATINDEX('%@aaa.com',Email) as FirstOccurance from tblPerson where PATINDEX('%@aaa.com', Email) > 0


--REPLACE()
Select REPLACE('Sara@aaa.com', '.com', '.net')

Select [Name], Email, REPLACE(Email, '.com', '.net') as [Updated Email] from tblPerson

--STUFF()
--masking using STUFF , earlier we used REPLICATE()
Select [Name], Email, STUFF(Email,2,CHARINDEX('@', Email) - 2,'*****') from tblPerson


---LECTURE 25 : DATETIME FUNCTIONS ---

Create table tblDateTime
(
	c_time time(7),
	c_date date,
	c_smalldatetime smalldatetime,
	c_datetime datetime,
	c_datetime2 datetime2,
	c_datetimeoffset datetimeoffset
)

select * from tblDateTime
Select GETDATE()

Insert into tblDateTime values (GETDATE(), GETDATE(), GETDATE(), GETDATE(), GETDATE(), GETDATE())
Insert into tblDateTime values (GETDATE(), GETDATE(), GETDATE(), GETDATE(), GETDATE(), SYSDATETIMEOFFSET())

update tblDateTime set c_datetimeoffset = '2024-08-16 18:59:47.0930000 +01:00' where c_datetimeoffset = '2024-08-16 18:59:44.0930000 +00:00'

Select GETDATE()			-- 2024-08-16 19:09:11.823
Select CURRENT_TIMESTAMP	-- 2024-08-16 19:09:00.767
Select SYSDATETIME()		-- 2024-08-16 19:09:33.3297188
Select SYSDATETIMEOFFSET()	-- 2024-08-16 19:09:45.7107194 +05:30
Select GETUTCDATE()			-- 2024-08-16 13:39:54.417
Select SYSUTCDATETIME()		-- 2024-08-16 13:40:03.6364545



