




--SELECT * FROM ETL.NHA_Certification_Exam  WHERE FirstName = 'Ajenea' AND LastName =  'Rousseau' AND StudentEmail = 'ajenea.rousseau2@gmail.com' AND CertProduct = 'CPT' AND Status = 'exam_completed' and ExamResult = 'Fail'
--SELECT FirstName,LastName,CertProduct,StudentEmail,Status,ExamResult,ActualExamDate FROM  ETL.NHA_Certification_Exam GROUP BY FirstName,LastName,CertProduct,StudentEmail,Status,ExamResult,ActualExamDate HAVING COUNT(*) > 1
--DELETE FROM dwh.NHA_Certification_Exam
--[etl].[sp_NHA_Certification_Exam_Merge]  ''



CREATE PROCEDURE [etl].[sp_NHA_Certification_Exam_Merge] -- 'test'
@FileName VARCHAR(50)
AS
BEGIN
    BEGIN TRY

        DECLARE @MergeOutput TABLE
        (
            ActionTaken VARCHAR(10),
            ModifiedOn DATETIME,
            ModifiedBy VARCHAR(100)
        );
		
        EXECUTE etl.[sp_DeleteDuplicates] 'ETL', 'NHA_Certification_Exam';

        MERGE dwh.NHA_Certification_Exam AS TARGET
        USING  etl.NHA_Certification_Exam AS SOURCE 
        ON (
			target.StudentEmail = source.StudentEmail
               and TARGET.CertProduct = SOURCE.CertProduct
			   and TARGET.NHAExamRegistrationDate = SOURCE.NHAExamRegistrationDate
			   and TARGET.Status = SOURCE.Status
			   and TARGET.Score = SOURCE.Score
			   and TARGET.ApprovalDate = SOURCE.ApprovalDate
			   and TARGET.ExamResult = SOURCE.ExamResult
	   
           )
        WHEN MATCHED THEN
            UPDATE SET TARGET.Institution = SOURCE.Institution,
                       TARGET.ProductNumber = SOURCE.ProductNumber,
                       TARGET.ExamOrderTaken = SOURCE.ExamOrderTaken,
                       TARGET.ModeofTesting = SOURCE.ModeofTesting,
                       TARGET.CetificationNumAwarded = SOURCE.CetificationNumAwarded,
                       TARGET.DataCurrentAsOf = SOURCE.DataCurrentAsOf,
                       TARGET.ModifiedBy = 'System',
					   TARGET.ActualExamDate = SOURCE.ActualExamDate,
					   TARGET.PlannedExamDate = SOURCE.PlannedExamDate,
					   TARGET.FirstName = SOURCE.FirstName,
					   TARGET.LastName = SOURCE.LastName,
                       TARGET.ModifiedOn = GETDATE()
        WHEN NOT MATCHED BY TARGET THEN
            INSERT
            (
                FirstName,
                LastName,
                StudentEmail,
                Institution,
                CertProduct,
                ProductNumber,
                NHAExamRegistrationDate,
                ExamOrderTaken,
                ModeofTesting,
                ApprovalDate,
                PlannedExamDate,
                ActualExamDate,
                Score,
                ExamResult,
                CetificationNumAwarded,
                DataCurrentAsOf,
				status,
                ModifiedBy,
                ModifiedOn
            )
            VALUES
            (SOURCE.FirstName, SOURCE.LastName, SOURCE.StudentEmail, SOURCE.Institution, SOURCE.CertProduct,
             SOURCE.ProductNumber, SOURCE.NHAExamRegistrationDate, SOURCE.ExamOrderTaken, SOURCE.ModeofTesting,
             SOURCE.ApprovalDate, SOURCE.PlannedExamDate, SOURCE.ActualExamDate, SOURCE.Score, SOURCE.ExamResult,
             SOURCE.CetificationNumAwarded, SOURCE.DataCurrentAsOf,isnull(SOURCE.status,''), 'System', GETDATE())
        OUTPUT $action,
               GETDATE(),
               CURRENT_USER
        INTO @MergeOutput;

        DECLARE @ProcedureName AS NVARCHAR(256) = N'[etl].[sp_NHA_Certification_Exam_Merge]',
                @InsertedCount AS INT =
                (
                    SELECT COUNT(*)FROM @MergeOutput WHERE ActionTaken = 'INSERT'
                ),
                @DeletedCount AS INT =
                (
                    SELECT COUNT(*)FROM @MergeOutput WHERE ActionTaken = 'DELETE'
                );



        EXEC etl.sp_MergeLoggerAdd @ProcedureName,@FileName, @InsertedCount, @DeletedCount;



    END TRY
    BEGIN CATCH
        DECLARE @RC INT,
                @ErrorMessage NVARCHAR(MAX) = ERROR_MESSAGE(),
                @ErrorNumber INT = ERROR_NUMBER(),
                @ErrorState INT = ERROR_STATE(),
                @ErrorSeverity INT = ERROR_SEVERITY(),
                @ErrorLine INT = ERROR_LINE();


        EXECUTE @RC = [etl].[sp_ErrorLoggerAdd] @ErrorMessage,
                                                @ErrorNumber,
                                                @ErrorState,
                                                @ErrorSeverity,
                                                @ErrorLine;
        THROW;
    END CATCH;
END;