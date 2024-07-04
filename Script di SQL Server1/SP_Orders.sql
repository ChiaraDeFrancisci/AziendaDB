USE Azienda;
GO
----select clienti non parametrica
--Create PROCEDURE SP_GetAllOrdini
--AS
--BEGIN
--	SET NOCOUNT ON;
--	SELECT C.*,O.IdOrdine,O.DataOrdine FROM Ordini AS O
--	JOIN Clienti AS C ON C.IdCliente = O.IdCliente;
--END
--GO
----select cliente Id parametro
--ALTER PROCEDURE SP_GetOrdineByID
--@IdOrdine INT = 0
--AS
--BEGIN
--	SET NOCOUNT ON;
	
	--SELECT C.*,O.IdOrdine,O.DataOrdine FROM Ordini AS O
	--JOIN Clienti AS C ON C.IdCliente = O.IdCliente
	--WHERE O.IdOrdine=@IdOrdine;
--END
--GO
--update cliente
--drop procedure SP_UpdateClientByID;
--go
--create PROCEDURE SP_UpdateOrderByID
--@IdCliente INT = 0,
--@IdOrdine INT = 0,
--@DataOrdine DATE=NULL,
--@Totale MONEY=NULL
--AS
--BEGIN
--	UPDATE Ordini
--	SET IdCliente=@IdCliente,DataOrdine=@DataOrdine,Totale=@Totale
--	WHERE IdOrdine=@IdOrdine;
--END
--GO
----insert cliente
--Create PROCEDURE SP_InsertOrder
--@IdCliente INT =0,
--@DataOrdine DATE=NULL,
--@Totale MONEY=NULL
--AS
--BEGIN
--	SET NOCOUNT ON;
	
--	INSERT INTO Ordini (IdCliente, DataOrdine, Totale)
--	VALUES  (@IdCliente, @DataOrdine, @Totale);
--END
--GO

--Create PROCEDURE SP_DeleteOrderByID
--@IdOrdine INT = 0
--AS
--BEGIN
--	SET NOCOUNT ON;	
--	DELETE FROM StatoOrdini 
--	WHERE IdOrdine=@IdOrdine;
--	DELETE FROM DettaglioOrdini 
--	WHERE IdOrdine=@IdOrdine;
--	DELETE FROM Ordini 
--	WHERE IdOrdine=@IdOrdine;
--END
--GO


CREATE TYPE Dettaglio AS TABLE
(    
    IdProdotto INT,
    Quantita INT
);
go

go
Alter PROCEDURE SP_InsertOrder

@Dettagli Dettaglio READONLY,
@IdCliente INT =0,
@Totale MONEY =0,
@DataOrdine DATE = NULL

AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @IdOrdine INT;

	INSERT INTO Ordini (IdCliente, DataOrdine, Totale)
	VALUES  (@IdCliente, @DataOrdine, @Totale);

	--declare @IdOrdine INT = (
	--SELECT O.IdOrdine FROM Ordini AS O
	--WHERE O.IdCliente = @IdCliente AND
	--	  O.DataOrdine = @DataOrdine AND
	--	  O.Totale = @Totale);
	SET @IdOrdine = SCOPE_IDENTITY(); 

	INSERT INTO StatoOrdini (IdOrdine, DataPrimoInvio, Esito, DataConsegna)
	Values (@IdOrdine,NULL,2,NULL);

	DECLARE DettagliCursor CURSOR FOR
    SELECT IdProdotto, Quantita
    FROM @Dettagli;

	DECLARE @IdProdotto INT;
    DECLARE @Quantita INT;

	OPEN DettagliCursor;
	FETCH NEXT FROM DettagliCursor INTO @IdProdotto, @Quantita;
	WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Call the stored procedure for each row
        EXEC [Azienda].[dbo].[SP_InsertInfoOrder] @IdOrdine, @IdProdotto, @Quantita;
        FETCH NEXT FROM DettagliCursor INTO @IdProdotto, @Quantita;
    END

    -- Close and deallocate cursor
    CLOSE DettagliCursor;
    DEALLOCATE DettagliCursor;


END
GO
--prova
DECLARE @return_value INT;
DECLARE @Dettagli dbo.Dettaglio;

-- Popola la variabile con dati di test
INSERT INTO @Dettagli (IdProdotto, Quantita)
VALUES (5, 2), (7, 2);

-- Esegui la stored procedure con i parametri
EXEC @return_value = dbo.SP_InsertOrder
    @Dettagli = @Dettagli,
    @IdCliente = 4,
    @Totale = 24,
    @DataOrdine = '2024-06-28';

-- Mostra il valore di ritorno della stored procedure
SELECT @return_value AS ReturnValue;
go


ALTER PROCEDURE SP_GetAllDettaglioOrdini
AS
BEGIN
	SET NOCOUNT ON;
	SELECT C.Nome, C.Email ,O.*,P.*,DO.Quantita FROM DettaglioOrdini AS DO
	JOIN Ordini AS O ON O.IdOrdine = DO.IdOrdine
	JOIN Prodotti AS P ON P.IdProdotto = DO.IdProdotto
	JOIN Clienti AS C ON C.IdCliente = O.IdCliente;
END
GO



ALTER PROCEDURE SP_InviaOrdineByID
@IdOrdine INT =0,
@DataPrimoInvio DATETIME = NULL

AS
BEGIN 
SET NOCOUNT ON;
 UPDATE StatoOrdini
 SET DataPrimoInvio=  @DataPrimoInvio
 WHERE IdOrdine = @IdOrdine;
END
GO