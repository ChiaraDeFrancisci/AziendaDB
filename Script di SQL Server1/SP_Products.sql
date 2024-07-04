USE Azienda;
GO
--select clienti non parametrica
ALTER PROCEDURE SP_GetAllProducts
AS
BEGIN
	SET NOCOUNT ON;
	SELECT P.IdProdotto, P.Descrizione, P.Prezzo FROM Prodotti As P
	ORDER BY P.Descrizione;
END
GO
--select cliente Id parametro
create PROCEDURE SP_GetProductByID
@IdProdotto INT = 0
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT P.IdProdotto, P.Descrizione, P.Prezzo FROM Prodotti As P
	WHERE P.IdProdotto=@IdProdotto;
END
GO
--update cliente
create PROCEDURE SP_UpdateProductByID
@IdProdotto INT = 0,
@Descrizione VARCHAR(100)=NULL,
@Prezzo MONEY = 0
AS
BEGIN
	SET NOCOUNT ON;
	
	UPDATE Prodotti
	SET Descrizione=@Descrizione,Prezzo=@Prezzo
	WHERE IdProdotto=@IdProdotto;
END
GO
--insert cliente
Create PROCEDURE SP_InsertProduct
@Descrizione VARCHAR(100)=NULL,
@Prezzo MONEY = 0
AS
BEGIN
	SET NOCOUNT ON;
	
	INSERT INTO Prodotti (Descrizione, Prezzo)
	VALUES  (@Descrizione, @Prezzo);
END
GO
--delete cliente by id
Create PROCEDURE SP_DeleteProductByID
@IdProdotto INT = 0
AS
BEGIN
	SET NOCOUNT ON;
	DELETE FROM DettaglioOrdini 
	WHERE IdProdotto=@IdProdotto;
	DELETE FROM Prodotti
	WHERE IdProdotto=@IdProdotto;	
END
GO