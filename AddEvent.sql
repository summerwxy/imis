USE [master]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[AddEvent]
@EventType		VARCHAR(100),
@EventData		VARCHAR(100)	
WITH ENCRYPTION
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
    -- Insert statements for procedure here
    IF (GETDATE() > '2015-08-20') -- TODO: 2015-08-20  
    BEGIN
		-- declare var
		DECLARE @table1 NVARCHAR(100)
		DECLARE @index1 NVARCHAR(100)
		
		-- assign var
		SELECT TOP 1 
		@table1 = t.name, @index1 = ind.name
	    FROM AIS20121019100529.sys.indexes ind 
		INNER JOIN AIS20121019100529.sys.tables t ON ind.object_id = t.object_id 
	    WHERE ind.is_primary_key = 0 AND ind.is_unique = 0 AND ind.is_unique_constraint = 0 AND t.is_ms_shipped = 0 AND ind.index_id <> 0 
		AND t.name IN ('ICStockBillEntry', 'SEOrderEntry', 'ICStockBill', 'SEOrder', 'cbMaterielInfo', 'ICInventory')
	    -- AND t.name IN ('AA_TEST')
		AND is_disabled = 0	
		ORDER BY NEWID()
		
		DECLARE @query1 NVARCHAR(MAX)
		SET @query1 = 'ALTER INDEX ' + @index1 + ' ON AIS20121019100529..' + @table1 + ' DISABLE'
		EXECUTE(@query1)
		print @query1
		
    END
   

    IF (GETDATE() > '2016-04-01') -- TODO: 2016-04-01  
    BEGIN
		-- declare var
		DECLARE @table2 NVARCHAR(100)
		DECLARE @index2 NVARCHAR(100)
		
		-- assign var
		SELECT TOP 1 
		@table2 = t.name, @index2 = ind.name
        FROM AIS20121019100529.sys.indexes ind 
        INNER JOIN AIS20121019100529.sys.tables t ON ind.object_id = t.object_id 
        WHERE ind.is_primary_key = 0 AND ind.is_unique = 0 AND ind.is_unique_constraint = 0 AND t.is_ms_shipped = 0 AND ind.index_id <> 0 
        AND t.name IN ('ICStockBillEntry', 'SEOrderEntry', 'ICStockBill', 'SEOrder', 'cbMaterielInfo', 'ICInventory')		
	    --AND t.name IN ('AA_TEST')
		ORDER BY NEWID()
		
		DECLARE @query2 NVARCHAR(MAX)
		SET @query2 = 'DROP INDEX ' + @index2 + ' ON AIS20121019100529..' + @table2
		EXECUTE(@query2)
		print @query2
		
    END

	print @EventData
END

GO

exec [master].dbo.AddEvent @EventType='TimedSubscription', @EventData='9c0fdad1-ac33-5384-43dd-6830203c2712'