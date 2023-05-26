CREATE TABLE [etl].[ErrorLogger] (
    [ErrorLogID]    INT            IDENTITY (1, 1) NOT NULL,
    [ErrorMessage]  NVARCHAR (MAX) NULL,
    [ErrorNumber]   INT            NULL,
    [ErrorState]    INT            NULL,
    [ErrorSeverity] INT            NULL,
    [ErrorLine]     INT            NULL,
    [ErrorTime]     DATETIME       DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([ErrorLogID] ASC)
);

