CREATE PROCEDURE SP_Ricerca
@IdCliente INT = NULL,
@IdProdotto INT = NULL,
@DataOrdineFrom DATE = NULL,
@DataOrdineTo DATE = NULL,
@DataConsegnaFrom DATE = NULL,
@DataConsegnaTo DATE = NULL,
@Esito INT = NULL,
@TotaleFrom MONEY = NULL,
@TotaleTo MONEY = NULL

AS
BEGIN
SET NOCOUNT ON;

SELECT O.IdOrdine,O.IdCliente,C.Nome,C.Email,O.DataOrdine,O.Totale, DO.Quantita,P.IdProdotto,P.Descrizione,P.Prezzo,SO.DataPrimoInvio,SO.DataConsegna,SO.Esito From [Azienda].[dbo].[Ordini] AS O
JOIN [Azienda].[dbo].[Clienti] AS C ON C.IdCliente=O.IdCliente
JOIN [Azienda].[dbo].[DettaglioOrdini] As DO On DO.IdOrdine=O.IdOrdine
JOIN [Azienda].[dbo].[StatoOrdini] AS SO ON SO.IdOrdine=O.IdOrdine
JOIN [Azienda].[dbo].[Prodotti] AS P ON P.IdProdotto=DO.IdProdotto

WHERE   (@IdCliente IS NULL OR C.IdCliente=@IdCliente)AND
		(@IdProdotto IS NULL OR P.IdProdotto=@IdProdotto)AND
		(@DataOrdineFrom IS NULL OR O.DataOrdine>=@DataOrdineFrom)AND
		(@DataOrdineTo IS NULL OR O.DataOrdine<=@DataOrdineTo)AND
		(@DataConsegnaFrom IS NULL OR SO.DataConsegna>=@DataConsegnaFrom)AND
		(@DataConsegnaTo IS NULL OR SO.DataConsegna<=@DataConsegnaTo)AND
		(@TotaleFrom IS NULL OR O.Totale>=@TotaleFrom)AND
		(@TotaleTo IS NULL OR O.Totale<=@TotaleTo)AND
		(@Esito IS NULL OR SO.Esito=@Esito)

END
GO