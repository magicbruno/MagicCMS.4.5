:SETVAR DbName MagicCMS
:SETVAR DbDataPath "N'c:\Program Files\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER_R2\MSSQL\DATA\MagicCMS.mdf'"
:SETVAR DbLogPath "N'c:\Program Files\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER_R2\MSSQL\DATA\MagicCMS_log.ldf'"
:SETVAR AdminEmail "N'bruno@magicbusmultimedia.it'"

USE [master]
GO
/****** Object:  Database [$(DbName)]    Script Date: 07/04/2015 08:14:34 ******/
CREATE DATABASE [$(DbName)] ON  PRIMARY 
( NAME = [$(DbName)], FILENAME = $(DbDataPath) , SIZE = 17408KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = [$(DbName)_log], FILENAME = $(DbLogPath) , SIZE = 76736KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
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
