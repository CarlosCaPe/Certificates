

--SELECT * FROM ETL.NHA_Certification_Exam  WHERE FirstName = 'Maria' AND LastName =  'Smith' AND StudentEmail = 'msmith4237@gmail.com' AND PlannedExamDate = '06/09/2022' AND NHAExamRegistrationDate = '06/02/2022' AND ActualExamDate = '06/09/2022' AND ApprovalDate = '06/06/2022'
--SELECT FirstName,LastName,CertProduct,StudentEmail,PlannedExamDate,NHAExamRegistrationDate,ActualExamDate,ApprovalDate FROM  ETL.NHA_Certification_Exam GROUP BY FirstName,LastName,StudentEmail,CertProduct,PlannedExamDate,NHAExamRegistrationDate,ActualExamDate,ApprovalDate HAVING COUNT(*) > 1
--DELETE FROM dwh.NHA_Certification_Exam
--[etl].[sp_NHA_Certification_Exam_Merge]  ''



CREATE PROCEDURE [etl].[sp_NHA_Certification_Exam_Merge]  
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
               TARGET.FirstName = SOURCE.FirstName
               AND TARGET.LastName = SOURCE.LastName
               AND TARGET.StudentEmail = SOURCE.StudentEmail
               AND TARGET.NHAExamRegistrationDate = SOURCE.NHAExamRegistrationDate
               AND TARGET.PlannedExamDate = SOURCE.PlannedExamDate
               AND TARGET.ActualExamDate = SOURCE.ActualExamDate
               AND TARGET.ApprovalDate = SOURCE.ApprovalDate
               AND TARGET.Score = SOURCE.Score
			   AND TARGET.CertProduct = SOURCE.CertProduct
           )
        WHEN MATCHED THEN
            UPDATE SET TARGET.Institution = SOURCE.Institution,
                       TARGET.ProductNumber = SOURCE.ProductNumber,
                       TARGET.ExamOrderTaken = SOURCE.ExamOrderTaken,
                       TARGET.ModeofTesting = SOURCE.ModeofTesting,
                       TARGET.ExamResult = SOURCE.ExamResult,
                       TARGET.CetificationNumAwarded = SOURCE.CetificationNumAwarded,
                       TARGET.DataCurrentAsOf = SOURCE.DataCurrentAsOf,
                       TARGET.ModifiedBy = 'System',
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
                ModifiedBy,
                ModifiedOn
            )
            VALUES
            (SOURCE.FirstName, SOURCE.LastName, SOURCE.StudentEmail, SOURCE.Institution, SOURCE.CertProduct,
             SOURCE.ProductNumber, SOURCE.NHAExamRegistrationDate, SOURCE.ExamOrderTaken, SOURCE.ModeofTesting,
             SOURCE.ApprovalDate, SOURCE.PlannedExamDate, SOURCE.ActualExamDate, SOURCE.Score, SOURCE.ExamResult,
             SOURCE.CetificationNumAwarded, SOURCE.DataCurrentAsOf, 'System', GETDATE())
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