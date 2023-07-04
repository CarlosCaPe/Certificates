






CREATE VIEW [dwh].[v_NHA_ExamPrepCourseAssignment]
AS
WITH cte_sf_ProgramAssigment
AS (
   SELECT enlighten__Program__c,
          enlighten__Contact__c,
          ID,
          program_id_number__c,
          ROW_NUMBER() OVER (PARTITION BY enlighten__Contact__c
                             ORDER BY Program_ID_Number__c DESC
                            ) AS rn
   FROM dwh.sf_ProgramAssigment),
     temp
AS (SELECT c.Case_Safe_ID_contacts__c,
           P.enlighten__Program__c,
           P.id,
           P.program_id_number__c,
           pt.AttemptUserID,
           pt.Data_Current_As_OF,
           pt.Acct_created_Date,
           Approval_date,
           Cert_PRoduct,
           COALESCE(
                       [1st_Practice_Test_Attempt Date],
                       [2nd_Practice_Test_Attempt Date],
                       [3rd_Practice_Test_Attempt Date],
                       [4th_Practice_Test_Attempt Date],
                       [5th_Practice_Test_Attempt Date],
                       [6th_Practice_Test_Attempt Date]
                   ) AS PracticeDate,
           CAST(COALESCE(
                            [1st_Practice_Test_Score],
                            [2nd_Practice_Test_Score],
                            [3rd_Practice_Test_Score],
                            [4th_Practice_Test_Score],
                            [5th_Practice_Test_Score],
                            [6th_Practice_Test_Score]
                        ) AS FLOAT) AS Score
    FROM etl.NHA_Practice_Test pt
        INNER JOIN dwh.sf_Contact c
            ON pt.Student_Email IN ( c.email, c.Academic_Email__c, c.Alternate_Email__c )
        INNER JOIN cte_sf_ProgramAssigment P
            ON P.enlighten__Contact__c = c.Case_Safe_ID_contacts__c
               AND P.rn = 1),
     finalResult
AS (SELECT Case_Safe_ID_contacts__c,
           enlighten__Program__c,
           t.ID AS ProgramAssigment_ID,
           program_id_number__c,
           AttemptUserID,
           e.Id,
           t.PracticeDate,
           Approval_date,
           t.Data_Current_As_OF,
           t.Acct_created_Date,
           Cert_PRoduct,
           t.Score,
           ROW_NUMBER() OVER (PARTITION BY t.Case_Safe_ID_contacts__c,
                                           t.ID,
                                           t.Cert_Product,
                                           t.Approval_date
                              ORDER BY AttemptUserID DESC
                             ) AS rn
    FROM temp t
        LEFT JOIN dwh.sf_ExamPrepCourseAssignment__c e
            ON t.Case_Safe_ID_contacts__c = e.contact__c
               AND t.ID = e.Prog_con_Assignment__c
               AND t.Cert_Product = e.Course__c
               AND t.Approval_date = e.Approval_date__C
    WHERE t.PracticeDate <> '')
SELECT *
FROM finalResult
WHERE rn = 1;