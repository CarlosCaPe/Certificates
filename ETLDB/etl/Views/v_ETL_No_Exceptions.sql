






CREATE VIEW [etl].[v_ETL_No_Exceptions]
AS
    SELECT distinct C.Name,
            pt.Student_Email,
            'Contact'                       AS 'SalesForceTable',
            'Data inserted for Practice Test ' AS 'Action'
    FROM
            dwh.v_NHA_Practice_Test pt
        inner JOIN
            dwh.sf_Contact        c
                ON pt.Student_Email = c.email
                   OR pt.Student_Email = c.Academic_Email__c
                   OR pt.Student_Email = c.Alternate_Email__c
				   OR pt.Student_Email = c.NHA_Registered_email__c
    WHERE
            c.Case_Safe_ID_contacts__c IS not NULL
    UNION ALL
    SELECT distinct C.Name,
            pt.StudentEmail,
            'Contact'                       AS 'SalesForceTable',
            'Data inserted for Certification Exam ' AS 'Action'
    FROM
            dwh.v_NHA_Certification_Exam pt
        inner JOIN
            dwh.sf_Contact        c
                ON pt.StudentEmail = c.email
                   OR pt.StudentEmail = c.Academic_Email__c
                   OR pt.StudentEmail = c.Alternate_Email__c
				   OR pt.StudentEmail = c.NHA_Registered_email__c
    WHERE
            c.Case_Safe_ID_contacts__c IS not NULL
  ;