

--select * from dwh.v_NHA_ExamPrepCourseAssignment



CREATE VIEW [dwh].[v_NHA_ExamPrepCourseAssignment]
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
                p.Program_ID, p.EnrolledProgram, p.Certification, p.Contact_ID, p.ProgramAssiment_ID,p.ProgramCertificationId
       )
         , temp AS
       (
           SELECT
                            c.Case_Safe_ID_contacts__c
                            , P.id
                            , pt.AttemptUserID
                            , pt.Data_Current_As_OF
                            , pt.Acct_created_Date
                            , Approval_date
                            , Cert_PRoduct
							, p.ProgramCertificationId
           FROM
                            etl.NHA_Practice_Test   pt
               INNER JOIN   dwh.sf_Contact          c ON pt.Student_Email IN (
                                                                                 c.email
                                                                                 , c.Academic_Email__c
                                                                                 , c.Alternate_Email__c
                                                                                 , c.NHA_registered_email__c
                                                                             )
               INNER JOIN   cte_sf_ProgramAssigment P ON P.enlighten__Contact__c = c.Case_Safe_ID_contacts__c
                                                         AND P.CERT              = pt.Cert_Product
                                                         AND P.qty1              = 1
                                                         AND P.qty2              = 1
           WHERE            pt.enrolledIncourse = 1
       )
         , finalResult AS
       (
           SELECT
                            Case_Safe_ID_contacts__c
                            , t.id                  AS ProgramAssigment_ID
                            , e.id
                            , Approval_date
                            , t.Data_Current_As_OF
                            , t.Acct_created_Date
                            , Cert_PRoduct
							, t.ProgramCertificationId
                            , ROW_NUMBER() OVER (PARTITION BY
                                                     t.Case_Safe_ID_contacts__c, t.id, t.Cert_Product, t.Approval_date
                                                 ORDER BY AttemptUserID DESC
                                                )   AS rn
           FROM
                            temp                               t
               LEFT JOIN    dwh.sf_ExamPrepCourseAssignment__c e ON t.Case_Safe_ID_contacts__c = e.contact__c
                                                                    AND t.id                   = e.Prog_con_Assignment__c
                                                                    AND t.Cert_Product         = e.Course__c
                                                                    AND t.Approval_date        = e.Approval_date__C
       )
    SELECT  Case_Safe_ID_contacts__c,ProgramAssigment_ID,id,Approval_date,Data_Current_As_OF,Acct_created_Date,Cert_PRoduct,ProgramCertificationId
    FROM    finalResult
    WHERE   finalResult.rn = 1;