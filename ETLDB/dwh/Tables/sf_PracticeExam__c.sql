CREATE TABLE [dwh].[sf_PracticeExam__c] (
    [CreatedById]                 NVARCHAR (18)  NULL,
    [CreatedDate]                 DATETIME       NULL,
    [ExamPrepCourseAssignment__c] NVARCHAR (18)  NULL,
    [Id]                          NVARCHAR (18)  NULL,
    [IsDeleted]                   BIT            NULL,
    [LastModifiedById]            NVARCHAR (18)  NULL,
    [LastModifiedDate]            DATETIME       NULL,
    [Name]                        NVARCHAR (80)  NULL,
    [Practice_Date__c]            DATE           NULL,
    [Score__c]                    NUMERIC (9, 2) NULL,
    [SystemModstamp]              DATETIME       NULL,
    [External_Exam_Prep_Id__c]    NVARCHAR (18)  NULL
);

