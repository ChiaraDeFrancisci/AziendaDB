CREATE TYPE OrdiniDaAggiornare AS TABLE
(    
    IdOrdine INT
);
go
ALTER PROCEDURE SP_UpdateAutomatico
@Ordini OrdiniDaAggiornare READONLY
AS
BEGIN
SET NOCOUNT ON;

	DECLARE OrdiniCursor CURSOR FOR
    SELECT IdOrdine
    FROM @Ordini;

	DECLARE @IdOrdine INT;

	OPEN OrdiniCursor;
	FETCH NEXT FROM OrdiniCursor INTO @IdOrdine;
	WHILE @@FETCH_STATUS = 0
	BEGIN
        UPDATE StatoOrdini
        SET Esito = 1, DataConsegna=GETDATE()		
        WHERE IdOrdine = @IdOrdine;

        -- Passare al prossimo ordine
        FETCH NEXT FROM OrdiniCursor INTO @IdOrdine;
    END;

    -- Chiusura e deallocazione del cursore
    CLOSE OrdiniCursor;
    DEALLOCATE OrdiniCursor;

END
GO

--prova
DECLARE @return_value INT;
DECLARE @Ordini dbo.OrdiniDaAggiornare;

-- Popola la variabile con dati di test
INSERT INTO @Ordini (IdOrdine)
VALUES (1);

-- Esegui la stored procedure con i parametri
EXEC @return_value = dbo.SP_UpdateAutomatico
    @Ordini = @Ordini;


-- Mostra il valore di ritorno della stored procedure
SELECT @return_value AS ReturnValue;
go



ALTER PROCEDURE SP_SelectOrdersToUpdate
AS
BEGIN
SET NOCOUNT ON;
SELECT SO.IdOrdine,O.IdCliente,C.Nome,C.Email,O.DataOrdine,O.Totale, DO.Quantita,P.IdProdotto,P.Descrizione,P.Prezzo,SO.DataPrimoInvio,SO.DataConsegna,SO.Esito From Ordini AS O
JOIN Clienti AS C ON C.IdCliente=O.IdCliente
JOIN DettaglioOrdini As DO On DO.IdOrdine=O.IdOrdine
JOIN StatoOrdini AS SO ON SO.IdOrdine=O.IdOrdine
JOIN Prodotti AS P ON P.IdProdotto=DO.IdProdotto
WHERE SO.Esito=2;
END
GO