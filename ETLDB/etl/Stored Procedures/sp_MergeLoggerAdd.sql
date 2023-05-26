
CREATE PROCEDURE [etl].[sp_MergeLoggerAdd]
    @ProcedureName NVARCHAR(128),
	@FileName NVARCHAR(128),
    @InsertedCount INT,
    @DeletedCount INT
AS
BEGIN
    INSERT INTO etl.MergeLogger (ProcedureName, FileName, InsertedCount, DeletedCount, ModifiedBy, ModifiedOn)
    VALUES (@ProcedureName, @FileName, @InsertedCount, @DeletedCount, CURRENT_USER, GETDATE());
END;