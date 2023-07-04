CREATE TABLE [dwh].[sf_ExamPrepCourseAssignment__c] (
    [Account_Creation_Date__c]          DATE           NULL,
    [Approval_Date__c]                  DATE           NULL,
    [Cleared_for_National_Exam__c]      BIT            NULL,
    [Cleared_for_National_Exam_Date__c] DATE           NULL,
    [Contact__c]                        NVARCHAR (18)  NULL,
    [Course__c]                         NVARCHAR (255) NULL,
    [CourseNumber__c]                   NUMERIC (18)   NULL,
    [CreatedById]                       NVARCHAR (18)  NULL,
    [CreatedDate]                       DATETIME       NULL,
    [External_Exam_Prep_Id__c]          NVARCHAR (20)  NULL,
    [Id]                                NVARCHAR (18)  NULL,
    [IsDeleted]                         BIT            NULL,
    [LastModifiedById]                  NVARCHAR (18)  NULL,
    [LastModifiedDate]                  DATETIME       NULL,
    [Name]                              NVARCHAR (80)  NULL,
    [Practice_Exam_Exceptions__c]       NVARCHAR (255) NULL,
    [Prog_Con_Assignment__c]            NVARCHAR (18)  NULL,
    [SystemModstamp]                    DATETIME       NULL,
    [Voucher_Code__c]                   NVARCHAR (50)  NULL,
    [Voucher_Code_Sent_Date__c]         DATE           NULL
);

