

--select *  FROM dwh.v_sf_ProgramAssigment



--select * from [dwh].[v_NHA_Certification_Exam]

CREATE VIEW [dwh].[v_NHA_Certification_Exam]
AS
    WITH cte_sf_ProgramAssigment AS
       (
           SELECT
                p.ProgramAssiment_ID AS id
                , p.Contact_ID       AS enlighten__Contact__c
                , p.Program_ID       AS enlighten__Program__c
                , p.EnrolledProgram  AS Enrolled_Program__c
                , p.Certification    AS CERT
				, p.ProgramCertificationId
                , COUNT(*)           qty1
                , COUNT(*) OVER (PARTITION BY
                                     p.Contact_ID, p.Certification
                                )    AS qty2
           FROM dwh.v_sf_ProgramAssigment p
           GROUP BY
                p.Program_ID, p.EnrolledProgram, p.Certification, p.Contact_ID, p.ProgramAssiment_ID, p.ProgramCertificationId
       )
         , main AS
       (
           SELECT
                            e.FirstName
                            , e.LastName
                            , CA.id
                            , c.Case_Safe_ID_contacts__c
                            , c.AccountID
                            , e.StudentEmail
                            , P.id                                                                        AS ProgramAssigment_Id
                            , P.enlighten__Contact__c
							, p.ProgramCertificationId
                            , e.Institution
                            , e.CertProduct
                            , e.ProductNumber
                            , CAST(e.NHAExamRegistrationDate AS DATE)                                     AS NHAExamRegistrationDate
                            , e.ExamOrderTaken
                            , e.ModeofTesting
                            , CAST(IIF(e.ApprovalDate = '', NULL, e.ApprovalDate) AS SMALLDATETIME)       AS ApprovalDate
                            , CAST(IIF(e.PlannedExamDate = '', NULL, e.PlannedExamDate) AS SMALLDATETIME) AS PlannedExamDate
                            , CAST(IIF(e.ActualExamDate = '', NULL, e.ActualExamDate) AS SMALLDATETIME)   AS ActualExamDate
                            , CAST(NULLIF(NULLIF(e.Score, ''), 0) AS FLOAT)                               AS Score
                            , e.ExamResult
                            , e.CetificationNumAwarded
                            , CAST(IIF(e.DataCurrentAsOf = '', NULL, e.DataCurrentAsOf) AS SMALLDATETIME) AS DataCurrentAsOf
                            , e.ModifiedBy
                            , e.ModifiedOn
                            , 'Registered'                                                                AS RegistrationStatus
                            , ISNULL(e.status, '')                                                        AS Status
                            , CASE WHEN status = 'rescheduled' THEN 4
                                  WHEN status = 'absent' THEN 3
                                  WHEN LTRIM(RTRIM(status)) = '' THEN 1
                                  WHEN status = 'exam_completed' THEN 5
                                  WHEN status = 'scheduled' THEN 2
                                  ELSE 1
                              END                                                                         AS status_order
                            , COALESCE(   CA.Attempt_Number__c, DENSE_RANK() OVER (PARTITION BY e.StudentEmail
                                                                                   ORDER BY e.NHAExamRegistrationDate
                                                                                  )
                                      )                                                                   AS Attempt_Number__c
                            , ROW_NUMBER() OVER (PARTITION BY
                                                     c.Case_Safe_ID_contacts__c
                                                     , e.CertProduct
                                                     , CAST(e.NHAExamRegistrationDate AS DATE)
                                                 ORDER BY CASE WHEN status = 'rescheduled' THEN 4
                                                              WHEN status = 'absent' THEN 3
                                                              WHEN LTRIM(RTRIM(status)) = '' THEN 1
                                                              WHEN status = 'exam_completed' THEN 5
                                                              WHEN status = 'scheduled' THEN 2
                                                              ELSE 1
                                                          END DESC
                                                )                                                         AS rn
           FROM
                            dwh.NHA_Certification_Exam     e
               LEFT JOIN    dwh.sf_Contact                 c ON e.StudentEmail IN (
                                                                                      c.email
                                                                                      , c.Academic_Email__c
                                                                                      , c.Alternate_Email__c
                                                                                      , c.NHA_registered_email__c
                                                                                  )
               LEFT JOIN    dwh.sf_CertificationAttempt__c CA ON CA.Contact__c                                       = c.Case_Safe_ID_contacts__c
                                                                 AND   ISNULL(CAST(CA.Approval_Date__c AS DATE), '') = ISNULL(
                                                                                                                                 CAST(e.ApprovalDate AS DATE)
                                                                                                                                 , ''
                                                                                                                             )
                                                                 AND   ISNULL(CA.Scheduled_Date__c, '')              = ISNULL(
                                                                                                                                 e.PlannedExamDate
                                                                                                                                 , ''
                                                                                                                             )
                                                                 AND   ISNULL(CA.Testing_Date__c, '')                = ISNULL(
                                                                                                                                 e.ActualExamDate
                                                                                                                                 , ''
                                                                                                                             )
                                                                 AND   CA.Registered_Program__c                      = e.CertProduct
                                                                 AND   CA.Attempt_Number__c                          = Attempt_Number__c
               INNER JOIN   cte_sf_ProgramAssigment        P ON P.enlighten__Contact__c                              = c.Case_Safe_ID_contacts__c
                                                                AND P.CERT                                           = e.CertProduct
                                                                AND P.qty1                                           = 1
                                                                AND P.qty2                                           = 1
           WHERE            c.Case_Safe_ID_contacts__c IS NOT NULL
       )
    SELECT
            CertProduct + ' Attempt ' + CAST(Attempt_Number__c AS VARCHAR (10)) AS Name, *
    FROM    main
    WHERE
            main.rn = 1
            AND ProgramAssigment_Id IS NOT NULL;