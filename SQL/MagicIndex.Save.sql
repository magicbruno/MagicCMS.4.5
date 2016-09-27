DECLARE	@RMT_Contenuti_Id INT,
		@RMT_Title NVARCHAR(1000),
		@RMT_LangId NVARCHAR(5),
		@RMT_PK INT
SET @RMT_Contenuti_Id = 200
SET @RMT_LangId = N'en'
SET @RMT_PK = 1
SET @RMT_Title = N'pastellino-was-born-in-eboli'
BEGIN TRY
	IF EXISTS (SELECT
			1
		FROM REL_MagicTitle
		WHERE RMT_Title = @RMT_Title AND RMT_LangId = @RMT_LangId AND @RMT_Contenuti_Id <> RMT_Contenuti_Id)
	BEGIN
		SET @RMT_Title = CONVERT(NVARCHAR(10), @RMT_Contenuti_Id) + '/' + @RMT_Title
	END
	BEGIN TRANSACTION
		UPDATE REL_MagicTitle
		SET RMT_Title = @RMT_Title
		WHERE RMT_Contenuti_Id = @RMT_Contenuti_Id
		AND RMT_LangId = @RMT_LangId;
		IF @@rowcount = 0
		BEGIN
			INSERT REL_MagicTitle (RMT_Contenuti_Id, RMT_Title, RMT_LangId)
				VALUES (@RMT_Contenuti_Id, @RMT_Title, @RMT_LangId);
			SET @RMT_PK = SCOPE_IDENTITY()
		END
	COMMIT TRANSACTION
	SELECT @RMT_PK
END TRY
BEGIN CATCH
	SELECT -ERROR_STATE()
	IF XACT_STATE() <> 0
	BEGIN
		ROLLBACK TRANSACTION
	END
END CATCH;