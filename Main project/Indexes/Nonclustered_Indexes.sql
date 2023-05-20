------------------------------------------------------
--Some non-Clustered indexes to help with the Search.
-------------------------------------------------------
------------------------------------------------------
------------------------------------------------------



--------------------------------------------------------
CREATE NONCLUSTERED INDEX Search_by_Exam
ON [Exam] (Normal_Exam, Corrective_Exam);
-------------------------------------------------------




-----------------------------------------------------
CREATE NONCLUSTERED INDEX Search_by_Mgr_ID
ON [dbo].[Instructor] ([Mgr_ID]);
-----------------------------------------------------




-----------------------------------------------------
CREATE NONCLUSTERED INDEX Search_by_Student_Exam_Results
ON [dbo].[Students_take_Exam] ([Questions_result]);
-----------------------------------------------------


-----------------------------------------------------
CREATE NONCLUSTERED INDEX Search_by_Questions_degree
ON [dbo].[Questions] ([Degree]);
------------------------------------------------------
