CREATE TABLE [dwh].[NHA_Certification_Exam] (
    [NHA_Certification_Exam_id] INT           IDENTITY (1, 1) NOT NULL,
    [FirstName]                 VARCHAR (50)  NULL,
    [LastName]                  VARCHAR (50)  NULL,
    [StudentEmail]              VARCHAR (50)  NULL,
    [Institution]               VARCHAR (50)  NULL,
    [CertProduct]               VARCHAR (50)  NULL,
    [ProductNumber]             VARCHAR (50)  NULL,
    [NHAExamRegistrationDate]   VARCHAR (50)  NULL,
    [ExamOrderTaken]            VARCHAR (50)  NULL,
    [ModeofTesting]             VARCHAR (50)  NULL,
    [ApprovalDate]              VARCHAR (50)  NULL,
    [PlannedExamDate]           VARCHAR (50)  NULL,
    [ActualExamDate]            VARCHAR (50)  NULL,
    [Score]                     VARCHAR (50)  NULL,
    [ExamResult]                VARCHAR (50)  NULL,
    [CetificationNumAwarded]    VARCHAR (50)  NULL,
    [DataCurrentAsOf]           VARCHAR (50)  NULL,
    [ModifiedBy]                VARCHAR (50)  CONSTRAINT [DF_NHA_Certification_Exam_ModifiedBy] DEFAULT (user_name()) NOT NULL,
    [ModifiedOn]                SMALLDATETIME CONSTRAINT [DF_NHA_Certification_Exam_ModifiedOn] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_NHA_Certification_Exam] PRIMARY KEY CLUSTERED ([NHA_Certification_Exam_id] ASC)
);

