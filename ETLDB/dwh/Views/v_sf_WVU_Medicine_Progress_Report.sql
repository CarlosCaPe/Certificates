
CREATE VIEW dwh.v_sf_WVU_Medicine_Progress_Report
AS
    SELECT
        C.Academic_Status__c    AS Academic_Status
        , C.FirstName           AS First_Name
        , C.LastName            AS Last_Name
        , C.Enrolled_Program__c AS Enrolled_Program
        , C.Start_Date__c       AS Start_Date
        , C.End_Date__c				as PRogram_End_Date
        , C.Program_Completion_Date__c as Program_Completion_Date
        , pa.Student_Program_Completion__c as Student_Program_Completion
        , pa.Program_Target_Completion__c as Program_Target_Completion
        , C.Cleared_for_National_Exam__c  as Cleared_for_National_Exam
        , C.Certification_1_Final_Result__c as Certification_1_Final_Result
        , C.Last_Activity_Completion__c as Last_LMS_Activity_Date
        , pa.LastActivityDate	as Last_ActivityDate
		, a.name as AccountName
		, p.name as ProgramName

    FROM
        dwh.sf_Contact                       AS C
        LEFT JOIN dwh.sf_ProgramAssigmentPRD pa ON C.Case_Safe_ID_contacts__c = pa.enlighten__Contact__c
		   LEFT JOIN [dwh].[sf_Account] a ON a.Case_Safe_ID_acct__c = c.AccountID
		   LEFT JOIN  dwh.[sf_ProgramPRD] p ON p.Case_Safe_ID__c = pa.enlighten__Program__c;