USE Azienda;
GO
-----STORED PROCEDURES---------
ALTER PROCEDURE TEST_FilterOrders
--parametri esito e path del file da creare
@Esito INT = 0,
@Path VARCHAR(2000) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	--dichiaro var temp da inserire nel cursore
	DECLARE @Nome VARCHAR(100), @DataOrdine DATE, @Totale INT, @DataConsegna DATETIME
	--dichiaro txt del record da inserire nel file
	DECLARE @Text VARCHAR(2000)
	--dichiaro il cursore
	DECLARE IteratorCursor CURSOR FOR

	--query select per il result set di dati che mi serve inserire nel cursore
	SELECT C.Nome, O.DataOrdine, O.Totale, COALESCE(SO.DataConsegna,0) AS DataConsegna FROM StatoOrdini AS SO
	JOIN Ordini AS O ON O.IdOrdine = SO.IdOrdine
	JOIN Clienti AS C ON C.IdCliente = O.IdCliente
	WHERE SO.Esito = @Esito
	ORDER BY  O.DataOrdine DESC;

	--apro il cursore
	OPEN IteratorCursor;

	--mi posiziono sul primo record
	FETCH NEXT FROM IteratorCursor INTO @Nome, @DataOrdine, @Totale, @DataConsegna;

	--itero sul cursore per mostrare tutti i risultati
	WHILE @@FETCH_STATUS=0 --perchè il fetch se trova un record ritorna con il fetchstatus uno 0
	BEGIN
		SET @Text = 'Nome Cliente: '+@Nome+'           DataOrdine: '+CAST(@DataOrdine AS VARCHAR(15))+'    Totale: '+CAST(@Totale AS VARCHAR(10))+ '    DataConsegna: '+ CAST(@DataConsegna AS VARCHAR(24));
		EXEC [Azienda].[dbo].[TEST_FileWrite] @Path, @Text
		FETCH NEXT FROM IteratorCursor INTO @Nome, @DataOrdine, @Totale, @DataConsegna;
	END

	--Chiudo il cursore
	CLOSE IteratorCursor;

	--dealloca memoria occupata dal cursore
	DEALLOCATE IteratorCursor;
END
GO

DECLARE @Esito INT = 2
SELECT C.Nome, O.DataOrdine, O.Totale, SO.DataConsegna FROM StatoOrdini AS SO
	JOIN Ordini AS O ON O.IdOrdine = SO.IdOrdine
	JOIN Clienti AS C ON C.IdCliente = O.IdCliente
	WHERE SO.Esito = @Esito
	ORDER BY  O.DataOrdine DESC;


EXEC TEST_FilterOrders @Esito = 1, @Path = 'C:\Temp\OrdiniConsegnati.txt'
EXEC TEST_FilterOrders @Esito = 2, @Path = 'C:\Temp\OrdiniNonConsegnati.txt'


--------PERMESSI DA ABILITARE--------

EXEC sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO

EXEC sp_configure 'OLE Automation Procedures', 1;
GO
RECONFIGURE;
GO