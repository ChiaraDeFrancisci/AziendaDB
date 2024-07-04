USE Azienda;
GO
--select clienti non parametrica
Alter PROCEDURE SP_GetAllClients
AS
BEGIN
	SET NOCOUNT ON;
	SELECT C.IdCliente,C.Nome,C.Email FROM Clienti AS C
	Order by C.Nome;
END
GO
--select cliente Id parametro
create PROCEDURE SP_GetClientByID
@IdCliente INT = 0
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT C.IdCliente,C.Nome,C.Email FROM Clienti AS C
	WHERE C.IdCliente=@IdCliente;
END
GO
--update cliente
--drop procedure SP_UpdateClientByID;
--go
create PROCEDURE SP_UpdateClientByID
@IdCliente INT = 0,
@Nome VARCHAR(100)=NULL,
@Email VARCHAR(100)=NULL
AS
BEGIN
	UPDATE Clienti
	SET Nome=@Nome,Email=@Email
	WHERE IdCliente=@IdCliente;
END
GO
--insert cliente
Create PROCEDURE SP_InsertClient
@Nome VARCHAR(100)=NULL,
@Email VARCHAR(100)=NULL
AS
BEGIN
	SET NOCOUNT ON;
	
	INSERT INTO Clienti (Nome, Email)
	VALUES  (@Nome, @Email);
END
GO
--delete cliente by id
Create PROCEDURE SP_DeleteClientByID
@IdCliente INT = 0
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @IdOrdine INT = (SELECT O.IdOrdine FROM Ordini AS O
						WHERE O.IdCliente=@IdCliente);
	
	DELETE FROM StatoOrdini 
	WHERE IdOrdine=@IdOrdine;
	DELETE FROM DettaglioOrdini 
	WHERE IdOrdine=@IdOrdine;
	DELETE FROM Ordini 
	WHERE IdOrdine=@IdOrdine;
	DELETE FROM Clienti 
	WHERE IdCliente=@IdCliente;	
END
GO