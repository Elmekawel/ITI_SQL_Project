
EXEC CorrectExamForStudent 1, 1

CREATE OR ALTER Procedure CorrectExamForStudent @std_id INT, @exam_id INT
AS
BEGIN
    -- Create a temp table to hold the student exam results
    CREATE TABLE #tmpExamResults(
        [Std_ID] [int] NOT NULL,
        [Exam_ID] [int] NOT NULL,
        [Questions_result] [int] NULL,
        [Std_Answer_Text_Question] [nvarchar](max) NOT NULL,
        [Std_Answer_Choose_Question] [nvarchar](1) NOT NULL,
        [Std_Answer_True_or_False] [bit] NOT NULL,
        [Questions_Id] [int] NOT NULL
    )

    -- Insert student exam results into temp table
    INSERT INTO #tmpExamResults 
    SELECT * FROM Students_take_Exam WHERE Std_ID = @std_id AND Exam_ID = @exam_id

    -- Loop over each row in the temp table
    DECLARE @questionId INT
    DECLARE @textAnswer NVARCHAR(MAX)
    DECLARE @chooseAnswer NVARCHAR(1)
    DECLARE @trueFalseAnswer BIT
    DECLARE @correctTextAnswer NVARCHAR(MAX)
    DECLARE @correctChooseAnswer NVARCHAR(1)
    DECLARE @correctTrueFalseAnswer BIT
    DECLARE @questionsResult INT

    DECLARE examCursor CURSOR FOR 
    SELECT tr.Questions_Id, tr.Std_Answer_Text_Question, tr.Std_Answer_Choose_Question, 
        tr.Std_Answer_True_or_False, q.Correct_Answer_Text_Questions, 
        q.Correct_Answer_Choose_Question, q.Correct_Answer_True_or_False, tr.Questions_result
    FROM #tmpExamResults tr
    INNER JOIN Questions q ON tr.Questions_Id = q.Questions_ID

    OPEN examCursor
    FETCH NEXT FROM examCursor INTO @questionId, @textAnswer, @chooseAnswer, @trueFalseAnswer,
        @correctTextAnswer, @correctChooseAnswer, @correctTrueFalseAnswer, @questionsResult

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Check if the student's answer matches the model answer for each question
		DECLARE @student_mark INT = 0;
		
		IF (@textAnswer LIKE '%' + @correctTextAnswer + '%' 
		OR @textAnswer LIKE '%[^a-zA-Z]'+ @correctTextAnswer + '[^a-zA-Z]%') -- Use Regex
			SET @student_mark = @student_mark + 10
		
		IF (@chooseAnswer = @correctChooseAnswer)
			SET @student_mark = @student_mark + 10

		IF (@trueFalseAnswer = @correctTrueFalseAnswer)
			SET @student_mark = @student_mark + 10


            -- Update the question result by increasing it by student's mark
            SET @questionsResult = @student_mark
            UPDATE Students_take_Exam SET Questions_result = @questionsResult 
            WHERE Std_ID = @std_id AND Exam_ID = @exam_id AND Questions_Id = @questionId


        FETCH NEXT FROM examCursor INTO @questionId, @textAnswer, @chooseAnswer, @trueFalseAnswer,
            @correctTextAnswer, @correctChooseAnswer, @correctTrueFalseAnswer, @questionsResult
    END

    CLOSE examCursor
    DEALLOCATE examCursor

    -- Drop the temp table
    DROP TABLE #tmpExamResults
END
