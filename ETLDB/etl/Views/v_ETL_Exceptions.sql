








--SELECT * FROM [etl].[v_ETL_Exceptions] WHERE sTUDENT_EMAIL = 'abcarson94@gmail.com'
--SELECT COUNT(*) FROM  [etl].[v_ETL_Exceptions] 22501,10408

CREATE VIEW [etl].[v_ETL_Exceptions]
AS
    SELECT  c.Name,
            pt.Student_Email,
            'Contact'                       AS 'SalesForceTable',
            'Data Integrity Alert: Missing Contact Record in Salesforce' AS 'Exception'
    FROM
            etl.NHA_Practice_Test pt
        LEFT JOIN
            dwh.sf_Contact        c
                ON pt.Student_Email = c.email
                   OR pt.Student_Email = c.Academic_Email__c
                   OR pt.Student_Email = c.Alternate_Email__c
				   or pt.Student_Email = c.NHA_registered_email__c
    WHERE
            c.Case_Safe_ID_contacts__c IS NULL
    UNION
    SELECT   c.Name,
            pt.StudentEmail,
            'Contact'                       AS 'SalesForceTable',
            'Data Integrity Alert: Missing Contact Record in Salesforce' AS 'Exception'
    FROM
            etl.NHA_Certification_Exam pt
        LEFT JOIN
            dwh.sf_Contact        c
                ON pt.StudentEmail = c.email
                   OR pt.StudentEmail = c.Academic_Email__c
                   OR pt.StudentEmail = c.Alternate_Email__c
				   or pt.StudentEmail = c.NHA_registered_email__c
    WHERE
            c.Case_Safe_ID_contacts__c IS NULL
    UNION
    SELECT
	Name,
        Email,
        SalesForceTable,
        exception
    FROM
        (
            SELECT  c.Name,
                    c.Email,
                    'sf_ProgramAssigment / Mapping code table'                                                   AS 'SalesForceTable',
                    'Data Integrity Alert: Multiple Enrollments Detected : ' + PCT.CERT + '' AS 'exception',
                    count(*) over (partition by  pa.enlighten__Contact__c, PCT.CERT,PCT.ProgramCode) as qty1,
					count(*) over (partition by  pa.enlighten__Contact__c, PCT.CERT) as qty2
            FROM
                    dwh.sf_ProgramAssigment   pa
                INNER JOIN
                    [dwh].[sf_Program]        p
                        ON p.Case_Safe_ID__c = pa.enlighten__Program__c
                           AND p.Parent_program__c = pa.Parent_program__c
                INNER JOIN
                    [dwh].[ProgramCodeToCert] PCT
                        ON PCT.ProgramCode = p.Program_Code__c
                INNER JOIN
                    [dwh].[sf_Contact]        c
                        ON c.Case_Safe_ID_contacts__c = pa.enlighten__Contact__c

				INNER JOIN 
					etl.NHA_Certification_Exam pt    ON (pt.StudentEmail = c.email
                   OR pt.StudentEmail = c.Academic_Email__c
                   OR pt.StudentEmail = c.Alternate_Email__c
				   or pt.StudentEmail = c.NHA_registered_email__c)
				   				   and (PCT.CERT= pt.CertProduct )

            GROUP BY
			c.Name,
                    PCT.CERT,
                    c.Email,
                    pa.enlighten__Contact__c,
                    PCT.ProgramCode
        ) AS ori
    WHERE
        QTY2 > 1 or QTY1 > 1
		
		
		    UNION
    SELECT
	name,
        Email,
        SalesForceTable,
        exception
    FROM
        (
            SELECT  c.Name,
                    c.Email,
                    'sf_ProgramAssigment / Mapping code table'                                                   AS 'SalesForceTable',
                    'Data Integrity Alert: Multiple Enrollments Detected : ' + PCT.CERT + '' AS 'exception',
                     count(*) over (partition by  pa.enlighten__Contact__c, PCT.CERT,PCT.ProgramCode) as qty1,
					 count(*) over (partition by  pa.enlighten__Contact__c, PCT.CERT) as qty2
				   
            FROM
                    dwh.sf_ProgramAssigment   pa
                INNER JOIN
                    [dwh].[sf_Program]        p
                        ON p.Case_Safe_ID__c = pa.enlighten__Program__c
                           AND p.Parent_program__c = pa.Parent_program__c
                INNER JOIN
                    [dwh].[ProgramCodeToCert] PCT
                        ON PCT.ProgramCode = p.Program_Code__c
                INNER JOIN
                    [dwh].[sf_Contact]        c
                        ON c.Case_Safe_ID_contacts__c = pa.enlighten__Contact__c

				INNER JOIN 
					etl.NHA_Practice_Test pt    ON (pt.Student_Email = c.email
                   OR pt.Student_Email = c.Academic_Email__c
                   OR pt.Student_Email = c.Alternate_Email__c
				   or pt.Student_Email = c.NHA_registered_email__c)
				   and (PCT.CERT= pt.Cert_Product )

            GROUP BY
				c.Name,
                    PCT.CERT,
                    c.Email,
                    pa.enlighten__Contact__c,
                    PCT.ProgramCode
        ) AS ori
    WHERE
       QTY2 > 1 or QTY1 > 1
		
		;