DECLARE	@child_PK INT = 0,
		@parentFrom_Pk INT = 0,
		@parentTo_PK INT = 1000;
DELETE FROM REL_contenuti_Argomenti
WHERE Id_Argomenti = @parentTo_PK;

DECLARE children CURSOR FAST_FORWARD READ_ONLY LOCAL FOR
SELECT
	rca.Id_Contenuti
FROM REL_contenuti_Argomenti rca
WHERE rca.Id_Argomenti = @parentFrom_Pk;

OPEN children;

FETCH NEXT FROM children INTO @child_PK;
IF @@fetch_status = 0  BEGIN  
	PRINT @child_PK;
	INSERT REL_contenuti_Argomenti (Id_Contenuti, Id_Argomenti)
		VALUES (@child_PK, @parentTo_PK);
	
END


WHILE @@fetch_status = 0
BEGIN
	PRINT @@fetch_status;
	FETCH NEXT FROM children INTO @child_PK;
	IF @@fetch_status = 0 BEGIN  
		INSERT REL_contenuti_Argomenti (Id_Contenuti, Id_Argomenti)
			VALUES (@child_PK, @parentTo_PK);
		PRINT @child_PK;  	
	END
	
END;

CLOSE children;
DEALLOCATE children;