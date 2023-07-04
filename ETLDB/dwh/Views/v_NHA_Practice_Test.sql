






CREATE VIEW [dwh].[v_NHA_Practice_Test]
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
   FROM dwh.[sf_ProgramAssigment]),
     temp
AS (SELECT c.Case_Safe_ID_contacts__c,
           pt.Cert_Product,
           P.enlighten__Program__c,
           P.id,
           P.program_id_number__c,
           pt.Product_Number,
           pt.AttemptUserID,
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
                        ) AS FLOAT) AS Score,

						ROW_NUMBER() OVER (PARTITION BY c.Case_Safe_ID_contacts__c,
													    pt.Cert_Product,
														P.enlighten__Program__c,   COALESCE(
																						   [1st_Practice_Test_Attempt Date],
																						   [2nd_Practice_Test_Attempt Date],
																						   [3rd_Practice_Test_Attempt Date],
																						   [4th_Practice_Test_Attempt Date],
																						   [5th_Practice_Test_Attempt Date],
																						   [6th_Practice_Test_Attempt Date]
																					   ) 
                                    ORDER BY pt.AttemptUserID desc
                                   ) as rn
	
    FROM etl.NHA_Practice_Test pt
        INNER JOIN dwh.sf_Contact c
            ON pt.Student_Email in ( c.email,c.Academic_Email__c,c.Alternate_Email__c)
        INNER JOIN cte_sf_ProgramAssigment P
            ON P.enlighten__Contact__c = c.Case_Safe_ID_contacts__c
               AND P.rn = 1)
SELECT Case_Safe_ID_contacts__c,
       enlighten__Program__c,
       Cert_Product,
       t.ID AS ProgramAssigment_ID,
       e.ID AS ExamPrepCourseAssignment_ID,
       pe.ID,
       PracticeDate,
       Score,
	   t.rn,e.CourseNumber__c, t.program_id_number__c 

FROM temp t
    LEFT JOIN [dwh].[sf_ExamPrepCourseAssignment__c] e
        ON t.Case_Safe_ID_contacts__c = e.Contact__c
           AND t.ID = e.Prog_Con_Assignment__c
           AND e.Course__c = t.Cert_Product
           AND cast(e.CourseNumber__c as varchar(10)) = t.program_id_number__c 
	LEFT JOIN dwh.sf_PracticeExam__c PE
        ON PE.ExamPrepCourseAssignment__c =  e.ID 
           AND PE.Practice_Date__c = t.PracticeDate
WHERE isnull(PracticeDate,'') <> '' 
		and rn = 1
		and  e.ID is not null
;