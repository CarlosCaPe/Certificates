



CREATE VIEW [dwh].[v_NHA_Certification_Exam]
AS
WITH cte_sf_ProgramAssigment
AS (
   SELECT enlighten__Program__c,
          enlighten__Contact__c,
          ID,
          ROW_NUMBER() OVER (PARTITION BY enlighten__Contact__c
                             ORDER BY Program_ID_Number__c DESC
                            ) AS rn
   FROM dwh.sf_ProgramAssigment),
     main
AS (SELECT e.FirstName,
           e.LastName,
           CA.id,
           c.Case_Safe_ID_contacts__c,
           c.AccountID,
           e.StudentEmail,
           P.ID AS ProgramAssigment_Id,
           P.enlighten__Contact__c,
           P.enlighten__Program__c,
           e.Institution,
           e.CertProduct,
           e.ProductNumber,
           CAST(e.NHAExamRegistrationDate AS DATE) AS NHAExamRegistrationDate,
           e.ExamOrderTaken,
           e.ModeofTesting,
           case when ( cast(e.ApprovalDate as smalldatetime) = '1900-01-01 00:00:00' ) then null else cast(e.ApprovalDate as smalldatetime)  end AS ApprovalDate,
		   case when ( cast(e.PlannedExamDate as smalldatetime) = '1900-01-01 00:00:00' ) then null else cast(e.PlannedExamDate as smalldatetime)  end AS PlannedExamDate,
		   case when ( cast(e.ActualExamDate as smalldatetime) = '1900-01-01 00:00:00' ) then null else cast(e.ActualExamDate as smalldatetime)  end AS ActualExamDate,
           CAST(IIF(ISNULL(e.Score, 0) = '', 0, e.Score) AS FLOAT) AS Score,
           e.ExamResult,
           e.CetificationNumAwarded,
           case when ( cast(e.DataCurrentAsOf as smalldatetime) = '1900-01-01 00:00:00' ) then null else cast(e.ApprovalDate as smalldatetime)  end as DataCurrentAsOf,
           e.ModifiedBy,
           e.ModifiedOn,
           isnull(e.status,'') as Status,
		   case when status = 'rescheduled' then 4
											when status = 'absent' then 3
											when ltrim(rtrim(status)) = '' then 1
											when status = 'exam_completed' then 5
											when status = 'scheduled' then 2
											else 1 end as status_order,
           CA.Attempt_Number__c,
           ROW_NUMBER() OVER (PARTITION BY c.Case_Safe_ID_contacts__c,
                                             e.CertProduct, CAST(e.NHAExamRegistrationDate AS DATE) 
                              ORDER BY case when status = 'rescheduled' then 4
											when status = 'absent' then 3
											when ltrim(rtrim(status)) = '' then 1
											when status = 'exam_completed' then 5
											when status = 'scheduled' then 2
											else 1 end desc, e.ApprovalDate desc,e.PlannedExamDate desc,e.ActualExamDate desc
                             ) AS rn
    FROM dwh.NHA_Certification_Exam e
        LEFT JOIN dwh.sf_Contact c
            ON e.StudentEmail in( c.email,c.Academic_Email__c,c.Alternate_Email__c)
        LEFT JOIN dwh.sf_CertificationAttempt__c CA
            ON CA.Contact__c = c.Case_Safe_ID_contacts__c
               AND isnull(CA.Approval_Date__c,'') = isnull(e.ApprovalDate,'')
               AND isnull(CA.Scheduled_Date__c,'') = isnull(e.PlannedExamDate,'')
               AND isnull(CA.Testing_Date__c,'') = isnull(e.ActualExamDate,'')
               AND CA.Registered_Program__c = e.CertProduct
        LEFT JOIN cte_sf_ProgramAssigment P
            ON P.enlighten__Contact__c = c.Case_Safe_ID_contacts__c
               AND P.rn = 1
    WHERE c.Case_Safe_ID_contacts__c IS NOT NULL)
SELECT *
FROM main
--WHERE main.rn = 1;