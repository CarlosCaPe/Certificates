create   VIEW [dwh].[v_sf_ProgramAssigment]
AS
    SELECT
                    PCA.Id                      ProgramAssiment_ID
                    , PCA.name                  AS ProgramAssigmentName
                    , PCA.enlighten__Contact__c AS Contact_ID
                    , PCA.program_id_number__c  AS ProgramIdNumber
                    , PCA.enlighten__program__c AS Program_ID
                    , PCA.Enrolled_Program__c   AS EnrolledProgram
                    , PC.id                     AS ProgramCertificationId
                    , PC.name                   AS Certification
    FROM
                    [dwh].[sf_ProgramContactAssigment__c] PCA
        INNER JOIN  [dwh].[sf_ProgramCertification]       PC ON PCA.ID = PC.ProgramAssignment__c;