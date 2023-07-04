CREATE TABLE [dbo].[SFContact_temp] (
    [ContactID]          INT             NULL,
    [SalesforceRecordId] NVARCHAR (18)   NULL,
    [IsNew]              BIT             NULL,
    [TableName]          NVARCHAR (100)  NULL,
    [ProgramName]        NVARCHAR (100)  NULL,
    [Cost]               DECIMAL (18, 2) NULL,
    [Duration]           NUMERIC (18, 2) NULL,
    [LeadID]             INT             NULL,
    [ProgramDescription] NVARCHAR (500)  NULL,
    [AccountID]          NVARCHAR (500)  NULL,
    [Channel]            NVARCHAR (500)  NULL,
    [SFProgramCode]      NVARCHAR (500)  NULL,
    [Supported]          BIT             NULL
);



