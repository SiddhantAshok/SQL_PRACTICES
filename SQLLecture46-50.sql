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