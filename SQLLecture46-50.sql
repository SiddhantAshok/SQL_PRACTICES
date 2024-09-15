---LECTURE 46 : INSTEAD OF UPDATE TRIGGER IN SQL SERVER ---
Use SampleDB
Go

Select * from tblEmployee
Select * from tblDepartment

Select * from vWEmployeeDetails

Update vWEmployeeDetails set [DepartmentName] = 'IT' where Id = 101
--Above query does not behave as it is supposed to, The above query has updated the tblDepartment itself where else it is supposed to update tblEmployee only.

--To revert the impact of above query let's correct the tblDepartment again by updating to the actual value.
--Update tblDepartment set DepartmentName = 'HR' where Id = 3

sp_helptext vWEmployeeDetails

Create Trigger tr_vWEmployeeDetails_InsteadOfUpdate
On vWEmployeeDetails
Instead Of Update
As
Begin
	Select * from deleted
	Select * from inserted
End

Alter Trigger tr_vWEmployeeDetails_InsteadOfUpdate
On vWEmployeeDetails
Instead Of Update
As
Begin
	Declare @DeptId int
	Select @DeptId = tblDepartment.Id from tblDepartment join inserted on inserted.DepartmentName = tblDepartment.DepartmentName
	Declare @EmpId int 
	Select @EmpId = Id from inserted

	if(@DeptId is null)
	Begin
		Raiserror('Invalid Department Name. Statement terminated',16,1)
		return
	End

	Update tblEmployee set DepartmentId = @DeptId where Id = @EmpId
End


Create View vWEmployeeDetails
As
Select E.ID, E.[Name], E.Gender, E.Salary, E.City, D.DepartmentName 
from tblEmployee as E 
join tblDepartment as D 
on D.Id = E.DepartmentId

Select * from vWEmployeeDetails

Update vWEmployeeDetails set DepartmentName = 'IT' where Id = 2

Create Trigger tr_vWEmployeeDetails_InsteadOfUpdate
On vWEmployeeDetails
Instead Of Update
As
Begin
	
	--if Employee Id is updated
	if(Update(Id))
	Begin
		Raiserror('Id cannot be changed',16,1)
		return
	End

	--If DeptName is Updated
	if(Update(DepartmentName))
	Begin
		Declare @DepartmentId int
		Select @DepartmentId = tblDepartment.Id from tblDepartment join inserted on inserted.DepartmentName = tblDepartment.DepartmentName

		if(@DepartmentId is NULL)
		Begin
			Raiserror('Invalid Department Name',16,1)
			Return
		End

		Update tblEmployee set DepartmentId = @DepartmentId from inserted join tblEmployee on tblEmployee.ID = inserted.Id
	End

	--if gender is updated
	If(Update(Gender))
	Begin
		Update tblEmployee set Gender = inserted.Gender from inserted join tblEmployee on tblEmployee.ID = inserted.ID
	End

	
	--if Salary is updated
	If(Update(Salary))
	Begin
		Update tblEmployee set Salary = inserted.Salary from inserted join tblEmployee on tblEmployee.ID = inserted.ID
	End

	
	--if city is updated
	If(Update(City))
	Begin
		Update tblEmployee set City = inserted.City from inserted join tblEmployee on tblEmployee.ID = inserted.ID
	End

	
	--if name is updated
	If(Update(Name))
	Begin
		Update tblEmployee set Name = inserted.Name from inserted join tblEmployee on tblEmployee.ID = inserted.ID
	End

End

Select * from tblDepartment
Select * from tblEmployee


Select * from vWEmployeeDetails

Update vWEmployeeDetails set Name = 'Pam' where ID In (2)


--Final Instead of Update trigger for vWEmployeeDetails which checks for the same update values
Alter Trigger tr_vWEmployeeDetails_InsteadOfUpdate
On vWEmployeeDetails
Instead Of Update
As
Begin
	
	Declare @Id int
	Declare @OldName nvarchar(40), @NewName nvarchar(40)
	Declare @OldGender nvarchar(20), @NewGender nvarchar(20)
	Declare @OldSalary int, @NewSalary int
	Declare @OldCity nvarchar(40), @NewCity nvarchar(40)
	--Declare @OldDeptId int, @NewDeptId int
	Declare @OldDeptName nvarchar(20), @NewDeptName nvarchar(20)

	Select * into #tblTempEmployeeDetail from inserted
	While(Exists(Select Id from #tblTempEmployeeDetail))
	Begin


		Select Top 1 @Id = Id, @NewName = Name, @NewGender = Gender, @NewSalary = Salary, @NewCity = City, @NewDeptName = DepartmentName from #tblTempEmployeeDetail

		Select @OldName = Name, @OldGender = Gender, @OldSalary = Salary, @OldCity = City, @OldDeptName = DepartmentName from deleted where Id = @Id

		--if Employee Id is updated
		if(Update(Id))
		Begin
			Raiserror('Id cannot be changed',16,1)
			return
		End

		--If DeptName is Updated
		if(Update(DepartmentName))
		Begin
			If(@OldDeptName = @NewDeptName)
			Begin
				Raiserror('Department name is same as earlier', 16, 1)
			End
			Else
			Begin
				Declare @DepartmentId int
				Select @DepartmentId = tblDepartment.Id from tblDepartment join inserted on inserted.DepartmentName = tblDepartment.DepartmentName

				if(@DepartmentId is NULL)
				Begin
					Raiserror('Invalid Department Name',16,1)
					Return
				End

				Update tblEmployee set DepartmentId = @DepartmentId from #tblTempEmployeeDetail join tblEmployee on tblEmployee.ID = #tblTempEmployeeDetail.Id
			End
		End

		--if gender is updated
		If(Update(Gender) And @OldGender <> @NewGender)
		Begin
			Update tblEmployee set Gender = #tblTempEmployeeDetail.Gender from #tblTempEmployeeDetail join tblEmployee on tblEmployee.ID = #tblTempEmployeeDetail.ID
		End

		
		--if Salary is updated
		If(Update(Salary))
		Begin
			If(@OldSalary = @NewSalary)
			Begin
				Raiserror('Salary is same as earlier',16,1)
			End
			Else
			Begin
				Update tblEmployee set Salary = #tblTempEmployeeDetail.Salary from #tblTempEmployeeDetail join tblEmployee on tblEmployee.ID = #tblTempEmployeeDetail.ID
			End
		End

		
		--if city is updated
		If(Update(City) And @OldCity <> @NewCity)
		Begin
			Update tblEmployee set City = #tblTempEmployeeDetail.City from #tblTempEmployeeDetail join tblEmployee on tblEmployee.ID = #tblTempEmployeeDetail.ID
		End

		
		--if name is updated
		If(Update(Name))
		Begin
			If(@OldName = @NewName)
			Begin
				Raiserror('Name is same as earlier', 16,1)
			End
			Else
			Begin
				Update tblEmployee set Name = #tblTempEmployeeDetail.Name from #tblTempEmployeeDetail join tblEmployee on tblEmployee.ID = #tblTempEmployeeDetail.ID
			End
		End


		Delete from  #tblTempEmployeeDetail where Id = @Id
	End

End


---LECTURE 47 : INSTEAD OF DELETE TRIGGER ---

Select * from tblEmployee
Select * from tblDepartment

sp_helptext tr_tblEmployee_ForDelete

Select * from tblEmployeeAudit

Select * from vWEmployeeDetails

Delete from vWEmployeeDetails where Id = 108
--Above query throws below error
--Msg 4405, Level 16, State 1, Line 236
--View or function 'vWEmployeeDetails' is not updatable because the modification affects multiple base tables.


--In place of the delete query we must write a trigger to delete the tuple from the base table
Create Trigger tr_vWEmployeeDetails_InsteadOfDelete
On vWEmployeeDetails
Instead Of Delete
As
Begin
	
	Delete tblEmployee from tblEmployee join deleted on deleted.Id = tblEmployee.Id

End


--Trigger						INSERTED or DELETED?
--Instead of Insert		-	DELETED table is always empty and the INSERTED table contains the newly inserted data.
--Instead of Delete		-	INSERTED table is always empty and the DELETED table contains the rows deleted
--Instead of Update		-	DELETED table contains OLD data (before update), and inserted table contains NEW data(Updated data)


---LECTURE 48 : DERIVED TABLES AND COMMON TABLE EXPRESSIONS ---

Select * from tblEmployee
Select * from tblDepartment

Select D.DepartmentName, Count(E.ID) as TotalEmployees from tblEmployee as E join tblDepartment as D on D.Id = E.DepartmentId Group By D.DepartmentName

Create View vWEmployeeCount
As
Select D.DepartmentName, E.DepartmentId, Count(E.ID) as TotalEmployees from tblEmployee as E join tblDepartment as D on D.Id = E.DepartmentId Group By D.DepartmentName, E.DepartmentId

Select DepartmentName, TotalEmployees from vWEmployeeCount where TotalEmployees >= 2

--Note : Views get saved in the database, and can be available to other queries and stored procedures. However, if this view is only used at this one place, it can be easily eliminated using other options, like CTE, Derived Tables, Temp Tables,Table Variables etc.

--Use Temp Tables --

Select D.DepartmentName, E.DepartmentId, Count(E.Id) as TotalEmployees 
into #TempEmployeeCount 
from tblEmployee as E 
join tblDepartment as D 
on D.Id = E.DepartmentId 
group by D.DepartmentName, E.DepartmentId

Select DepartmentName, TotalEmployees from #TempEmployeeCount where TotalEmployees > = 2

Drop Table #TempEmployeeCount

--Note : Temporary tables are stored in TempDB. Local temporary tables are visible only in the current session, and can be shared between nested stored procedure calls. Global temporary tables are visible to other sessions and are destroyed , when the last connection referencing the table is closed.

--Now Using Table Variable --
Declare @tblEmployeeCount table (DepartmentName nvarchar(20), DepartmentId int, TotalEmployees int)

Insert @tblEmployeeCount
Select D.DepartmentName, E.DepartmentId, Count(E.ID) as TotalEmployees 
from tblEmployee as E join tblDepartment as D
on D.Id = E.DepartmentId
Group by DepartmentName, DepartmentId

Select DepartmentName, TotalEmployees from @tblEmployeeCount where TotalEmployees >=2

--Note : Just like TempTables, a Table variable is also vreated in TempDB. The scope of a table variables is the batch, stored procedure, or statement block in which it is declared. They can be passed as parameters between procedures.

--Using Derived Tables --

Select DepartmentName, TotalEmployees 
from
	(	
		Select D.DepartmentName, E.DepartmentId, Count(E.ID) as TotalEmployees
		from tblEmployee as E join tblDepartment as D 
		on D.Id = E.DepartmentId 
		Group By D.DepartmentName, E.DepartmentId
	)
as EmployeeCount
where TotalEmployees >= 2

--EmployeeCount is the derived table
--Note: Derived tables are available only in the context of the current query.

--Now we will use CTE --

With EmployeeCount(DepartmentName, DepartmentId, TotalEmployees)
as
	(
		Select D.DepartmentName, E.DepartmentId, Count(E.ID) as TotalEmployees
		from tblEmployee as E join tblDepartment as D 
		on D.Id = E.DepartmentId 
		Group By D.DepartmentName, E.DepartmentId
	)

Select DepartmentName, TotalEmployees from EmployeeCount where TotalEmployees >= 2