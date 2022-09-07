USE [Navigator]

GO

BEGIN TRAN


	-- Add the parameters for the stored procedure here
	DECLARE @PK varchar(max) = '1984'			--Project_PK
	DECLARE @ServerName varchar(max) = 'CVC-SQL1\SAGE_EST_DEV'	
	DECLARE @DatabaseName varchar(max) = 'Estimates'
	DECLARE @sageStagingDataPK int = 0
	DECLARE @currentUser varchar(max) = 'MaksK'
	DECLARE @jobName varchar(50) = 'Publish job specs'
	-- OUTPUT
	DECLARE @exceptionCount int
	DECLARE @warningCount int 
	DECLARE @totalTestCount int
	DECLARE @evaluationCount int 
	DECLARE @validationPass bit 

	EXEC [Transform].[CVC_JobProcess] @PK, @ServerName, @DatabaseName, @sageStagingDataPK, @currentUser, @jobName, @exceptionCount, @warningCount, @totalTestCount, @evaluationCount, @validationPass

	SELECT * FROM [Staging].[CVC_JobSpecData]

ROLLBACK TRAN