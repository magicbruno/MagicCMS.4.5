:SETVAR DbName MagicCMS
:SETVAR DbDataPath "N'c:\Program Files\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER_R2\MSSQL\DATA\MagicCMS.mdf'"
:SETVAR DbLogPath "N'c:\Program Files\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER_R2\MSSQL\DATA\MagicCMS_log.ldf'"
:SETVAR AdminEmail "N'bruno@magicbusmultimedia.it'"

USE [master]
GO
/****** Object:  Database [$(DbName)]    Script Date: 07/04/2015 08:14:34 ******/
CREATE DATABASE [$(DbName)] ON  PRIMARY 
( NAME = [$(DbName)], FILENAME = $(DbDataPath) , SIZE = 6016KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = [$(DbName)_log], FILENAME = $(DbLogPath) , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10% )
GO
ALTER DATABASE [$(DbName)] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [$(DbName)].[dbo].[sp_fulltext_database] @action = 'enable'
end
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
ALTER DATABASE [$(DbName)] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [$(DbName)] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [$(DbName)] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [$(DbName)] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [$(DbName)] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [$(DbName)] SET  DISABLE_BROKER 
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
ALTER DATABASE [$(DbName)] SET  MULTI_USER 
GO
ALTER DATABASE [$(DbName)] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [$(DbName)] SET DB_CHAINING OFF 
GO
USE [$(DbName)]
GO
/****** Object:  User [magicAdmin]    Script Date: 07/04/2015 08:14:34 ******/
CREATE USER [magicAdmin] FOR LOGIN [magicAdmin] WITH DEFAULT_SCHEMA=[dbo]
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
CREATE FUNCTION [dbo].[FN_GET_NEWS_ELENCO_TAG]
(
	@ID int = 0
)
RETURNS varchar(4000)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @ResultValue varchar(4000),
			@Tag varchar(256),
			@Flag bit
			
	SET @ResultValue = ''
	SET @Flag = 0
	
	DECLARE NEWS CURSOR FOR
		SELECT Titolo FROM REL_contenuti_Argomenti INNER JOIN
			MB_contenuti ON Id_Argomenti = MB_contenuti.Id
				WHERE Id_Contenuti = @ID


	OPEN NEWS
	FETCH NEXT FROM NEWS
		INTO @Tag
	
	WHILE @@FETCH_STATUS = 0
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
CREATE TABLE [dbo].[_LOG_ANA_AZIONI](
	[act_PK] [int] NOT NULL,
	[act_COMMAND] [varchar](20) NULL,
 CONSTRAINT [PK__LOG_ANA_AZIONI] PRIMARY KEY CLUSTERED 
(
	[act_PK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
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
CREATE TABLE [dbo].[_LOG_REGISTRY](
	[reg_PK] [int] IDENTITY(1,1) NOT NULL,
	[reg_TABELLA] [varchar](50) NULL,
	[reg_RECORD_PK] [int] NULL,
	[reg_act_PK] [int] NULL,
	[reg_user_PK] [int] NULL,
	[reg_ERROR] [varchar](256) NULL,
	[reg_TIMESTAMP] [datetime] NOT NULL,
	[reg_fileName] [nvarchar](1000) NULL,
	[reg_methodName] [nvarchar](1000) NULL,
 CONSTRAINT [PK__LOG_REGISTRY] PRIMARY KEY CLUSTERED 
(
	[reg_PK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ANA_CONT_TYPE]    Script Date: 07/04/2015 08:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ANA_CONT_TYPE](
	[TYP_PK] [int] IDENTITY(1,1) NOT NULL,
	[TYP_NAME] [nvarchar](255) NOT NULL,
	[TYP_HELP] [nvarchar](max) NULL,
	[TYP_ContenutiPreferiti] [nvarchar](1000) NULL,
	[TYP_FlagContenitore] [bit] NOT NULL,
	[TYP_label_Titolo] [nvarchar](100) NOT NULL,
	[TYP_label_ExtraInfo] [nvarchar](100) NULL,
	[TYP_label_TestoBreve] [nvarchar](50) NULL,
	[TYP_label_TestoLungo] [nvarchar](50) NULL,
	[TYP_label_url] [nvarchar](50) NULL,
	[TYP_label_url_secondaria] [nvarchar](50) NULL,
	[TYP_label_scadenza] [nvarchar](50) NULL,
	[TYP_label_altezza] [nvarchar](50) NULL,
	[TYP_label_larghezza] [nvarchar](50) NULL,
	[TYP_label_ExtraInfo_1] [nvarchar](50) NULL,
	[TYP_label_ExtraInfo_2] [nvarchar](50) NULL,
	[TYP_label_ExtraInfo_3] [nvarchar](50) NULL,
	[TYP_label_ExtraInfo_4] [nvarchar](50) NULL,
	[TYP_label_ExtraInfo_5] [nvarchar](50) NULL,
	[TYP_label_ExtraInfo_6] [nvarchar](50) NULL,
	[TYP_label_ExtraInfo_7] [nvarchar](50) NULL,
	[TYP_label_ExtraInfo_8] [nvarchar](50) NULL,
	[TYP_label_ExtraInfoNumber_1] [nvarchar](50) NULL,
	[TYP_label_ExtraInfoNumber_2] [nvarchar](50) NULL,
	[TYP_label_ExtraInfoNumber_3] [nvarchar](50) NULL,
	[TYP_label_ExtraInfoNumber_4] [nvarchar](50) NULL,
	[TYP_label_ExtraInfoNumber_5] [nvarchar](50) NULL,
	[TYP_label_ExtraInfoNumber_6] [nvarchar](50) NULL,
	[TYP_label_ExtraInfoNumber_7] [nvarchar](50) NULL,
	[TYP_label_ExtraInfoNumber_8] [nvarchar](50) NULL,
	[TYP_flag_cercaServer] [bit] NOT NULL,
	[TYP_DataUltimaModifica] [smalldatetime] NULL,
	[TYP_Flag_Attivo] [bit] NOT NULL,
	[TYP_Flag_Cancellazione] [bit] NOT NULL,
	[TYP_Data_Cancellazione] [smalldatetime] NULL,
	[TYP_flag_breve] [bit] NOT NULL,
	[TYP_flag_lungo] [bit] NOT NULL,
	[TYP_flag_link] [bit] NOT NULL,
	[TYP_flag_urlsecondaria] [bit] NOT NULL,
	[TYP_flag_scadenza] [bit] NOT NULL,
	[TYP_flag_specialTag] [bit] NOT NULL,
	[TYP_flag_tags] [bit] NOT NULL,
	[TYP_flag_altezza] [bit] NOT NULL,
	[TYP_flag_larghezza] [bit] NOT NULL,
	[TYP_flag_ExtraInfo] [bit] NOT NULL,
	[TYP_flag_ExtraInfo1] [bit] NOT NULL,
	[TYP_flag_BtnGeolog] [bit] NOT NULL,
	[TYP_Icon] [nvarchar](50) NULL,
	[TYP_MasterPageFile] [nvarchar](256) NULL,
 CONSTRAINT [PK_ANA_CONT_TYPE] PRIMARY KEY CLUSTERED 
(
	[TYP_PK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ANA_Dictionary]    Script Date: 07/04/2015 08:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ANA_Dictionary](
	[DICT_Pk] [int] IDENTITY(1,1) NOT NULL,
	[DICT_Source] [nvarchar](1000) NULL,
	[DICT_LANG_Id] [nvarchar](5) NULL,
	[DICT_Translation] [nvarchar](1000) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ANA_LANGUAGE]    Script Date: 07/04/2015 08:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ANA_LANGUAGE](
	[LANG_Id] [nvarchar](5) NOT NULL,
	[LANG_Name] [nvarchar](50) NULL,
	[LANG_Active] [bit] NOT NULL,
	[LANG_AutoHide] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[LANG_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ANA_PREROGATIVE]    Script Date: 07/04/2015 08:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ANA_PREROGATIVE](
	[pre_PK] [int] NOT NULL,
	[pre_PREROGATIVA] [varchar](20) NULL,
	[pre_LAST_MODIFIED] [datetime] NULL,
 CONSTRAINT [PK_ANA_PREROGATIVE] PRIMARY KEY CLUSTERED 
(
	[pre_PK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ANA_TRANSLATION]    Script Date: 07/04/2015 08:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ANA_TRANSLATION](
	[TRAN_Pk] [int] IDENTITY(1,1) NOT NULL,
	[TRAN_LANG_Id] [nvarchar](5) NOT NULL,
	[TRAN_Title] [nvarchar](1000) NULL,
	[TRAN_TestoBreve] [nvarchar](max) NULL,
	[TRAN_TestoLungo] [nvarchar](max) NULL,
	[TRAN_Tags] [nvarchar](4000) NULL,
	[TRAN_MB_contenuti_Id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[TRAN_Pk] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ANA_USR]    Script Date: 07/04/2015 08:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ANA_USR](
	[usr_PK] [int] IDENTITY(1,1) NOT NULL,
	[usr_EMAIL] [varchar](254) NULL,
	[usr_NAME] [nvarchar](254) NULL,
	[usr_PASSWORD] [nvarchar](200) NULL,
	[usr_LEVEL] [int] NOT NULL,
	[usr_LAST_MODIFIED] [datetime] NULL,
	[usr_PROFILE_PK] [int] NOT NULL,
	[usr_ACTIVE] [bit] NOT NULL,
 CONSTRAINT [PK_ANA_USR] PRIMARY KEY CLUSTERED 
(
	[usr_PK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CONFIG]    Script Date: 07/04/2015 08:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CONFIG](
	[CON_PK] [int] NOT NULL,
	[CON_SinglePage] [bit] NOT NULL,
	[CON_MultiPage] [bit] NOT NULL,
	[CON_TRANS_Auto] [bit] NOT NULL,
	[CON_TRANS_Id] [nvarchar](500) NULL,
	[CON_TRANS_SecretKey] [nvarchar](500) NULL,
	[CON_TRANS_SourceLangId] [nvarchar](10) NOT NULL,
	[CON_TransSourceLangName] [nvarchar](50) NULL,
	[CON_ThemePath] [nvarchar](256) NULL,
	[CON_DefaultContentMaster] [nvarchar](256) NULL,
	[CON_ImagesPath] [nvarchar](256) NULL,
	[CON_DefaultImage] [nvarchar](256) NULL,
	[CON_SMTP_Server] [nvarchar](256) NULL,
	[CON_SMTP_Username] [nvarchar](100) NULL,
	[CON_SMTP_Password] [nvarchar](100) NULL,
	[CON_SMTP_DefaultFromMail] [nvarchar](256) NULL,
	[CON_SMTP_AdminMail] [nvarchar](256) NULL,
	[CON_ga_Property_ID] [nvarchar](20) NULL,
	[CON_NAV_StartPage] [int] NOT NULL,
	[CON_NAV_MainMenu] [int] NOT NULL,
	[CON_NAV_SecondaryMenu] [int] NOT NULL,
	[CON_NAV_FooterMenu] [int] NOT NULL,
	[CON_SiteName] [nvarchar](256) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CON_PK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[IMG_MINIATURE]    Script Date: 07/04/2015 08:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IMG_MINIATURE](
	[IMG_MIN_PK] [int] IDENTITY(1,1) NOT NULL,
	[IMG_MIN_OPATH] [nvarchar](1000) NULL,
	[IMG_MIN_BIN] [varbinary](max) NULL,
	[IMG_MIN_HEIGHT] [int] NOT NULL,
	[IMG_MIN_WIDTH] [int] NOT NULL,
	[IMG_MIN_ODATE_TICKS] [bigint] NOT NULL,
 CONSTRAINT [PK_IMG_MINIATURE] PRIMARY KEY CLUSTERED 
(
	[IMG_MIN_PK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MB_contenuti]    Script Date: 07/04/2015 08:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MB_contenuti](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Titolo] [nvarchar](1000) NULL,
	[Sottotitolo] [nvarchar](1000) NULL,
	[Abstract] [nvarchar](max) NULL,
	[Autore] [nvarchar](1000) NULL,
	[Banner] [nvarchar](max) NULL,
	[Link] [nvarchar](1000) NULL,
	[Larghezza] [int] NOT NULL,
	[Altezza] [int] NOT NULL,
	[Tipo] [int] NULL,
	[Contenuto_parent] [int] NOT NULL,
	[Propietario] [int] NULL,
	[DataPubblicazione] [smalldatetime] NULL,
	[DataScadenza] [smalldatetime] NULL,
	[DataUltimaModifica] [smalldatetime] NULL,
	[Flag_Attivo] [bit] NOT NULL,
	[Flag_Cancellazione] [bit] NOT NULL,
	[Data_Cancellazione] [smalldatetime] NULL,
	[ExtraInfo1] [nvarchar](1000) NULL,
	[ExtraInfo4] [nvarchar](1000) NULL,
	[ExtraInfo3] [nvarchar](1000) NULL,
	[ExtraInfo2] [nvarchar](1000) NULL,
	[ExtraInfo5] [nvarchar](1000) NULL,
	[ExtraInfo6] [nvarchar](1000) NULL,
	[ExtraInfo7] [nvarchar](1000) NULL,
	[ExtraInfo8] [nvarchar](1000) NULL,
	[ExtraInfoNumber1] [numeric](38, 2) NOT NULL,
	[ExtraInfoNumber2] [numeric](38, 2) NOT NULL,
	[ExtraInfoNumber3] [numeric](38, 2) NOT NULL,
	[ExtraInfoNumber4] [numeric](38, 2) NOT NULL,
	[ExtraInfoNumber5] [numeric](38, 2) NOT NULL,
	[ExtraInfoNumber6] [numeric](38, 2) NOT NULL,
	[ExtraInfoNumber7] [numeric](38, 2) NOT NULL,
	[ExtraInfoNumber8] [numeric](38, 2) NOT NULL,
	[Tags] [nvarchar](4000) NULL,
 CONSTRAINT [PK_MB_CONTENUTI] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[REL_contenuti_Argomenti]    Script Date: 07/04/2015 08:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[REL_contenuti_Argomenti](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Id_Contenuti] [int] NOT NULL,
	[Id_Argomenti] [int] NOT NULL,
 CONSTRAINT [PK_REL_contenuti_Argomenti] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY],
 CONSTRAINT [IX_REL_contenuti_Argomenti] UNIQUE NONCLUSTERED 
(
	[Id_Contenuti] ASC,
	[Id_Argomenti] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[REL_INDIRIZZI_SPEDIZIONI]    Script Date: 07/04/2015 08:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[REL_INDIRIZZI_SPEDIZIONI](
	[RIS_MLIST_PK] [uniqueidentifier] NOT NULL,
	[RIS_SPED_PK] [int] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[REL_KEYWORDS]    Script Date: 07/04/2015 08:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[REL_KEYWORDS](
	[key_content_PK] [int] NOT NULL,
	[key_keyword] [nvarchar](1024) NULL,
	[key_langId] [nvarchar](5) NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[REL_MESSAGE_REPL_MESSAGE]    Script Date: 07/04/2015 08:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[REL_MESSAGE_REPL_MESSAGE](
	[REL_REPL_PK] [int] IDENTITY(1,1) NOT NULL,
	[REL_REPL_MESSAGE_PK] [int] NOT NULL,
	[REL_REPL_MESSAGE_REPLTO_PK] [int] NOT NULL,
 CONSTRAINT [PK_REL_MESSAGE_REPL_MESSAGE] PRIMARY KEY CLUSTERED 
(
	[REL_REPL_PK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[REL_MESSAGE_USER_TO]    Script Date: 07/04/2015 08:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[REL_MESSAGE_USER_TO](
	[REL_TOMSG_PK] [int] IDENTITY(1,1) NOT NULL,
	[REL_TOMSG_MESSAGE_PK] [int] NOT NULL,
	[REL_TOMSG_USER_PK] [int] NOT NULL,
 CONSTRAINT [PK_REL_MESSAGE_USER_TO] PRIMARY KEY CLUSTERED 
(
	[REL_TOMSG_PK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[REL_NEWS_SPEDIZIONI]    Script Date: 07/04/2015 08:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[REL_NEWS_SPEDIZIONI](
	[RNS_NEWS_PK] [int] NULL,
	[RNS_SPED_PK] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[STAT_CLICKS]    Script Date: 07/04/2015 08:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[STAT_CLICKS](
	[STAT_CLICKS_PK] [int] IDENTITY(1,1) NOT NULL,
	[STAT_CLICKS_SHOP] [int] NOT NULL,
	[STAT_CLICKS_TARGET] [int] NOT NULL,
	[STAT_CLICKS_CAT] [int] NOT NULL,
	[STAT_CLICKS_URL] [nvarchar](2000) NULL,
	[STAT_CLICKS_DATE] [datetime] NOT NULL,
	[STAT_CLICKS_USER_AGENT] [varchar](512) NULL,
	[STAT_CLICKS_REMOTE_ADDRESS] [varchar](15) NULL,
	[STAT_CLICKS_INTERNAL_LINK] [bit] NOT NULL,
 CONSTRAINT [PK_STAT_CLICKS] PRIMARY KEY CLUSTERED 
(
	[STAT_CLICKS_PK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
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
CREATE TABLE [dbo].[STAT_USER](
	[STAT_USER_PK] [int] NOT NULL,
	[STAT_USER_LOGON] [varchar](20) NOT NULL,
	[STAT_USER_EMAIL] [varchar](256) NULL,
	[STAT_USER_PASSWORD] [varchar](20) NULL,
 CONSTRAINT [PK_STAT_USER] PRIMARY KEY CLUSTERED 
(
	[STAT_USER_PK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[T_ANA_MAILING_LIST]    Script Date: 07/04/2015 08:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_ANA_MAILING_LIST](
	[MLIST_PK] [uniqueidentifier] NOT NULL,
	[MLIST_Address] [nvarchar](256) NULL,
	[MLIST_DataInserimento] [datetime] NULL,
	[MLIST_FlagCancellazione] [bit] NULL,
	[MLIST_DataCancellazione] [datetime] NULL,
	[MLIST_DataRipristino] [datetime] NULL,
 CONSTRAINT [PK_T_ANA_MAILING_LIST] PRIMARY KEY CLUSTERED 
(
	[MLIST_PK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[T_SPEDIZIONI_NL]    Script Date: 07/04/2015 08:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_SPEDIZIONI_NL](
	[SPED_PK] [int] IDENTITY(1,1) NOT NULL,
	[SPED_DATA] [smalldatetime] NULL,
 CONSTRAINT [PK_T_SPEDIZIONI_NL] PRIMARY KEY CLUSTERED 
(
	[SPED_PK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[VOTI]    Script Date: 07/04/2015 08:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[VOTI](
	[Voti_PK] [int] IDENTITY(1,1) NOT NULL,
	[Voti_USER] [varchar](250) NULL,
	[Voti_POST_PK] [int] NULL,
	[Voti_VOTO] [int] NULL,
	[Voti_LastModify] [datetime] NULL
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
	SELECT * 
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
SELECT     at.TRAN_Pk, at.TRAN_Title, at.TRAN_TestoBreve, at.TRAN_TestoLungo, at.TRAN_MB_contenuti_Id, al.LANG_Name, al.LANG_Active
FROM         dbo.ANA_TRANSLATION AS at FULL OUTER JOIN
                      dbo.ANA_LANGUAGE AS al ON al.LANG_Id = at.TRAN_LANG_Id
WHERE     (al.LANG_Active = 1)

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
                      dbo.REL_contenuti_Argomenti.Id_Contenuti, MB_contenuti_1.Titolo AS VA_titolo, REL_contenuti_Argomenti_1.Id_Contenuti AS VA_id, 
                      REL_contenuti_Argomenti_1.Id_Argomenti, MB_contenuti_1.DataPubblicazione, MB_contenuti_1.Tipo AS VA_Tipo
FROM         dbo.REL_contenuti_Argomenti AS REL_contenuti_Argomenti_1 INNER JOIN
                      dbo.REL_contenuti_Argomenti ON REL_contenuti_Argomenti_1.Id_Argomenti = dbo.REL_contenuti_Argomenti.Id_Argomenti INNER JOIN
                      dbo.MB_contenuti AS MB_contenuti_1 ON REL_contenuti_Argomenti_1.Id_Contenuti = MB_contenuti_1.Id INNER JOIN
                      dbo.ANA_CONT_TYPE ON MB_contenuti_1.Tipo = dbo.ANA_CONT_TYPE.TYP_PK
WHERE     (dbo.ANA_CONT_TYPE.TYP_FlagContenitore = 0) OR
                      (MB_contenuti_1.Tipo = 29)

GO
/****** Object:  View [dbo].[VW_NEWS_NEWSLETTER]    Script Date: 07/04/2015 08:14:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VW_NEWS_NEWSLETTER]
AS
SELECT     TOP (100) PERCENT dbo.MB_contenuti.Id, dbo.MB_contenuti.Titolo, dbo.MB_contenuti.Abstract, dbo.MB_contenuti.Banner, dbo.MB_contenuti.Tipo, 
                      dbo.MB_contenuti.Contenuto_parent, dbo.MB_contenuti.DataPubblicazione, dbo.MB_contenuti.DataScadenza
FROM         dbo.MB_contenuti INNER JOIN
                      dbo.REL_contenuti_Argomenti ON dbo.MB_contenuti.Id = dbo.REL_contenuti_Argomenti.Id_Contenuti INNER JOIN
                      dbo.MB_contenuti AS MB_contenuti_1 ON dbo.REL_contenuti_Argomenti.Id_Argomenti = MB_contenuti_1.Id
WHERE     (MB_contenuti_1.Titolo = N'Newsletter') AND (dbo.MB_contenuti.DataScadenza > GETDATE()) AND (dbo.MB_contenuti.Flag_Cancellazione = 0) OR
                      (MB_contenuti_1.Titolo = N'Newsletter') AND (dbo.MB_contenuti.DataScadenza IS NULL) AND (dbo.MB_contenuti.Flag_Cancellazione = 0)
ORDER BY dbo.MB_contenuti.DataPubblicazione DESC

GO
ALTER TABLE [dbo].[_LOG_REGISTRY] ADD  DEFAULT (getdate()) FOR [reg_TIMESTAMP]
GO
ALTER TABLE [dbo].[ANA_CONT_TYPE] ADD  DEFAULT ('New content type') FOR [TYP_NAME]
GO
ALTER TABLE [dbo].[ANA_CONT_TYPE] ADD  DEFAULT ((0)) FOR [TYP_FlagContenitore]
GO
ALTER TABLE [dbo].[ANA_CONT_TYPE] ADD  DEFAULT ('Nome') FOR [TYP_label_Titolo]
GO
ALTER TABLE [dbo].[ANA_CONT_TYPE] ADD  DEFAULT ('Testo breve') FOR [TYP_label_TestoBreve]
GO
ALTER TABLE [dbo].[ANA_CONT_TYPE] ADD  DEFAULT ('Testo completo') FOR [TYP_label_TestoLungo]
GO
ALTER TABLE [dbo].[ANA_CONT_TYPE] ADD  DEFAULT ('Url principale') FOR [TYP_label_url]
GO
ALTER TABLE [dbo].[ANA_CONT_TYPE] ADD  DEFAULT ('Ulr secondaria') FOR [TYP_label_url_secondaria]
GO
ALTER TABLE [dbo].[ANA_CONT_TYPE] ADD  DEFAULT ('Scadenza') FOR [TYP_label_scadenza]
GO
ALTER TABLE [dbo].[ANA_CONT_TYPE] ADD  DEFAULT ('Altezza') FOR [TYP_label_altezza]
GO
ALTER TABLE [dbo].[ANA_CONT_TYPE] ADD  DEFAULT ('Larghezza') FOR [TYP_label_larghezza]
GO
ALTER TABLE [dbo].[ANA_CONT_TYPE] ADD  DEFAULT ((0)) FOR [TYP_flag_cercaServer]
GO
ALTER TABLE [dbo].[ANA_CONT_TYPE] ADD  DEFAULT (getdate()) FOR [TYP_DataUltimaModifica]
GO
ALTER TABLE [dbo].[ANA_CONT_TYPE] ADD  DEFAULT ((1)) FOR [TYP_Flag_Attivo]
GO
ALTER TABLE [dbo].[ANA_CONT_TYPE] ADD  DEFAULT ((0)) FOR [TYP_Flag_Cancellazione]
GO
ALTER TABLE [dbo].[ANA_CONT_TYPE] ADD  DEFAULT ((1)) FOR [TYP_flag_breve]
GO
ALTER TABLE [dbo].[ANA_CONT_TYPE] ADD  DEFAULT ((1)) FOR [TYP_flag_lungo]
GO
ALTER TABLE [dbo].[ANA_CONT_TYPE] ADD  DEFAULT ((1)) FOR [TYP_flag_link]
GO
ALTER TABLE [dbo].[ANA_CONT_TYPE] ADD  DEFAULT ((1)) FOR [TYP_flag_urlsecondaria]
GO
ALTER TABLE [dbo].[ANA_CONT_TYPE] ADD  DEFAULT ((0)) FOR [TYP_flag_scadenza]
GO
ALTER TABLE [dbo].[ANA_CONT_TYPE] ADD  DEFAULT ((0)) FOR [TYP_flag_specialTag]
GO
ALTER TABLE [dbo].[ANA_CONT_TYPE] ADD  DEFAULT ((1)) FOR [TYP_flag_tags]
GO
ALTER TABLE [dbo].[ANA_CONT_TYPE] ADD  DEFAULT ((0)) FOR [TYP_flag_altezza]
GO
ALTER TABLE [dbo].[ANA_CONT_TYPE] ADD  DEFAULT ((0)) FOR [TYP_flag_larghezza]
GO
ALTER TABLE [dbo].[ANA_CONT_TYPE] ADD  DEFAULT ((0)) FOR [TYP_flag_ExtraInfo]
GO
ALTER TABLE [dbo].[ANA_CONT_TYPE] ADD  DEFAULT ((0)) FOR [TYP_flag_ExtraInfo1]
GO
ALTER TABLE [dbo].[ANA_CONT_TYPE] ADD  DEFAULT ((0)) FOR [TYP_flag_BtnGeolog]
GO
ALTER TABLE [dbo].[ANA_LANGUAGE] ADD  DEFAULT ((1)) FOR [LANG_Active]
GO
ALTER TABLE [dbo].[ANA_LANGUAGE] ADD  DEFAULT ((0)) FOR [LANG_AutoHide]
GO
ALTER TABLE [dbo].[ANA_PREROGATIVE] ADD  CONSTRAINT [DF_ANA_PREROGATIVE_pre_LAST_MODIFIED]  DEFAULT (getdate()) FOR [pre_LAST_MODIFIED]
GO
ALTER TABLE [dbo].[ANA_USR] ADD  CONSTRAINT [DF_ANA_USR_usr_LEVEL]  DEFAULT ((0)) FOR [usr_LEVEL]
GO
ALTER TABLE [dbo].[ANA_USR] ADD  CONSTRAINT [DF_ANA_USR_usr_LAST_MODIFIED]  DEFAULT (getdate()) FOR [usr_LAST_MODIFIED]
GO
ALTER TABLE [dbo].[ANA_USR] ADD  DEFAULT ((0)) FOR [usr_PROFILE_PK]
GO
ALTER TABLE [dbo].[ANA_USR] ADD  DEFAULT ((1)) FOR [usr_ACTIVE]
GO
ALTER TABLE [dbo].[CONFIG] ADD  DEFAULT ((0)) FOR [CON_SinglePage]
GO
ALTER TABLE [dbo].[CONFIG] ADD  DEFAULT ((1)) FOR [CON_MultiPage]
GO
ALTER TABLE [dbo].[CONFIG] ADD  DEFAULT ((1)) FOR [CON_TRANS_Auto]
GO
ALTER TABLE [dbo].[CONFIG] ADD  DEFAULT ('it') FOR [CON_TRANS_SourceLangId]
GO
ALTER TABLE [dbo].[CONFIG] ADD  DEFAULT ((0)) FOR [CON_NAV_StartPage]
GO
ALTER TABLE [dbo].[CONFIG] ADD  DEFAULT ((0)) FOR [CON_NAV_MainMenu]
GO
ALTER TABLE [dbo].[CONFIG] ADD  DEFAULT ((0)) FOR [CON_NAV_SecondaryMenu]
GO
ALTER TABLE [dbo].[CONFIG] ADD  DEFAULT ((0)) FOR [CON_NAV_FooterMenu]
GO
ALTER TABLE [dbo].[CONFIG] ADD  CONSTRAINT [DF_CONFIG_CON_SiteName]  DEFAULT (N'MagicCMS Site') FOR [CON_SiteName]
GO
ALTER TABLE [dbo].[IMG_MINIATURE] ADD  CONSTRAINT [DF_IMG_MINIATURE_IMG_MIN_HEIGHT]  DEFAULT ((0)) FOR [IMG_MIN_HEIGHT]
GO
ALTER TABLE [dbo].[IMG_MINIATURE] ADD  CONSTRAINT [DF_IMG_MINIATURE_IMG_MIN_WIDTH]  DEFAULT ((0)) FOR [IMG_MIN_WIDTH]
GO
ALTER TABLE [dbo].[IMG_MINIATURE] ADD  CONSTRAINT [DF_IMG_MINIATURE_IMG_MIN_ODATE_TICKS]  DEFAULT ((0)) FOR [IMG_MIN_ODATE_TICKS]
GO
ALTER TABLE [dbo].[MB_contenuti] ADD  CONSTRAINT [DF_MB_contenuti_Larghezza]  DEFAULT ((0)) FOR [Larghezza]
GO
ALTER TABLE [dbo].[MB_contenuti] ADD  CONSTRAINT [DF_MB_contenuti_Altezza]  DEFAULT ((0)) FOR [Altezza]
GO
ALTER TABLE [dbo].[MB_contenuti] ADD  CONSTRAINT [DF_MB_contenuti_Contenuto_parent]  DEFAULT ((0)) FOR [Contenuto_parent]
GO
ALTER TABLE [dbo].[MB_contenuti] ADD  CONSTRAINT [DF_MB_CONTENUTI_Flag_Attivo]  DEFAULT ((1)) FOR [Flag_Attivo]
GO
ALTER TABLE [dbo].[MB_contenuti] ADD  CONSTRAINT [DF_MB_CONTENUTI_Flag_Cancellazione]  DEFAULT ((0)) FOR [Flag_Cancellazione]
GO
ALTER TABLE [dbo].[MB_contenuti] ADD  CONSTRAINT [DF_MB_contenuti_ExtraInfoNumber1]  DEFAULT ((0)) FOR [ExtraInfoNumber1]
GO
ALTER TABLE [dbo].[MB_contenuti] ADD  CONSTRAINT [DF_MB_contenuti_ExtraInfoNumber2]  DEFAULT ((0)) FOR [ExtraInfoNumber2]
GO
ALTER TABLE [dbo].[MB_contenuti] ADD  CONSTRAINT [DF_MB_contenuti_ExtraInfoNumber3]  DEFAULT ((0)) FOR [ExtraInfoNumber3]
GO
ALTER TABLE [dbo].[MB_contenuti] ADD  CONSTRAINT [DF_MB_contenuti_ExtraInfoNumber4]  DEFAULT ((0)) FOR [ExtraInfoNumber4]
GO
ALTER TABLE [dbo].[MB_contenuti] ADD  CONSTRAINT [DF_MB_contenuti_ExtraInfoNumber5]  DEFAULT ((0)) FOR [ExtraInfoNumber5]
GO
ALTER TABLE [dbo].[MB_contenuti] ADD  CONSTRAINT [DF_MB_contenuti_ExtraInfoNumber6]  DEFAULT ((0)) FOR [ExtraInfoNumber6]
GO
ALTER TABLE [dbo].[MB_contenuti] ADD  CONSTRAINT [DF_MB_contenuti_ExtraInfoNumber7]  DEFAULT ((0)) FOR [ExtraInfoNumber7]
GO
ALTER TABLE [dbo].[MB_contenuti] ADD  CONSTRAINT [DF_MB_contenuti_ExtraInfoNumber8]  DEFAULT ((0)) FOR [ExtraInfoNumber8]
GO
ALTER TABLE [dbo].[REL_KEYWORDS] ADD  DEFAULT ('it') FOR [key_langId]
GO
ALTER TABLE [dbo].[REL_MESSAGE_REPL_MESSAGE] ADD  CONSTRAINT [DF_REL_MESSAGE_REPL_MESSAGE_REL_MESSAGE_PK]  DEFAULT ((0)) FOR [REL_REPL_MESSAGE_PK]
GO
ALTER TABLE [dbo].[REL_MESSAGE_REPL_MESSAGE] ADD  CONSTRAINT [DF_REL_MESSAGE_REPL_MESSAGE_REL_MESSAGE_REPLTO_PK]  DEFAULT ((0)) FOR [REL_REPL_MESSAGE_REPLTO_PK]
GO
ALTER TABLE [dbo].[REL_MESSAGE_USER_TO] ADD  CONSTRAINT [DF_REL_MESSAGE_USER_TO_REL_TOMSG_MESSAGE_PK]  DEFAULT ((0)) FOR [REL_TOMSG_MESSAGE_PK]
GO
ALTER TABLE [dbo].[REL_MESSAGE_USER_TO] ADD  CONSTRAINT [DF_REL_MESSAGE_USER_TO_REL_TOMSG_USER_PK]  DEFAULT ((0)) FOR [REL_TOMSG_USER_PK]
GO
ALTER TABLE [dbo].[STAT_CLICKS] ADD  CONSTRAINT [DF_STAT_CLICKS_STAT_CLICKS_SHOP]  DEFAULT ((0)) FOR [STAT_CLICKS_SHOP]
GO
ALTER TABLE [dbo].[STAT_CLICKS] ADD  CONSTRAINT [DF_STAT_CLICKS_STAT_CLICKS_TARGET]  DEFAULT ((0)) FOR [STAT_CLICKS_TARGET]
GO
ALTER TABLE [dbo].[STAT_CLICKS] ADD  CONSTRAINT [DF_STAT_CLICKS_STAT_CLICKS_CAT]  DEFAULT ((0)) FOR [STAT_CLICKS_CAT]
GO
ALTER TABLE [dbo].[STAT_CLICKS] ADD  CONSTRAINT [DF_STAT_CLICKS_STAT_CLICKS_DATE]  DEFAULT (getdate()) FOR [STAT_CLICKS_DATE]
GO
ALTER TABLE [dbo].[STAT_CLICKS] ADD  CONSTRAINT [DF_STAT_CLICKS_STAT_CLICKS_INTERNAL_LINK]  DEFAULT ((0)) FOR [STAT_CLICKS_INTERNAL_LINK]
GO
ALTER TABLE [dbo].[STAT_USER] ADD  CONSTRAINT [DF_STAT_USER_STAT_USER_LOGON]  DEFAULT (N'Sconosciuto') FOR [STAT_USER_LOGON]
GO
ALTER TABLE [dbo].[T_ANA_MAILING_LIST] ADD  CONSTRAINT [DF_T_ANA_MAILING_LIST_MLIST_PK]  DEFAULT (newid()) FOR [MLIST_PK]
GO
ALTER TABLE [dbo].[T_ANA_MAILING_LIST] ADD  CONSTRAINT [DF_T_ANA_MAILING_LIST_MLIST_DataInserimento]  DEFAULT (getdate()) FOR [MLIST_DataInserimento]
GO
ALTER TABLE [dbo].[T_ANA_MAILING_LIST] ADD  CONSTRAINT [DF_T_ANA_MAILING_LIST_MLIST_FlagCancellazione]  DEFAULT ((0)) FOR [MLIST_FlagCancellazione]
GO
ALTER TABLE [dbo].[T_SPEDIZIONI_NL] ADD  CONSTRAINT [DF_T_SPEDIZIONI_NL_SPED_DATA]  DEFAULT (getdate()) FOR [SPED_DATA]
GO
ALTER TABLE [dbo].[REL_INDIRIZZI_SPEDIZIONI]  WITH CHECK ADD  CONSTRAINT [FK_REL_INDIRIZZI_SPEDIZIONI_T_ANA_MAILING_LIST] FOREIGN KEY([RIS_MLIST_PK])
REFERENCES [dbo].[T_ANA_MAILING_LIST] ([MLIST_PK])
GO
ALTER TABLE [dbo].[REL_INDIRIZZI_SPEDIZIONI] CHECK CONSTRAINT [FK_REL_INDIRIZZI_SPEDIZIONI_T_ANA_MAILING_LIST]
GO
ALTER TABLE [dbo].[REL_INDIRIZZI_SPEDIZIONI]  WITH CHECK ADD  CONSTRAINT [FK_REL_INDIRIZZI_SPEDIZIONI_T_SPEDIZIONI_NL] FOREIGN KEY([RIS_SPED_PK])
REFERENCES [dbo].[T_SPEDIZIONI_NL] ([SPED_PK])
GO
ALTER TABLE [dbo].[REL_INDIRIZZI_SPEDIZIONI] CHECK CONSTRAINT [FK_REL_INDIRIZZI_SPEDIZIONI_T_SPEDIZIONI_NL]
GO
ALTER TABLE [dbo].[REL_NEWS_SPEDIZIONI]  WITH CHECK ADD  CONSTRAINT [FK_REL_NEWS_SPEDIZIONI_MB_contenuti] FOREIGN KEY([RNS_NEWS_PK])
REFERENCES [dbo].[MB_contenuti] ([Id])
GO
ALTER TABLE [dbo].[REL_NEWS_SPEDIZIONI] CHECK CONSTRAINT [FK_REL_NEWS_SPEDIZIONI_MB_contenuti]
GO
ALTER TABLE [dbo].[REL_NEWS_SPEDIZIONI]  WITH CHECK ADD  CONSTRAINT [FK_REL_NEWS_SPEDIZIONI_T_SPEDIZIONI_NL] FOREIGN KEY([RNS_SPED_PK])
REFERENCES [dbo].[T_SPEDIZIONI_NL] ([SPED_PK])
GO
ALTER TABLE [dbo].[REL_NEWS_SPEDIZIONI] CHECK CONSTRAINT [FK_REL_NEWS_SPEDIZIONI_T_SPEDIZIONI_NL]
GO
EXEC [$(DbName)].sys.sp_addextendedproperty @name=N'MagicCMS_version', @value=N'3.0' 
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VW_ANA_TRANSLATION_BLANK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VW_ANA_TRANSLATION_BLANK'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VW_MB_contenuti_attivi'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VW_MB_contenuti_attivi'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VW_MB_ContenutiSibling'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VW_MB_ContenutiSibling'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VW_NEWS_NEWSLETTER'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'VW_NEWS_NEWSLETTER'
GO
USE [master]
GO
ALTER DATABASE [$(DbName)] SET  READ_WRITE 
GO
USE [$(DbName)]
GO

SET LANGUAGE us_english

INSERT [dbo].[_LOG_ANA_AZIONI] ([act_PK], [act_COMMAND]) VALUES (0, N'DELETE')
INSERT [dbo].[_LOG_ANA_AZIONI] ([act_PK], [act_COMMAND]) VALUES (1, N'INSERT')
INSERT [dbo].[_LOG_ANA_AZIONI] ([act_PK], [act_COMMAND]) VALUES (2, N'UPDATE')
INSERT [dbo].[_LOG_ANA_AZIONI] ([act_PK], [act_COMMAND]) VALUES (3, N'READ')
SET IDENTITY_INSERT [dbo].[ANA_CONT_TYPE] ON 

INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (1, N'Pagina standard', N'<p>Pagina standard.&nbsp;</p>

<ul>
	<li><strong>Titolo</strong>: Inserire il titolo della pagina</li>
	<li><strong>Testo lungo</strong>: Inserire il testo della pagina</li>
</ul>
', N'', 0, N'Nome', N'cliente', N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', N'Titolo mostrato', N'', N'', N'', N'Classe icona', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 1, N'2015-02-08 09:52:00', 1, 0, NULL, 1, 1, 1, 1, 0, 0, 1, 0, 0, 0, 1, 0, N'fa-file-text-o', N'StandardPage.master')
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (2, N'Pagina con video', N'<p>	Pagina che contiene un video embedded da altro sito (You Tube o altro provider di video).&nbsp;Utilizza, se previsto dal tema il gruppo di pannelli di default.</p>', N'33', 1, N'Nome', N'youtube id', N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, N'2011-03-20 08:25:00', 0, 1, N'2015-01-29 16:34:00', 1, 1, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (3, N'Pagina con loader multimediale', N'Pagina che contiene risorsa multimediale (Animazione flash, Immagine ,jpg. .gif o .png) caricata con loader.', NULL, 0, N'Nome', N'cliente', N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, N'2010-04-13 12:10:00', 0, 1, N'2012-02-09 16:46:00', 1, 1, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (4, N'Comingsoon page', N'', N'', 0, N'Nome', N'', N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 1, N'2015-11-06 16:13:00', 1, 1, N'2015-11-07 10:15:00', 0, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, N'fa-clock-o', N'ComingSoon.master')
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (5, N'Progetti di oggi', NULL, NULL, 0, N'Nome', NULL, N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'2007-08-22 17:32:00', 1, 1, N'2008-11-27 15:33:00', 1, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (6, N'Questionari', NULL, NULL, 0, N'Nome', NULL, N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'2007-09-04 15:06:00', 1, 1, N'2008-11-27 15:33:00', 1, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (8, N'Ricerche e pubblicazioni', N'', NULL, 0, N'Nome', NULL, N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'2007-10-25 10:07:00', 1, 1, N'2008-11-27 15:33:00', 1, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (9, N'FAD E CORSI D''AULA', N'Corsi di formazione a distanza che Ecipar ha predisposto per te.', NULL, 0, N'Nome', NULL, N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'2008-02-26 16:35:00', 1, 1, N'2008-11-27 15:33:00', 1, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (10, N'Coomingsoon Page', N'', N'', 0, N'Nome', N'', N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', N'Titolo mostrato', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 1, N'2015-11-07 09:58:00', 1, 0, N'2008-11-27 15:33:00', 1, 1, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, N'fa-file-text-o', N'ComingSoon.master')
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (11, N'Repertori', N'Repertori Regionali delle Imprese Femminili Eccellenti', NULL, 0, N'Nome', NULL, N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'2008-10-21 10:16:00', 1, 1, N'2008-11-27 15:33:00', 1, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (12, N'Video', N'Video ''Embedded'' (YouTube o altra risorsa) o ''Linked'' da qualsiasi url.', NULL, 0, N'Nome', NULL, N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'2008-10-17 17:23:00', 1, 1, N'2008-11-27 15:33:00', 1, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (13, N'Argomento', N'<p>Raggruppa pi&ugrave; pagine o argomenti. Simile ai tag consente di inserire iun testo di introduzione e di aggiungere pannelli..&nbsp;</p>

<p><strong>Tipo ordinamento</strong> consente di personalizzire l&#39;ordinamento con cui vengono mostrati gli elementi contenuti. I valori validi sono:</p>

<ul>
	<li>DATA ASC (per data ascendente)</li>
	<li>ASC (secondo il valore contenuto nel campo Rilevanza acendente)</li>
	<li>DATA DESC (per data discendente)</li>
	<li>DESC (secondo il valore contenuto nel campo Rilevanza discendente)</li>
</ul>
', N'', 1, N'Nome', N'tipo ordinamento', N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', N'', N'Preferiti (lista di tipi separati da virgole)', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 1, N'2015-02-04 12:28:00', 0, 0, NULL, 1, 1, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, N'fa-folder', N'Categoria.master')
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (14, N'Argomento con iframe', N'Argomento con inserimento di risorse esterna all''interno della pagina. ', NULL, 1, N'Nome', NULL, N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'2011-03-19 10:20:00', 0, 1, N'2011-03-19 10:21:00', 1, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (15, N'Menu', N'<p>Voce di menu. Per definire il men&ugrave; principale dare al campo rilevanza un valore minore a quello di tutti gli altri menu.</p>

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
', N'', 1, N'Nome', N'Tipo ordinamento', N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', N'Titolo mostrato', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 0, N'2015-02-11 19:32:00', 1, 0, NULL, 1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 0, N'fa-th-list', N'')
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (17, N'Collegamento Internet', N'<p>Link esterno con possibile commento.</p>

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
', N'', 0, N'Nome', N'Target', N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', N'Titolo mostrato', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 1, N'2015-02-21 17:36:00', 1, 0, NULL, 1, 0, 1, 1, 0, 0, 1, 0, 0, 1, 1, 0, N'fa-external-link-square', N'')
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (20, N'Collegamento a una pagina interna', N'<p>Link ad una pagina interna con possibile commento.</p>

<ul>
	<li>Utilizzare il campo <strong>Identificativo pagina</strong> per inserire l&#39;id (un numero) o il titolo della pagina. In caso di pagine con titolo uguale verr&agrave; privilegiata la prima in ordinamento o (se uguali) la pi&ugrave; recente.</li>
	<li>Si pu&ograve; usare l&#39;url secondaria per definire un&#39;icona personalizzata del sito altrimenti, se previsto dal tema ne verr&agrave; utilizzata una di default.</li>
</ul>
', N'', 0, N'Nome', N'identificativo pagina o "auto"', N'Testo breve', N'Testo completo', N'Url', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', N'Titolo mostrato', N'Tipo di risorsa', N'Classe link', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 1, N'2015-02-04 17:21:00', 1, 0, NULL, 1, 0, 1, 1, 0, 0, 1, 0, 0, 1, 1, 0, N'fa-link', N'')
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (24, N'Radiodramma', N'', NULL, 0, N'Nome', NULL, N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, N'2010-04-13 14:09:00', 1, 1, N'2011-03-19 10:22:00', 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (25, N'Documento scaricabile', N'<p>Questo elemento consente di inserire un documento scaricabile che potr&agrave; essere inserito in un pannello o nella pagina download</p>

<ul>
	<li><strong>Titolo </strong>(obbligatorio): Titolo del file. Testo sensibiule cliccando il quale si potr&agrave; scaricare il documento. Le icone vengono aggiunte automaticamente dal sistema sulla base dell&#39;estensione del file.</li>
	<li><strong>Url</strong>: Indirizzo fisico del file. Utilizzando il pulsante cerca sul server &egrave; possibile sfogliare i documenti gi&agrave; presenti e caricarne di nuovi.</li>
	<li><strong>Rilevanza</strong>: Indica l&#39;ordine con cui la risorsa &egrave; collocata nell&#39;elemento che la contiene.</li>
	<li><strong>Testo breve</strong>: Breve descrizione che viene aggiunta sotto il titolo.</li>
</ul>

<p>&nbsp;</p>
', N'', 0, N'Nome', N'Sottotitolo', N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', N'Testo del link', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 1, N'2015-01-29 17:14:00', 1, 0, NULL, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, N'fa-download', N'')
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (28, N'Bottone lingua', N'', N'', 0, N'Nome', N'Lingua', N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', N'Testo mostrato', N'Classe css', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 1, N'2015-02-10 18:20:00', 1, 0, N'2010-04-13 08:02:00', 1, 0, 0, 1, 0, 0, 0, 1, 1, 1, 1, 0, N'fa-language', N'')
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (29, N'Pannello automatico', N'<p>Questo elemento organizza le risorse di un determinato tipo&nbsp;collegate ad una pagina (video, immagini, filmati flash, documenti scalicabili, link interni ed esterni) in un pannello a cui &egrave; possibile dare un titolo.</p>

<ul>
	<li><strong>Titolo </strong>(obbligatorio): Titolo del pannello. Viene visualizzato nella pagina che la contiene.</li>
	<li><strong>Rilevanza</strong>: Indica l&#39;ordine con cui la risorsa &egrave; collocata nell&#39;elemento che la contiene (ad esampio in un gruppo di pannelli).</li>
	<li><b>dimensioni:</b> dimensioni delle miniature create automaticamente (solo per immagini, video e filmati flash)</li>
	<li><strong>Tipi di risorsa da ricercare</strong>:: il tipo o i tipi di risrsa collegati alla pagina corrente che verranno visualizzati nel pannello. Si devono inserire uno o p&ugrave; numeri interi secondo questa tabella:
	<div>Collegamento Interno =&gt; 20;</div>

	<div>Collegamento Internet =&gt; 17;</div>

	<div>Documento Scaricabile =&gt; &nbsp;25;</div>

	<div>FilmatoFlash =&gt; &nbsp;32;</div>

	<div>Immagine &nbsp;=&gt; 30;</div>

	<div>Video In Galleria =&gt; 33;</div>

	<div>&nbsp;</div>
	</li>
</ul>
', N'17, 20, 25, 30, 32, 33', 0, N'Nome', N'Tipo di risorsa', N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', N'Titolo mostrato (HTML)', N'Categoria (tag)', N'Sottocategoria', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 1, N'2015-01-29 17:19:00', 0, 0, NULL, 1, 0, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, N'fa-cogs', N'')
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (30, N'Immagine', N'<p>Questo elemento consente di inserire un&#39;immagine&nbsp;in una o in un progetto galleria. Cliccando la miniatura l&#39;immagine viene visualizzata in una fancybox</p>

<ul>
	<li><strong>Titolo </strong>(obbligatorio): Non visualizzato</li>
	<li><strong>Url</strong>: Indirizzo fisico del file. Utilizzando il pulsante cerca sul server &egrave; possibile sfogliare le immagini gi&agrave; presenti e caricarne di nuove.</li>
	<li><strong>Url secondaria</strong>: Consente di personalizzare la miniatura associata all&#39;immagini che altrimenti viene generata automaticamente dal sistema.. Utilizzando il pulsante cerca sul server &egrave; possibile sfogliare le immagini gi&agrave; presenti e caricarne di nuove.</li>
	<li><strong>Rilevanza</strong>: Indica l&#39;ordine con cui la risorsa &egrave; collocata nell&#39;elemento che la contiene.</li>
	<li><strong>Testo breve</strong>: Breve descrizione che viene visualizzata nella light box.</li>
</ul>

<p>NB: Le immagini devono essere collegate ad una galleria utilizzando il pannello collegamenti.</p>
', N'', 0, N'Nome', N'Testo alternativo/Titolo', N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', N'Titolo mostrato', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 1, N'2015-03-15 00:02:00', 1, 0, NULL, 1, 0, 1, 1, 0, 0, 1, 0, 0, 1, 1, 0, N'fa-image', N'Image.master')
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (31, N'Pagina con pannelli personalizzati', N'<p>Come la pagina standard ma con la possibilit&agrave; di aggiungere pannelli personalizzati.&nbsp;</p>
', N'', 1, N'Nome', N'', N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', N'Titolo mostrato', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 1, N'2015-02-10 18:06:00', 0, 0, N'2015-01-29 16:36:00', 1, 1, 1, 1, 0, 0, 1, 0, 0, 0, 1, 0, N'fa-file-text', N'')
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (32, N'Filmato flash', N'<p>	La pagina consente un collegamento diretto ad un fimato flash che si apre in una fancybox. Il filmato pu&ograve; essere inserito in un pannello.</p><ul>	<li>		<strong>Titolo </strong>(obbligatorio)</li>	<li>		<strong>Url</strong>: Indirizzo fisico del filmato.</li>	<li>		<strong>Rilevanza</strong>: Indica l&#39;ordine con cui la risorsa &egrave; collocata nell&#39;elemento che la contiene.</li>	<li>		<strong>Url secondario</strong>: Thumbnail</li></ul>', NULL, 0, N'Nome', N'Codice action script', N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, N'2011-03-20 09:38:00', 0, 1, N'2015-01-29 16:36:00', 1, 0, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (33, N'Video in galleria', N'<p>Questo elemento consente di incorporare un video fornito da You Tube in una fancybox. Basta inserire l&#39;ID youtube del video.</p>

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
', N'', 0, N'Nome', N'yuotube id', N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 0, N'2015-01-29 17:20:00', 1, 0, NULL, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, N'fa-video-camera', N'')
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (34, N'Pagina Multitab', N'<p> 	Contenitore di pi&ugrave; pagine con tab. Usato nella sezione CF&amp;L I nostri numeri.</p> ', N'35', 1, N'Nome', NULL, N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'2011-05-05 09:17:00', 0, 1, N'2012-02-09 22:56:00', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (35, N'Pagina con Tabs', N'<p> 	Contenitore di &nbsp;tab. Usato nella sezione CF&amp;L I nostri numeri.</p> <ul> 	<li> 		Titolo (obbligatorio): Testo che viene visualizzato nei pulsanti che consente ai gruppi di tab.</li> </ul> ', N'36', 1, N'Nome', NULL, N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'2011-05-05 09:17:00', 0, 1, N'2012-02-09 22:57:00', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (36, N'Tab Ajax', N'<p> 	Tab il cui contenuto viene caricato dinamicamente. Usato nella sezione CF&amp;L I nostri numeri. Elementi modificabili;</p> <ul> 	<li> 		<strong>Titolo </strong>(obbligatorio): testo che da il nome al tab</li> 	<li> 		<strong>Rilevanza:</strong>&nbsp;Ordine dei tab.</li> 	<li> 		<strong>Testo breve</strong>: commento ai dati</li> </ul> ', NULL, 0, N'Nome', NULL, N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'2011-05-05 09:18:00', 0, 1, N'2012-02-09 22:57:00', 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (37, N'Categoria', N'<p>Parola chiave/categoria a cui possono essere associate le pagine.&nbsp;</p>

<ul>
	<li><strong>Titolo</strong> (obbligatorio)</li>
	<li><strong>Url secondaria</strong>: eventuale immagine associata al tag</li>
	<li><strong>Rilevanza</strong>: Indica l&#39;ordine con cui la risorsa &egrave; collocata nell&#39;elemento che la contiene.</li>
</ul>
', N'', 1, N'Nome', N'Tipo ordinamento', N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', N'', N'Preferiti (lista di tipi separati da virgole)', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 1, N'2015-02-10 08:36:00', 1, 0, NULL, 1, 0, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0, N'fa-certificate', N'Categoria.master')
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (38, N'News', N'<p>Questo elemento consente di inserire un notizia.</p>

<ul>
	<li><strong>Titolo </strong>(obbligatorio): Viene visualizzato negli elenchi di notizie..</li>
	<li><strong>Data di pubblicazione</strong>: La data. Le news sono ordinate in ordine inverso rispetto a questa data (prima le pi&ugrave; recenti).</li>
	<li><strong>Data di scadenza</strong>:&nbsp;Data dopo la quale la news non appare pi&ugrave; negli elenchi</li>
	<li><strong>Url secondaria</strong>: Scegli un immagine da associare alla news (NB. Alla news possono essere anche associae gallerie)</li>
	<li><strong>Rilevanza</strong>: Determina l&#39;rdine dellle news che hanno la stessa data.</li>
	<li><strong>Testo breve</strong>: Breve descrizione che viene aggiunta sotto il titolo negli elenchi.</li>
	<li><strong>Testo lungo</strong>: corpo dellla notizia.</li>
</ul>

<p>&nbsp;</p>
', N'48', 1, N'Nome', N'', N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 1, N'2015-02-08 23:13:00', 1, 0, NULL, 1, 1, 0, 1, 1, 0, 1, 1, 0, 0, 0, 0, N'fa-newspaper-o', N'News.master')
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (39, N'FAQ', N'<p>	Questo elemento consente di inserire un domanda frequente nella sezione FAQ..</p><ul>	<li>		<strong>Titolo </strong>(obbligatorio): Viene visualizzato solo in fase di editing.</li>	<li>		<strong>Data di pubblicazione</strong>: Opzionale.</li>	<li>		<strong>Data di scadenza</strong>:&nbsp;Data dopo la quale la FAQ non appare pi&ugrave; negli elenchi</li>	<li>		<strong>Rilevanza</strong>: Determina l&#39;ordine in cui le FAQ vengono presentate.</li>	<li>		<strong>Testo breve</strong>: Inserire qui la domanda.</li>	<li>		<strong>Testo lungo</strong>: Inserire qui la risposta..</li></ul><p>	<strong>NB</strong>: Per essere pubblicate le FAQ devono essere collegate a un tag pubblicato o nella sezione <strong>FAQ</strong>.</p>', NULL, 0, N'Nome', NULL, N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'2011-10-30 10:15:00', 0, 1, N'2012-02-09 23:00:00', 1, 1, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (40, N'Home page', N'', N'', 1, N'Nome', N'Ordinamento', N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 1, N'2015-02-03 16:48:00', 0, 0, NULL, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, N'fa-home', N'Home.master')
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (41, N'Database', N'<p>	<span style="font-family: Arial, Helvetica, sans-serif; font-size: 11px; text-align: left; ">Questo elemento considte di associare un database al motore di ricerca..</span></p><ul style="margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 0px; border-style: initial; border-color: initial; border-image: initial; outline-width: 0px; outline-style: initial; outline-color: initial; font-size: 11px; vertical-align: baseline; background-image: initial; background-attachment: initial; background-origin: initial; background-clip: initial; list-style-type: none; font-family: Arial, Helvetica, sans-serif; text-align: left; ">	<li style="margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; padding-top: 0px; padding-right: 0px; padding-bottom: 4px; padding-left: 13px; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 0px; border-style: initial; border-color: initial; border-image: initial; outline-width: 0px; outline-style: initial; outline-color: initial; vertical-align: baseline; background-image: url(http://www.brunomigliaretti.localhost/mb_images/bullet_sq.gif); background-attachment: initial; background-origin: initial; background-clip: initial; background-color: initial; list-style-type: none; background-position: 0% 5px; background-repeat: no-repeat no-repeat; ">		<strong style="margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 0px; border-style: initial; border-color: initial; border-image: initial; outline-width: 0px; outline-style: initial; outline-color: initial; vertical-align: baseline; background-image: initial; background-attachment: initial; background-origin: initial; background-clip: initial; background-color: transparent; ">Titolo&nbsp;</strong>(obbligatorio): Viene visualizzato solo in fase di editing.</li>	<li style="margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; padding-top: 0px; padding-right: 0px; padding-bottom: 4px; padding-left: 13px; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 0px; border-style: initial; border-color: initial; border-image: initial; outline-width: 0px; outline-style: initial; outline-color: initial; vertical-align: baseline; background-image: url(http://www.brunomigliaretti.localhost/mb_images/bullet_sq.gif); background-attachment: initial; background-origin: initial; background-clip: initial; background-color: initial; list-style-type: none; background-position: 0% 5px; background-repeat: no-repeat no-repeat; ">		<strong style="margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 0px; border-style: initial; border-color: initial; border-image: initial; outline-width: 0px; outline-style: initial; outline-color: initial; vertical-align: baseline; background-image: initial; background-attachment: initial; background-origin: initial; background-clip: initial; background-color: transparent; ">Data di pubblicazione</strong>: Opzionale.</li>	<li style="margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; padding-top: 0px; padding-right: 0px; padding-bottom: 4px; padding-left: 13px; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 0px; border-style: initial; border-color: initial; border-image: initial; outline-width: 0px; outline-style: initial; outline-color: initial; vertical-align: baseline; background-image: url(http://www.brunomigliaretti.localhost/mb_images/bullet_sq.gif); background-attachment: initial; background-origin: initial; background-clip: initial; background-color: initial; list-style-type: none; background-position: 0% 5px; background-repeat: no-repeat no-repeat; ">		<strong style="background-color: transparent; margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 0px; border-style: initial; border-color: initial; border-image: initial; outline-width: 0px; outline-style: initial; outline-color: initial; vertical-align: baseline; background-image: initial; background-attachment: initial; background-origin: initial; background-clip: initial; ">Rilevanza</strong><span style="background-color: initial; ">: Non usato.</span></li>	<li style="margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; padding-top: 0px; padding-right: 0px; padding-bottom: 4px; padding-left: 13px; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 0px; border-style: initial; border-color: initial; border-image: initial; outline-width: 0px; outline-style: initial; outline-color: initial; vertical-align: baseline; background-image: url(http://www.brunomigliaretti.localhost/mb_images/bullet_sq.gif); background-attachment: initial; background-origin: initial; background-clip: initial; background-color: initial; list-style-type: none; background-position: 0% 5px; background-repeat: no-repeat no-repeat; ">		<b>Nome database&nbsp;</b>(obbligatorio): il nome del database&nbsp;</li>	<li style="margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; padding-top: 0px; padding-right: 0px; padding-bottom: 4px; padding-left: 13px; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 0px; border-style: initial; border-color: initial; border-image: initial; outline-width: 0px; outline-style: initial; outline-color: initial; vertical-align: baseline; background-image: url(http://www.brunomigliaretti.localhost/mb_images/bullet_sq.gif); background-attachment: initial; background-origin: initial; background-clip: initial; background-color: initial; list-style-type: none; background-position: 0% 5px; background-repeat: no-repeat no-repeat; ">		<strong style="margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 0px; border-style: initial; border-color: initial; border-image: initial; outline-width: 0px; outline-style: initial; outline-color: initial; vertical-align: baseline; background-image: initial; background-attachment: initial; background-origin: initial; background-clip: initial; background-color: transparent; ">Url</strong>: L&#39;url assoluta con cui va richiamato la pagine con la parola convenzionale &quot;_pxxx&quot; al posto del dumero identificatico della pagina. Es: http://www.sisteminterattivi.org/mb_showPage.asp?page=_pxxx</li>	<li style="margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; padding-top: 0px; padding-right: 0px; padding-bottom: 4px; padding-left: 13px; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 0px; border-style: initial; border-color: initial; border-image: initial; outline-width: 0px; outline-style: initial; outline-color: initial; vertical-align: baseline; background-image: url(http://www.brunomigliaretti.localhost/mb_images/bullet_sq.gif); background-attachment: initial; background-origin: initial; background-clip: initial; background-color: initial; list-style-type: none; background-position: 0% 5px; background-repeat: no-repeat no-repeat; ">		<strong>Url secondaria</strong>: Un&#39;immagine da usare come icona identificativa del database.</li></ul>', NULL, 0, N'Nome', N'Nome del database', N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, N'2012-02-09 23:01:00', 0, 1, N'2015-01-29 16:37:00', 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (42, N'Pagina di ricerca', N'<p>	Pagina di ricerca. Perch&egrave; funzioni &egrave; necessario collegarlo alla definizione di uno o pi&ugrave; database. L&#39;opzione url consente di collegare una pagina di ricerca personalizzata altrimenti verr&agrave; utilizzata quella di default.</p>', N'41', 1, N'Nome', NULL, N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'2012-02-09 23:07:00', 0, 1, N'2015-01-29 16:38:00', 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (43, N'Calendario', N'<p>	Pannello particolare che contiene un calendario. Tuggli gli elementi collegati saranno raggiungibili selezionando le date corrispondenti.</p>', NULL, 1, N'Nome', NULL, N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'2012-02-09 23:15:00', 0, 1, N'2015-01-29 16:38:00', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (44, N'Gruppo di pannelli', N'<p>	Elemento che consente di definire il gruppo di pannelli (collegamento a pagine di ricerca, calendari, &nbsp;pannelli contenitori) di default, mostrato cio&egrave; nelle pagine standard e nelle pagine in cui non siano definiti pannelli.</p>', N'42, 43, 29, 50, 47', 1, N'Nome', N'Tipo di ordinamento dei singoli pannelli contenuti', N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'2012-02-10 10:23:00', 0, 1, N'2015-01-29 16:38:00', 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (45, N'Pagina di download', N'<p>	La pagina consente di organizzare il download di documenti per gruppi. I file sono raggruppati a seconda dei tag a cui sono associati.</p><ul>	<li>		<strong>Titolo</strong>: titolo della pagina (visualizzato)</li>	<li>		<strong>Testo breve&nbsp;</strong>testo che viene mostrato nelle liste..</li>	<li>		<strong>Testo lungo: </strong>testo&nbsp;che viene inserito sotto il titolo prima degli elenchi di file.</li></ul>', N'37', 1, N'Nome', N'Root area download', N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, N'2012-02-10 10:50:00', 0, 1, N'2015-01-29 16:39:00', 1, 1, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (46, N'Cartella', N'', N'', 1, N'Nome', N'Tipo ordinamento', N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', N'', N'Preferiti (lista di tipi separati da virgole)', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 0, N'2015-02-10 08:37:00', 1, 0, NULL, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, N'fa-folder', N'')
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (47, N'Plugin', N'<p>	Consente di creare un pannello che contiene codice arbitrario scritto dall&#39;utente.</p><ul>	<li>		<strong>Titolo&nbsp;</strong>(obbligatorio): Titolo della pannello.</li>	<li>		<strong>Rilevanza</strong>: Indica l&#39;ordine con cui la risorsa &egrave; collocata nell&#39;elemento che la contiene.</li>	<li>		<b>Dimensioni:</b>&nbsp;dimensioni del pannello (opzionale)</li>	<li>		<strong>Testo breve</strong>: Per defalt l&#39;edito &egrave; impostato per inserire direttamente il codice HTML che genera il pannello (codice javascipt che genera pubblicit&agrave;, &nbsp;codice per mostrare video, widget di varia origine)</li></ul>', NULL, 0, N'Nome', N'Script collegato', N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'2012-02-14 23:04:00', 0, 0, NULL, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (48, N'Galleria', N'<p>	Elemento specializzato per galleria di immagini o video.</p><ul>	<li>		<strong>Titolo </strong>(obbligatorio): Titolo della galleria.</li>	<li>		<strong>Sottotitolo </strong>(opzionale): sottotitolo.</li>	<li>		<strong>Rilevanza</strong>: Indica l&#39;ordine con cui la risorsa &egrave; collocata nell&#39;elemento che la contiene.</li>	<li>		<b>dimensioni:</b> dimensioni delle miniature create automaticamente&nbsp;</li></ul>', N'30, 33', 1, N'Nome', N'Sottotitolo', N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'2012-06-30 09:13:00', 0, 0, NULL, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (49, N'Annuncio pubblicitario', N'<p>	Annuncio pubblicitario da inserire in un banner.</p><ul>	<li>		Titolo&nbsp;(obbligatorio): Identifica l&#39;annuncio nelle statistiche</li>	<li>		Url: Indirizzo da richiamare cliccando sull&#39;annuanco</li>	<li>		Url secondaria: Immagine da visualizzare nel banner.</li>	<li>		Rilevanza non usato.</li>	<li>		Testo alternativo: Testo da inserire come testo alternativi se l&#39;immagine non &egrave; visualizzata.</li></ul><p>	NB: Le immagini devono essere collegate ad una galleria utilizzando il pannello collegamenti.</p>', NULL, 0, N'Nome', N'Testo alternativo', N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, N'2012-10-03 07:41:00', 0, 1, N'2015-01-29 16:40:00', 0, 0, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (50, N'Banner pubblicitario', N'<p>	Elemento specializzato per contenere annunci pubblicitari..</p><ul>	<li>		<strong>Titolo&nbsp;</strong>(obbligatorio, non visializzato): Identifica il banner. Nel caso dei banner fissi corrisponde all&#39;attributo <strong>id</strong> che ha l&#39;elemento corrispondente nella pagina.</li>	<li>		<strong>Ordine di scelta&nbsp;</strong>(opzionale): &nbsp;Nel caso pi&ugrave; banner sia assegnati allo stesso spazio il primo secondo:		<ul>			<li>				DATA DESC: quello con data pi&ugrave; recente</li>			<li>				ASC: quello che il valore pi&ugrave; alto nel campo Rilevanza..</li>			<li>				DESC :&nbsp;quello che il valore pi&ugrave; bassonel campo Rilevanza..</li>			<li>				RANDOM: in maniera casuale (i banner venco alternati)</li>		</ul>	</li>	<li>		<strong>Rilevanza</strong>: Indica l&#39;ordine con cui la risorsa &egrave; collocata nell&#39;elemento che la contiene.</li></ul>', N'49', 1, N'Nome', N'Ordine di scelta', N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'2012-10-03 07:50:00', 0, 1, N'2015-01-29 16:40:00', 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (51, N'PaginaAccordion', N'<p>	Raggruppa pi&ugrave; pagine standard. Delle pagine collegate viene usato solo il titolo e il testo lungo che vengono usati per creare gli elementi di un Accordion&nbsp;</p><p>	<strong>Tipo ordinamento</strong> consente di personalizzire l&#39;ordinamento con cui vengono mostrati gli elementi contenuti. I valori validi sono:</p><ul>	<li>		DATA ASC (per data ascendente)</li>	<li>		ASC (secondo il valore contenuto nel campo Rilevanza acendente)</li>	<li>		DATA DESC (per data discendente)</li>	<li>		DESC (secondo il valore contenuto nel campo Rilevanza discendente)</li></ul>', N'1', 1, N'Nome', N'Ordinamento', N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, N'2012-12-07 12:44:00', 0, 1, N'2015-01-29 16:40:00', 1, 1, 1, 1, 0, 0, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (52, N'Voce di glossario', NULL, NULL, 0, N'Nome', N'alias', N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'2012-12-07 13:40:00', 1, 1, N'2015-01-29 16:40:00', 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (53, N'Locazione sulla mappa', NULL, NULL, 0, N'Nome', N'Indirizzo', N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, N'2012-12-10 23:59:00', 0, 0, NULL, 1, 1, 0, 1, 0, 0, 1, 1, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (54, N'FakeLink', NULL, NULL, 0, N'Nome', NULL, N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'2013-05-02 17:12:00', 0, 0, NULL, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (55, N'Progetto', N'', N'30, 33,25, 59', 1, N'Nome', N'anno', N'Note', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', N'Titolo mostrato', N'committente', N'importo', N'progettisti', N'Luogo', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 0, N'2015-02-08 16:12:00', 1, 0, NULL, 1, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, N'fa-cubes', N'Progetto.master')
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (56, N'Slide', N'', N'', 0, N'Nome', N'', N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', N'Titolo mostrato', N'Sottotitolo', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 1, N'2015-01-29 18:29:00', 0, 0, NULL, 1, 0, 1, 1, 1, 0, 1, 0, 0, 0, 1, 0, N'fa-slideshare', N'')
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (57, N'Negozio', NULL, NULL, 0, N'Nome', NULL, N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'2013-08-06 17:05:00', 0, 1, N'2015-01-29 17:10:00', 1, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (58, N'Collegamento social', N'', N'', 0, N'Nome', N'Icona (classe da applicare)', N'Collegamento al profilo', N'Testo completo', N'Collegamento', N'Icona (opzionale)', N'Scadenza', N'Altezza', N'Larghezza', N'Testo del link', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 1, N'2015-02-17 19:13:00', 1, 0, NULL, 0, 0, 1, 1, 0, 0, 1, 0, 0, 1, 1, 0, N'fa-users', N'')
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (59, N'Progettista', N'', N'', 1, N'Nome', N'Ruolo', N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', N'Nome e titolo mostarto', N'Luogo di nascita', N'Data di nascita', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 1, N'2015-02-10 13:00:00', 1, 0, NULL, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 1, 0, N'fa-user', N'Socio.master')
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (60, N'Pagina contatti', N'', N'', 0, N'Nome', N'', N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', N'Titolo mostrato', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 1, N'2015-02-03 15:34:00', 1, 0, NULL, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, N'fa-envelope-o', N'Contatti.master')
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (61, N'Utente', NULL, N'62, 63', 1, N'Nome', N'Ruolo', N'Testo breve', N'Nota biografica', N'Url principale', N'Foto personale', N'Scadenza', N'Altezza', N'Larghezza', NULL, N'E-mail', N'Codice Fiscale', N'password', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, N'2013-08-23 10:59:00', 0, 1, N'2015-01-29 18:23:00', 0, 1, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (62, N'Impresa (dati completi)', NULL, NULL, 0, N'Nome', N'Geolocazione', N'Testo mappa', N'Testo pagina', N'Sito web', N'Logo azienda', N'Data fondazione', N'Di cui donne ', N'Addetti totali', N'Indirizzo completo', N'e-mail pubblica', N'Partita IVA', N'Telefono e Fax', N'Legale rappresentate (se diverso)', N'Distribuziione quote società', N'Premi e certificazioni', N'Prodotti (frasi separate da ";")', N'Fatturato totale', N'Fatturato con estero', N'Fatturato farnitori in provincia', N'Fatturato fornitori resto regione', N'Fatturato fornitori resto italia', N'Fatturato fornitori resto Europa', N'Fatturato fornitori resto mondo', NULL, 1, N'2013-08-23 11:00:00', 0, 1, N'2015-01-29 18:24:00', 1, 1, 1, 1, 1, 0, 1, 1, 0, 0, 1, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (63, N'Impresa (dati ridotti)', NULL, NULL, 0, N'Nome', N'Geolocazione', N'Testo mappa', N'Testo completo', N'Sito web', N'Logo azienda', N'Scadenza', N'Altezza', N'Larghezza', N'Indirizzo completo', N'e-mail pubblica', N'Partita IVA', N'Telefono e fax', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, N'2013-08-23 11:00:00', 0, 1, N'2015-01-29 18:24:00', 1, 0, 1, 1, 0, 0, 1, 0, 0, 0, 1, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (64, N'Parola chiave area mercato', NULL, N'8', 1, N'Nome', NULL, N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'2013-08-23 11:02:00', 0, 1, N'2015-01-29 18:24:00', 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (65, N'Categoria di prodotto', NULL, N'9', 1, N'Nome', NULL, N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'2013-08-23 11:03:00', 0, 1, N'2015-01-29 18:24:00', 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (66, N'Parola chiave attività strategica', NULL, N'10', 1, N'Nome', NULL, N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'2013-08-23 11:04:00', 0, 1, N'2015-01-29 18:24:00', 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (67, N'Settore azienda', NULL, N'11', 1, N'Nome', NULL, N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'2013-08-23 12:31:00', 0, 1, N'2015-01-29 18:24:00', 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (68, N'Settore fornitore', NULL, N'12', 1, N'Nome', NULL, N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'2013-08-23 12:31:00', 0, 1, N'2015-01-29 18:24:00', 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (69, N'Settore cliente', N'', N'13', 1, N'Nome', NULL, N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'2013-08-23 12:31:00', 0, 1, N'2015-01-29 18:24:00', 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (70, N'Parola chiave buone prassi', NULL, N'14', 1, N'Nome', NULL, N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'2013-08-23 12:32:00', 0, 1, N'2015-01-29 18:25:00', 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (71, N'Parola chiave punti di forza', NULL, N'15', 1, N'Nome', NULL, N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'2013-08-23 12:33:00', 0, 1, N'2015-01-29 18:25:00', 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (72, N'Parola chiave obiettivi aziendali', NULL, N'16', 1, N'Nome', NULL, N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'2013-08-23 12:33:00', 0, 1, N'2015-01-29 18:25:00', 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (73, N'Parola chiave per identificare l''impresa', NULL, N'17', 1, N'Nome', NULL, N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'2013-08-23 12:34:00', 0, 1, N'2015-01-29 18:25:00', 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (74, N'Lista di distribuzione', N'', N'18', 1, N'Nome', NULL, N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'2013-08-23 12:34:00', 0, 1, N'2015-01-29 18:25:00', 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (75, N'Prerogativa utente', NULL, N'107', 1, N'Nome', NULL, N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Codice', N'Livello', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'2013-08-26 16:23:00', 0, 1, N'2015-01-29 18:25:00', 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (76, N'Provincia', NULL, N'146', 1, N'Nome', NULL, N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, N'2013-09-10 07:57:00', 0, 1, N'2015-01-29 18:25:00', 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, NULL, NULL)
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (77, N'Messaggio o post', N'', N'', 0, N'Nome', N'', N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', N'Oggetto', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 0, N'2015-01-29 18:35:00', 0, 0, NULL, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, N'fa-envelope-square', N'')
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (78, N'Risposta o commento', N'', N'', 0, N'Nome', N'', N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', N'', 0, N'2015-01-29 18:36:00', 0, 0, NULL, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, N'fa-comment-o', N'')
INSERT INTO [dbo].[ANA_CONT_TYPE] ([TYP_PK], [TYP_NAME], [TYP_HELP], [TYP_ContenutiPreferiti], [TYP_FlagContenitore], [TYP_label_Titolo], [TYP_label_ExtraInfo], [TYP_label_TestoBreve], [TYP_label_TestoLungo], [TYP_label_url], [TYP_label_url_secondaria], [TYP_label_scadenza], [TYP_label_altezza], [TYP_label_larghezza], [TYP_label_ExtraInfo_1], [TYP_label_ExtraInfo_2], [TYP_label_ExtraInfo_3], [TYP_label_ExtraInfo_4], [TYP_label_ExtraInfo_5], [TYP_label_ExtraInfo_6], [TYP_label_ExtraInfo_7], [TYP_label_ExtraInfo_8], [TYP_label_ExtraInfoNumber_1], [TYP_label_ExtraInfoNumber_2], [TYP_label_ExtraInfoNumber_3], [TYP_label_ExtraInfoNumber_4], [TYP_label_ExtraInfoNumber_5], [TYP_label_ExtraInfoNumber_6], [TYP_label_ExtraInfoNumber_7], [TYP_label_ExtraInfoNumber_8], [TYP_flag_cercaServer], [TYP_DataUltimaModifica], [TYP_Flag_Attivo], [TYP_Flag_Cancellazione], [TYP_Data_Cancellazione], [TYP_flag_breve], [TYP_flag_lungo], [TYP_flag_link], [TYP_flag_urlsecondaria], [TYP_flag_scadenza], [TYP_flag_specialTag], [TYP_flag_tags], [TYP_flag_altezza], [TYP_flag_larghezza], [TYP_flag_ExtraInfo], [TYP_flag_ExtraInfo1], [TYP_flag_BtnGeolog], [TYP_Icon], [TYP_MasterPageFile]) VALUES (79, N'Sequenza', N'', N'56', 1, N'Nome', N'classe', N'Testo breve', N'Testo completo', N'Url principale', N'Ulr secondaria', N'Scadenza', N'Altezza', N'Larghezza', N'Titolo mostrato', N'id', N'prev button (html)', N'next button (HTML)', N'pagination (HTML)', N'slide wrapper class', N'slide class', N'', N'', N'', N'', N'', N'', N'', N'', N'', 1, N'2015-01-29 18:37:00', 0, 0, NULL, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, N'fa-retweet', N'')
SET IDENTITY_INSERT [dbo].[ANA_CONT_TYPE] OFF

INSERT [dbo].[ANA_LANGUAGE] ([LANG_Id], [LANG_Name], [LANG_Active], [LANG_AutoHide]) VALUES (N'de', N'Deutsch', 0, 0)
INSERT [dbo].[ANA_LANGUAGE] ([LANG_Id], [LANG_Name], [LANG_Active], [LANG_AutoHide]) VALUES (N'en', N'English', 1, 1)
INSERT [dbo].[ANA_LANGUAGE] ([LANG_Id], [LANG_Name], [LANG_Active], [LANG_AutoHide]) VALUES (N'es', N'Español', 0, 0)
INSERT [dbo].[ANA_LANGUAGE] ([LANG_Id], [LANG_Name], [LANG_Active], [LANG_AutoHide]) VALUES (N'fr', N'Français', 0, 0)
INSERT [dbo].[ANA_PREROGATIVE] ([pre_PK], [pre_PREROGATIVA], [pre_LAST_MODIFIED]) VALUES (0, N'Guest', CAST(0x0000A2CB009AAC7C AS DateTime))
INSERT [dbo].[ANA_PREROGATIVE] ([pre_PK], [pre_PREROGATIVA], [pre_LAST_MODIFIED]) VALUES (1, N'Community', CAST(0x0000A3DC011BEBC0 AS DateTime))
INSERT [dbo].[ANA_PREROGATIVE] ([pre_PK], [pre_PREROGATIVA], [pre_LAST_MODIFIED]) VALUES (4, N'Editor', CAST(0x0000A2CB009AB5DC AS DateTime))
INSERT [dbo].[ANA_PREROGATIVE] ([pre_PK], [pre_PREROGATIVA], [pre_LAST_MODIFIED]) VALUES (10, N'Administrator', CAST(0x0000A2CB009ADC88 AS DateTime))

SET IDENTITY_INSERT [dbo].[ANA_USR] ON 

INSERT [dbo].[ANA_USR] ([usr_PK], [usr_EMAIL], [usr_NAME], [usr_PASSWORD], [usr_LEVEL], [usr_LAST_MODIFIED], [usr_PROFILE_PK], [usr_ACTIVE]) VALUES (1, $(AdminEmail), N'MagicCMS Administrator', N'yairhFCEzylQkVBlLIqp58JTUrt9wMPN0i3H604N/2E=', 10, CAST(0x0000A3E800CA0CE6 AS DateTime), 0, 1)

SET IDENTITY_INSERT [dbo].[ANA_USR] OFF
