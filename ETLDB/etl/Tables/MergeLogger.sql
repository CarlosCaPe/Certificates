CREATE TABLE [etl].[MergeLogger] (
    [MergeLogId]    INT            IDENTITY (1, 1) NOT NULL,
    [ProcedureName] NVARCHAR (128) NULL,
    [FileName]      NVARCHAR (128) NULL,
    [InsertedCount] INT            NULL,
    [DeletedCount]  INT            NULL,
    [ModifiedBy]    NVARCHAR (128) NULL,
    [ModifiedOn]    DATETIME       NULL,
    CONSTRAINT [PK__MergeLog__5AD716869BD57FA7] PRIMARY KEY CLUSTERED ([MergeLogId] ASC)
);

