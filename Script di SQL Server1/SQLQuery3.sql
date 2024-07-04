SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[TEST_FileWrite]
    @File VARCHAR(2000),
    @Text VARCHAR(2000)
AS
BEGIN
    DECLARE @OLE INT
    DECLARE @FileID INT
    DECLARE @hr INT
    DECLARE @Source VARCHAR(255)
    DECLARE @Description VARCHAR(255)

    BEGIN TRY
        EXECUTE @hr = sp_OACreate 'Scripting.FileSystemObject', @OLE OUT
        IF @hr <> 0
            RAISERROR('sp_OACreate failed', 16, 1)

        EXECUTE @hr = sp_OAMethod @OLE, 'OpenTextFile', @FileID OUT, @File, 8, 1
        IF @hr <> 0
            RAISERROR('sp_OAMethod OpenTextFile failed', 16, 1)

        EXECUTE @hr = sp_OAMethod @FileID, 'WriteLine', NULL, @Text
        IF @hr <> 0
            RAISERROR('sp_OAMethod WriteLine failed', 16, 1)
        
        EXECUTE @hr = sp_OADestroy @FileID
        IF @hr <> 0
            RAISERROR('sp_OADestroy FileID failed', 16, 1)
        
        EXECUTE @hr = sp_OADestroy @OLE
        IF @hr <> 0
            RAISERROR('sp_OADestroy OLE failed', 16, 1)
    END TRY
    BEGIN CATCH
        SELECT
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_SEVERITY() AS ErrorSeverity,
            ERROR_STATE() AS ErrorState,
            ERROR_PROCEDURE() AS ErrorProcedure,
            ERROR_LINE() AS ErrorLine,
            ERROR_MESSAGE() AS ErrorMessage;

        -- Get the OLE error details
        EXECUTE sp_OAGetErrorInfo @OLE, @Source OUT, @Description OUT
        PRINT 'OLE Error Source: ' + @Source
        PRINT 'OLE Error Description: ' + @Description

        -- Clean up OLE objects if they are still active
        IF @FileID IS NOT NULL
            EXECUTE sp_OADestroy @FileID
        IF @OLE IS NOT NULL
            EXECUTE sp_OADestroy @OLE
    END CATCH
END
GO