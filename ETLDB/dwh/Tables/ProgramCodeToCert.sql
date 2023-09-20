CREATE TABLE [dwh].[ProgramCodeToCert] (
    [ProgramCode] VARCHAR (50) NOT NULL,
    [Cert]        VARCHAR (50) NOT NULL,
    CONSTRAINT [PK_ProgramCodeToCert] PRIMARY KEY CLUSTERED ([ProgramCode] ASC, [Cert] ASC)
);

