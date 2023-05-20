--------------------------------------------------
-- To view students information
--------------------------------------------------
Create View Student_Info as
select Students.Std_ID, Std_Name, Std_Age, Exam.[Exam_Degree],[dbo].[Students_take_Exam].Exam_ID,Intake.Intake_ID, Intake_Name,[Student_Branch].[Branch_ID],[Branch_Name], [Track].[Track_ID], [Track_Name]
from Students  join Students_take_Exam 
on Students.Std_ID = Students_take_Exam.Std_ID
join
Student_Intake
on Student_Intake.Std_ID = Students.Std_ID
join
Intake
on  Student_Intake.Intake_ID = Intake.Intake_ID
join
[Student_Branch]
on [Student_Branch].[Std_ID] = [Students].[Std_ID]
join
[dbo].[Branch]
on [Student_Branch].[Branch_ID] = [Branch].[Branch_ID]
join
[dbo].[Student_Track]
on [Student_Track].[Std_ID] = [Students].[Std_ID]
join
[dbo].[Track]
on [Track].[Track_ID] = [Student_Track].[Track_ID]
join
[dbo].[Exam]
on Exam.Exam_ID = [dbo].[Students_take_Exam].[Exam_ID]


SELECT * FROM Student_Info -- Check student information

-----------------------------------------------------
--To View Instructor's information
-----------------------------------------------------

Create View Instructor_Info as
select [Instructor].Ins_ID,Age,[Inst_Name],[Mgr_ID], [Instructor_Choose_Questions].[Questions_ID],[dbo].[Instructor_Teach_Course].[Course_ID],[Instructor_Sets_Exam].[Exam_ID]
from [dbo].[Instructor] join [dbo].[Instructor_Choose_Questions]
on  [Instructor].[Ins_ID] = [Instructor_Choose_Questions].[Instructor_ID]
join
[dbo].[Questions]
on [dbo].[Questions].[Questions_ID] = [dbo].[Instructor_Choose_Questions].[Questions_ID]
join
[dbo].[Instructor_Teach_Course]
on [dbo].[Instructor_Teach_Course].[Inst_ID] = [dbo].[Instructor].[Ins_ID]
join
[dbo].[Instructor_Sets_Exam]
on [dbo].[Instructor_Sets_Exam].[Inst_ID] = [dbo].[Instructor].[Ins_ID]

select * from Instructor_Info

--------------------------------------------------------
--To View all branches and the course information
--------------------------------------------------------

Create view Course_Info as
select  [dbo].[Course].[Course_ID], [dbo].[Course].[Min_Degree],  [dbo].[Course].[Max_Degree], [dbo].[Course].[Name],Course_Exams.Exam_ID, [dbo].[Branch].Branch_ID, [Branch].[Branch_Name]
from [dbo].[Course] join Course_Exams
on [dbo].[Course].Course_ID = Course_Exams.Course_ID
join
[dbo].[Course_Branch]
on [Course_Branch].[Course_ID] = [dbo].[Course].[Course_ID]
join
[dbo].[Branch]
on [Course_Branch].[Branch_ID] = [dbo].[Branch].[Branch_ID]

select * from Course_Info



------------------------------------------------------------
-- To View Intake information
------------------------------------------------------------
Create view Check_Exams as
select [dbo].[Intake].[Intake_ID],[dbo].[Intake].[Intake_Name]
from [dbo].[Intake]

select*
from  Check_Exams

---------------------------------------------------------------------------------------------------