CREATE TABLE [dwh].[sf_PracticeExam__c] (
    [CreatedById]                 NVARCHAR (18)      NULL,
    [CreatedDate]                 DATETIMEOFFSET (0) NULL,
    [ExamPrepCourseAssignment__c] NVARCHAR (18)      NULL,
    [Id]                          NVARCHAR (18)      NULL,
    [IsDeleted]                   BIT                NULL,
    [LastModifiedById]            NVARCHAR (18)      NULL,
    [LastModifiedDate]            DATETIMEOFFSET (0) NULL,
    [Name]                        NVARCHAR (80)      NULL,
    [Practice_Date__c]            DATE               NULL,
    [Score__c]                    NUMERIC (9, 2)     NULL,
    [SystemModstamp]              DATETIMEOFFSET (0) NULL,
    [Attempt__c]                  NUMERIC (18)       NULL,
    [ProgramCertification__c]     NVARCHAR (18)      NULL
);



