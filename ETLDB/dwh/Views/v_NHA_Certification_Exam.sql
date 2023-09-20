



--select * from [dwh].[v_NHA_Certification_Exam]

CREATE VIEW [dwh].[v_NHA_Certification_Exam]
AS
    WITH cte_sf_ProgramAssigment
    AS (
           SELECT
                   pa.ID AS id,
                    PCT.CERT,
                   pa.enlighten__Contact__c,
				    PCT.ProgramCode,count(*) qty1,count(*) over ( PARTITION BY   pa.enlighten__Contact__c,PCT.CERT)  as qty2
                   
           FROM
                   dwh.sf_ProgramAssigment   pa
               INNER JOIN
                   [dwh].[sf_Program]        p
                       ON p.Case_Safe_ID__c = pa.enlighten__Program__c
                          AND p.Parent_program__c = pa.Parent_program__c
               INNER JOIN
                   [dwh].[ProgramCodeToCert] PCT
                       ON PCT.ProgramCode = p.Program_Code__c
           GROUP BY
                    PCT.CERT,
					PCT.ProgramCode,
                   pa.enlighten__Contact__c,
				   pa.ID

			   
				   ),
         main
    AS (   SELECT
                   e.FirstName,
                   e.LastName,
                   CA.id,
                   c.Case_Safe_ID_contacts__c,
                   c.AccountID,
                   e.StudentEmail,
                   P.id                                                                        AS ProgramAssigment_Id,
                   P.enlighten__Contact__c,
                   e.Institution,
                   e.CertProduct,
                   e.ProductNumber,
                   CAST(e.NHAExamRegistrationDate AS DATE)                                     AS NHAExamRegistrationDate,
                   e.ExamOrderTaken,
                   e.ModeofTesting,
                   CAST(IIF(e.ApprovalDate = '', NULL, e.ApprovalDate) AS SMALLDATETIME)       AS ApprovalDate,
                   CAST(IIF(e.PlannedExamDate = '', NULL, e.PlannedExamDate) AS SMALLDATETIME) AS PlannedExamDate,
                   CAST(IIF(e.ActualExamDate = '', NULL, e.ActualExamDate) AS SMALLDATETIME)   AS ActualExamDate,
                   CAST(NULLIF(NULLIF(e.Score, ''), 0) AS FLOAT)                               AS Score,
                   e.ExamResult,
                   e.CetificationNumAwarded,
                   CAST(IIF(e.DataCurrentAsOf = '', NULL, e.DataCurrentAsOf) AS SMALLDATETIME) AS DataCurrentAsOf,
                   e.ModifiedBy,
                   e.ModifiedOn,
				   'Registered' as RegistrationStatus,
                   ISNULL(e.status, '')                                                        AS Status,
                   CASE
                       WHEN status = 'rescheduled'
                           THEN
                           4
                       WHEN status = 'absent'
                           THEN
                           3
                       WHEN LTRIM(RTRIM(status)) = ''
                           THEN
                           1
                       WHEN status = 'exam_completed'
                           THEN
                           5
                       WHEN status = 'scheduled'
                           THEN
                           2
                       ELSE
                           1
                   END                                                                         AS status_order,
                   COALESCE(   CA.Attempt_Number__c, DENSE_RANK() OVER (PARTITION BY
                                                                            e.StudentEmail
                                                                        ORDER BY
                                                                            e.NHAExamRegistrationDate
                                                                       )
                           )                                                                   AS Attempt_Number__c,
                   ROW_NUMBER() OVER (PARTITION BY
                                          c.Case_Safe_ID_contacts__c,
                                          e.CertProduct,
                                          CAST(e.NHAExamRegistrationDate AS DATE)
                                      ORDER BY
                                          CASE
                                              WHEN status = 'rescheduled'
                                                  THEN
                                                  4
                                              WHEN status = 'absent'
                                                  THEN
                                                  3
                                              WHEN LTRIM(RTRIM(status)) = ''
                                                  THEN
                                                  1
                                              WHEN status = 'exam_completed'
                                                  THEN
                                                  5
                                              WHEN status = 'scheduled'
                                                  THEN
                                                  2
                                              ELSE
                                                  1
                                          END DESC
                                     )                                                         AS rn
           FROM
                   dwh.NHA_Certification_Exam     e
               LEFT JOIN
                   dwh.sf_Contact                 c
                       ON e.StudentEmail IN (
                                                c.email, c.Academic_Email__c, c.Alternate_Email__c , c.NHA_registered_email__c
                                            )
               LEFT JOIN
                   dwh.sf_CertificationAttempt__c CA
                       ON CA.Contact__c = c.Case_Safe_ID_contacts__c
                          AND ISNULL(CAST(CA.Approval_Date__c AS DATE), '') = ISNULL(CAST(e.ApprovalDate AS DATE), '')
                          AND ISNULL(CA.Scheduled_Date__c, '') = ISNULL(e.PlannedExamDate, '')
                          AND ISNULL(CA.Testing_Date__c, '') = ISNULL(e.ActualExamDate, '')
                          AND CA.Registered_Program__c = e.CertProduct
						  and CA.Attempt_Number__c = Attempt_Number__c
               INNER JOIN
                   cte_sf_ProgramAssigment        P
                       ON P.enlighten__Contact__c = c.Case_Safe_ID_contacts__c
                          AND P.CERT = e.CertProduct
						  AND p.qty1 = 1 
						  AND p.qty2 = 1 
           WHERE
                   c.Case_Safe_ID_contacts__c IS NOT NULL)
    SELECT
        CertProduct + ' Attempt ' + cast(Attempt_Number__c  as varchar(10)) as Name,*
		  
    FROM
        main
    WHERE
        main.rn = 1
        AND ProgramAssigment_Id IS NOT NULL;