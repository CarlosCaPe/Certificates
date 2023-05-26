CREATE TABLE [dbo].[SFContactImportError] (
    [ContactID]    INT             NULL,
    [ErrorCode]    INT             NULL,
    [ErrorColumn]  INT             NULL,
    [ErrorMessage] NVARCHAR (2048) NULL,
    [CreatedDate]  DATETIME        CONSTRAINT [DF_SFContactImportError_CreatedDate] DEFAULT (getdate()) NULL,
    [TableName]    NVARCHAR (100)  NULL,
    [LeadID]       INT             NULL
);

