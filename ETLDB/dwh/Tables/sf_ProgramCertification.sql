﻿CREATE TABLE [dwh].[sf_ProgramCertification] (
    [CertificationDate__c]                       DATE               NULL,
    [Clinical_Required__c]                       BIT                NULL,
    [Clinical_Site_Address__c]                   NVARCHAR (255)     NULL,
    [Clinical_Site_City__c]                      NVARCHAR (255)     NULL,
    [Clinical_Site_Contact_Name__c]              NVARCHAR (255)     NULL,
    [Clinical_Site_Contact_Phone_Number__c]      NVARCHAR (40)      NULL,
    [Clinical_Site_Name__c]                      NVARCHAR (255)     NULL,
    [Clinical_Site_Requesting_Sponsorship__c]    NVARCHAR (255)     NULL,
    [Clinical_Site_Requirement_Fulfilled__c]     NVARCHAR (255)     NULL,
    [Clinical_Site_State__c]                     NVARCHAR (255)     NULL,
    [Clinical_Site_Zip__c]                       NVARCHAR (255)     NULL,
    [ClinicalSiteContactEmail__c]                NVARCHAR (80)      NULL,
    [Completed_Externship__c]                    BIT                NULL,
    [Confirmed_Placement__c]                     DATE               NULL,
    [CreatedById]                                NVARCHAR (18)      NULL,
    [CreatedDate]                                DATETIMEOFFSET (0) NULL,
    [Employer_Relations_Coordinator__c]          NVARCHAR (18)      NULL,
    [ERC_Calendly_Link__c]                       NVARCHAR (255)     NULL,
    [ERC_Email__c]                               NVARCHAR (80)      NULL,
    [ERC_Phone__c]                               NVARCHAR (40)      NULL,
    [Externship_Account__c]                      NVARCHAR (18)      NULL,
    [Externship_Date_Enrollment_App_Received__c] DATE               NULL,
    [Externship_Date_Enrollment_App_Sent__c]     DATE               NULL,
    [Externship_End_Date__c]                     DATE               NULL,
    [Externship_Notes__c]                        NVARCHAR (MAX)     NULL,
    [Externship_Opt_Out__c]                      BIT                NULL,
    [Externship_Start_Date__c]                   DATE               NULL,
    [Externship_Status__c]                       NVARCHAR (255)     NULL,
    [Id]                                         NVARCHAR (18)      NULL,
    [IsDeleted]                                  BIT                NULL,
    [LastModifiedById]                           NVARCHAR (18)      NULL,
    [LastModifiedDate]                           DATETIMEOFFSET (0) NULL,
    [Name]                                       NVARCHAR (80)      NULL,
    [OwnerId]                                    NVARCHAR (18)      NULL,
    [Primary_Site_Contact__c]                    NVARCHAR (100)     NULL,
    [ProgramAssignment__c]                       NVARCHAR (18)      NULL,
    [Requires_Externship__c]                     BIT                NULL,
    [RX3000_Week_10_Outreach__c]                 BIT                NULL,
    [RX3000_Week_2_Outreach__c]                  BIT                NULL,
    [Scrubs_and_Stethoscope_Email_Sent_Date__c]  DATE               NULL,
    [Site_Contact_Information__c]                NVARCHAR (255)     NULL,
    [StudentClinicalSiteInfoFormSubmit__c]       DATE               NULL,
    [SystemModstamp]                             DATETIMEOFFSET (0) NULL
);
