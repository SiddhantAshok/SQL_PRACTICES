---LECTURE 26 : More functions on DateTime ---

Use SampleDB
Go

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

---LECTURE 27 : MORE FUNCTIONS ON DATETIME - DATEPART(), DATEADD(), DATEDIFF() ---

--DATENAME(DatePart, Date)
Select DATENAME(MONTH, '2024-08-17 23:00:14.087')	--August

--DATEPART(DatePart, Date)
Select DATEPART(MONTH,  '2024-08-17 23:00:14.087')	--8

--DATENAME() and DATEPART() functions are similar but DATENAME() returns nvarchar, where as DATEPART() returns an integer.

--DATEPART			ABBREVIATION
--YEAR					yy, yyyy
--QUARTER				qq, q
--MONTH					mm, m
--DAYOFYEAR				dy, y
--DAY					dd, d
--WEEK					wk, ww,
--WEEKDAY				dw
--HOUR					hh
--MINUTE				mi, n
--SECOND				ss, s
--MILLISECOND			ms
--MICROSECOND			mcs
--NANOSECOND			ns
--TZOFFSET				tz


Select DATEPART(DAYOFYEAR, '2024-08-17 23:00:14.087')		--230
Select DATEPART(DAY, '2024-08-17 23:00:14.087')				--17
Select DATEPART(HOUR, '2024-08-17 23:00:14.087')			--23
Select DATEPART(MILLISECOND,  '2024-08-17 23:00:14.087')	--87
Select DATEPART(TZOFFSET, '2024-08-17 23:00:14.087')		--0
Select DATEPART(WEEK, '2024-08-17 23:00:14.087')			--33


Select DATENAME(DAYOFYEAR, '2024-08-17 23:00:14.087')		--230
Select DATENAME(DAY, '2024-08-17 23:00:14.087')				--17
Select DATENAME(HOUR, '2024-08-17 23:00:14.087')			--23
Select DATENAME(MILLISECOND,  '2024-08-17 23:00:14.087')	--87
Select DATENAME(TZOFFSET, '2024-08-17 23:00:14.087')		--+00.00
Select DATENAME(WEEK, '2024-08-17 23:00:14.087')			--33

Select DATENAME(TZOFFSET, '2024-08-16 19:09:45.7107194 +05:30')  -- +05:30

Select DATEPART(TZOFFSET, '2024-08-16 19:09:45.7107194 +05:30')  -- 330		[+05:30] and [1 hours = 60 minutes] 60*5 +30 = 330

--DATEADD() : DATEADD(datepart, NumberToAdd, date)
Select DateAdd(DAY, 20, '2024-08-17 23:00:14.087')	-- 2024-09-06 23:00:14.087

Select DateAdd(DAY, -20, '2024-08-17 23:00:14.087')	-- 2024-07-28 23:00:14.087
Select DateAdd(MONTH, -2, '2024-08-17 23:00:14.087')	-- 2024-06-17 23:00:14.087

--DATEDIFF()		DATEDIFF(DatePart, StartDate, EndDate)
Select DATEDIFF(YEAR, '2014-01-17 23:00:14.087' , GETDATE()) --10
Select DATEDIFF(DAY, '2014-01-17 23:00:14.087' , GETDATE()) --10



Select * from tblEmployeeDateOfBirth

----------for practicing code in SQL----------
--Declare @Month int, @Year int, @Date int 
--Select @Month = MONTH(GETDATE())
--Select @Year = YEAR(GETDATE())
--Select @Date = DATENAME(DAY, GETDATE())

--Select Concat(@Month, ' months ', @Date, ' date ', @Year, ' Year')
---------------------------

--Select [Name], DateOfBirth, 
--	CONCAT( DATEDIFF(YEAR, DateOfBirth, GETDATE()),' YEARS', 
	
--	DATEDIFF(MONTH, DATEADD(YEAR, DATEDIFF(YEAR, DateOfBirth, GETDATE()), DateOfBirth), GETDATE()), ' MONTHS', 
	
--	' DAYS OLD' )

--from tblEmployeeDateOfBirth

---------
--Declare @DOB datetime, @tempDate datetime, @years int, @month int, @days int

--Set @DOB = '12/09/1994'

--Select @tempDate = @DOB

--Select @years = DATEDIFF(YEAR, @tempDate, GETDATE()) - 
--				CASE
--					WHEN(MONTH(@DOB) > MONTH(GETDATE())) OR
--					(MONTH(@DOB) = MONTH(GETDATE()) AND DAY(@DOB) > DAY(GETDATE()))
--					THEN 1 ELSE 0
--				END

--Select @tempDate = DATEADD(YEAR, @years, @tempdate)

--Select @month = DATEDIFF(MONTH, @tempDate, GETDATE()) - 
--				CASE
--					WHEN(DAY(@DOB) > DAY(GETDATE()))
--					THEN 1 ELSE 0
--				END
--Select @tempDate = DATEADD(MONTH, @month, @tempDate )

--Select @days = DATEDIFF(DAY, @tempDate, GETDATE())

--Select @years as YEARS, @month as MONTHS, @days as [DAYS]
---------

--CREATE FUNCTION FOR THE ABOVE QUERIES
CREATE FUNCTION fnComputeAge(@DOB datetime)
returns nvarchar(50)
As
Begin
	Declare  @tempDate datetime, @years int, @month int, @days int
	
	--Set @DOB = '12/09/1994'
	
	Select @tempDate = @DOB
	
	Select @years = DATEDIFF(YEAR, @tempDate, GETDATE()) - 
					CASE
						WHEN(MONTH(@DOB) > MONTH(GETDATE())) OR
						(MONTH(@DOB) = MONTH(GETDATE()) AND DAY(@DOB) > DAY(GETDATE()))
						THEN 1 ELSE 0
					END
	
	Select @tempDate = DATEADD(YEAR, @years, @tempdate)
	
	Select @month = DATEDIFF(MONTH, @tempDate, GETDATE()) - 
					CASE
						WHEN(DAY(@DOB) > DAY(GETDATE()))
						THEN 1 ELSE 0
					END
	Select @tempDate = DATEADD(MONTH, @month, @tempDate )
	
	Select @days = DATEDIFF(DAY, @tempDate, GETDATE())

	Declare @Age nvarchar(50)
	Set @Age =  Concat( CAST(@years as nvarchar(4)), ' Years ', CAST(@month as nvarchar(2)), ' months ', CAST(@days as nvarchar(2)), ' days old')

	return @Age
End



Select [Name], DateOfBirth,  dbo.fnComputeAge(DateOfBirth) as Age  from tblEmployeeDateOfBirth