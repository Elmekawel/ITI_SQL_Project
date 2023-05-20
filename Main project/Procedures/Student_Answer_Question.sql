

EXEC StudentAnswerExamQuestion 1, 1, 2, 'collection of table', 'b', 1 


CREATE OR ALTER PROCEDURE StudentAnswerExamQuestion @exam_id INT, @std_id INT, @q_id INT,
@text_q_answer nvarchar(max), @choose_q_answer nvarchar(1), @tf_q_answer BIT
AS
BEGIN
	-- Check if start time of exam is due and exam can start answering questions or else return error
	DECLARE @exam_start_time time(7) = (SELECT e.Start_Time from Instructor_Sets_Exam e where e.Exam_ID = @exam_id)
	DECLARE @exam_end_time time(7) = (SELECT e.End_Time from Instructor_Sets_Exam e where e.Exam_ID = @exam_id)
	DECLARE @current_time time = (SELECT CONVERT(time, GETDATE()))
	
	if (@current_time < @exam_start_time or @current_time > @exam_end_time)
	BEGIN
		-- Throw error if exam time is not due
		RAISERROR('Exam cannot be taken at the current time',16,1)
		RETURN
	END

	-- Make sure that student can take this exam as assigned by instructor

	IF NOT EXISTS (SELECT * from [Instructor's_Selected_Students] s where s.Exam_Id = @exam_id
	 and s.Std_ID = @std_id)
	 	BEGIN
		-- Throw error if student can't do this exam
		RAISERROR('You cannot take this exam, contact your instructor',16,1)
		RETURN
	END

	-- Make sure that selected question exists in exam
		IF NOT EXISTS (SELECT * from Questions_Consist_Exam q where q.Exam_ID = @exam_id
		and q.Questions_ID = @q_id)
	 	BEGIN
		-- Throw error if exam does not contain the question
		RAISERROR('The provided question id does not exist in the exam',16,1)
		RETURN
	END

	-- If student answered this question previously throw an error
	IF Exists (SELECT * from Students_take_Exam where Exam_ID = @exam_id and
	Std_ID = @std_id and Questions_Id = @q_id)
		BEGIN
			-- Throw error if exam does not contain the question
			RAISERROR('You answered this question previously, you cannot edit your answers',16,1)
			RETURN
		END

	INSERT into Students_take_Exam VALUES (@std_id, @exam_id, NULL, 
	@text_q_answer, @choose_q_answer, @tf_q_answer, @q_id)
END
