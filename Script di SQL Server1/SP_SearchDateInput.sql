USE Azienda;
GO
ALTER PROCEDURE TEST_SearchDateInput
	@DateFrom DATE,
	@DateTo DATE,
	@Path VARCHAR(2000) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @ClientName VARCHAR(100), @DateOrder DATE, @TotalPaid MONEY;
	DECLARE @Text VARCHAR(2000);
	DECLARE SearchCursor CURSOR FOR

	SELECT C.Nome, O.DataOrdine, O.Totale FROM Ordini AS O
	JOIN Clienti AS C ON C.IdCliente=O.IdCliente
	WHERE (@DateFrom IS NULL OR O.DataOrdine>=@DateFrom)
	   AND(@DateTo IS NULL OR O.DataOrdine<=@DateTo)
	ORDER BY O.DataOrdine;

	OPEN SearchCursor;
	FETCH NEXT FROM SearchCursor INTO  @ClientName, @DateOrder, @TotalPaid;
	WHILE @@FETCH_STATUS=0
	BEGIN
		SET @Text='Nome Cliente: '+@ClientName+'    Data Ordine: '+CAST(@DateOrder AS VARCHAR(15))+'     Totale Pagato: '+CAST(@TotalPaid AS VARCHAR(10));
		EXEC [Azienda].[dbo].[TEST_FileWrite] @Path, @Text;
		FETCH NEXT FROM SearchCursor INTO  @ClientName, @DateOrder, @TotalPaid;
	END
	CLOSE SearchCursor;
	DEALLOCATE SearchCursor;
END
GO

EXEC TEST_SearchDateInput @DateFrom ='2024-01-01', @DateTo='2024-06-18', @Path = 'C:\Temp\OrdiniTraDati.txt'


--------PERMESSI DA ABILITARE--------

EXEC sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO

EXEC sp_configure 'OLE Automation Procedures', 1;
GO
RECONFIGURE;
GO