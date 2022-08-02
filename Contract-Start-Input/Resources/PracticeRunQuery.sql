BEGIN TRAN;

DECLARE @PK varchar(max) = '4462'				--Estimate_PK
DECLARE @ServerName varchar(max) = 'CVC-SQL1\SAGE_EST_DEV'	
DECLARE @DatabaseName varchar(max) = 'Eestimates'	
DECLARE @sageStagingDataPK int = -1
DECLARE @currentUser varchar(max) = 'MaksK'
DECLARE @jobName varchar(50) = 'Dex'
DECLARE @exceptionCount int 
DECLARE @warningCount int 
DECLARE @totalTestCount int 
DECLARE @evaluationCount int 
DECLARE @validationPass bit 			
	

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

	SET NOCOUNT ON;

	--Get sageStagingDataPK
	IF @sageStagingDataPK=-1	--means generate reportable views came from CMI rather than DEX
		SET @sageStagingDataPK = (SELECT SageReportableViewID FROM Core.SageEstimateLink WHERE Estimate_PK = @PK)

	--Create temp Item table (UDTT)
	DECLARE @sql nvarchar(max)
	SET @sql = 
            'SELECT 
				  EstimateId,
				  ItemId,
				  TakeoffQuantity,
				  TakeoffUnitName,
				  LTRIM(RTRIM(Wbs01)),
				  LTRIM(RTRIM(Wbs02)),
				  LabManHours,
				  LabAmount+LabAllocatedAmount,
				  MatAmount+MatAllocatedAmount,
				  SubAmount+SubAllocatedAmount,
				  EqpAmount+EqpAllocatedAmount,
				  OthAmount+OthAllocatedAmount,
				  LTRIM(RTRIM(CombinedJcCostCode))
			FROM SageSecuredReportStaging.Item WHERE EstimateId =' + CAST(@sageStagingDataPK as varchar(100)) 
	DECLARE @Item AS SageSecuredReportStaging.Item
	INSERT INTO @Item(
			EstimateId,
			ItemId,
			TakeoffQuantity,
			TakeoffUnitName,
			Wbs01,
			Wbs02,
			LabManHours,
			LabAmount,
			MatAmount,
			SubAmount,
			EqpAmount,
			OthAmount,
			CombinedJcCostCode)
	EXEC (@sql)

	--Get new Batch number
	DECLARE @Batch int = ISNULL((SELECT MAX(Batch)+1 FROM Reference.CVC_ContractCheckData WHERE Estimate_PK = @PK),1);

	/*
	--Create FootprintQuantity table (only take first of each CombinedJCCostCode grouping)
	WITH cteSummary
	AS (
		SELECT i.Wbs01
			,i.Wbs02
			,i.CombinedJcCostCode
			,SUM(i.TakeoffQuantity) AS Qty
			,ROW_NUMBER() OVER (
				PARTITION BY i.Wbs01
				,i.Wbs02
				,i.CombinedJCCostCode ORDER BY SUM(i.TakeoffQuantity) DESC
				) AS rank
		FROM @Item i
		GROUP BY i.[Wbs01]
			,i.[Wbs02]
			,i.[CombinedJcCostCode]
		HAVING i.[CombinedJcCostCode] LIKE '%15.100'
		)
	SELECT *
	INTO #FootprintQuantity
	FROM cteSummary
	WHERE rank = 1
*/
	--Insert Records
		--gather records to sum and group by
     SELECT @PK as Estimate_PK
		,i.Wbs01 AS [Plan]
		,i.Wbs02 AS [ELV/OPT]
		,'' AS IdentifyingNotes
		,CASE WHEN i.CombinedJcCostCode IN('010.001') THEN i.TakeoffQuantity ELSE 0 END AS FootprintQuantity
		,LabManHours AS LaborHours
		,CASE WHEN i.CombinedJcCostCode IN('015.100','017.100') THEN i.TakeoffQuantity ELSE 0 END  AS ConcreteQuantity
		,CASE WHEN i.CombinedJcCostCode IN('016.161','016.160') THEN i.TakeoffQuantity ELSE 0 END AS RockQuantity
		,CASE WHEN i.CombinedJcCostCode IN('014.143', '014.144', '014.145', '014.146', '014.147', '016.143', '016.144', '016.145', '016.146') THEN i.TakeoffQuantity ELSE 0 END AS SteelQuantity
		,CASE WHEN i.CombinedJcCostCode IN('014.141') THEN i.TakeoffQuantity ELSE 0 END AS PTCableQuantity
		,CASE WHEN i.CombinedJcCostCode IN('015.100','017.100') THEN i.TakeoffQuantity ELSE 0 END AS PumpingQuantity
		,CASE WHEN i.CombinedJcCostCode IN('013.020') THEN i.TakeoffQuantity ELSE 0 END AS LumberQuantity
		,LabAmount + MatAmount + SubAmount + EqpAmount + OthAmount AS SageEstimateAmount
		,NULL AS CreatedBy
		,NULL AS CreatedDate
		,NULL AS UpdateBy
		,NULL AS UpdateDate
		,@Batch AS Batch
	INTO #Item
	FROM @Item i 
	WHERE LabAmount + MatAmount + SubAmount + EqpAmount + OthAmount <>0;

		--FINAL INSERT
	--INSERT INTO [Reference].[CVC_ContractCheckData]
 --       ([Estimate_PK]
 --       ,[Plan]
 --       ,[ELV/OPT]
 --       ,[IdentifyingNotes]
 --       ,[FootprintQuantity]
 --       ,[LaborHours]
 --       ,[ConcreteQuantity]
 --       ,[RockQuantity]
 --       ,[SteelQuantity]
 --       ,[PTCableQuantity]
 --       ,[PumpingQuantity]
 --       ,[LumberQuantity]
 --       ,[SageEstimateAmount]
	--	,[Batch])
	SELECT 
		Estimate_PK,
		[Plan],
		[ELV/OPT],
		IdentifyingNotes,
		SUM(FootprintQuantity),
		SUM(LaborHours),
		SUM(ConcreteQuantity),
		SUM(RockQuantity),
		SUM(SteelQuantity),
		SUM(PTCableQuantity),
		SUM(PumpingQuantity),
		SUM(LumberQuantity),
		SUM(SageEstimateAmount),
		Batch
	FROM #Item
	GROUP BY 
		Estimate_PK,
		[Plan],
		[ELV/OPT],
		IdentifyingNotes,
		-- FootprintQuantity,
		Batch
	ORDER BY [Plan], [ELV/OPT]

	----Output Parameters
	--SET @exceptionCount = 0
	--SET @warningCount = 0
	--SET @totalTestCount = 0
	--SET @evaluationCount = 0
	--SET @validationPass = 1

	----Final Output
	--SELECT 50, 500

	--SELECT 'ErrorNum' AS 'Error#', 'Description' as 'Description'

DROP TABLE #Item 

ROLLBACK TRAN;
