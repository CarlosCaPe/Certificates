﻿CREATE TABLE [dwh].[sf_CertificationAttempt__c] (
    [Approval_Date__c]       DATE           NULL,
    [Attempt_Number__c]      NUMERIC (18)   NULL,
    [Contact__c]             NVARCHAR (18)  NULL,
    [CreatedById]            NVARCHAR (18)  NULL,
    [CreatedDate]            DATETIME       NULL,
    [Exam_Raw_Score__c]      NUMERIC (6)    NULL,
    [Exam_Result__c]         NVARCHAR (255) NULL,
    [Id]                     NVARCHAR (18)  NULL,
    [IsDeleted]              BIT            NULL,
    [LastModifiedById]       NVARCHAR (18)  NULL,
    [LastModifiedDate]       DATETIME       NULL,
    [Name]                   NVARCHAR (80)  NULL,
    [Prog_Con_Assignment__c] NVARCHAR (18)  NULL,
    [Registered_Program__c]  NVARCHAR (255) NULL,
    [Registration_Date__c]   DATE           NULL,
    [Registration_Status__c] NVARCHAR (255) NULL,
    [Scheduled_Date__c]      DATE           NULL,
    [Status_Updated_Date__c] DATE           NULL,
    [SystemModstamp]         DATETIME       NULL,
    [Testing_Date__c]        DATE           NULL,
    [Testing_Result__c]      NVARCHAR (255) NULL,
    [Voucher__c]             NVARCHAR (50)  NULL,
    [Voucher_Sent_Date__c]   DATE           NULL
);
