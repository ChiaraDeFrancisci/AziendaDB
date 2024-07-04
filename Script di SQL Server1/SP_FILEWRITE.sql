USE [Azienda];
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[TEST_FileWrite]
	@File VARCHAR(2000),
	@Text VARCHAR(2000)
AS
BEGIN
	DECLARE @OLE INT
	DECLARE @FileID INT

	EXECUTE sp_OACreate 'Scripting.FileSystemObject', @OLE OUT

	EXECUTE sp_OAMethod @OLE, 'OpenTextFile', @FileID OUT, @File, 8, 1
	EXECUTE sp_OAMethod @FileID, 'WriteLine', NULL, @Text

	EXECUTE sp_OADestroy @FileID
	EXECUTE sp_OADestroy @OLE

END