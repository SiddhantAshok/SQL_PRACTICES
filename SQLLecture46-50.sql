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

Update vWEmployeeDetails set City = 'Maxico', DepartmentName = 'HR' where ID = 2