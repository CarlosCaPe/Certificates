CREATE PROCEDURE [etl].[sp_ErrorLoggerAdd]
    @ErrorMessage NVARCHAR(MAX),
    @ErrorNumber INT,
    @ErrorState INT,
    @ErrorSeverity INT,
    @ErrorLine INT
AS
BEGIN
    INSERT INTO etl.ErrorLogger(ErrorMessage, ErrorNumber, ErrorState, ErrorSeverity, ErrorLine)
    VALUES (@ErrorMessage, @ErrorNumber, @ErrorState, @ErrorSeverity, @ErrorLine);
END;