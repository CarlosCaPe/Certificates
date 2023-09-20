CREATE TABLE [dwh].[sf_ProgramCourseAssosiation__c] (
    [CreatedById]            NVARCHAR (18)      NULL,
    [CreatedDate]            DATETIMEOFFSET (0) NULL,
    [enlighten__ComboID__c]  NVARCHAR (20)      NULL,
    [enlighten__Course__c]   NVARCHAR (18)      NULL,
    [enlighten__Program__c]  NVARCHAR (18)      NULL,
    [enlighten__Set_Name__c] NVARCHAR (255)     NULL,
    [Id]                     NVARCHAR (18)      NULL,
    [IsDeleted]              BIT                NULL,
    [LastActivityDate]       DATE               NULL,
    [LastModifiedById]       NVARCHAR (18)      NULL,
    [LastModifiedDate]       DATETIMEOFFSET (0) NULL,
    [Name]                   NVARCHAR (80)      NULL,
    [SystemModstamp]         DATETIMEOFFSET (0) NULL
);

