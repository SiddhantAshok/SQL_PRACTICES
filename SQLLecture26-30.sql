---LECTURE 26 : More functions on DateTime ---

Select GETDATE()			-- 2024-08-16 19:09:11.823
Select CURRENT_TIMESTAMP	-- 2024-08-16 19:09:00.767
Select SYSDATETIME()		-- 2024-08-16 19:09:33.3297188
Select SYSDATETIMEOFFSET()	-- 2024-08-16 19:09:45.7107194 +05:30
Select GETUTCDATE()			-- 2024-08-16 13:39:54.417
Select SYSUTCDATETIME()		-- 2024-08-16 13:40:03.6364545

Select ISDATE('Siddhant')	-- return 0 means false for any other datatype
Select ISDATE(GETDATE())	-- return 1 means true 
Select ISDATE('2024-08-17 23:00:14.087')	-- return 1 means true for datetime datatype
Select ISDATE('2024-08-17 23:00:14.0872900')	-- return 0 means false for *datetime2 datatype

--DAY()
Select DAY(GETDATE())
Select DAY('01/31/2024')

--MONTH()
Select MONTH(GETDATE())
Select MONTH('01/31/2024')

--YEAR()
Select YEAR(GETDATE())
Select YEAR('01/31/2024')


--DATENAME()
Select DATENAME(DAY, GETDATE())
Select DATENAME(DAY, '2024-08-17 23:00:14.087')
Select DATENAME(WEEKDAY, '2024-08-17 23:00:14.087')
Select DATENAME(ISO_WEEK, '2024-08-17 23:00:14.087')
Select DATENAME(MONTH, '2024-08-17 23:00:14.087')

--Employee Date of birth table
Create table tblEmployeeDateOfBirth
(
	Id int primary key identity(1,1),
	[Name] varchar(50) not null,
	DateOfBirth datetime not null
)

Select GetDate()	--2024-08-17 23:15:39.210

Insert into tblEmployeeDateOfBirth values('Sam', '1994-04-27 11:15:39.410')
Insert into tblEmployeeDateOfBirth values('Pam', '1987-11-17 09:12:49.510')
Insert into tblEmployeeDateOfBirth values('John', '1999-01-14 07:05:29.110')
Insert into tblEmployeeDateOfBirth values('Sara', '1996-02-27 10:16:19.210')S


Select * from tblEmployeeDateOfBirth


Select [Name], DateOfBirth, DATENAME(WEEKDAY, DateOfBirth) as [Day], DATENAME(MONTH, DateOfBirth) as [MonthName], MONTH(DateOfBirth) as MonthNumber, YEAR(DateOfBirth) as [Year] from tblEmployeeDateOfBirth
