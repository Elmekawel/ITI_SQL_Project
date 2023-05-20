
-- Testing constraint Instructor does not teach course
EXEC GenerateRandomExam @crs_id = 1, @ins_id = 2,
@exam_degree = 60, @is_normal_exam = 1,
@is_corrective_exam = 0, 
@start_time = '10:00:00', @end_time = '12:00:00';

-- Testing constraint Exam degree not multiple of 30
EXEC GenerateRandomExam @crs_id = 1, @ins_id = 1,
@exam_degree = 25, @is_normal_exam = 1,
@is_corrective_exam = 0, 
@start_time = '10:00:00', @end_time = '12:00:00';

-- Testing that it is working
EXEC GenerateRandomExam @crs_id = 1, @ins_id = 1,
@exam_degree = 60, @is_normal_exam = 1,
@is_corrective_exam = 0, 
@start_time = '10:00:00', @end_time = '12:00:00';

CREATE OR ALTER PROCEDURE GenerateRandomExam @crs_id INT, @ins_id INT, @exam_degree INT,
@is_normal_exam BIT, @is_corrective_exam BIT, @start_time time(7), @end_time time(7)
AS
BEGIN
	-- Exam degree must be multiples of 30
	IF @exam_degree % 30 <> 0
	BEGIN
		-- Throw error if exam degree is not divisible by 30
		RAISERROR('Exam degree must be a multiple of 30',16,1)
		RETURN
	END

	DECLARE @maxExamDegree INT = (SELECT SUM(q.Degree) from Questions q where q.Course_Id
	= @crs_id)

	IF (@maxExamDegree < @exam_degree)
	BEGIN
		 -- Throw error if number of questions available is not enough to make an exam with the
		 -- requested degree
		RAISERROR('Not enough questions to make an exam with the requested degree,
		please add more questions',16,1)
		RETURN
	END
 
 -- Get instructor and course and make sure he teaches that course

 IF NOT EXISTS(SELECT * FROM Instructor_Teach_Course ic WHERE ic.Course_ID = @crs_id 
 and ic.Inst_ID = @ins_id)
 BEGIN
 -- Throw error if instructor does not teach course
    RAISERROR('Instructor does not teach this course',16,1)
    RETURN
 END

 -- Check if exam degree is less than max course degree

 DECLARE @maxCourseMark INT =(SELECT c.Max_Degree from Course c where Course_ID = @crs_id)
 IF (@maxCourseMark < @exam_degree)
 BEGIN
  -- Throw error if exam degree exceeds max course degree
    RAISERROR('Exam degree is larger than max course degree',16,1)
    RETURN
 END

 DECLARE @lastExamId INT = (SELECT top 1 Exam_ID from Exam order by Exam_ID DESC)

 -- Create the exam record

 INSERT INTO Exam VALUES ((@lastExamId+1), @exam_degree, NULL, @is_normal_exam, @is_corrective_exam);

 DECLARE @currentYear DATE = (SELECT CONVERT(date, GETDATE()))

 INSERT INTO Instructor_Sets_Exam VALUES (@lastExamId+1, @ins_id, @start_time, @end_time, @currentYear)

 -- Start generating exam questions
   -- Loop over questions and add them to exam

  DECLARE @current_degree INT = 0
  DECLARE @questionId INT = 0

  WHILE @current_degree < @exam_degree
  BEGIN
    -- Select a random question from the Questions table
    SET @questionId = (
      SELECT TOP 1 q.Questions_ID
      FROM Questions q where q.Course_Id = @crs_id
      ORDER BY NEWID()
    )

    -- Insert a new row into the Questions_Consist_Exam table to associate the selected question with the exam
    IF NOT EXISTS (SELECT * from Questions_Consist_Exam where Questions_ID = @questionId and
	Exam_ID = (@lastExamId+1))
	BEGIN
			INSERT INTO Questions_Consist_Exam 
		VALUES (
		  @questionId,
		  @lastExamId+1
		)

		SET @current_degree = @current_degree + 30
	END
  END
END
