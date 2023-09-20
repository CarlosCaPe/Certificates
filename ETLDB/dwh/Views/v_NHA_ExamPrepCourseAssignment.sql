






CREATE VIEW [dwh].[v_NHA_ExamPrepCourseAssignment]
AS
WITH cte_sf_ProgramAssigment AS (
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
                    PCT.ProgramCode,
					 PCT.CERT,
                   pa.enlighten__Contact__c,
				   pa.ID
),
temp AS (
    SELECT
        c.Case_Safe_ID_contacts__c,
        P.id,
        pt.AttemptUserID,
        pt.Data_Current_As_OF,
        pt.Acct_created_Date,
        Approval_date,
        Cert_PRoduct
    FROM
        etl.NHA_Practice_Test pt
    INNER JOIN
        dwh.sf_Contact c ON pt.Student_Email IN (c.email, c.Academic_Email__c, c.Alternate_Email__c , c.NHA_registered_email__c)
    INNER JOIN
        cte_sf_ProgramAssigment P ON P.enlighten__Contact__c = c.Case_Safe_ID_contacts__c AND P.CERT = pt.Cert_Product and p.qty1 = 1 and p.qty2 = 1
    WHERE 
        pt.enrolledIncourse = 1
),
finalResult AS (
    SELECT
        Case_Safe_ID_contacts__c,
        t.id AS ProgramAssigment_ID,
        e.id,
        Approval_date,
        t.Data_Current_As_OF,
        t.Acct_created_Date,
        Cert_PRoduct,
        ROW_NUMBER() OVER (PARTITION BY t.Case_Safe_ID_contacts__c, t.id, t.Cert_Product, t.Approval_date ORDER BY AttemptUserID DESC) AS rn
    FROM
        temp t
    LEFT JOIN
        dwh.sf_ExamPrepCourseAssignment__c e ON t.Case_Safe_ID_contacts__c = e.contact__c AND t.id = e.Prog_con_Assignment__c AND t.Cert_Product = e.Course__c AND t.Approval_date = e.Approval_date__C
)
SELECT
    *
FROM
    finalResult
WHERE
    rn = 1;