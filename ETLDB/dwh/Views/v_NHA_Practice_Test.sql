








--select * from  [dwh].[v_NHA_Practice_Test]

CREATE VIEW [dwh].[v_NHA_Practice_Test]
AS
WITH cte_sf_ProgramAssigment AS (
			SELECT
                   pa.ID AS id,
                    PCT.CERT,
                   pa.enlighten__Contact__c,
				   PCT.ProgramCode, count(*) qty1,count(*) over ( PARTITION BY   pa.enlighten__Contact__c,PCT.CERT)  as qty2
                   
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
                    PCT.ProgramCode,
					 PCT.CERT,
                   pa.enlighten__Contact__c,
				   pa.ID
),
baseSelect AS (
    SELECT
        c.Case_Safe_ID_contacts__c,
        P.id,
        pt.AttemptUserID,
        pt.Data_Current_As_OF,
        pt.Acct_created_Date,
        pt.Approval_date,
        pt.Cert_PRoduct,
		pt.Student_Email,
        CASE 
            WHEN seq = 1 THEN [1st_Practice_Test_Attempt Date]
            WHEN seq = 2 THEN [2nd_Practice_Test_Attempt Date]
            WHEN seq = 3 THEN [3rd_Practice_Test_Attempt Date]
            WHEN seq = 4 THEN [4th_Practice_Test_Attempt Date]
            WHEN seq = 5 THEN [5th_Practice_Test_Attempt Date]
            WHEN seq = 6 THEN [6th_Practice_Test_Attempt Date]
        END AS PracticeDate,
        CASE 
            WHEN seq = 1 THEN CAST([1st_Practice_Test_Score] AS FLOAT)
            WHEN seq = 2 THEN CAST([2nd_Practice_Test_Score] AS FLOAT)
            WHEN seq = 3 THEN CAST([3rd_Practice_Test_Score] AS FLOAT)
            WHEN seq = 4 THEN CAST([4th_Practice_Test_Score] AS FLOAT)
            WHEN seq = 5 THEN CAST([5th_Practice_Test_Score] AS FLOAT)
            WHEN seq = 6 THEN CAST([6th_Practice_Test_Score] AS FLOAT)
        END AS Score
    FROM 
        (VALUES (1), (2), (3), (4), (5), (6)) AS Sequences(seq)
    CROSS JOIN etl.NHA_Practice_Test pt
    INNER JOIN dwh.sf_Contact c ON pt.Student_Email IN (c.email, c.Academic_Email__c, c.Alternate_Email__c , c.NHA_registered_email__c)
    INNER JOIN cte_sf_ProgramAssigment P ON P.enlighten__Contact__c = c.Case_Safe_ID_contacts__c AND P.CERT = pt.Cert_Product   and p.qty1 = 1  and p.qty2 = 1 
    WHERE pt.enrolledIncourse = 1
),
finalResult AS (
    SELECT
        b.Case_Safe_ID_contacts__c,
        e.id AS ProgramAssigment_ID,
        PE.id,
        b.Approval_date,
        b.Data_Current_As_OF,
        b.Acct_created_Date,
        b.Cert_PRoduct,
        b.PracticeDate,
		b.Student_Email,
        b.Score,
        ROW_NUMBER() OVER (PARTITION BY b.Case_Safe_ID_contacts__c, b.id, b.Cert_Product, b.Approval_date ORDER BY b.AttemptUserID DESC) AS rn
    FROM
        baseSelect b
    LEFT JOIN [dwh].[sf_ExamPrepCourseAssignment__c] e ON b.Case_Safe_ID_contacts__c = e.Contact__c AND b.id = e.Prog_Con_Assignment__c AND e.Course__c = b.Cert_Product
    LEFT JOIN dwh.sf_PracticeExam__c PE ON PE.ExamPrepCourseAssignment__c = e.id AND PE.Practice_Date__c = b.PracticeDate
    WHERE b.PracticeDate <> ''
)
SELECT * FROM finalResult;