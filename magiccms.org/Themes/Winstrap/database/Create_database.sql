:SETVAR DbName MagicCMS
:SETVAR DbDataPath "N'c:\Program Files\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER_R2\MSSQL\DATA\MagicCMS.mdf'"
:SETVAR DbLogPath "N'c:\Program Files\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER_R2\MSSQL\DATA\MagicCMS_log.ldf'"
:SETVAR AdminEmail "N'bruno@magicbusmultimedia.it'"

USE [master]
GO
/****** Object:  Database [$(DbName)]    Script Date: 07/04/2015 08:14:34 ******/
CREATE DATABASE [$(DbName)] ON  PRIMARY 
( NAME = [$(DbName)], FILENAME = $(DbDataPath) , SIZE = 30MB , MAXSIZE = 2048MB, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = [$(DbName)_log], FILENAME = $(DbLogPath) , SIZE = 30 MB , MAXSIZE = 2048MB , FILEGROWTH = 10%)
GO
ALTER DATABASE [$(DbName)] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
BEGIN
	EXEC [$(DbName)].[dbo].[sp_fulltext_database] @action = 'enable'
END
GO
ALTER DATABASE [$(DbName)] SET ANSI_NULL_DEFAULT OFF
GO
ALTER DATABASE [$(DbName)] SET ANSI_NULLS OFF
GO
ALTER DATABASE [$(DbName)] SET ANSI_PADDING OFF
GO
ALTER DATABASE [$(DbName)] SET ANSI_WARNINGS OFF
GO
ALTER DATABASE [$(DbName)] SET ARITHABORT OFF
GO
ALTER DATABASE [$(DbName)] SET AUTO_CLOSE OFF
GO
ALTER DATABASE [$(DbName)] SET AUTO_CREATE_STATISTICS ON
GO
ALTER DATABASE [$(DbName)] SET AUTO_SHRINK OFF
GO
ALTER DATABASE [$(DbName)] SET AUTO_UPDATE_STATISTICS ON
GO
ALTER DATABASE [$(DbName)] SET CURSOR_CLOSE_ON_COMMIT OFF
GO
ALTER DATABASE [$(DbName)] SET CURSOR_DEFAULT GLOBAL
GO
ALTER DATABASE [$(DbName)] SET CONCAT_NULL_YIELDS_NULL OFF
GO
ALTER DATABASE [$(DbName)] SET NUMERIC_ROUNDABORT OFF
GO
ALTER DATABASE [$(DbName)] SET QUOTED_IDENTIFIER OFF
GO
ALTER DATABASE [$(DbName)] SET RECURSIVE_TRIGGERS OFF
GO
ALTER DATABASE [$(DbName)] SET DISABLE_BROKER
GO
ALTER DATABASE [$(DbName)] SET AUTO_UPDATE_STATISTICS_ASYNC OFF
GO
ALTER DATABASE [$(DbName)] SET DATE_CORRELATION_OPTIMIZATION OFF
GO
ALTER DATABASE [$(DbName)] SET TRUSTWORTHY OFF
GO
ALTER DATABASE [$(DbName)] SET ALLOW_SNAPSHOT_ISOLATION OFF
GO
ALTER DATABASE [$(DbName)] SET PARAMETERIZATION SIMPLE
GO
ALTER DATABASE [$(DbName)] SET READ_COMMITTED_SNAPSHOT OFF
GO
ALTER DATABASE [$(DbName)] SET HONOR_BROKER_PRIORITY OFF
GO
ALTER DATABASE [$(DbName)] SET RECOVERY SIMPLE
GO
ALTER DATABASE [$(DbName)] SET MULTI_USER
GO
ALTER DATABASE [$(DbName)] SET PAGE_VERIFY CHECKSUM
GO
ALTER DATABASE [$(DbName)] SET DB_CHAINING OFF
GO
USE [$(DbName)]
GO
/****** Object:  User [magicAdmin]    Script Date: 07/04/2015 08:14:34 ******/
CREATE USER [magicAdmin] FOR LOGIN [magicAdmin] WITH DEFAULT_SCHEMA = [dbo]
GO
sys.sp_addrolemember @rolename = N'db_owner', @membername = N'magicAdmin'
GO
/****** Object:  UserDefinedFunction [dbo].[FN_GET_NEWS_ELENCO_TAG]    Script Date: 07/04/2015 08:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Bruno Migliaretti
-- Create date: 21/07/2011
-- Description:	Elenco separato da virgole dei tag
--				a cui è associata una notizia
-- =============================================
CREATE FUNCTION [dbo].[FN_GET_NEWS_ELENCO_TAG] (@ID INT = 0)
RETURNS VARCHAR(4000)
AS
BEGIN
	-- Declare the return variable here
	DECLARE	@ResultValue VARCHAR(4000),
			@Tag VARCHAR(256),
			@Flag BIT

	SET @ResultValue = ''
	SET @Flag = 0

	DECLARE NEWS CURSOR FOR
	SELECT
		Titolo
	FROM REL_contenuti_Argomenti
	INNER JOIN MB_contenuti
		ON Id_Argomenti = MB_contenuti.Id
	WHERE Id_Contenuti = @ID


	OPEN NEWS
	FETCH NEXT FROM NEWS
	INTO @Tag

	WHILE @@fetch_status = 0
	BEGIN
		IF @Flag = 1
		BEGIN
			SET @ResultValue = @ResultValue + ','
		END
		SET @ResultValue = @ResultValue + @Tag
		FETCH NEXT FROM NEWS
		INTO @Tag
		SET @Flag = 1
	END

	CLOSE NEWS
	DEALLOCATE NEWS
	RETURN @ResultValue

END

GO
/****** Object:  Table [dbo].[_LOG_ANA_AZIONI]    Script Date: 07/04/2015 08:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[_LOG_ANA_AZIONI] (
	[act_PK] [INT] NOT NULL,
	[act_COMMAND] [VARCHAR](20) NULL,
	CONSTRAINT [PK__LOG_ANA_AZIONI] PRIMARY KEY CLUSTERED
	(
	[act_PK] ASC
	) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[_LOG_REGISTRY]    Script Date: 07/04/2015 08:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[_LOG_REGISTRY] (
	[reg_PK] [INT] IDENTITY (1, 1) NOT NULL,
	[reg_TABELLA] [VARCHAR](50) NULL,
	[reg_RECORD_PK] [INT] NULL,
	[reg_act_PK] [INT] NULL,
	[reg_user_PK] [INT] NULL,
	[reg_ERROR] [VARCHAR](256) NULL,
	[reg_TIMESTAMP] [DATETIME] NOT NULL,
	[reg_fileName] [NVARCHAR](1000) NULL,
	[reg_methodName] [NVARCHAR](1000) NULL,
	CONSTRAINT [PK__LOG_REGISTRY] PRIMARY KEY CLUSTERED
	(
	[reg_PK] ASC
	) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ANA_CONT_TYPE]    Script Date: 07/04/2015 08:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ANA_CONT_TYPE] (
	[TYP_PK] [INT] IDENTITY (1, 1) NOT NULL,
	[TYP_NAME] [NVARCHAR](255) NOT NULL,
	[TYP_HELP] [NVARCHAR](MAX) NULL,
	[TYP_ContenutiPreferiti] [NVARCHAR](1000) NULL,
	[TYP_FlagContenitore] [BIT] NOT NULL,
	[TYP_label_Titolo] [NVARCHAR](100) NOT NULL,
	[TYP_label_ExtraInfo] [NVARCHAR](100) NULL,
	[TYP_label_TestoBreve] [NVARCHAR](50) NULL,
	[TYP_label_TestoLungo] [NVARCHAR](50) NULL,
	[TYP_label_url] [NVARCHAR](50) NULL,
	[TYP_label_url_secondaria] [NVARCHAR](50) NULL,
	[TYP_label_scadenza] [NVARCHAR](50) NULL,
	[TYP_label_altezza] [NVARCHAR](50) NULL,
	[TYP_label_larghezza] [NVARCHAR](50) NULL,
	[TYP_label_ExtraInfo_1] [NVARCHAR](50) NULL,
	[TYP_label_ExtraInfo_2] [NVARCHAR](50) NULL,
	[TYP_label_ExtraInfo_3] [NVARCHAR](50) NULL,
	[TYP_label_ExtraInfo_4] [NVARCHAR](50) NULL,
	[TYP_label_ExtraInfo_5] [NVARCHAR](50) NULL,
	[TYP_label_ExtraInfo_6] [NVARCHAR](50) NULL,
	[TYP_label_ExtraInfo_7] [NVARCHAR](50) NULL,
	[TYP_label_ExtraInfo_8] [NVARCHAR](50) NULL,
	[TYP_label_ExtraInfoNumber_1] [NVARCHAR](50) NULL,
	[TYP_label_ExtraInfoNumber_2] [NVARCHAR](50) NULL,
	[TYP_label_ExtraInfoNumber_3] [NVARCHAR](50) NULL,
	[TYP_label_ExtraInfoNumber_4] [NVARCHAR](50) NULL,
	[TYP_label_ExtraInfoNumber_5] [NVARCHAR](50) NULL,
	[TYP_label_ExtraInfoNumber_6] [NVARCHAR](50) NULL,
	[TYP_label_ExtraInfoNumber_7] [NVARCHAR](50) NULL,
	[TYP_label_ExtraInfoNumber_8] [NVARCHAR](50) NULL,
	[TYP_flag_cercaServer] [BIT] NOT NULL,
	[TYP_DataUltimaModifica] [SMALLDATETIME] NULL,
	[TYP_Flag_Attivo] [BIT] NOT NULL,
	[TYP_Flag_Cancellazione] [BIT] NOT NULL,
	[TYP_Data_Cancellazione] [SMALLDATETIME] NULL,
	[TYP_flag_breve] [BIT] NOT NULL,
	[TYP_flag_lungo] [BIT] NOT NULL,
	[TYP_flag_link] [BIT] NOT NULL,
	[TYP_flag_urlsecondaria] [BIT] NOT NULL,
	[TYP_flag_scadenza] [BIT] NOT NULL,
	[TYP_flag_specialTag] [BIT] NOT NULL,
	[TYP_flag_tags] [BIT] NOT NULL,
	[TYP_flag_altezza] [BIT] NOT NULL,
	[TYP_flag_larghezza] [BIT] NOT NULL,
	[TYP_flag_ExtraInfo] [BIT] NOT NULL,
	[TYP_flag_ExtraInfo1] [BIT] NOT NULL,
	[TYP_flag_BtnGeolog] [BIT] NOT NULL,
	[TYP_Icon] [NVARCHAR](50) NULL,
	[TYP_MasterPageFile] [NVARCHAR](256) NULL,
	CONSTRAINT [PK_ANA_CONT_TYPE] PRIMARY KEY CLUSTERED
	(
	[TYP_PK] ASC
	) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ANA_Dictionary]    Script Date: 07/04/2015 08:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ANA_Dictionary] (
	[DICT_Pk] [INT] IDENTITY (1, 1) NOT NULL,
	[DICT_Source] [NVARCHAR](1000) NULL,
	[DICT_LANG_Id] [NVARCHAR](5) NULL,
	[DICT_Translation] [NVARCHAR](1000) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ANA_LANGUAGE]    Script Date: 07/04/2015 08:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ANA_LANGUAGE] (
	[LANG_Id] [NVARCHAR](5) NOT NULL,
	[LANG_Name] [NVARCHAR](50) NULL,
	[LANG_Active] [BIT] NOT NULL,
	[LANG_AutoHide] [BIT] NOT NULL,
	PRIMARY KEY CLUSTERED
	(
	[LANG_Id] ASC
	) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ANA_PREROGATIVE]    Script Date: 07/04/2015 08:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ANA_PREROGATIVE] (
	[pre_PK] [INT] NOT NULL,
	[pre_PREROGATIVA] [VARCHAR](20) NULL,
	[pre_LAST_MODIFIED] [DATETIME] NULL,
	CONSTRAINT [PK_ANA_PREROGATIVE] PRIMARY KEY CLUSTERED
	(
	[pre_PK] ASC
	) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ANA_TRANSLATION]    Script Date: 07/04/2015 08:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ANA_TRANSLATION] (
	[TRAN_Pk] [INT] IDENTITY (1, 1) NOT NULL,
	[TRAN_LANG_Id] [NVARCHAR](5) NOT NULL,
	[TRAN_Title] [NVARCHAR](1000) NULL,
	[TRAN_TestoBreve] [NVARCHAR](MAX) NULL,
	[TRAN_TestoLungo] [NVARCHAR](MAX) NULL,
	[TRAN_Tags] [NVARCHAR](4000) NULL,
	[TRAN_MB_contenuti_Id] [INT] NOT NULL,
	PRIMARY KEY CLUSTERED
	(
	[TRAN_Pk] ASC
	) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ANA_USR]    Script Date: 07/04/2015 08:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ANA_USR] (
	[usr_PK] [INT] IDENTITY (1, 1) NOT NULL,
	[usr_EMAIL] [VARCHAR](254) NULL,
	[usr_NAME] [NVARCHAR](254) NULL,
	[usr_PASSWORD] [NVARCHAR](200) NULL,
	[usr_LEVEL] [INT] NOT NULL,
	[usr_LAST_MODIFIED] [DATETIME] NULL,
	[usr_PROFILE_PK] [INT] NOT NULL,
	[usr_ACTIVE] [BIT] NOT NULL,
	CONSTRAINT [PK_ANA_USR] PRIMARY KEY CLUSTERED
	(
	[usr_PK] ASC
	) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CONFIG]    Script Date: 07/04/2015 08:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CONFIG] (
	[CON_PK] [INT] NOT NULL,
	[CON_SinglePage] [BIT] NOT NULL,
	[CON_MultiPage] [BIT] NOT NULL,
	[CON_TRANS_Auto] [BIT] NOT NULL,
	[CON_TRANS_Id] [NVARCHAR](500) NULL,
	[CON_TRANS_SecretKey] [NVARCHAR](500) NULL,
	[CON_TRANS_SourceLangId] [NVARCHAR](10) NOT NULL,
	[CON_TransSourceLangName] [NVARCHAR](50) NULL,
	[CON_ThemePath] [NVARCHAR](256) NULL,
	[CON_DefaultContentMaster] [NVARCHAR](256) NULL,
	[CON_ImagesPath] [NVARCHAR](256) NULL,
	[CON_DefaultImage] [NVARCHAR](256) NULL,
	[CON_SMTP_Server] [NVARCHAR](256) NULL,
	[CON_SMTP_Username] [NVARCHAR](100) NULL,
	[CON_SMTP_Password] [NVARCHAR](100) NULL,
	[CON_SMTP_DefaultFromMail] [NVARCHAR](256) NULL,
	[CON_SMTP_AdminMail] [NVARCHAR](256) NULL,
	[CON_ga_Property_ID] [NVARCHAR](20) NULL,
	[CON_NAV_StartPage] [INT] NOT NULL,
	[CON_NAV_MainMenu] [INT] NOT NULL,
	[CON_NAV_SecondaryMenu] [INT] NOT NULL,
	[CON_NAV_FooterMenu] [INT] NOT NULL,
	[CON_SiteName] [NVARCHAR](256) NOT NULL,
	PRIMARY KEY CLUSTERED
	(
	[CON_PK] ASC
	) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[IMG_MINIATURE]    Script Date: 07/04/2015 08:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IMG_MINIATURE] (
	[IMG_MIN_PK] [INT] IDENTITY (1, 1) NOT NULL,
	[IMG_MIN_OPATH] [NVARCHAR](1000) NULL,
	[IMG_MIN_BIN] [VARBINARY](MAX) NULL,
	[IMG_MIN_HEIGHT] [INT] NOT NULL,
	[IMG_MIN_WIDTH] [INT] NOT NULL,
	[IMG_MIN_ODATE_TICKS] [BIGINT] NOT NULL,
	CONSTRAINT [PK_IMG_MINIATURE] PRIMARY KEY CLUSTERED
	(
	[IMG_MIN_PK] ASC
	) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MB_contenuti]    Script Date: 07/04/2015 08:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MB_contenuti] (
	[Id] [INT] IDENTITY (1, 1) NOT NULL,
	[Titolo] [NVARCHAR](1000) NULL,
	[Sottotitolo] [NVARCHAR](1000) NULL,
	[Abstract] [NVARCHAR](MAX) NULL,
	[Autore] [NVARCHAR](1000) NULL,
	[Banner] [NVARCHAR](MAX) NULL,
	[Link] [NVARCHAR](1000) NULL,
	[Larghezza] [INT] NOT NULL,
	[Altezza] [INT] NOT NULL,
	[Tipo] [INT] NULL,
	[Contenuto_parent] [INT] NOT NULL,
	[Propietario] [INT] NULL,
	[DataPubblicazione] [SMALLDATETIME] NULL,
	[DataScadenza] [SMALLDATETIME] NULL,
	[DataUltimaModifica] [SMALLDATETIME] NULL,
	[Flag_Attivo] [BIT] NOT NULL,
	[Flag_Cancellazione] [BIT] NOT NULL,
	[Data_Cancellazione] [SMALLDATETIME] NULL,
	[ExtraInfo1] [NVARCHAR](1000) NULL,
	[ExtraInfo4] [NVARCHAR](1000) NULL,
	[ExtraInfo3] [NVARCHAR](1000) NULL,
	[ExtraInfo2] [NVARCHAR](1000) NULL,
	[ExtraInfo5] [NVARCHAR](1000) NULL,
	[ExtraInfo6] [NVARCHAR](1000) NULL,
	[ExtraInfo7] [NVARCHAR](1000) NULL,
	[ExtraInfo8] [NVARCHAR](1000) NULL,
	[ExtraInfoNumber1] [NUMERIC](38, 2) NOT NULL,
	[ExtraInfoNumber2] [NUMERIC](38, 2) NOT NULL,
	[ExtraInfoNumber3] [NUMERIC](38, 2) NOT NULL,
	[ExtraInfoNumber4] [NUMERIC](38, 2) NOT NULL,
	[ExtraInfoNumber5] [NUMERIC](38, 2) NOT NULL,
	[ExtraInfoNumber6] [NUMERIC](38, 2) NOT NULL,
	[ExtraInfoNumber7] [NUMERIC](38, 2) NOT NULL,
	[ExtraInfoNumber8] [NUMERIC](38, 2) NOT NULL,
	[Tags] [NVARCHAR](4000) NULL,
	CONSTRAINT [PK_MB_CONTENUTI] PRIMARY KEY CLUSTERED
	(
	[Id] ASC
	) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[REL_contenuti_Argomenti]    Script Date: 07/04/2015 08:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[REL_contenuti_Argomenti] (
	[Id] [INT] IDENTITY (1, 1) NOT NULL,
	[Id_Contenuti] [INT] NOT NULL,
	[Id_Argomenti] [INT] NOT NULL,
	CONSTRAINT [PK_REL_contenuti_Argomenti] PRIMARY KEY CLUSTERED
	(
	[Id] ASC
	) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
	CONSTRAINT [IX_REL_contenuti_Argomenti] UNIQUE NONCLUSTERED
	(
	[Id_Contenuti] ASC,
	[Id_Argomenti] ASC
	) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[REL_INDIRIZZI_SPEDIZIONI]    Script Date: 07/04/2015 08:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[REL_INDIRIZZI_SPEDIZIONI] (
	[RIS_MLIST_PK] [UNIQUEIDENTIFIER] NOT NULL,
	[RIS_SPED_PK] [INT] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[REL_KEYWORDS]    Script Date: 07/04/2015 08:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[REL_KEYWORDS] (
	[key_content_PK] [INT] NOT NULL,
	[key_keyword] [NVARCHAR](1024) NULL,
	[key_langId] [NVARCHAR](5) NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[REL_MESSAGE_REPL_MESSAGE]    Script Date: 07/04/2015 08:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[REL_MESSAGE_REPL_MESSAGE] (
	[REL_REPL_PK] [INT] IDENTITY (1, 1) NOT NULL,
	[REL_REPL_MESSAGE_PK] [INT] NOT NULL,
	[REL_REPL_MESSAGE_REPLTO_PK] [INT] NOT NULL,
	CONSTRAINT [PK_REL_MESSAGE_REPL_MESSAGE] PRIMARY KEY CLUSTERED
	(
	[REL_REPL_PK] ASC
	) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[REL_MESSAGE_USER_TO]    Script Date: 07/04/2015 08:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[REL_MESSAGE_USER_TO] (
	[REL_TOMSG_PK] [INT] IDENTITY (1, 1) NOT NULL,
	[REL_TOMSG_MESSAGE_PK] [INT] NOT NULL,
	[REL_TOMSG_USER_PK] [INT] NOT NULL,
	CONSTRAINT [PK_REL_MESSAGE_USER_TO] PRIMARY KEY CLUSTERED
	(
	[REL_TOMSG_PK] ASC
	) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[REL_NEWS_SPEDIZIONI]    Script Date: 07/04/2015 08:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[REL_NEWS_SPEDIZIONI] (
	[RNS_NEWS_PK] [INT] NULL,
	[RNS_SPED_PK] [INT] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[STAT_CLICKS]    Script Date: 07/04/2015 08:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[STAT_CLICKS] (
	[STAT_CLICKS_PK] [INT] IDENTITY (1, 1) NOT NULL,
	[STAT_CLICKS_SHOP] [INT] NOT NULL,
	[STAT_CLICKS_TARGET] [INT] NOT NULL,
	[STAT_CLICKS_CAT] [INT] NOT NULL,
	[STAT_CLICKS_URL] [NVARCHAR](2000) NULL,
	[STAT_CLICKS_DATE] [DATETIME] NOT NULL,
	[STAT_CLICKS_USER_AGENT] [VARCHAR](512) NULL,
	[STAT_CLICKS_REMOTE_ADDRESS] [VARCHAR](15) NULL,
	[STAT_CLICKS_INTERNAL_LINK] [BIT] NOT NULL,
	CONSTRAINT [PK_STAT_CLICKS] PRIMARY KEY CLUSTERED
	(
	[STAT_CLICKS_PK] ASC
	) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[STAT_USER]    Script Date: 07/04/2015 08:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[STAT_USER] (
	[STAT_USER_PK] [INT] NOT NULL,
	[STAT_USER_LOGON] [VARCHAR](20) NOT NULL,
	[STAT_USER_EMAIL] [VARCHAR](256) NULL,
	[STAT_USER_PASSWORD] [VARCHAR](20) NULL,
	CONSTRAINT [PK_STAT_USER] PRIMARY KEY CLUSTERED
	(
	[STAT_USER_PK] ASC
	) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[T_ANA_MAILING_LIST]    Script Date: 07/04/2015 08:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_ANA_MAILING_LIST] (
	[MLIST_PK] [UNIQUEIDENTIFIER] NOT NULL,
	[MLIST_Address] [NVARCHAR](256) NULL,
	[MLIST_DataInserimento] [DATETIME] NULL,
	[MLIST_FlagCancellazione] [BIT] NULL,
	[MLIST_DataCancellazione] [DATETIME] NULL,
	[MLIST_DataRipristino] [DATETIME] NULL,
	CONSTRAINT [PK_T_ANA_MAILING_LIST] PRIMARY KEY CLUSTERED
	(
	[MLIST_PK] ASC
	) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[T_SPEDIZIONI_NL]    Script Date: 07/04/2015 08:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_SPEDIZIONI_NL] (
	[SPED_PK] [INT] IDENTITY (1, 1) NOT NULL,
	[SPED_DATA] [SMALLDATETIME] NULL,
	CONSTRAINT [PK_T_SPEDIZIONI_NL] PRIMARY KEY CLUSTERED
	(
	[SPED_PK] ASC
	) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[VOTI]    Script Date: 07/04/2015 08:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[VOTI] (
	[Voti_PK] [INT] IDENTITY (1, 1) NOT NULL,
	[Voti_USER] [VARCHAR](250) NULL,
	[Voti_POST_PK] [INT] NULL,
	[Voti_VOTO] [INT] NULL,
	[Voti_LastModify] [DATETIME] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  View [dbo].[vw_ANA_CONT_TYPE_ACTIVE]    Script Date: 07/04/2015 08:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_ANA_CONT_TYPE_ACTIVE]
AS
SELECT
	*
FROM dbo.ANA_CONT_TYPE
WHERE [TYP_Flag_Cancellazione] = 0

GO
/****** Object:  View [dbo].[VW_ANA_TRANSLATION]    Script Date: 07/04/2015 08:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_ANA_TRANSLATION]
AS
SELECT
	*
FROM ANA_TRANSLATION at
INNER JOIN ANA_LANGUAGE
	ON at.TRAN_LANG_Id = LANG_Id

GO
/****** Object:  View [dbo].[VW_ANA_TRANSLATION_BLANK]    Script Date: 07/04/2015 08:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_ANA_TRANSLATION_BLANK]
AS
SELECT
	at.TRAN_Pk,
	at.TRAN_Title,
	at.TRAN_TestoBreve,
	at.TRAN_TestoLungo,
	at.TRAN_MB_contenuti_Id,
	al.LANG_Name,
	al.LANG_Active
FROM dbo.ANA_TRANSLATION AS at
FULL OUTER JOIN dbo.ANA_LANGUAGE AS al
	ON al.LANG_Id = at.TRAN_LANG_Id
WHERE (al.LANG_Active = 1)

GO
/****** Object:  View [dbo].[VW_LOG_REGISTRY]    Script Date: 07/04/2015 08:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_LOG_REGISTRY]
AS
SELECT
	lr.reg_PK,
	lr.reg_TABELLA,
	lr.reg_RECORD_PK,
	lr.reg_act_PK,
	lr.reg_user_PK,
	lr.reg_ERROR,
	lr.reg_TIMESTAMP,
	lr.reg_fileName,
	lr.reg_methodName,
	au.usr_EMAIL AS usr_EMAIL
FROM _LOG_REGISTRY lr
INNER JOIN ANA_USR au
	ON lr.reg_user_PK = au.usr_PK

GO
/****** Object:  View [dbo].[VW_MB_contenuti_attivi]    Script Date: 07/04/2015 08:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_MB_contenuti_attivi]
AS
SELECT DISTINCT
	mc.Id,
	mc.Titolo,
	mc.Sottotitolo,
	mc.Abstract,
	mc.Autore,
	mc.Banner,
	mc.Link,
	mc.Larghezza,
	mc.Altezza,
	mc.Tipo,
	mc.Contenuto_parent,
	mc.Propietario,
	mc.DataPubblicazione,
	mc.DataScadenza,
	mc.DataUltimaModifica,
	mc.Flag_Attivo,
	mc.Flag_Cancellazione,
	mc.Data_Cancellazione,
	mc.ExtraInfo1,
	mc.ExtraInfo4,
	mc.ExtraInfo3,
	mc.ExtraInfo2,
	mc.ExtraInfo5,
	mc.ExtraInfo6,
	mc.ExtraInfo7,
	mc.ExtraInfo8,
	mc.ExtraInfoNumber1,
	mc.ExtraInfoNumber2,
	mc.ExtraInfoNumber3,
	mc.ExtraInfoNumber4,
	mc.ExtraInfoNumber5,
	mc.ExtraInfoNumber6,
	mc.ExtraInfoNumber7,
	mc.ExtraInfoNumber8,
	mc.Tags,
	rca.Id_Argomenti
FROM MB_contenuti mc
LEFT JOIN REL_contenuti_Argomenti rca
	ON mc.Id = rca.Id_Contenuti
WHERE (Flag_Cancellazione = 0)

GO
/****** Object:  View [dbo].[VW_MB_ContenutiSibling]    Script Date: 07/04/2015 08:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_MB_ContenutiSibling]
AS
SELECT DISTINCT
	dbo.REL_contenuti_Argomenti.Id_Contenuti,
	MB_contenuti_1.Titolo AS VA_titolo,
	REL_contenuti_Argomenti_1.Id_Contenuti AS VA_id,
	REL_contenuti_Argomenti_1.Id_Argomenti,
	MB_contenuti_1.DataPubblicazione,
	MB_contenuti_1.Tipo AS VA_Tipo
FROM dbo.REL_contenuti_Argomenti AS REL_contenuti_Argomenti_1
INNER JOIN dbo.REL_contenuti_Argomenti
	ON REL_contenuti_Argomenti_1.Id_Argomenti = dbo.REL_contenuti_Argomenti.Id_Argomenti
INNER JOIN dbo.MB_contenuti AS MB_contenuti_1
	ON REL_contenuti_Argomenti_1.Id_Contenuti = MB_contenuti_1.Id
INNER JOIN dbo.ANA_CONT_TYPE
	ON MB_contenuti_1.Tipo = dbo.ANA_CONT_TYPE.TYP_PK
WHERE (dbo.ANA_CONT_TYPE.TYP_FlagContenitore = 0)
OR (MB_contenuti_1.Tipo = 29)

GO
/****** Object:  View [dbo].[VW_NEWS_NEWSLETTER]    Script Date: 07/04/2015 08:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_NEWS_NEWSLETTER]
AS
SELECT TOP (100) PERCENT
	dbo.MB_contenuti.Id,
	dbo.MB_contenuti.Titolo,
	dbo.MB_contenuti.Abstract,
	dbo.MB_contenuti.Banner,
	dbo.MB_contenuti.Tipo,
	dbo.MB_contenuti.Contenuto_parent,
	dbo.MB_contenuti.DataPubblicazione,
	dbo.MB_contenuti.DataScadenza
FROM dbo.MB_contenuti
INNER JOIN dbo.REL_contenuti_Argomenti
	ON dbo.MB_contenuti.Id = dbo.REL_contenuti_Argomenti.Id_Contenuti
INNER JOIN dbo.MB_contenuti AS MB_contenuti_1
	ON dbo.REL_contenuti_Argomenti.Id_Argomenti = MB_contenuti_1.Id
WHERE (MB_contenuti_1.Titolo = N'Newsletter')
AND (dbo.MB_contenuti.DataScadenza > GETDATE())
AND (dbo.MB_contenuti.Flag_Cancellazione = 0)
OR (MB_contenuti_1.Titolo = N'Newsletter')
AND (dbo.MB_contenuti.DataScadenza IS NULL)
AND (dbo.MB_contenuti.Flag_Cancellazione = 0)
ORDER BY dbo.MB_contenuti.DataPubblicazione DESC

GO
ALTER TABLE [dbo].[_LOG_REGISTRY] ADD DEFAULT (GETDATE()) FOR [reg_TIMESTAMP]
GO
ALTER TABLE [dbo].[ANA_CONT_TYPE] ADD DEFAULT ('New content type') FOR [TYP_NAME]
GO
ALTER TABLE [dbo].[ANA_CONT_TYPE] ADD DEFAULT ((0)) FOR [TYP_FlagContenitore]
GO
ALTER TABLE [dbo].[ANA_CONT_TYPE] ADD DEFAULT ('Nome') FOR [TYP_label_Titolo]
GO
ALTER TABLE [dbo].[ANA_CONT_TYPE] ADD DEFAULT ('Testo breve') FOR [TYP_label_TestoBreve]
GO
ALTER TABLE [dbo].[ANA_CONT_TYPE] ADD DEFAULT ('Testo completo') FOR [TYP_label_TestoLungo]
GO
ALTER TABLE [dbo].[ANA_CONT_TYPE] ADD DEFAULT ('Url principale') FOR [TYP_label_url]
GO
ALTER TABLE [dbo].[ANA_CONT_TYPE] ADD DEFAULT ('Ulr secondaria') FOR [TYP_label_url_secondaria]
GO
ALTER TABLE [dbo].[ANA_CONT_TYPE] ADD DEFAULT ('Scadenza') FOR [TYP_label_scadenza]
GO
ALTER TABLE [dbo].[ANA_CONT_TYPE] ADD DEFAULT ('Altezza') FOR [TYP_label_altezza]
GO
ALTER TABLE [dbo].[ANA_CONT_TYPE] ADD DEFAULT ('Larghezza') FOR [TYP_label_larghezza]
GO
ALTER TABLE [dbo].[ANA_CONT_TYPE] ADD DEFAULT ((0)) FOR [TYP_flag_cercaServer]
GO
ALTER TABLE [dbo].[ANA_CONT_TYPE] ADD DEFAULT (GETDATE()) FOR [TYP_DataUltimaModifica]
GO
ALTER TABLE [dbo].[ANA_CONT_TYPE] ADD DEFAULT ((1)) FOR [TYP_Flag_Attivo]
GO
ALTER TABLE [dbo].[ANA_CONT_TYPE] ADD DEFAULT ((0)) FOR [TYP_Flag_Cancellazione]
GO
ALTER TABLE [dbo].[ANA_CONT_TYPE] ADD DEFAULT ((1)) FOR [TYP_flag_breve]
GO
ALTER TABLE [dbo].[ANA_CONT_TYPE] ADD DEFAULT ((1)) FOR [TYP_flag_lungo]
GO
ALTER TABLE [dbo].[ANA_CONT_TYPE] ADD DEFAULT ((1)) FOR [TYP_flag_link]
GO
ALTER TABLE [dbo].[ANA_CONT_TYPE] ADD DEFAULT ((1)) FOR [TYP_flag_urlsecondaria]
GO
ALTER TABLE [dbo].[ANA_CONT_TYPE] ADD DEFAULT ((0)) FOR [TYP_flag_scadenza]
GO
ALTER TABLE [dbo].[ANA_CONT_TYPE] ADD DEFAULT ((0)) FOR [TYP_flag_specialTag]
GO
ALTER TABLE [dbo].[ANA_CONT_TYPE] ADD DEFAULT ((1)) FOR [TYP_flag_tags]
GO
ALTER TABLE [dbo].[ANA_CONT_TYPE] ADD DEFAULT ((0)) FOR [TYP_flag_altezza]
GO
ALTER TABLE [dbo].[ANA_CONT_TYPE] ADD DEFAULT ((0)) FOR [TYP_flag_larghezza]
GO
ALTER TABLE [dbo].[ANA_CONT_TYPE] ADD DEFAULT ((0)) FOR [TYP_flag_ExtraInfo]
GO
ALTER TABLE [dbo].[ANA_CONT_TYPE] ADD DEFAULT ((0)) FOR [TYP_flag_ExtraInfo1]
GO
ALTER TABLE [dbo].[ANA_CONT_TYPE] ADD DEFAULT ((0)) FOR [TYP_flag_BtnGeolog]
GO
ALTER TABLE [dbo].[ANA_LANGUAGE] ADD DEFAULT ((1)) FOR [LANG_Active]
GO
ALTER TABLE [dbo].[ANA_LANGUAGE] ADD DEFAULT ((0)) FOR [LANG_AutoHide]
GO
ALTER TABLE [dbo].[ANA_PREROGATIVE] ADD CONSTRAINT [DF_ANA_PREROGATIVE_pre_LAST_MODIFIED] DEFAULT (GETDATE()) FOR [pre_LAST_MODIFIED]
GO
ALTER TABLE [dbo].[ANA_USR] ADD CONSTRAINT [DF_ANA_USR_usr_LEVEL] DEFAULT ((0)) FOR [usr_LEVEL]
GO
ALTER TABLE [dbo].[ANA_USR] ADD CONSTRAINT [DF_ANA_USR_usr_LAST_MODIFIED] DEFAULT (GETDATE()) FOR [usr_LAST_MODIFIED]
GO
ALTER TABLE [dbo].[ANA_USR] ADD DEFAULT ((0)) FOR [usr_PROFILE_PK]
GO
ALTER TABLE [dbo].[ANA_USR] ADD DEFAULT ((1)) FOR [usr_ACTIVE]
GO
ALTER TABLE [dbo].[CONFIG] ADD DEFAULT ((0)) FOR [CON_SinglePage]
GO
ALTER TABLE [dbo].[CONFIG] ADD DEFAULT ((1)) FOR [CON_MultiPage]
GO
ALTER TABLE [dbo].[CONFIG] ADD DEFAULT ((1)) FOR [CON_TRANS_Auto]
GO
ALTER TABLE [dbo].[CONFIG] ADD DEFAULT ('it') FOR [CON_TRANS_SourceLangId]
GO
ALTER TABLE [dbo].[CONFIG] ADD DEFAULT ((0)) FOR [CON_NAV_StartPage]
GO
ALTER TABLE [dbo].[CONFIG] ADD DEFAULT ((0)) FOR [CON_NAV_MainMenu]
GO
ALTER TABLE [dbo].[CONFIG] ADD DEFAULT ((0)) FOR [CON_NAV_SecondaryMenu]
GO
ALTER TABLE [dbo].[CONFIG] ADD DEFAULT ((0)) FOR [CON_NAV_FooterMenu]
GO
ALTER TABLE [dbo].[CONFIG] ADD CONSTRAINT [DF_CONFIG_CON_SiteName] DEFAULT (N'MagicCMS Site') FOR [CON_SiteName]
GO
ALTER TABLE [dbo].[IMG_MINIATURE] ADD CONSTRAINT [DF_IMG_MINIATURE_IMG_MIN_HEIGHT] DEFAULT ((0)) FOR [IMG_MIN_HEIGHT]
GO
ALTER TABLE [dbo].[IMG_MINIATURE] ADD CONSTRAINT [DF_IMG_MINIATURE_IMG_MIN_WIDTH] DEFAULT ((0)) FOR [IMG_MIN_WIDTH]
GO
ALTER TABLE [dbo].[IMG_MINIATURE] ADD CONSTRAINT [DF_IMG_MINIATURE_IMG_MIN_ODATE_TICKS] DEFAULT ((0)) FOR [IMG_MIN_ODATE_TICKS]
GO
ALTER TABLE [dbo].[MB_contenuti] ADD CONSTRAINT [DF_MB_contenuti_Larghezza] DEFAULT ((0)) FOR [Larghezza]
GO
ALTER TABLE [dbo].[MB_contenuti] ADD CONSTRAINT [DF_MB_contenuti_Altezza] DEFAULT ((0)) FOR [Altezza]
GO
ALTER TABLE [dbo].[MB_contenuti] ADD CONSTRAINT [DF_MB_contenuti_Contenuto_parent] DEFAULT ((0)) FOR [Contenuto_parent]
GO
ALTER TABLE [dbo].[MB_contenuti] ADD CONSTRAINT [DF_MB_CONTENUTI_Flag_Attivo] DEFAULT ((1)) FOR [Flag_Attivo]
GO
ALTER TABLE [dbo].[MB_contenuti] ADD CONSTRAINT [DF_MB_CONTENUTI_Flag_Cancellazione] DEFAULT ((0)) FOR [Flag_Cancellazione]
GO
ALTER TABLE [dbo].[MB_contenuti] ADD CONSTRAINT [DF_MB_contenuti_ExtraInfoNumber1] DEFAULT ((0)) FOR [ExtraInfoNumber1]
GO
ALTER TABLE [dbo].[MB_contenuti] ADD CONSTRAINT [DF_MB_contenuti_ExtraInfoNumber2] DEFAULT ((0)) FOR [ExtraInfoNumber2]
GO
ALTER TABLE [dbo].[MB_contenuti] ADD CONSTRAINT [DF_MB_contenuti_ExtraInfoNumber3] DEFAULT ((0)) FOR [ExtraInfoNumber3]
GO
ALTER TABLE [dbo].[MB_contenuti] ADD CONSTRAINT [DF_MB_contenuti_ExtraInfoNumber4] DEFAULT ((0)) FOR [ExtraInfoNumber4]
GO
ALTER TABLE [dbo].[MB_contenuti] ADD CONSTRAINT [DF_MB_contenuti_ExtraInfoNumber5] DEFAULT ((0)) FOR [ExtraInfoNumber5]
GO
ALTER TABLE [dbo].[MB_contenuti] ADD CONSTRAINT [DF_MB_contenuti_ExtraInfoNumber6] DEFAULT ((0)) FOR [ExtraInfoNumber6]
GO
ALTER TABLE [dbo].[MB_contenuti] ADD CONSTRAINT [DF_MB_contenuti_ExtraInfoNumber7] DEFAULT ((0)) FOR [ExtraInfoNumber7]
GO
ALTER TABLE [dbo].[MB_contenuti] ADD CONSTRAINT [DF_MB_contenuti_ExtraInfoNumber8] DEFAULT ((0)) FOR [ExtraInfoNumber8]
GO
ALTER TABLE [dbo].[REL_KEYWORDS] ADD DEFAULT ('it') FOR [key_langId]
GO
ALTER TABLE [dbo].[REL_MESSAGE_REPL_MESSAGE] ADD CONSTRAINT [DF_REL_MESSAGE_REPL_MESSAGE_REL_MESSAGE_PK] DEFAULT ((0)) FOR [REL_REPL_MESSAGE_PK]
GO
ALTER TABLE [dbo].[REL_MESSAGE_REPL_MESSAGE] ADD CONSTRAINT [DF_REL_MESSAGE_REPL_MESSAGE_REL_MESSAGE_REPLTO_PK] DEFAULT ((0)) FOR [REL_REPL_MESSAGE_REPLTO_PK]
GO
ALTER TABLE [dbo].[REL_MESSAGE_USER_TO] ADD CONSTRAINT [DF_REL_MESSAGE_USER_TO_REL_TOMSG_MESSAGE_PK] DEFAULT ((0)) FOR [REL_TOMSG_MESSAGE_PK]
GO
ALTER TABLE [dbo].[REL_MESSAGE_USER_TO] ADD CONSTRAINT [DF_REL_MESSAGE_USER_TO_REL_TOMSG_USER_PK] DEFAULT ((0)) FOR [REL_TOMSG_USER_PK]
GO
ALTER TABLE [dbo].[STAT_CLICKS] ADD CONSTRAINT [DF_STAT_CLICKS_STAT_CLICKS_SHOP] DEFAULT ((0)) FOR [STAT_CLICKS_SHOP]
GO
ALTER TABLE [dbo].[STAT_CLICKS] ADD CONSTRAINT [DF_STAT_CLICKS_STAT_CLICKS_TARGET] DEFAULT ((0)) FOR [STAT_CLICKS_TARGET]
GO
ALTER TABLE [dbo].[STAT_CLICKS] ADD CONSTRAINT [DF_STAT_CLICKS_STAT_CLICKS_CAT] DEFAULT ((0)) FOR [STAT_CLICKS_CAT]
GO
ALTER TABLE [dbo].[STAT_CLICKS] ADD CONSTRAINT [DF_STAT_CLICKS_STAT_CLICKS_DATE] DEFAULT (GETDATE()) FOR [STAT_CLICKS_DATE]
GO
ALTER TABLE [dbo].[STAT_CLICKS] ADD CONSTRAINT [DF_STAT_CLICKS_STAT_CLICKS_INTERNAL_LINK] DEFAULT ((0)) FOR [STAT_CLICKS_INTERNAL_LINK]
GO
ALTER TABLE [dbo].[STAT_USER] ADD CONSTRAINT [DF_STAT_USER_STAT_USER_LOGON] DEFAULT (N'Sconosciuto') FOR [STAT_USER_LOGON]
GO
ALTER TABLE [dbo].[T_ANA_MAILING_LIST] ADD CONSTRAINT [DF_T_ANA_MAILING_LIST_MLIST_PK] DEFAULT (NEWID()) FOR [MLIST_PK]
GO
ALTER TABLE [dbo].[T_ANA_MAILING_LIST] ADD CONSTRAINT [DF_T_ANA_MAILING_LIST_MLIST_DataInserimento] DEFAULT (GETDATE()) FOR [MLIST_DataInserimento]
GO
ALTER TABLE [dbo].[T_ANA_MAILING_LIST] ADD CONSTRAINT [DF_T_ANA_MAILING_LIST_MLIST_FlagCancellazione] DEFAULT ((0)) FOR [MLIST_FlagCancellazione]
GO
ALTER TABLE [dbo].[T_SPEDIZIONI_NL] ADD CONSTRAINT [DF_T_SPEDIZIONI_NL_SPED_DATA] DEFAULT (GETDATE()) FOR [SPED_DATA]
GO
ALTER TABLE [dbo].[REL_INDIRIZZI_SPEDIZIONI] WITH CHECK ADD CONSTRAINT [FK_REL_INDIRIZZI_SPEDIZIONI_T_ANA_MAILING_LIST] FOREIGN KEY ([RIS_MLIST_PK])
REFERENCES [dbo].[T_ANA_MAILING_LIST] ([MLIST_PK])
GO
ALTER TABLE [dbo].[REL_INDIRIZZI_SPEDIZIONI] CHECK CONSTRAINT [FK_REL_INDIRIZZI_SPEDIZIONI_T_ANA_MAILING_LIST]
GO
ALTER TABLE [dbo].[REL_INDIRIZZI_SPEDIZIONI] WITH CHECK ADD CONSTRAINT [FK_REL_INDIRIZZI_SPEDIZIONI_T_SPEDIZIONI_NL] FOREIGN KEY ([RIS_SPED_PK])
REFERENCES [dbo].[T_SPEDIZIONI_NL] ([SPED_PK])
GO
ALTER TABLE [dbo].[REL_INDIRIZZI_SPEDIZIONI] CHECK CONSTRAINT [FK_REL_INDIRIZZI_SPEDIZIONI_T_SPEDIZIONI_NL]
GO
ALTER TABLE [dbo].[REL_NEWS_SPEDIZIONI] WITH CHECK ADD CONSTRAINT [FK_REL_NEWS_SPEDIZIONI_MB_contenuti] FOREIGN KEY ([RNS_NEWS_PK])
REFERENCES [dbo].[MB_contenuti] ([Id])
GO
ALTER TABLE [dbo].[REL_NEWS_SPEDIZIONI] CHECK CONSTRAINT [FK_REL_NEWS_SPEDIZIONI_MB_contenuti]
GO
ALTER TABLE [dbo].[REL_NEWS_SPEDIZIONI] WITH CHECK ADD CONSTRAINT [FK_REL_NEWS_SPEDIZIONI_T_SPEDIZIONI_NL] FOREIGN KEY ([RNS_SPED_PK])
REFERENCES [dbo].[T_SPEDIZIONI_NL] ([SPED_PK])
GO
ALTER TABLE [dbo].[REL_NEWS_SPEDIZIONI] CHECK CONSTRAINT [FK_REL_NEWS_SPEDIZIONI_T_SPEDIZIONI_NL]
GO
EXEC [$(DbName)].sys.sp_addextendedproperty	@name = N'MagicCMS_version',
											@value = N'3.0'
GO
EXEC sys.sp_addextendedproperty	@name = N'MS_DiagramPane1',
								@value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "at"
            Begin Extent = 
               Top = 6
               Left = 259
               Bottom = 188
               Right = 462
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "al"
            Begin Extent = 
               Top = 51
               Left = 606
               Bottom = 155
               Right = 789
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
',
								@level0type = N'SCHEMA',
								@level0name = N'dbo',
								@level1type = N'VIEW',
								@level1name = N'VW_ANA_TRANSLATION_BLANK'
GO
EXEC sys.sp_addextendedproperty	@name = N'MS_DiagramPaneCount',
								@value = 1,
								@level0type = N'SCHEMA',
								@level0name = N'dbo',
								@level1type = N'VIEW',
								@level1name = N'VW_ANA_TRANSLATION_BLANK'
GO
EXEC sys.sp_addextendedproperty	@name = N'MS_DiagramPane1',
								@value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[54] 4[7] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "MB_contenuti_1"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 351
               Right = 229
            End
            DisplayFlags = 280
            TopColumn = 15
         End
         Begin Table = "MB_tipi_contenuto"
            Begin Extent = 
               Top = 6
               Left = 259
               Bottom = 340
               Right = 448
            End
            DisplayFlags = 280
            TopColumn = 10
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 26
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
',
								@level0type = N'SCHEMA',
								@level0name = N'dbo',
								@level1type = N'VIEW',
								@level1name = N'VW_MB_contenuti_attivi'
GO
EXEC sys.sp_addextendedproperty	@name = N'MS_DiagramPaneCount',
								@value = 1,
								@level0type = N'SCHEMA',
								@level0name = N'dbo',
								@level1type = N'VIEW',
								@level1name = N'VW_MB_contenuti_attivi'
GO
EXEC sys.sp_addextendedproperty	@name = N'MS_DiagramPane1',
								@value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[31] 2[9] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "REL_contenuti_Argomenti_1"
            Begin Extent = 
               Top = 140
               Left = 570
               Bottom = 327
               Right = 758
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "REL_contenuti_Argomenti"
            Begin Extent = 
               Top = 130
               Left = 66
               Bottom = 242
               Right = 254
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "MB_contenuti_1"
            Begin Extent = 
               Top = 0
               Left = 370
               Bottom = 129
               Right = 565
            End
            DisplayFlags = 280
            TopColumn = 8
         End
         Begin Table = "ANA_CONT_TYPE"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 274
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 4800
         Alias = 900
         Table = 1995
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
',
								@level0type = N'SCHEMA',
								@level0name = N'dbo',
								@level1type = N'VIEW',
								@level1name = N'VW_MB_ContenutiSibling'
GO
EXEC sys.sp_addextendedproperty	@name = N'MS_DiagramPaneCount',
								@value = 1,
								@level0type = N'SCHEMA',
								@level0name = N'dbo',
								@level1type = N'VIEW',
								@level1name = N'VW_MB_ContenutiSibling'
GO
EXEC sys.sp_addextendedproperty	@name = N'MS_DiagramPane1',
								@value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[20] 2[11] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1[50] 4[25] 3) )"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1[46] 4) )"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "MB_contenuti"
            Begin Extent = 
               Top = 0
               Left = 38
               Bottom = 243
               Right = 221
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "REL_contenuti_Argomenti"
            Begin Extent = 
               Top = 14
               Left = 328
               Bottom = 186
               Right = 511
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "MB_contenuti_1"
            Begin Extent = 
               Top = 13
               Left = 616
               Bottom = 239
               Right = 799
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 14
         Width = 284
         Width = 1500
         Width = 6765
         Width = 3330
         Width = 2970
         Width = 915
         Width = 1485
         Width = 1710
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 2730
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
',
								@level0type = N'SCHEMA',
								@level0name = N'dbo',
								@level1type = N'VIEW',
								@level1name = N'VW_NEWS_NEWSLETTER'
GO
EXEC sys.sp_addextendedproperty	@name = N'MS_DiagramPaneCount',
								@value = 1,
								@level0type = N'SCHEMA',
								@level0name = N'dbo',
								@level1type = N'VIEW',
								@level1name = N'VW_NEWS_NEWSLETTER'
GO
USE [master]
GO
ALTER DATABASE [$(DbName)] SET READ_WRITE
GO
USE [$(DbName)]
GO
INSERT INTO [dbo].[ANA_LANGUAGE] ([LANG_Id], [LANG_Name], [LANG_Active], [LANG_AutoHide])
	VALUES (N'de', N'Deutsch', 0, 0)
INSERT INTO [dbo].[ANA_LANGUAGE] ([LANG_Id], [LANG_Name], [LANG_Active], [LANG_AutoHide])
	VALUES (N'en', N'English', 0, 0)
INSERT INTO [dbo].[ANA_LANGUAGE] ([LANG_Id], [LANG_Name], [LANG_Active], [LANG_AutoHide])
	VALUES (N'es', N'Español', 0, 0)
INSERT INTO [dbo].[ANA_LANGUAGE] ([LANG_Id], [LANG_Name], [LANG_Active], [LANG_AutoHide])
	VALUES (N'fr', N'Français', 0, 0)
INSERT INTO [dbo].[ANA_LANGUAGE] ([LANG_Id], [LANG_Name], [LANG_Active], [LANG_AutoHide])
	VALUES (N'it', N'Italiano', 0, 0)
GO

INSERT INTO [dbo].[_LOG_ANA_AZIONI] ([act_PK], [act_COMMAND])
	VALUES (0, N'DELETE')
INSERT INTO [dbo].[_LOG_ANA_AZIONI] ([act_PK], [act_COMMAND])
	VALUES (1, N'INSERT')
INSERT INTO [dbo].[_LOG_ANA_AZIONI] ([act_PK], [act_COMMAND])
	VALUES (2, N'UPDATE')
INSERT INTO [dbo].[_LOG_ANA_AZIONI] ([act_PK], [act_COMMAND])
	VALUES (3, N'READ')
GO

INSERT INTO [dbo].[ANA_PREROGATIVE] ([pre_PK], [pre_PREROGATIVA], [pre_LAST_MODIFIED])
	VALUES (0, N'Guest', N'2014-02-07 09:23:09')
INSERT INTO [dbo].[ANA_PREROGATIVE] ([pre_PK], [pre_PREROGATIVA], [pre_LAST_MODIFIED])
	VALUES (1, N'Community', N'2014-11-07 17:13:43')
INSERT INTO [dbo].[ANA_PREROGATIVE] ([pre_PK], [pre_PREROGATIVA], [pre_LAST_MODIFIED])
	VALUES (4, N'Editor', N'2014-02-07 09:23:17')
INSERT INTO [dbo].[ANA_PREROGATIVE] ([pre_PK], [pre_PREROGATIVA], [pre_LAST_MODIFIED])
	VALUES (10, N'Administrator', N'2014-02-07 09:23:50')
GO

SET IDENTITY_INSERT [dbo].[ANA_USR] ON

INSERT [dbo].[ANA_USR] ([usr_PK], [usr_EMAIL], [usr_NAME], [usr_PASSWORD], [usr_LEVEL], [usr_LAST_MODIFIED], [usr_PROFILE_PK], [usr_ACTIVE])
	VALUES (1, $(AdminEmail), N'MagicCMS Administrator', N'yairhFCEzylQkVBlLIqp58JTUrt9wMPN0i3H604N/2E=', 10, CAST(0x0000A3E800CA0CE6 AS DATETIME), 0, 1)

SET IDENTITY_INSERT [dbo].[ANA_USR] OFF

SET IDENTITY_INSERT [dbo].[ANA_Dictionary] ON
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (1, N'Consenti solo tipi di pagine attivi', N'en', N'Allow only page types with active flag set')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (2, N'Consenti tutti i tipi di pagine', N'en', N'Allow all types of pages')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (3, N'Cambia password', N'en', N'Change password')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (4, N'Esci', N'en', N'Exit')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (5, N'Vocabolario globale', N'en', N'Global vocabulary')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (16, N'Crea contenuto', N'en', N'New content')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (17, N'<p>Questa procedura ricrea l''indice delle <em>url amichevoli</em>. </p> <p class="small">	<strong>NB</strong>: Di norma non è  						necessario lanciare manualmente questa procedura. L''indice dei titoli viene creato e aggiornato automaticamente da MagicCMS. </p>', N'en', N'<p> This procedure rebuilds the index of <em>friendly URLs.</em></p> <p class ="small"> <strong> NB </strong>: normally you do not need to manually start this procedure. The index of titles is created and updated automatically by MagicCMS.</p>')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (8, N'Definizione oggetti Web', N'en', N'Web objects definition')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (9, N'Utenti', N'en', N'Users')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (10, N'Registro attività ed errori', N'en', N'Activities and errors log ')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (11, N'Configurazione sito', N'en', N'Site configuration')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (12, N'CSS personalizzato', N'en', N'Custom CSS')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (13, N'Gestione file', N'en', N'File manager')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (14, N'Ricrea url parlanti', N'en', N'Recreates modern urls')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (15, N'Crea contenitore', N'en', N'New container')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (18, N'Lista tipi', N'en', N'Object types list')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (19, N'Vecchia password', N'en', N'Old password')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (20, N'Nuova password', N'en', N'New password')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (21, N'Ridigita password per controllo', N'en', N'Retype password')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (22, N'Scegli la posizione', N'en', N'Choose the location')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (23, N'Inserisci un indirizzo', N'en', N'Enter an address')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (24, N'Cerca', N'en', N'Search')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (25, N'Quando effettui il login su MagicCMS hai a disposizione una sessione di lavoro di 90 minuti. Puoi prolungare la sessione confermando la tua identità (inserisci nuovamente nome utente e password). Così manterrai i dati su cui stai lavorando. Se, invece, lascerai scadere la sessione, i dati della pagina corrente andranno perduti.', N'en', N'When you log in MagicCMS you have a work session of 90 minutes. You can extend the session by confirming your identity (re-enter username and password). So you will keep the data you''re working on. If, however, you will leave the session expires, the data of the current page will be lost.')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (26, N'Nome sito', N'en', N'Site name')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (27, N'Pagina iniziale', N'en', N'Homepage')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (28, N'Menù', N'en', N'Menu')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (29, N'Pagina Singola', N'en', N'Single Page')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (31, N'Pagine Multiple', N'en', N'Multiple Pages')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (32, N'Abilita Bing translator', N'en', N'Enable Bing translator')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (33, N'Client Id per Bing Translator', N'en', N' Bing Translator Client Id')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (34, N'Secret Key per Bing Translator', N'en', N'Bing Translator Secret Key')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (35, N'Id lingua di origine', N'en', N'Source language ID')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (36, N'Nome lingua di origine', N'en', N'Source language name')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (37, N'Cartella del tema', N'en', N'Theme folder')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (38, N'Pagina master di default', N'en', N'Default master page')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (39, N'Cartella delle icone', N'en', N'Icons folder')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (40, N'Immagine di default', N'en', N'Default image')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (41, N'Sfoglia', N'en', N'Browse')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (42, N'Mostra', N'en', N'View')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (43, N'Server SMTP', N'en', N'SMTP Server')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (44, N'Utente SMTP', N'en', N'SMTP User')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (45, N'Password SMTP', N'en', N'SMTP Password')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (46, N'Mittente di default', N'en', N'Default sender address')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (47, N'Email Web Master', N'en', N'Web Master email')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (48, N'Id Google Analytics', N'en', N'Google Analytics Id')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (49, N'Salva configurazione', N'en', N'Save configuration')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (50, N'Lingue disponibili per le traduzioni', N'en', N'Available languages')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (51, N'Lingua', N'en', N'Language')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (52, N'Nascondi pagine non tradotte', N'en', N'Hide untranslated pages')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (53, N'Editor css', N'en', N'Css editor')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (54, N'Cambia schema colore', N'en', N'Change editor colors scheme')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (55, N'Temi', N'en', N'Themes')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (56, N'Riduci corpo carattere', N'en', N'Reduce font size')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (57, N'Aumento corpo carattere', N'en', N'Increasing the font size')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (58, N'Salva', N'en', N'Save')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (59, N'Archivio fogli di stile', N'en', N'Style sheets repository')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (60, N'Combinazioni tasti attive', N'en', N'Editor keys shortcuts')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (61, N'Chiudi', N'en', N'Close')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (62, N'Foglio di stile da inserire', N'en', N'CSS that will be inserted')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (63, N'Sostituisci', N'en', N'Replace')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (64, N'Accoda al testo', N'en', N'Append to existing CSS')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (65, N'Annulla', N'en', N'Cancel')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (66, N'Archivia una copia del foglio di stile corrente', N'en', N'Stores a copy of the current style sheet')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (67, N'Tema', N'en', N'Theme')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (68, N'Vocabolario', N'en', N'Vocabulary')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (69, N'Termini e traduzioni', N'en', N'Terms and translations')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (70, N'nuovo termine', N'en', N'new term')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (71, N'Termine', N'en', N'Term')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (72, N'Traduzione', N'en', N'Translation')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (73, N'Modifica termine (o aggiungi traduzione)', N'en', N'Edit term (or add language)')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (74, N'Termine o frase', N'en', N'Term or phrase')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (75, N'Id lingua', N'en', N'Language ID')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (76, N'modifica/aggiungi', N'en', N'Edit/Add')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (77, N'elimina', N'en', N'delete')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (78, N'Il termine verrà eliminato definitivamente. Ser sicuro di voler continuare', N'en', N'The term will be permanently deleted. Are you sure you want to continue')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (79, N'Si è verificato un errore', N'en', N'An error has occurred')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (80, N'Nessun dato presente nella tabella', N'en', N'No data exists in the table')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (81, N'Traduci con bing', N'en', N'Translate with bing')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (82, N'Sessione scaduta. È necessario ripetere il login', N'en', N'Session expired. You must re-login')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (83, N'Vista da _START_ a _END_ di _TOTAL_ elementi', N'en', N'View from _START_ to _END_ of _TOTAL_ items')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (84, N'Vista da 0 a 0 di 0 elementi', N'en', N'View from 0 to 0 of 0 items')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (85, N'(filtrati da _MAX_ elementi totali)', N'en', N'(filtered from _MAX_ items)')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (86, N'Visualizza _MENU_ elementi', N'en', N'Show _MENU_ items')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (87, N'Caricamento', N'en', N'Loading')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (88, N'Elaborazione', N'en', N'Processing')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (89, N'La ricerca non ha portato alcun risultato', N'en', N'The search did not bring any results')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (90, N'Inizio', N'en', N'First')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (91, N'Precedente', N'en', N'Previous')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (92, N'Successivo', N'en', N'Next')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (93, N'Fine', N'en', N'Last')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (94, N'attiva per ordinare la colonna in ordine crescente', N'en', N'enable to sort the column in ascending order')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (95, N'attiva per ordinare la colonna in ordine decrescente', N'en', N'enable to sort the column in descending order')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (96, N'Modifica i contenuti del sito', N'en', N'Edit site contents')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (97, N'Struttura del sito', N'en', N'Site structure')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (98, N'aggiungi elemento figlio', N'en', N'add child')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (99, N'Mostra la lista di tutte le componenti del sito', N'en', N'View the list of all site components')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (100, N'Mostra gli elementi nel cestino', N'en', N'View items in the Recycle Bin')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (101, N'Immagine', N'en', N'Image')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (102, N'Pubblicato il', N'en', N'Posted on')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (103, N'Data di scadenza', N'en', N'Expiration Date')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (104, N'Modificato il', N'en', N'Last modified on')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (105, N'Ordinamento', N'en', N'Sorting order')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (106, N'Dati', N'en', N'Data')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (107, N'Calcola geolocazione', N'en', N'Calculates geolocation')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (108, N'Cerca file sul server', N'en', N'Browse files on server')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (109, N'Guarda il file', N'en', N'View')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (110, N'Ordine', N'en', N'Sorting order')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (111, N'Comprimi', N'en', N'Collapse')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (112, N'Parole chiave', N'en', N'Keywords')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (113, N'Crea duplicato', N'en', N'Create duplicate')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (114, N'Anteprima', N'en', N'Preview')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (115, N'Salva e pubblica', N'en', N'Save and publish')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (116, N'L''elemento verrà eliminato definitivamente. Sei sicuro di voler continuare', N'en', N'The item will be deleted permanently. Are you sure you want to continue')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (117, N'Stai spostando l''elemento nel cestino. Ser sicuro di voler continuare', N'en', N'You''re moving the item to the Recycle Bin. Be sure you want to continue')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (118, N'Aggiungi un elemento a', N'en', N'Add an item to the')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (119, N'Attenzione! I testi presenti nei campi saranno sostituiti dalla traduzione automatica. Continuare', N'en', N'Attention! The texts in the fields will be replaced by machine translation. Continue')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (120, N'Confermi l''eliminazione della traduzione', N'en', N'Do you confirm the deletion of the translation')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (121, N'Salvataggio dati', N'en', N'Saved data')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (122, N'Attenzione sono state rilevate modifiche non salvate', N'en', N'Caution! Not saved changes detected')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (123, N'Titolo', N'en', N'Title')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (124, N'Attività ed errori', N'en', N'Activities and errors')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (125, N'Data', N'en', N'Date')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (126, N'Utente', N'en', N'User')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (127, N'Tabella dati', N'en', N'Data table')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (128, N'Azione', N'en', N'Action')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (129, N'Errore', N'en', N'Error')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (130, N'Dettagli attività', N'en', N'Item details')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (131, N'Numero', N'en', N'Number')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (132, N'Data e ora', N'en', N'Date and time')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (133, N'Tabella', N'en', N'Table')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (134, N'Nome file', N'en', N'File name')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (135, N'Nome metodo', N'en', N'Method name')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (136, N'Notifica', N'en', N'Notification')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (137, N'Il record', N'en', N'The record')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (138, N'è stoto caricato con successo', N'en', N'was loaded successfully')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (139, N'È necessario eseguire la verifica reCaptcha', N'en', N'You must verify you are a human with reCaptcha')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (140, N'Primo accesso', N'en', N'First access')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (141, N'Password dimenticata', N'en', N'Forgotten password')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (142, N'Accesso', N'en', N'Login')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (143, N'Richiedi password', N'en', N'Password request')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (144, N'Invia richiesta', N'en', N'Send request')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (145, N'Vai al login', N'en', N'Go to login')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (214, N'Dati incoerenti. Per creare una traduzione bisogna prima salvare il post originale.', N'en', N'Inconsistent data. To create a translation you must first save the original post.')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (146, N'Elenco configurazioni', N'en', N'Configurations list')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (147, N'Nome', N'en', N'Name')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (148, N'Contenitore', N'en', N'Container')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (149, N'Attivo', N'en', N'Active')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (150, N'Testo completo', N'en', N'Full text')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (151, N'Descrizione breve', N'en', N'Short description')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (152, N'Url principale', N'en', N'Main URL')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (153, N'Url secondaria', N'en', N'Secondary URL')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (154, N'Nuova configurazione', N'en', N'New configuration')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (155, N'Preferiti', N'en', N'Favorites')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (156, N'Inserire id separati da virgola', N'en', N'Enter comma separated ids')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (157, N'Tipologie di oggetti MagicPost che possono essere inserite nel contenitore', N'en', N'MagicPost object types that can be inserted into the container')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (158, N'Componi lista tipi', N'en', N'Compose types list ')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (159, N'Se la configurazione non è attiva il tipo di oggetto viene nascosto', N'en', N'If the configuration is not active the type of object is hidden')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (160, N'Può contenere elementi figli', N'en', N'May contain child elements')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (161, N'Bottone ''cerca sul server''', N'en', N'Button ''browse''')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (162, N'Bottone che apre la dialog box per il calcolo della geolocazione', N'en', N'Button that opens the dialog box for the calculation of the geolocation')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (163, N'Geolocazione', N'en', N'Geolocation')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (164, N'Viene visualizzato il campo parole chiave', N'en', N'Displays the keywords field')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (165, N'Vengono visualizzati i campi altezza e larghezza', N'en', N'Displays the height and width fields')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (166, N'Dimensioni', N'en', N'Sizes')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (167, N'Il campo descrizione viene ricavato automaticamente dal campo testo completo', N'en', N'The description field is derived from the full text f')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (168, N'Crea descrizione', N'en', N'Generate short description ')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (169, N'Etichette che verranno associate ai campi', N'en', N'Labels that are bound to fields')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (170, N'Etichetta da associare al campo titolo', N'en', N'Label to associate the title field')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (171, N'Etichetta da associare al campo descrizione breve', N'en', N'Label to associate the short description field')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (172, N'Visualizza il campo descrizione breve', N'en', N'Displays the short description field')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (173, N'Etichetta da associare al campo url principale', N'en', N'Label to be associated with the main url field')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (174, N'Visualizza il campo url principale', N'en', N'Displays the main url field ')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (175, N'Etichetta da associare al campo url secondaria', N'en', N'Label to be associated with the secondary url field')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (176, N'Visualizza il campo url secondaria', N'en', N'Display the secondary url field')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (177, N'Altezza', N'en', N'Height')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (178, N'Etichetta da associare al campo Altezza', N'en', N'Label to associate with the field Height')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (179, N'Visualizza il campo Altezza', N'en', N'Displays the Height  field')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (180, N'Larghezza', N'en', N'Width')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (181, N'Etichetta da associare al campo Larghezza', N'en', N'Label to associate with the Width field ')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (182, N'Visualizza il campo Larghezza', N'en', N'Displays the Width field ')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (183, N'Etichetta da associare al campo', N'en', N'Label to associate with the field')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (184, N'Visualizza il campo', N'en', N'Displays the field')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (185, N'Titolo mostrato', N'en', N'Display title')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (186, N'Scadenza', N'en', N'Expiration Date')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (187, N'Etichetta da associare al campo scadenza', N'en', N'Label to associate with the expiration date field')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (188, N'Lasciare vuoto per nascondere il campo', N'en', N'Leave blank to hide the field')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (189, N'Campo Numerico', N'en', N'Numeric Field')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (190, N'Salva modifiche', N'en', N'Save changes')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (191, N'Nuova configuazione', N'en', N'New configuration')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (192, N'recupera', N'en', N'Retrieves')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (193, N'modifica', N'en', N'edit')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (194, N'cestino', N'en', N'Recycle Bin')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (195, N'Le modifiche non salvate andranno perse. Voui continuare', N'en', N'Unsaved changes will be lost. Do you want to continue')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (196, N'La configurazione verrà eliminata definitivamente. Sei sicuro di voler continuare', N'en', N'The configuration will be permanently deleted. Are you sure you want to continue')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (197, N'Stai spostando la configurazione nel cestino. Ser sicuro di voler continuare', N'en', N'You\''re moving the configuration into the trash. Are you sure you want to continue')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (198, N'Icona', N'en', N'Icon')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (199, N'Scegli la master page', N'en', N'Choose the master page')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (200, N'Record salvato con successo', N'en', N'Record saved successfully')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (201, N'è stato caricato con successo', N'en', N'has been loaded successfully')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (202, N'Gestione utenti', N'en', N'Users management')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (203, N'Elenco utenti', N'en', N'Users list')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (204, N'nuovo utente', N'en', N'new user')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (205, N'Prerogative', N'en', N'Prerogatives')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (206, N'Modifica i dati di un utente', N'en', N'Edit user data')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (207, N'Nome e Cognome', N'en', N'Name and surname')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (208, N'invia automaticamente una e-mail all''utente dopo la registrazione', N'en', N'automatically sends an email to user after registration')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (209, N'L''utente verrà eliminato definitivamente. Ser sicuro di voler continuare', N'en', N'The user will be permanently deleted. Are you sure you want to continue')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (210, N'Inserisci nuovo utente', N'en', N'Add new user')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (211, N'Modifica utente', N'en', N'Edit user')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (212, N'Operazione conclusa con successo.', N'en', N'Operation completed successfully.')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (213, N'Necessario configurare una ''Client Secret Key'' per utilizzare il motore di traduzione', N'en', N'Need to set up a Client Secret Key to use the translation engine')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (215, N'Errore: la tabella', N'en', N'Error: the table')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (216, N'non esiste.', N'en', N'does not exist.')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (217, N'Dati insuffucienti o non pervenuti.', N'en', N'Insuffucienti data or missing.')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (218, N'Record cancellato con successo.', N'en', N'Record deleted successfully.')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (219, N'Il campo e-mail è obbligatorio.', N'en', N'The e-mail field is required.')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (220, N'Utente già registrato. L''indirizzo e-mail è già presente nel database.', N'en', N'User already registered. The e-mail address already exists in the database.')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (221, N'Si è verificato un errore. Controlla il registro delle attività per maggiori informazioni.', N'en', N'An error has occurred. Check the activity log for more information.')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (222, N'L''id del post a cui la traduzione si riferisce non è specificato.', N'en', N'The id of the post to which the translation refers to is not specified.')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (223, N'Errore: Tutti i campi devono essere compilati!', N'en', N'Error: all fields must be completed!')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (224, N'È necessario inserire al meno il nome o il cognome.', N'en', N'You must enter at least the first or last name.')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (225, N'Impossibile salvare la modifica.', N'en', N'Unable to save the change.')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (226, N'Errore del server', N'en', N'Server error')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (227, N'Nessun record da eliminare.', N'en', N'No records to be deleted.')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (228, N'Password modificata con successo.', N'en', N'Password changed successfully.')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (229, N'La nuova password inserita non corrisponde a quella inserita per controllo.', N'en', N'The password entered does not match the version submitted for inspection.')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (230, N'Formato password: tra 6 e 20 caratteri, nessun spazio, lettere, numeri e #_%&', N'en', N'Password format: between 6 and 20 characters, no space, letters, numbers and #_% &')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (231, N'Sessione scaduta.', N'en', N'Session expired.')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (232, N'Vecchia password errata.', N'en', N'Old password is incorrect.')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (233, N'Indice delle url parlanti creato con successo.', N'en', N'Index of ''modern'' urls created successfully.')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (234, N'Indice delle url parlanti creato con successo. Inserite', N'en', N'Index of ''modern'' urls created successfully. Processed')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (235, N'voci.', N'en', N'entries.')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (236, N'La creazione dell''indice delle url parlanti è fallita o si è interrotta.', N'en', N'Index creation of ''modern'' url failed or was shut down.')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (237, N'Impossibile creare la tabella MagicTitle.', N'en', N'Unable to create the table MagicTitle.')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (239, N'La nuova password è stata inviata al tuo indirizzo.', N'en', N'A new password has been sent to your email address.')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (240, N'L''utente non risulta registrato', N'en', N'The user is not registered')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (241, N'L''utente è stato disattivato', N'en', N'The user has been disabled')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (242, N'Errore di sitema', N'en', N'System error')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (243, N'Errore di sitema. Impossibile copletare l''operazione.', N'en', N'System error. Unable to complete the operation.')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (244, N'Salva traduzione', N'en', N'Save translation')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (245, N'Elimina traduzione', N'en', N'Delete translation')
INSERT INTO [dbo].[ANA_Dictionary] ([DICT_Pk], [DICT_Source], [DICT_LANG_Id], [DICT_Translation]) VALUES (238, N'Impossibile creare l''anteprima: non è stata definita alcuna MasterPage per il rendering di questo tipo di oggetto.', N'en', N'Unable to create the preview: you have not defined any MasterPage for rendering of this object type.')
SET IDENTITY_INSERT [dbo].[ANA_Dictionary] OFF

DECLARE @lang NVARCHAR(50)
SET @lang = @@language

SET LANGUAGE us_english

SET IDENTITY_INSERT [dbo].[ANA_CONT_TYPE] ON
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (1, N'Pagina standard ', N'<p>Pagina standard. &nbsp;</p>

<ul>
	<li><strong>Titolo</strong>: Inserire il titolo della pagina&nbsp;</li>
	<li><strong>Rilevanza</strong>: Indica l&#39;ordine con cui la risorsa &egrave; collocata nell&#39;elemento che la contiene&nbsp;</li>
	<li><strong>Titolo mostrato</strong>: Titolo mostrato in testa alla pagina. Viene anche inserito nell&#39;url che identifica la pagina.</li>
	<li><strong>Immagine</strong>: Viene utilizzata, quando possibile, come immagine da inviare ai social network in caso di condivisione della pagina.</li>
	<li><b>Descrizione breve</b>: Testo&nbsp;formattato uasto come descrizione. Viene utilizzato come descrizione dei contenuti dai motori di ricerca e dai social network in caso di condivisione.</li>
	<li><strong>Testo</strong>: Testi formattato che costituisce il testo vero e proprio della pagina.</li>
	<li><strong>Icona font-awesome</strong>: Nome della classe che identifica una icona&nbsp;dell&#39;icon font font-awesome. Ha sempre il formato <code>fa-nomeicona</code>&nbsp;. Viene utilizzata&nbsp;nel men&ugrave;&nbsp;a cui &egrave; collegata la pagina.</li>
</ul>
', N'', 0, N'Nome', N'Cliente', N'Descrizione breve', N'Testo', N'Url principale', N'Immagine', N'Scadenza', N'Altezza', N'Larghezza', N'Titolo mostrato', N'', N'', N'', N'Icona font-awesome', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 1, N'2016-12-08 12:16:00', 1, 0, NULL, 1, 1, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, N'fa-file-text-o', N'StandardPage.master')
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (2, N'Pagina con video', N'<p>Pagina che contiene un video incorporato fornito da&nbsp;<a href="https://support.google.com/youtube/answer/171780?hl=it" target="_blank">You Tube</a>, <a href="https://help.vimeo.com/hc/en-us/articles/224969968-Embedding-videos-overview" target="_blank">Vimeo</a>, <a href="https://www.facebook.com/help/1570724596499071" target="_blank">Facebook </a>ecc.. Il video &egrave; responsive e si adatta automaticamente alla larghezza dello spazio disponibile. La pagina pu&ograve; essere utilizzata anche per incorporare un qualsiasi ogetto <em>responsive </em>fornito da un provider&nbsp;che utilizzi la tecnologia iframe per l&#39;embedding (ad esempio uno slide show incorporato&nbsp;da <a href="http://www.slideshare.net/">www.slideshare.net</a>).</p>

<ul>
	<li><strong>Nome</strong>: Inserire il nome della pagina.</li>
	<li><strong>Codice da incorporare</strong>: Inserire qui il codice fornito dal provider del video per incorporare il video in una pagina web. Alcuni esempi:
	<ul>
		<li><strong>Youtube</strong>: Cliccare con il tasto tasto del mouse sul video e scegliere &quot;Copia il codice per l&#39;incorporamento&quot;. Incolla il codice qui.</li>
		<li><strong>Vimeo</strong>: Selezionare &quot;Share&quot; <span class="fa fa-send" style="color:rgb(0, 0, 0);"></span>&nbsp; e cliccare, nella&nbsp;pop-up che si apre, sul campo &quot;Embed&quot;. Copiare il codice gi&agrave; selezionato e incollarlo qui.</li>
		<li><strong>Facebook</strong>: Apri&nbsp;la pagina dei&nbsp;video del profilo o della pagina. Seleziona&nbsp;il video dediserato in modo che si apra nella una pop-up. Selezione &quot;Opzioni&quot; poi &quot;incorpora&quot;. Copia il codice nella casella e incollalo qui.</li>
	</ul>
	</li>
	<li><strong>Rilevanza</strong>: Indica l&#39;ordine con cui la risorsa &egrave; collocata nell&#39;elemento che la contiene&nbsp;</li>
	<li><strong>Immagine</strong>: Viene utilizzata, quando possibile, come immagine da inviare ai social network in caso di condivisione della pagina.</li>
	<li><strong>Titolo mostrato</strong>: Titolo mostrato in testa alla pagina. Viene anche inserito nell&#39;url che identifica la pagina.</li>
	<li><strong>Classe personalizzata</strong>: Classe che verr&agrave; assegnata al contenitore dell&#39;oggetto incorporato.&nbsp;Tipicamente serve a definire le proporzioni dell&#39;oggetto riprodotto. Se viene omessa il video (o l&#39;oggetto) verr&agrave; visualizzato in 16/9.</li>
	<li><b>Descrizione breve</b>: Testo&nbsp;formattato uasto come descrizione. Viene utilizzato come descrizione dei contenuti dai motori di ricerca e dai social network in caso di condivisione.</li>
	<li><strong>Testo</strong>: Testi formattato che costituisce il testo vero e proprio della pagina.</li>
	<li><strong>Icona font-awesome</strong>: Nome della classe che identifica una icona&nbsp;dell&#39;icon font font-awesome. Ha sempre il formato <code>fa-nomeicona</code>&nbsp;. Viene utilizzate nel men&egrave; a cui &egrave; collegata la pagina.</li>
</ul>
', N'33', 0, N'Titolo', N'Codice da incorporare', N'Colonna di testo', N'Testo completo', N'Url video da incorporare', N'Immagine', N'Scadenza', N'Altezza', N'Larghezza', N'Titolo mostrato', N'Classe personalizzata', N'', N'', N'Icona font-awesome', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 0, N'2016-12-12 17:33:00', 1, 0, N'2015-01-29 16:34:00', 1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 1, 0, N'fa-video-camera', N'StandardPage.master')
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (3, N'Programmi Giorno', N'', N'', 1, N'Nome', N'Cliente', N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', N'Titolo visualizzato', N'', N'', N'', N'Classe icona', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 1, N'2015-12-21 06:33:00', 1, 1, N'2015-12-21 06:33:00', 0, 1, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, N'fa-newspaper-o', N'')
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (4, N'Progetti di ieri', NULL, NULL, 0, N'Nome', NULL, N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'2007-08-22 17:32:00', 1, 1, N'2008-11-27 15:33:00', 1, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (5, N'Blog', N'<p>Pagina che raggruppa gli articoli di un blog. Per aggiungere un nuovo articolo apri il blog cliccando sul nome e premi <kbd><span class="fa fa-plus"></span>&nbsp;aggiungi </kbd>.</p>

<ul>
	<li><strong>Nome</strong>: Nome che identifica l&#39;ogetto</li>
	<li><strong>Titolo mostrato</strong>: Titolo mostrato in testa alla pagina e nel menu. Viene anche inserito nell&#39;url che identifica la pagina.</li>
	<li><strong>Tipo ordinamento</strong> tipo di l&#39;ordinamento con cui vengono mostrati gli elementi contenuti. I valori validi sono:
	<ul>
		<li><code>DATA ASC </code> (per data ascendente)</li>
		<li><code>ASC </code>(secondo il valore contenuto nel campo Rilevanza acendente)</li>
		<li><code>DATA DESC </code> (per data discendente)</li>
		<li><code>DESC </code>(secondo il valore contenuto nel campo Rilevanza discendente)</li>
		<li><code>ALPHA </code>per nome (ascendente)</li>
		<li><code>ALPHA DESC </code> per nome (discendente)</li>
	</ul>
	</li>
	<li><strong>Pagina facebook</strong>: Pagina&nbsp;facebook i cui post vengono utilizzati per la colonna Notizie.</li>
	<li><strong>Immagine</strong>: Viene utilizzata, quando possibile, come immagine da inviare ai social network in caso di condivisione della pagina.</li>
	<li><b>Descrizione breve</b>: Testo&nbsp;formattato uasto come descrizione. Viene utilizzato come descrizione dei contenuti dai motori di ricerca e dai social network in caso di condivisione.</li>
	<li><strong>Testo</strong>: Testi formattato che costituisce il testo vero e proprio della pagina.</li>
	<li><strong>Preferiti (lista di tipi separati da virgole)</strong>: Elenco dei tipi che vengono mostrati nel men&ugrave; <kbd><span class="fa fa-plus"></span>&nbsp;aggiungi </kbd>.</li>
	<li><strong>Icona font-awesome</strong>: Nome della classe che identifica una icona&nbsp;dell&#39;icon font font-awesome. Ha sempre il formato <code>fa-nomeicona</code>&nbsp;. Viene utilizzate nel men&egrave; a cui &egrave; collegata la pagina.</li>
</ul>
', N'38,2,1', 1, N'Nome', N'Tipo di ordinamento', N'Descrizione breve', N'Testo ', N'Url principale', N'Immagine', N'Scadenza', N'Altezza', N'Larghezza', N'Titolo visualizzato', N'Pagina Facebook', N'', N'', N'Icona font-awesome', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 1, N'2017-01-08 10:53:00', 1, 0, N'2016-08-16 12:45:00', 1, 1, 0, 1, 0, 0, 1, 0, 0, 1, 1, 0, N'fa-newspaper-o', N'BlogDocs.master')
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (6, N'Questionari', NULL, NULL, 0, N'Nome', NULL, N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'2007-09-04 15:06:00', 1, 1, N'2008-11-27 15:33:00', 1, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (8, N'Ricerche e pubblicazioni', N'', NULL, 0, N'Nome', NULL, N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'2007-10-25 10:07:00', 1, 1, N'2008-11-27 15:33:00', 1, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (9, N'FAD E CORSI D''AULA', N'Corsi di formazione a distanza che Ecipar ha predisposto per te.', NULL, 0, N'Nome', NULL, N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'2008-02-26 16:35:00', 1, 1, N'2008-11-27 15:33:00', 1, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (10, N'Coming soon', N'<p>Pagina caming soon. &nbsp;All&#39;interno del testo viene inserito un counter che misura il tempo che manca alla scadenza determeinata dal campi&nbsp;<code>scadenza</code>.</p>

<ul>
	<li><strong>Nome</strong>: Inserire il nome della pagina&nbsp;</li>
	<li><strong>Scadenza (data)</strong>: data di fine del conto alla rovescia</li>
	<li><strong>Ora scadenza (hh:mm:ss)</strong>: ora di fine del conto alla rovescia.</li>
	<li><strong>Rilevanza</strong>: Indica l&#39;ordine con cui la risorsa &egrave; collocata nell&#39;elemento che la contiene&nbsp;</li>
	<li><strong>Titolo mostrato</strong>: Viene inserito nell&#39;url che identifica la pagina.</li>
	<li><strong>Immagine</strong>: Viene utilizzata, quando possibile, come immagine da inviare ai social network in caso di condivisione della pagina.</li>
	<li><b>Descrizione breve</b>: Testo&nbsp;formattato usato come descrizione. Viene utilizzato come descrizione dei contenuti dai motori di ricerca e dai social network in caso di condivisione.</li>
	<li><strong>Testo</strong>: Testo&nbsp;formattato che costituisce il testo vero e proprio della pagina. Deve contenere un elemento <strong>div&nbsp;</strong>in cui verr&agrave; inserito il counter. L&#39;elemento contenitore dovr&agrave; essere identificato dal selettore indicato in <strong>Counter selector</strong>. Se ad&nbsp;esempio <strong>counter selector</strong> riporta <kbd>.coming-soon</kbd>&nbsp;l&#39;elemto dovtr&agrave; essere:&nbsp;<code>&lt;div class=&quot;coming-soon&quot;&gt;&lt;/div&gt;</code>&nbsp;</li>
	<li><strong>Counter selector</strong>: Selettore che identifica il contenitore del counter.</li>
</ul>
', N'', 0, N'Nome', N'Ora scadenza (hh:mm:ss)', N'Testo breve', N'Testo completo', N'Url principale', N'Immagine', N'Scadenza (data)', N'Altezza', N'Larghezza', N'Titolo mostrato', N'', N'', N'', N'Counter selector', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 1, N'2017-01-05 16:42:00', 1, 0, N'2008-11-27 15:33:00', 1, 1, 0, 1, 1, 0, 1, 0, 0, 1, 1, 0, N'fa-file-text-o', N'ComingSoon.master')
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (11, N'Repertori', N'Repertori Regionali delle Imprese Femminili Eccellenti', NULL, 0, N'Nome', NULL, N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'2008-10-21 10:16:00', 1, 1, N'2008-11-27 15:33:00', 1, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (12, N'Video', N'Video ''Embedded'' (YouTube o altra risorsa) o ''Linked'' da qualsiasi url.', NULL, 0, N'Nome', NULL, N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'2008-10-17 17:23:00', 1, 1, N'2008-11-27 15:33:00', 1, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (13, N'Argomento', N'<p>Pagina che raggruppa pi&ugrave; blocchi. Per aggiungere un nuovo blocco apri l&#39;argomento cliccando sul nome e premi <kbd><span class="fa fa-plus"></span>&nbsp;aggiungi </kbd>.</p>

<ul>
	<li><strong>Nome</strong>: Nome dell&#39;argomento</li>
	<li><strong>Titolo mostrato</strong>: Titolo mostrato in testa alla pagina. Viene anche inserito nell&#39;url che identifica la pagina.</li>
	<li><strong>Tipo ordinamento</strong> tipo di l&#39;ordinamento con cui vengono mostrati gli elementi contenuti. I valori validi sono:
	<ul>
		<li><code>DATA ASC </code> (per data ascendente)</li>
		<li><code>ASC </code>(secondo il valore contenuto nel campo Rilevanza acendente)</li>
		<li><code>DATA DESC </code> (per data discendente)</li>
		<li><code>DESC </code>(secondo il valore contenuto nel campo Rilevanza discendente)</li>
		<li><code>ALPHA </code>per nome (ascendente)</li>
		<li><code>ALPHA DESC </code> per nome (discendente)</li>
	</ul>
	</li>
	<li><strong>Immagine</strong>: Viene utilizzata, quando possibile, come immagine da inviare ai social network in caso di condivisione della pagina.</li>
	<li><b>Descrizione breve</b>: Testo&nbsp;formattato uasto come descrizione. Viene utilizzato come descrizione dei contenuti dai motori di ricerca e dai social network in caso di condivisione.</li>
	<li><strong>Testo</strong>: Testi formattato che costituisce il testo vero e proprio della pagina.</li>
	<li><strong>Preferiti (lista di tipi separati da virgole)</strong>: Elenco dei tipi che vengono mostrati nel men&ugrave; <kbd><span class="fa fa-plus"></span>&nbsp;aggiungi </kbd>.</li>
  	<li><strong>Icona font-awesome</strong>: Nome della classe che identifica una icona&nbsp;dell&#39;icon font font-awesome. Ha sempre il formato <code>fa-nomeicona</code>&nbsp;. Viene utilizzate nel men&egrave; a cui &egrave; collegata la pagina.</li>
</ul>
', N'2,60,1', 1, N'Nome', N'tipo ordinamento', N'Descrizione', N'Colonna sinistra (citazione)', N'', N'Immagine ', N'Scadenza', N'Altezza', N'Larghezza', N'Titolo mostrato ', N'Preferiti (lista di tipi separati da virgole)', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 1, N'2016-12-07 16:08:00', 1, 0, NULL, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 1, 0, N'fa-folder-open', N'TopicPage.master')
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (14, N'Pagina iframe', N'<p>Consente di inserire una pagina esterna in un <code>iframe </code>a tutta pagina.</p>

<ul>
	<li><strong>Nome</strong>: Inserire il nome della pagina&nbsp;</li>
	<li><strong>Rilevanza</strong>: Indica l&#39;ordine con cui la risorsa &egrave; collocata nell&#39;elemento che la contiene&nbsp;</li>
	<li><strong>Titolo mostrato</strong>: Viene anche inserito nell&#39;url che identifica la pagina.</li>
	<li><strong>Immagine</strong>: Viene utilizzata, quando possibile, come immagine da inviare ai social network in caso di condivisione della pagina.</li>
	<li><strong>Url</strong>: Url della pagina web da inserire nell&#39;iframe.</li>
	<li><b>Descrizione breve</b>: Testo&nbsp;formattato uasto come descrizione. Viene utilizzato come descrizione dei contenuti dai motori di ricerca e dai social network in caso di condivisione.</li>
	<li><strong>Icona font-awesome</strong>: Nome della classe che identifica una icona&nbsp;dell&#39;icon font font-awesome. Ha sempre il formato <code>fa-nomeicona</code>&nbsp;. Viene utilizzate nel men&egrave; a cui &egrave; collegata la pagina.</li>
</ul>
', N'', 0, N'Nome', N'', N'Descrizione breve', N'Testo completo', N'Url ', N'Immagine', N'Scadenza', N'Altezza', N'Larghezza', N'Titolo mostrato', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 1, N'2016-12-07 16:10:00', 1, 0, N'2011-03-19 10:21:00', 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, 1, 0, N'fa-folder', N'IFramePage.master')
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (15, N'Menu', N'<p>Voce di menu.&nbsp;</p>

<ul>
	<li><strong>Titolo</strong>: La voce di men&ugrave; (se non viene specificato<em> Titolo mostrato</em> viene visualizzato nel men&ugrave;.</li>
	<li><strong>Tipo ordinamento</strong> consente di personalizzire l&#39;ordinamento con cui vengono mostrati gli elementi contenuti. I valori validi sono:
	<ul>
		<li>DATA ASC (per data ascendente)</li>
		<li>ASC (secondo il valore contenuto nel campo Rilevanza acendente)</li>
		<li>DATA DESC (per data discendente)</li>
		<li>DESC (secondo il valore contenuto nel campo Rilevanza discendente)</li>
	</ul>
	</li>
	<li><strong>Titolo mostrato: </strong>Titolo alternativo (accetta tag HTML)</li>
</ul>
', N'', 1, N'Nome', N'Tipo ordinamento', N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', N'Titolo mostrato', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 1, N'2016-12-07 16:11:00', 1, 0, NULL, 1, 0, 1, 0, 0, 0, 1, 0, 0, 1, 1, 0, N'fa-th-list', N'')
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (17, N'Collegamento Internet', N'<p>Link esterno con possibile commento.</p>

<ul>
	<li>E&#39; possibile definire se aprire il link in una nuova finestra:. Basta riempire il campo &quot;target&quot;
	<ul>
		<li>internal: il link viene aperto in una finestra javascript (fancy-box)</li>
		<li>external o _blank viene aperta una nuova finestra del browser: ;</li>
		<li>in tutti gli altri casi: stssa finestra del browser<br />
		&nbsp;</li>
	</ul>
	</li>
	<li>Si pu&ograve; usare l&#39;url secondaria per definire un&#39;icona personalizzata del sito altrimenti, se previsto dal tema ne verr&agrave; utilizzata una di default.</li>
</ul>
', N'', 0, N'Nome', N'Target', N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', N'Titolo mostrato', N'', N'', N'', N'Icona font-awesome', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 1, N'2016-11-10 17:04:00', 1, 0, NULL, 1, 0, 1, 1, 0, 0, 1, 0, 0, 1, 1, 0, N'fa-external-link-square', N'')
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (20, N'Collegamento a una pagina interna', N'<p>Link ad una pagina interna con possibile commento.</p>

<ul>
	<li>Utilizzare il campo <strong>Identificativo pagina</strong> per inserire l&#39;id (un numero) o il titolo della pagina. In caso di pagine con titolo uguale verr&agrave; privilegiata la prima in ordinamento o (se uguali) la pi&ugrave; recente.</li>
	<li>Si pu&ograve; usare l&#39;url secondaria per definire un&#39;icona personalizzata del sito altrimenti, se previsto dal tema ne verr&agrave; utilizzata una di default.</li>
</ul>
', N'', 0, N'Nome', N'identificativo pagina o "auto"', N'Testo breve', N'Testo completo', N'Url', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', N'Titolo mostrato', N'Tipo di risorsa', N'Classe link', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 1, N'2015-02-04 17:21:00', 1, 1, N'2016-08-16 15:20:00', 1, 0, 1, 1, 0, 0, 1, 0, 0, 1, 1, 0, N'fa-link', N'')
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (24, N'Radiodramma', N'', NULL, 0, N'Nome', NULL, N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, N'2010-04-13 14:09:00', 1, 1, N'2011-03-19 10:22:00', 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (25, N'Documento scaricabile', N'<p>Questo elemento consente di inserire il collegamento ad un documento scaricabile.</p>

<ul>
	<li><strong>Nume</strong>(obbligatorio): Nome dell&#39;oggetto</li>
	<li><strong>Url</strong>: Indirizzo fisico del file. Utilizzando il pulsante cerca sul server &egrave; possibile sfogliare i documenti gi&agrave; presenti e caricarne di nuovi.</li>
	<li><strong>Rilevanza</strong>: Indica l&#39;ordine con cui la risorsa &egrave; collocata nell&#39;elemento che la contiene.</li>
	<li><strong>Testo del link</strong>: Testo sensibile che consente di scaricare il file.</li>
</ul>

<p>&nbsp;</p>
', N'', 0, N'Nome', N'Sottotitolo', N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', N'Testo del link', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 1, N'2016-12-07 16:18:00', 1, 0, NULL, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, N'fa-download', N'')
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (28, N'Bottone lingua', N'<p>Bottone che consente di cambiare la lingua in cui &egrave; mostrato il sito.</p>

<ul>
	<li><strong>Nome</strong>: Inserire il nome del bottone</li>
	<li><strong>Rilevanza</strong>: Indica l&#39;ordine con cui la risorsa &egrave; collocata nel men&ugrave; che la contiene&nbsp;</li>
	<li><strong>Icona lingua</strong>: Se definita &egrave; l&#39;immagine &egrave; l&#39;immagine cliccabile che consente di cambiare lingua.</li>
	<li><strong>Lingua</strong>: Id della lingua a cui si passa cliccando sul bottone (esempio: <code>en </code>per inglese).</li>
	<li><strong>Testo mostrato</strong>: Testo mostrato nel menu se non viene definita un icona.</li>
	<li><strong>Classe-css</strong>: Classe di stile da assegnare al bottone.</li>
</ul>
', N'', 0, N'Nome', N'Lingua', N'Testo breve', N'Testo completo', N'Url principale', N'Icona lingua', N'Scadenza', N'Altezza', N'Larghezza', N'Testo mostrato', N'Classe css', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 1, N'2016-12-07 16:32:00', 1, 0, N'2010-04-13 08:02:00', 1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 1, 0, N'fa-language', N'')
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (29, N'Galleria automatica', N'<p>Pagina o sezione che contiene una galleria di immagini.&nbsp; La galleria viene creata automaticamnete da tutte le immagine contenute nella cartella selezionata.</p>

<ul>
	<li><strong>Nome</strong>: Inserisci il nome che ti consentir&agrave; di identificare l&#39;elemento per idividuarlo e modificarlo.</li>
	<li><strong>Larghezza e altezza</strong>: Larghezza e altezza in pixel delle&nbsp;miniature. Se l&#39;altezza viene impostata a 0 verra calcolato automaticamente rispettando le proporzioni dell&#39;immagine originale.</li>
	<li><strong>Titolo mostrato</strong>: Titolo mostrato in testa alla pagina. Viene anche inserito nell&#39;url che identifica la pagina.</li>
	<li><b>Descrizione breve</b>: Testo&nbsp;formattato uasto come descrizione. Viene utilizzato come descrizione dei contenuti dai motori di ricerca e dai social network in caso di condivisione.</li>
	<li><strong>Testo</strong>: Testo formattato da inserire nella pagina.</li>
	<li><strong>Cartella immagini</strong>: Seleziona un&#39;Immagine: la galleria verr&agrave; creata autoamticamente utilizzando tutte le immagini contenute nella stessa cartella.
	<ul>
		<li>Clicca il pulsante <kbd>Sfoglia</kbd> per aprire l&#39;interfaccia che ti consente di navigare tra le immagini presenti sul server.</li>
		<li>Seleziona gli appositi comandi per creare nuove cartelle se necessario.</li>
		<li>Usa il pulsante <kbd>Clicca&nbsp;qui&nbsp;per&nbsp;inviare&nbsp;un&nbsp;file</kbd> per aggiungere un&#39;immagine alla cartella aperta.</li>
		<li>Fai doppio click su un&#39;immaghine per selezionarla.</li>
		<li>Se vuoi eliminare un&#39;immagine dalla galleria cancellala o spostala in un altra cartella.</li>
	</ul>
	</li>
	<li><strong>Immagine</strong>: Viene utilizzata, quando possibile, come immagine da inviare ai social network in caso di condivisione della pagina.</li>
</ul>
', N'', 0, N'Nome', N'Tipo di risorsa', N'Testo', N'Testo completo', N'Cartella foto', N'Immagine', N'Scadenza', N'Autoplay foto', N'Larghezza', N'Titolo mostrato', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 1, N'2016-12-08 07:42:00', 1, 0, N'2016-08-16 15:21:00', 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 0, N'fa-cogs', N'')
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (30, N'Immagine', N'<p>Questo elemento consente di inserire un&#39;immagine&nbsp;in una galleria non automatica. Cliccando la miniatura l&#39;immagine viene visualizzata in una fancybox.</p>

<ul>
	<li><strong>Nome</strong>(obbligatorio): Nome che identifica l&#39;immagine.</li>
	<li><strong>Url</strong>: Indirizzo fisico del file. Utilizzando il pulsante cerca sul server &egrave; possibile sfogliare le immagini gi&agrave; presenti e caricarne di nuove.</li>
	<li><strong>Url secondaria</strong>: Consente di personalizzare la miniatura associata all&#39;immagini che altrimenti viene generata automaticamente dal sistema.. Utilizzando il pulsante cerca sul server &egrave; possibile sfogliare le immagini gi&agrave; presenti e caricarne di nuove.</li>
	<li><strong>Rilevanza</strong>: Indica l&#39;ordine con cui la risorsa &egrave; collocata nell&#39;elemento che la contiene.</li>
	<li><strong>Testo breve</strong>: Breve descrizione che viene visualizzata nella light box.</li>
</ul>
', N'', 0, N'Nome', N'Testo alternativo/Titolo', N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', N'Titolo mostrato', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 1, N'2016-12-07 16:52:00', 1, 0, NULL, 1, 0, 1, 1, 0, 0, 1, 0, 0, 1, 1, 0, N'fa-image', N'Image.master')
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (31, N'Pagina con pannelli personalizzati', N'<p>Come la pagina standard ma con la possibilit&agrave; di aggiungere pannelli personalizzati.&nbsp;</p>
', N'', 1, N'Nome', N'', N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', N'Titolo mostrato', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 1, N'2015-02-10 18:06:00', 0, 1, N'2016-08-16 22:38:00', 1, 1, 1, 1, 0, 0, 1, 0, 0, 0, 1, 0, N'fa-file-text', N'')
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (32, N'Filmato flash', N'<p>	La pagina consente un collegamento diretto ad un fimato flash che si apre in una fancybox. Il filmato pu&ograve; essere inserito in un pannello.</p><ul>	<li>		<strong>Titolo </strong>(obbligatorio)</li>	<li>		<strong>Url</strong>: Indirizzo fisico del filmato.</li>	<li>		<strong>Rilevanza</strong>: Indica l&#39;ordine con cui la risorsa &egrave; collocata nell&#39;elemento che la contiene.</li>	<li>		<strong>Url secondario</strong>: Thumbnail</li></ul>', NULL, 0, N'Nome', N'Codice action script', N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, N'2011-03-20 09:38:00', 0, 1, N'2015-01-29 16:36:00', 1, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (33, N'Video in galleria', N'<p>Questo elemento consente di incorporare un video fornito da You Tube in una fancybox. Basta inserire l&#39;ID youtube del video.</p>

<ul>
	<li><strong>Titolo </strong>(obbligatorio): Non visualizzato</li>
	<li><b>Youtube ID</b>: inserire l&#39;id che you tube assegna la video una volta inserito. Per indivis&igrave;duare il codice
	<ul>
		<li>Scegli sulla pagina di YouTube <strong>Condividi</strong></li>
		<li>Verr&agrave; visualizzato un ulr del tipo&nbsp;<strong>http://youtu.be/G5KnOZKmRqQ&nbsp;</strong></li>
		<li>L&#39;ID &egrave; la parte finale dell&#39;url, quella che segue l&#39;ultima barra&nbsp;http://youtu.be/<strong>G5KnOZKmRqQ</strong></li>
	</ul>
	</li>
	<li><strong>Rilevanza</strong>: Indica l&#39;ordine con cui la risorsa &egrave; collocata nell&#39;elemento che la contiene.</li>
	<li><strong>Testo breve</strong>: Breve descrizione che viene visualizzata nella light box.</li>
</ul>
', N'', 0, N'Nome', N'yuotube id', N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 0, N'2016-12-07 16:53:00', 0, 0, NULL, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, N'fa-video-camera', N'')
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (34, N'Pagina Multitab', N'<p> 	Contenitore di pi&ugrave; pagine con tab. Usato nella sezione CF&amp;L I nostri numeri.</p> ', N'35', 1, N'Nome', NULL, N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'2011-05-05 09:17:00', 0, 1, N'2012-02-09 22:56:00', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (35, N'Pagina con Tabs', N'<p> 	Contenitore di &nbsp;tab. Usato nella sezione CF&amp;L I nostri numeri.</p> <ul> 	<li> 		Titolo (obbligatorio): Testo che viene visualizzato nei pulsanti che consente ai gruppi di tab.</li> </ul> ', N'36', 1, N'Nome', NULL, N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'2011-05-05 09:17:00', 0, 1, N'2012-02-09 22:57:00', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (36, N'Tab Ajax', N'<p> 	Tab il cui contenuto viene caricato dinamicamente. Usato nella sezione CF&amp;L I nostri numeri. Elementi modificabili;</p> <ul> 	<li> 		<strong>Titolo </strong>(obbligatorio): testo che da il nome al tab</li> 	<li> 		<strong>Rilevanza:</strong>&nbsp;Ordine dei tab.</li> 	<li> 		<strong>Testo breve</strong>: commento ai dati</li> </ul> ', NULL, 0, N'Nome', NULL, N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'2011-05-05 09:18:00', 0, 1, N'2012-02-09 22:57:00', 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (37, N'Categoria', N'<p>Categoria a cui possono essere associate le pagine.&nbsp;</p>

<ul>
	<li><strong>Nome</strong>: Inserire il nome della categoria&nbsp;</li>
	<li><strong>Rilevanza</strong>: Indica l&#39;ordine con cui la risorsa &egrave; collocata nell&#39;elemento che la contiene&nbsp;</li>
	<li><strong>Titolo mostrato</strong>: Se la categoria viene usate per creare una pagina &egrave; il titolo mostrato in testa alla pagina. Viene anche inserito nell&#39;url che identifica la pagina.</li>
	<li><strong>Immagine</strong>: Viene utilizzata, quando possibile, come immagine da inviare ai social network in caso di condivisione della pagina.</li>
	<li><b>Descrizione breve</b>: Testo&nbsp;formattato uasto come descrizione. Viene utilizzato come descrizione dei contenuti dai motori di ricerca e dai social network in caso di condivisione.</li>
	<li><strong>Tipo ordinamento</strong> tipo di l&#39;ordinamento con cui vengono mostrati gli elementi contenuti. I valori validi sono:
	<ul>
		<li><code>DATA ASC </code> (per data ascendente)</li>
		<li><code>ASC </code>(secondo il valore contenuto nel campo Rilevanza acendente)</li>
		<li><code>DATA DESC </code> (per data discendente)</li>
		<li><code>DESC </code>(secondo il valore contenuto nel campo Rilevanza discendente)</li>
		<li><code>ALPHA </code>per nome (ascendente)</li>
		<li><code>ALPHA DESC </code> per nome (discendente)</li>
	</ul>
	</li>
	<li><strong>Preferiti (lista di tipi separati da virgole)</strong>: Elenco dei tipi che vengono mostrati nel men&ugrave; <kbd><span class="fa fa-plus"></span>&nbsp;aggiungi </kbd>.</li>
</ul>
', N'', 1, N'Nome', N'Tipo ordinamento', N'Testo breve', N'Testo completo', N'Url principale', N'Immagine', N'Scadenza', N'Altezza', N'Larghezza', N'Titolo mostrato', N'Preferiti (lista di tipi separati da virgole)', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 1, N'2016-12-07 23:36:00', 1, 0, NULL, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 1, 0, N'fa-certificate', N'Portfolio.master')
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (38, N'News', N'<p>Questo elemento consente di inserire un notizia.</p>

<ul>
	<li><strong>Nome</strong>: Inserire il nome della news</li>
	<li><strong>Rilevanza</strong>: Indica l&#39;ordine con cui la risorsa &egrave; collocata nell&#39;elemento che la contiene&nbsp;</li>
	<li><strong>Titolo mostrato</strong>: Titolo mostrato in testa alla pagina. Viene anche inserito nell&#39;url che identifica la pagina.</li>
	<li><strong>Immagine</strong>: Viene utilizzata, quando possibile, come immagine da inviare ai social network in caso di condivisione della pagina.</li>
	<li><b>Descrizione breve</b>: Testo&nbsp;formattato uasto come descrizione. Viene utilizzato come descrizione dei contenuti dai motori di ricerca e dai social network in caso di condivisione.</li>
	<li><strong>Testo</strong>: Testi formattato che costituisce il testo vero e proprio della pagina.</li>
</ul>

<p>&nbsp;</p>
', N'48', 1, N'Nome', N'', N'Testo breve', N'Testo completo', N'Url principale', N'Immagine', N'Scadenza', N'Altezza', N'Larghezza', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 1, N'2016-12-07 17:01:00', 1, 0, NULL, 1, 1, 0, 1, 1, 0, 1, 1, 0, 0, 0, 0, N'fa-newspaper-o', N'StatdardPage.master')
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (39, N'FAQ', N'<p>	Questo elemento consente di inserire un domanda frequente nella sezione FAQ..</p><ul>	<li>		<strong>Titolo </strong>(obbligatorio): Viene visualizzato solo in fase di editing.</li>	<li>		<strong>Data di pubblicazione</strong>: Opzionale.</li>	<li>		<strong>Data di scadenza</strong>:&nbsp;Data dopo la quale la FAQ non appare pi&ugrave; negli elenchi</li>	<li>		<strong>Rilevanza</strong>: Determina l&#39;ordine in cui le FAQ vengono presentate.</li>	<li>		<strong>Testo breve</strong>: Inserire qui la domanda.</li>	<li>		<strong>Testo lungo</strong>: Inserire qui la risposta..</li></ul><p>	<strong>NB</strong>: Per essere pubblicate le FAQ devono essere collegate a un tag pubblicato o nella sezione <strong>FAQ</strong>.</p>', NULL, 0, N'Nome', NULL, N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'2011-10-30 10:15:00', 0, 1, N'2012-02-09 23:00:00', 1, 1, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (40, N'Home page', N'<p>Pagina o sezione con sequenza di slide. &nbsp;</p>

<ul>
	<li><strong>Nome</strong>: Inserire il nome dato alla pagina.&nbsp;</li>
	<li><strong>Rilevanza</strong>: Indica l&#39;ordine con cui la risorsa &egrave; collocata nell&#39;elemento che la contiene&nbsp;</li>
	<li><strong>Titolo mostrato</strong>: Titolo che appare in testa alla pagina e&nbsp;nel menu.</li>
	<li><strong>Pagina facebook</strong>: Pagina&nbsp;facebook i cui post vengono utilizzati per la colonna Notizie.</li>
	<li><strong>Immagine FB</strong>: Viene utilizzata, quando possibile, come immagine da inviare ai social network in caso di condivisione della pagina.</li>
	<li><b>Descrizione breve</b>: Testo&nbsp;formattato uasto come descrizione. Viene utilizzato come descrizione dei contenuti dai motori di ricerca e dai social network in caso di condivisione.</li>
	<li><strong>Testo</strong>: Testi formattato che costituisce il testo vero e proprio della pagina.</li>
	<li><strong>Icona font-awesome</strong>: Nome della classe che identifica una icona&nbsp;dell&#39;icon font font-awesome. Ha sempre il formato <code>fa-nomeicona</code>&nbsp;. Viene utilizzata&nbsp;nel men&ugrave;&nbsp;a cui &egrave; collegata la pagina.</li>
</ul>
', N'56', 1, N'Nome', N'Facebook access key', N'Descrizione breve', N'Testo', N'Url principale', N'Immagine fb', N'Scadenza', N'Altezza', N'Larghezza', N'Titolo mostrato', N'Pagina Facebook', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 1, N'2017-01-08 10:51:00', 1, 0, NULL, 1, 1, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, N'fa-home', N'SlideShow.master')
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (41, N'Database', N'<p>	<span style="font-family: Arial, Helvetica, sans-serif; font-size: 11px; text-align: left; ">Questo elemento considte di associare un database al motore di ricerca..</span></p><ul style="margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 0px; border-style: initial; border-color: initial; border-image: initial; outline-width: 0px; outline-style: initial; outline-color: initial; font-size: 11px; vertical-align: baseline; background-image: initial; background-attachment: initial; background-origin: initial; background-clip: initial; list-style-type: none; font-family: Arial, Helvetica, sans-serif; text-align: left; ">	<li style="margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; padding-top: 0px; padding-right: 0px; padding-bottom: 4px; padding-left: 13px; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 0px; border-style: initial; border-color: initial; border-image: initial; outline-width: 0px; outline-style: initial; outline-color: initial; vertical-align: baseline; background-image: url(http://www.brunomigliaretti.localhost/mb_images/bullet_sq.gif); background-attachment: initial; background-origin: initial; background-clip: initial; background-color: initial; list-style-type: none; background-position: 0% 5px; background-repeat: no-repeat no-repeat; ">		<strong style="margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 0px; border-style: initial; border-color: initial; border-image: initial; outline-width: 0px; outline-style: initial; outline-color: initial; vertical-align: baseline; background-image: initial; background-attachment: initial; background-origin: initial; background-clip: initial; background-color: transparent; ">Titolo&nbsp;</strong>(obbligatorio): Viene visualizzato solo in fase di editing.</li>	<li style="margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; padding-top: 0px; padding-right: 0px; padding-bottom: 4px; padding-left: 13px; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 0px; border-style: initial; border-color: initial; border-image: initial; outline-width: 0px; outline-style: initial; outline-color: initial; vertical-align: baseline; background-image: url(http://www.brunomigliaretti.localhost/mb_images/bullet_sq.gif); background-attachment: initial; background-origin: initial; background-clip: initial; background-color: initial; list-style-type: none; background-position: 0% 5px; background-repeat: no-repeat no-repeat; ">		<strong style="margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 0px; border-style: initial; border-color: initial; border-image: initial; outline-width: 0px; outline-style: initial; outline-color: initial; vertical-align: baseline; background-image: initial; background-attachment: initial; background-origin: initial; background-clip: initial; background-color: transparent; ">Data di pubblicazione</strong>: Opzionale.</li>	<li style="margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; padding-top: 0px; padding-right: 0px; padding-bottom: 4px; padding-left: 13px; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 0px; border-style: initial; border-color: initial; border-image: initial; outline-width: 0px; outline-style: initial; outline-color: initial; vertical-align: baseline; background-image: url(http://www.brunomigliaretti.localhost/mb_images/bullet_sq.gif); background-attachment: initial; background-origin: initial; background-clip: initial; background-color: initial; list-style-type: none; background-position: 0% 5px; background-repeat: no-repeat no-repeat; ">		<strong style="background-color: transparent; margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 0px; border-style: initial; border-color: initial; border-image: initial; outline-width: 0px; outline-style: initial; outline-color: initial; vertical-align: baseline; background-image: initial; background-attachment: initial; background-origin: initial; background-clip: initial; ">Rilevanza</strong><span style="background-color: initial; ">: Non usato.</span></li>	<li style="margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; padding-top: 0px; padding-right: 0px; padding-bottom: 4px; padding-left: 13px; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 0px; border-style: initial; border-color: initial; border-image: initial; outline-width: 0px; outline-style: initial; outline-color: initial; vertical-align: baseline; background-image: url(http://www.brunomigliaretti.localhost/mb_images/bullet_sq.gif); background-attachment: initial; background-origin: initial; background-clip: initial; background-color: initial; list-style-type: none; background-position: 0% 5px; background-repeat: no-repeat no-repeat; ">		<b>Nome database&nbsp;</b>(obbligatorio): il nome del database&nbsp;</li>	<li style="margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; padding-top: 0px; padding-right: 0px; padding-bottom: 4px; padding-left: 13px; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 0px; border-style: initial; border-color: initial; border-image: initial; outline-width: 0px; outline-style: initial; outline-color: initial; vertical-align: baseline; background-image: url(http://www.brunomigliaretti.localhost/mb_images/bullet_sq.gif); background-attachment: initial; background-origin: initial; background-clip: initial; background-color: initial; list-style-type: none; background-position: 0% 5px; background-repeat: no-repeat no-repeat; ">		<strong style="margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 0px; border-style: initial; border-color: initial; border-image: initial; outline-width: 0px; outline-style: initial; outline-color: initial; vertical-align: baseline; background-image: initial; background-attachment: initial; background-origin: initial; background-clip: initial; background-color: transparent; ">Url</strong>: L&#39;url assoluta con cui va richiamato la pagine con la parola convenzionale &quot;_pxxx&quot; al posto del dumero identificatico della pagina. Es: http://www.sisteminterattivi.org/mb_showPage.asp?page=_pxxx</li>	<li style="margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; padding-top: 0px; padding-right: 0px; padding-bottom: 4px; padding-left: 13px; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 0px; border-style: initial; border-color: initial; border-image: initial; outline-width: 0px; outline-style: initial; outline-color: initial; vertical-align: baseline; background-image: url(http://www.brunomigliaretti.localhost/mb_images/bullet_sq.gif); background-attachment: initial; background-origin: initial; background-clip: initial; background-color: initial; list-style-type: none; background-position: 0% 5px; background-repeat: no-repeat no-repeat; ">		<strong>Url secondaria</strong>: Un&#39;immagine da usare come icona identificativa del database.</li></ul>', NULL, 0, N'Nome', N'Nome del database', N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, N'2012-02-09 23:01:00', 0, 1, N'2015-01-29 16:37:00', 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (42, N'Pagina di ricerca', N'<p>	Pagina di ricerca. Perch&egrave; funzioni &egrave; necessario collegarlo alla definizione di uno o pi&ugrave; database. L&#39;opzione url consente di collegare una pagina di ricerca personalizzata altrimenti verr&agrave; utilizzata quella di default.</p>', N'41', 1, N'Nome', NULL, N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'2012-02-09 23:07:00', 0, 1, N'2015-01-29 16:38:00', 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (43, N'Calendario', N'<p>	Pannello particolare che contiene un calendario. Tuggli gli elementi collegati saranno raggiungibili selezionando le date corrispondenti.</p>', NULL, 1, N'Nome', NULL, N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'2012-02-09 23:15:00', 0, 1, N'2015-01-29 16:38:00', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (44, N'Gruppo di pannelli', N'<p>	Elemento che consente di definire il gruppo di pannelli (collegamento a pagine di ricerca, calendari, &nbsp;pannelli contenitori) di default, mostrato cio&egrave; nelle pagine standard e nelle pagine in cui non siano definiti pannelli.</p>', N'42, 43, 29, 50, 47', 1, N'Nome', N'Tipo di ordinamento dei singoli pannelli contenuti', N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'2012-02-10 10:23:00', 0, 1, N'2015-01-29 16:38:00', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (45, N'Pagina di download', N'<p>	La pagina consente di organizzare il download di documenti per gruppi. I file sono raggruppati a seconda dei tag a cui sono associati.</p><ul>	<li>		<strong>Titolo</strong>: titolo della pagina (visualizzato)</li>	<li>		<strong>Testo breve&nbsp;</strong>testo che viene mostrato nelle liste..</li>	<li>		<strong>Testo lungo: </strong>testo&nbsp;che viene inserito sotto il titolo prima degli elenchi di file.</li></ul>', N'37', 1, N'Nome', N'Root area download', N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, N'2012-02-10 10:50:00', 0, 1, N'2015-01-29 16:39:00', 1, 1, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (46, N'Cartella', N'<p>Generico contenitore utilizzabile per organizzare pagine e altri oggetti del sito.&nbsp;</p>

<ul>
	<li><strong>Nome</strong>: Inserire il nome della cartella.</li>
	<li><strong>Tipo ordinamento</strong> tipo di l&#39;ordinamento con cui vengono mostrati gli elementi contenuti. I valori validi sono:
	<ul>
		<li><code>DATA ASC </code> (per data ascendente)</li>
		<li><code>ASC </code>(secondo il valore contenuto nel campo Rilevanza acendente)</li>
		<li><code>DATA DESC </code> (per data discendente)</li>
		<li><code>DESC </code>(secondo il valore contenuto nel campo Rilevanza discendente)</li>
		<li><code>ALPHA </code>per nome (ascendente)</li>
		<li><code>ALPHA DESC </code> per nome (discendente)</li>
	</ul>
	</li>
	<li><strong>Preferiti (lista di tipi separati da virgole)</strong>: Elenco dei tipi che vengono mostrati nel men&ugrave; <kbd><span class="fa fa-plus"></span>&nbsp;aggiungi </kbd>.</li>
</ul>
', N'', 1, N'Nome', N'Tipo ordinamento', N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', N'', N'Preferiti (lista di tipi separati da virgole)', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 0, N'2016-12-08 05:47:00', 1, 0, NULL, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, N'fa-folder', N'')
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (47, N'Plugin', N'', N'', 0, N'Nome', N'Script collegato', N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 0, N'2016-12-07 23:38:00', 0, 0, NULL, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, N'fa-file-text-o', N'')
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (48, N'Galleria', N'<p>Pagina o sezione che contiene una galleria di immagini e/o di video.&nbsp; Contrariamente alle gallerie automatiche qui gli elementi che compongono la galleria sono inseriti come elementi figli (elementi <code>Immagine&nbsp;</code>or <code>Video in galleria</code> inseriti nel database.</p>

<ul>
	<li><strong>Nome</strong>: Inserisci il nome che ti consentir&agrave; di identificare l&#39;elemento per idividuarlo e modificarlo.</li>
	<li><strong>Larghezza e altezza</strong>: Larghezza e altezza in pixel delle&nbsp;miniature. Se l&#39;altezza viene impostata a 0 verra calcolato automaticamente rispettando le proporzioni dell&#39;immagine originale.</li>
	<li><strong>Titolo mostrato</strong>: Titolo mostrato in testa alla pagina. Viene anche inserito nell&#39;url che identifica la pagina.</li>
	<li><b>Descrizione breve</b>: Testo&nbsp;formattato uasto come descrizione. Viene utilizzato come descrizione dei contenuti dai motori di ricerca e dai social network in caso di condivisione.</li>
	<li><strong>Testo</strong>: Testo formattato da inserire nella pagina.</li>
	<li><strong>Immagine</strong>: Viene utilizzata, quando possibile, come immagine da inviare ai social network in caso di condivisione della pagina.</li>
</ul>
', N'30, 33', 1, N'Nome', N'Sottotitolo', N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza miniatura', N'Larghezza miniatura', N'Titolo mostrato', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 0, N'2016-12-08 07:41:00', 1, 0, NULL, 1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 0, N'fa-folder', N'')
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (49, N'Annuncio pubblicitario', N'<p>	Annuncio pubblicitario da inserire in un banner.</p><ul>	<li>		Titolo&nbsp;(obbligatorio): Identifica l&#39;annuncio nelle statistiche</li>	<li>		Url: Indirizzo da richiamare cliccando sull&#39;annuanco</li>	<li>		Url secondaria: Immagine da visualizzare nel banner.</li>	<li>		Rilevanza non usato.</li>	<li>		Testo alternativo: Testo da inserire come testo alternativi se l&#39;immagine non &egrave; visualizzata.</li></ul><p>	NB: Le immagini devono essere collegate ad una galleria utilizzando il pannello collegamenti.</p>', NULL, 0, N'Nome', N'Testo alternativo', N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, N'2012-10-03 07:41:00', 0, 1, N'2015-01-29 16:40:00', 0, 0, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (50, N'Banner pubblicitario', N'<p>	Elemento specializzato per contenere annunci pubblicitari..</p><ul>	<li>		<strong>Titolo&nbsp;</strong>(obbligatorio, non visializzato): Identifica il banner. Nel caso dei banner fissi corrisponde all&#39;attributo <strong>id</strong> che ha l&#39;elemento corrispondente nella pagina.</li>	<li>		<strong>Ordine di scelta&nbsp;</strong>(opzionale): &nbsp;Nel caso pi&ugrave; banner sia assegnati allo stesso spazio il primo secondo:		<ul>			<li>				DATA DESC: quello con data pi&ugrave; recente</li>			<li>				ASC: quello che il valore pi&ugrave; alto nel campo Rilevanza..</li>			<li>				DESC :&nbsp;quello che il valore pi&ugrave; bassonel campo Rilevanza..</li>			<li>				RANDOM: in maniera casuale (i banner venco alternati)</li>		</ul>	</li>	<li>		<strong>Rilevanza</strong>: Indica l&#39;ordine con cui la risorsa &egrave; collocata nell&#39;elemento che la contiene.</li></ul>', N'49', 1, N'Nome', N'Ordine di scelta', N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'2012-10-03 07:50:00', 0, 1, N'2015-01-29 16:40:00', 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (51, N'PaginaAccordion', N'<p>	Raggruppa pi&ugrave; pagine standard. Delle pagine collegate viene usato solo il titolo e il testo lungo che vengono usati per creare gli elementi di un Accordion&nbsp;</p><p>	<strong>Tipo ordinamento</strong> consente di personalizzire l&#39;ordinamento con cui vengono mostrati gli elementi contenuti. I valori validi sono:</p><ul>	<li>		DATA ASC (per data ascendente)</li>	<li>		ASC (secondo il valore contenuto nel campo Rilevanza acendente)</li>	<li>		DATA DESC (per data discendente)</li>	<li>		DESC (secondo il valore contenuto nel campo Rilevanza discendente)</li></ul>', N'1', 1, N'Nome', N'Ordinamento', N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, N'2012-12-07 12:44:00', 0, 1, N'2015-01-29 16:40:00', 1, 1, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (52, N'Voce di glossario', NULL, NULL, 0, N'Nome', N'alias', N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'2012-12-07 13:40:00', 1, 1, N'2015-01-29 16:40:00', 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (53, N'Locazione sulla mappa', N'<p>Categoria a cui possono essere associate le pagine.&nbsp;</p>

<ul>
	<li><strong>Nome</strong>: Inserire il nome assegnato al marker</li>
	<li><strong>Titolo mostrato</strong>: Titolo del marker (tooltip che appare al mouse over).</li>
	<li><strong>Segnalino</strong>: Icona che vie usata per indicare la posizione del marker. Se omessa viene utilizzata quella di default. (<span style="color:#a52a2a;"><span class="fa fa-map-marker"></span></span>).</li>
	<li><b>Testo</b>: Testo&nbsp;formattato che appare nella <em>infowindow </em>del marker.</li>
	<li><strong>Coordinate</strong>: Geolocazione del marker&nbsp;(longitudine e latitudine). Cliccare&nbsp;<kbd><span class="fa fa-map-marker"></span></kbd> per definire la posizione interattiviamante sulla mappa.</li>
</ul>
', N'', 0, N'Nome', N'Coordinate', N'Testo breve', N'Testo', N'Url principale', N'Segnalino', N'Scadenza', N'Altezza', N'Larghezza', N'Titolo mostrato', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 1, N'2016-12-08 06:03:00', 1, 0, NULL, 0, 1, 0, 1, 0, 0, 1, 1, 0, 1, 1, 1, N'fa-map-marker', N'')
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (54, N'FakeLink', N'<p>Placeholder da utilizzare nei menu durante la fase di design di un sito o di un tema.</p>
', N'', 0, N'Nome', N'', N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', N'Titolo mostrato', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 0, N'2016-12-08 06:06:00', 0, 0, NULL, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, N'fa-link', N'')
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (55, N'Progetto', N'', N'30, 33,25, 59', 1, N'Nome', N'anno', N'Note', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', N'Titolo mostrato', N'committente', N'importo', N'progettisti', N'Luogo', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 0, N'2015-02-08 16:12:00', 1, 1, N'2016-12-08 06:06:00', 1, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, N'fa-cubes', N'Progetto.master')
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (56, N'Slide', N'<p>Testo formattato (HTML) di una slide inserita in una sequenza.</p>
', N'', 0, N'Nome', N'', N'Testo ', N'Testo completo', N'Url principale', N'Url secondaria', N'Scadenza', N'Altezza', N'Larghezza', N'Titolo mostrato', N'Sottotitolo', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 1, N'2017-01-08 10:48:00', 1, 0, NULL, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, N'fa-slideshare', N'SingleSlideTest.master')
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (57, N'Mappa', N'<p>Pagina o sezione con una Google map. &nbsp;</p>

<ul>
	<li><strong>Nome</strong>: Inserire il nome che identifica la pagina o la sezione.&nbsp;</li>
	<li><strong>Rilevanza</strong>: Indica l&#39;ordine con cui la risorsa &egrave; collocata nell&#39;elemento che la contiene&nbsp;</li>
	<li><strong>Zoom</strong>: livello di zoom iniziale della mappa.</li>
	<li><strong>Centro mappa</strong>: Geolocazione (longitudine e latitudine) del centro della mappa. Cliccare&nbsp;<kbd><span class="fa fa-map-marker"></span></kbd> per definire la posizione interattiviamante sulla mappa.</li>
	<li><strong>Titolo mostrato</strong>: Titolo mostrato in testa alla pagina. Viene anche inserito nell&#39;url che identifica la pagina.</li>
	<li><strong>Immagine</strong>: Viene utilizzata, quando possibile, come immagine da inviare ai social network in caso di condivisione della pagina.</li>
	<li><b>Descrizione breve</b>: Testo&nbsp;formattato uasto come descrizione. Viene utilizzato come descrizione dei contenuti dai motori di ricerca e dai social network in caso di condivisione.</li>
	<li><strong>Testo</strong>: Testi formattato che costituisce il testo vero e proprio della pagina.</li>
	<li><strong>Icona font-awesome</strong>: Nome della classe che identifica una icona&nbsp;dell&#39;icon font font-awesome. Ha sempre il formato <code>fa-nomeicona</code>&nbsp;. Se specificato viene utilizzate nel men&ugrave;&nbsp;a cui &egrave; collegata la pagina.</li>
</ul>
', N'', 0, N'Nome', N'Centro mappa', N'Descrizione breve', N'Testo ', N'Url principale', N'Immagine', N'Scadenza', N'Zoom', N'Larghezza', N'Titolo mostrato', N'', N'', N'', N'Icona font-awesome', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 0, N'2016-12-08 07:41:00', 1, 0, N'2015-01-29 17:10:00', 1, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, N'fa-map-marker', N'')
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (58, N'Collegamento social', N'', N'', 0, N'Nome', N'', N'Collegamento al profilo', N'Testo completo', N'Collegamento', N'Icona (opzionale)', N'Scadenza', N'Altezza', N'Larghezza', N'Testo del link', N'', N'', N'', N'Icona (che utilizza una classe css)', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 1, N'2016-12-08 06:27:00', 0, 0, NULL, 0, 0, 1, 1, 0, 0, 1, 0, 0, 1, 1, 0, N'fa-users', N'')
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (59, N'Membro dello staff', N'', N'', 1, N'Nome', N'Ruolo', N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', N'Nome e titolo mostarto', N'Luogo di nascita', N'Data di nascita', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 1, N'2016-12-08 07:40:00', 0, 0, NULL, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 1, 0, N'fa-user', N'Socio.master')
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (60, N'Pagina contatti', N'<p>Pagina o sezione contatti con una Google map opzionale. Ha le stesse caratteristiche della pagina di tipo mappa.</p>

<ul>
	<li><strong>Nome</strong>: Inserire il nome che identifica la pagina o la sezione.&nbsp;</li>
	<li><strong>Rilevanza</strong>: Indica l&#39;ordine con cui la risorsa &egrave; collocata nell&#39;elemento che la contiene&nbsp;</li>
	<li><strong>Zoom</strong>: livello di zoom iniziale della mappa.</li>
	<li><strong>Centro mappa</strong>: Geolocazione (longitudine e latitudine) del centro della mappa. Cliccare&nbsp;<kbd><span class="fa fa-map-marker"></span></kbd> per definire la posizione interattiviamante sulla mappa.</li>
	<li><strong>Titolo mostrato</strong>: Titolo mostrato in testa alla pagina. Viene anche inserito nell&#39;url che identifica la pagina.</li>
	<li><strong>Immagine</strong>: Viene utilizzata, quando possibile, come immagine da inviare ai social network in caso di condivisione della pagina.</li>
	<li><b>Descrizione breve</b>: Testo&nbsp;formattato uasto come descrizione. Viene utilizzato come descrizione dei contenuti dai motori di ricerca e dai social network in caso di condivisione.</li>
	<li><strong>Testo</strong>: Testi formattato che costituisce il testo vero e proprio della pagina.</li>
	<li><strong>Icona font-awesome</strong>: Nome della classe che identifica una icona&nbsp;dell&#39;icon font font-awesome. Ha sempre il formato <code>fa-nomeicona</code>&nbsp;. Se specificato viene utilizzate nel men&ugrave;&nbsp;a cui &egrave; collegata la pagina.</li>
</ul>
', N'53', 1, N'Titolo', N'Geolocazione', N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Zoom Mappa', N'Larghezza', N'Titolo mostrato', N'', N'', N'', N'Icona (font-awesome)', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 1, N'2016-12-08 07:39:00', 1, 0, NULL, 1, 1, 0, 0, 0, 0, 1, 1, 0, 1, 1, 1, N'fa-envelope-o', N'ContactPage.master')
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (61, N'Utente', NULL, N'62, 63', 1, N'Nome', N'Ruolo', N'Testo breve', N'Nota biografica', N'Url principale', N'Foto personale', N'Scadenza', N'Altezza', N'Larghezza', NULL, N'E-mail', N'Codice Fiscale', N'password', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, N'2013-08-23 10:59:00', 0, 1, N'2015-01-29 18:23:00', 0, 1, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (62, N'Impresa (dati completi)', NULL, NULL, 0, N'Nome', N'Geolocazione', N'Testo mappa', N'Testo pagina', N'Sito web', N'Logo azienda', N'Data fondazione', N'Di cui donne ', N'Addetti totali', N'Indirizzo completo', N'e-mail pubblica', N'Partita IVA', N'Telefono e Fax', N'Legale rappresentate (se diverso)', N'Distribuziione quote società', N'Premi e certificazioni', N'Prodotti (frasi separate da ";")', N'Fatturato totale', N'Fatturato con estero', N'Fatturato farnitori in provincia', N'Fatturato fornitori resto regione', N'Fatturato fornitori resto italia', N'Fatturato fornitori resto Europa', N'Fatturato fornitori resto mondo', NULL, 1, N'2013-08-23 11:00:00', 0, 1, N'2015-01-29 18:24:00', 1, 1, 1, 1, 1, 0, 1, 1, 0, 0, 1, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (63, N'Impresa (dati ridotti)', NULL, NULL, 0, N'Nome', N'Geolocazione', N'Testo mappa', N'Testo completo', N'Sito web', N'Logo azienda', N'Scadenza', N'Altezza', N'Larghezza', N'Indirizzo completo', N'e-mail pubblica', N'Partita IVA', N'Telefono e fax', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, N'2013-08-23 11:00:00', 0, 1, N'2015-01-29 18:24:00', 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, 1, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (64, N'Finestra pop-up', N'', N'8', 0, N'Nome', N'Testo bottone', N'Header finestra', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', N'Titolo visualizzato', N'Classe personalizzata', N'', N'', N'Icona ', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 0, N'2016-12-08 07:40:00', 0, 0, N'2015-01-29 18:24:00', 1, 1, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, N'fa-list-alt', N'')
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (65, N'Add to any button', N'<p>Aggiunge automaticamente un men&ugrave; Add to any (<a href="https://www.addtoany.com/" target="_blank">https://www.addtoany.com/</a>) che consente la condivisione della pagine sui principali Social Network ad un menu Bootstrap.</p>

<ul>
	<li><strong>Nome</strong>: Inserisci il nome che ti consentir&agrave; di identificare l&#39;elemento per idividuarlo e modificarlo.</li>
	<li><strong>Titolo mostrato</strong>: Titolo mostrato nel menu.</li>
	<li><strong>Icona font-awesome</strong>: Nome della classe che identifica una icona&nbsp;dell&#39;icon font font-awesome. Ha sempre il formato <code>fa-nomeicona</code>&nbsp;. Se specificato viene utilizzate nel men&ugrave;&nbsp;a cui &egrave; collegata la pagina.</li>
</ul>
', N'', 0, N'Nome', N'', N'Personalizza', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', N'Titolo mostrato', N'', N'', N'', N'Icona (font-awesome)', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 0, N'2016-12-08 06:38:00', 1, 0, N'2015-01-29 18:24:00', 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, N'fa-share-alt', N'')
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (66, N'Parola chiave attività strategica', NULL, N'10', 1, N'Nome', NULL, N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'2013-08-23 11:04:00', 0, 1, N'2015-01-29 18:24:00', 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (67, N'Settore azienda', NULL, N'11', 1, N'Nome', NULL, N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'2013-08-23 12:31:00', 0, 1, N'2015-01-29 18:24:00', 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (68, N'Settore fornitore', NULL, N'12', 1, N'Nome', NULL, N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'2013-08-23 12:31:00', 0, 1, N'2015-01-29 18:24:00', 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (69, N'Settore cliente', N'', N'13', 1, N'Nome', NULL, N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'2013-08-23 12:31:00', 0, 1, N'2015-01-29 18:24:00', 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (70, N'Parola chiave buone prassi', NULL, N'14', 1, N'Nome', NULL, N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'2013-08-23 12:32:00', 0, 1, N'2015-01-29 18:25:00', 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (71, N'Parola chiave punti di forza', NULL, N'15', 1, N'Nome', NULL, N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'2013-08-23 12:33:00', 0, 1, N'2015-01-29 18:25:00', 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (72, N'Parola chiave obiettivi aziendali', NULL, N'16', 1, N'Nome', NULL, N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'2013-08-23 12:33:00', 0, 1, N'2015-01-29 18:25:00', 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (73, N'Parola chiave per identificare l''impresa', NULL, N'17', 1, N'Nome', NULL, N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'2013-08-23 12:34:00', 0, 1, N'2015-01-29 18:25:00', 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (74, N'Lista di distribuzione', N'', N'18', 1, N'Nome', NULL, N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'2013-08-23 12:34:00', 0, 1, N'2015-01-29 18:25:00', 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (75, N'Prerogativa utente', NULL, N'107', 1, N'Nome', NULL, N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Codice', N'Livello', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'2013-08-26 16:23:00', 0, 1, N'2015-01-29 18:25:00', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (76, N'Provincia', NULL, N'146', 1, N'Nome', NULL, N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'2013-09-10 07:57:00', 0, 1, N'2015-01-29 18:25:00', 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (77, N'Messaggio o post', N'', N'', 0, N'Nome', N'', N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', N'Oggetto', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 0, N'2015-01-29 18:35:00', 0, 1, N'2016-08-16 15:23:00', 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, N'fa-envelope-square', N'')
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (78, N'Risposta o commento', N'', N'', 0, N'Nome', N'', N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 0, N'2015-01-29 18:36:00', 0, 1, N'2016-08-16 15:24:00', 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, N'fa-comment-o', N'')
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile])
	VALUES (79, N'Sequenza', N'', N'56', 1, N'Titolo', N'Facebook access key', N'Descrizione breve', N'Testo', N'Url principale', N'Immagine fb', N'Scadenza', N'Altezza', N'Larghezza', N'Titolo mostrato', N'Pagina facebook', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 1, N'2016-11-10 15:45:00', 1, 0, NULL, 1, 1, 1, 1, 0, 0, 1, 0, 0, 1, 1, 0, N'fa-retweet', N'SlideShow.master')
SET IDENTITY_INSERT [dbo].[ANA_CONT_TYPE] OFF

SET LANGUAGE @lang