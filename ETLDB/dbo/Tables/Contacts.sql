CREATE TABLE [dbo].[Contacts] (
    [ContactID]               INT             IDENTITY (1, 1) NOT NULL,
    [First Name]              NVARCHAR (255)  NULL,
    [Last Name]               NVARCHAR (255)  NULL,
    [Email]                   NVARCHAR (255)  NULL,
    [Contact Phone]           NVARCHAR (255)  NULL,
    [Mailing Street]          NVARCHAR (255)  NULL,
    [Mailing City]            NVARCHAR (255)  NULL,
    [Mailing State]           NVARCHAR (255)  NULL,
    [Mailing Zip/Postal Code] NVARCHAR (255)  NULL,
    [Account ID]              NVARCHAR (255)  NULL,
    [Contact Record Type]     NVARCHAR (255)  NULL,
    [Program Code]            NVARCHAR (255)  NULL,
    [Start Date]              DATE            NULL,
    [ProcessedInd]            INT             NULL,
    [SFContactID]             VARCHAR (50)    NULL,
    [ExternalID]              NVARCHAR (255)  NULL,
    [SFProgramAssignmentID]   VARCHAR (50)    NULL,
    [SFProgramID]             VARCHAR (50)    NULL,
    [Cost]                    DECIMAL (18, 2) NULL,
    [Duration]                NUMERIC (18, 2) NULL,
    [EnrollmentStartDate]     DATE            CONSTRAINT [DF_Contacts_EnrollmentStartDate] DEFAULT (getdate()) NULL,
    [DOB]                     DATE            NULL,
    [Channel]                 NVARCHAR (255)  NULL,
    [SFProgramName]           NVARCHAR (255)  NULL,
    [SFProgramCode]           NVARCHAR (255)  NULL,
    [CreatedDate]             DATETIME        CONSTRAINT [DF_Contacts_DateCreated] DEFAULT (getdate()) NULL,
    [Supported]               BIT             NULL
);



