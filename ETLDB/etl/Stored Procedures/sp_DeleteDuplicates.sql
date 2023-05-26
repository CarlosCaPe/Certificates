CREATE PROCEDURE [etl].[sp_DeleteDuplicates]
    @schema nvarchar(128),
    @tablename nvarchar(128)
AS
BEGIN
    DECLARE @sql nvarchar(max);
    DECLARE @columnList nvarchar(max);
    DECLARE @trimColumnList nvarchar(max);

    -- Get the list of columns for the table
    SELECT @columnList = COALESCE(@columnList + ', ', '') + QUOTENAME(COLUMN_NAME)
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = @schema AND TABLE_NAME = @tablename;

    -- Create the list of columns with LTRIM and RTRIM
    SELECT @trimColumnList = COALESCE(@trimColumnList + ', ', '') + 'LTRIM(RTRIM(' + QUOTENAME(COLUMN_NAME) + ')) AS ' + QUOTENAME(COLUMN_NAME)
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = @schema AND TABLE_NAME = @tablename;

    -- Build the SQL statement to copy the data to a temporary table, delete from the original table,
    -- and then copy back one instance of each set of duplicate values
    SET @sql = 
        'SELECT DISTINCT ' + @trimColumnList + ' INTO #TempTable FROM ' + QUOTENAME(@schema) + '.' + QUOTENAME(@tablename) + ';' +
        'DELETE FROM ' + QUOTENAME(@schema) + '.' + QUOTENAME(@tablename) + ';' +
        'INSERT INTO ' + QUOTENAME(@schema) + '.' + QUOTENAME(@tablename) + '(' + @columnList + ') SELECT ' + @columnList + ' FROM #TempTable;' +
        'DROP TABLE #TempTable;';

    -- Execute the SQL statement
    EXEC sp_executesql @sql;

    
END