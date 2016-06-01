USE [master]
GO
/****** Object:  Database [Astro]    Script Date: 2016-06-01 16:12:30 ******/
CREATE DATABASE [Astro]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Astro', FILENAME = N'c:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\Astro.mdf' , SIZE = 1024000KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'Astro_log', FILENAME = N'c:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\Astro_log.ldf' , SIZE = 10240KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [Astro] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Astro].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Astro] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Astro] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Astro] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Astro] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Astro] SET ARITHABORT OFF 
GO
ALTER DATABASE [Astro] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Astro] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [Astro] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Astro] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Astro] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Astro] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Astro] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Astro] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Astro] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Astro] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Astro] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Astro] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Astro] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Astro] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Astro] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Astro] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Astro] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Astro] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Astro] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [Astro] SET  MULTI_USER 
GO
ALTER DATABASE [Astro] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Astro] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Astro] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Astro] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [Astro]
GO
/****** Object:  StoredProcedure [dbo].[observationsDelta]    Script Date: 2016-06-01 16:12:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[observationsDelta]
   
AS
BEGIN
   
   create table #tempTable
(
	[StarName] [varchar](50) NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[UPhotometry] [bit] NULL,
	[VPhotometry] [bit] NULL,
	[BPhotometry] [bit] NULL,
)
   insert into #tempTable select StarName, StartDate, EndDate, UPhotometry, VPhotometry, BPhotometry from (
      select StarName, StartDate, EndDate, UPhotometry, VPhotometry, BPhotometry from dbo.StagingObservations
         except
      select StarName, StartDate, EndDate, UPhotometry, VPhotometry, BPhotometry from dbo.Observations) t

	  select * from #tempTable
	  drop table #tempTable
END
  




    

GO
/****** Object:  Table [dbo].[bPhotometry]    Script Date: 2016-06-01 16:12:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[bPhotometry](
	[bPhotometryId] [bigint] NOT NULL,
	[bPhotometry] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[bPhotometryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[bPhotometryTime]    Script Date: 2016-06-01 16:12:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[bPhotometryTime](
	[bPhotometryTimeId] [bigint] NOT NULL,
	[bPhotometryTime] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[bPhotometryTimeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[log]    Script Date: 2016-06-01 16:12:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[log](
	[ID] [int] NOT NULL,
	[ProcName] [varchar](50) NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[Message] [varchar](1) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[metadataComparison]    Script Date: 2016-06-01 16:12:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[metadataComparison](
	[ID] [int] NOT NULL,
	[MetadataCountsId] [int] NOT NULL,
	[StagingColumn] [varchar](50) NULL,
	[DeltaColumn] [varchar](50) NULL,
	[DeltaColumnId] [varchar](50) NULL,
	[DataTypeConversion] [varchar](1000) NULL,
	[NullValuesConversion] [varchar](100) NULL,
	[JoinHint] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[metadataCounts]    Script Date: 2016-06-01 16:12:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[metadataCounts](
	[ID] [int] NOT NULL,
	[StagingTable] [varchar](50) NULL,
	[DeltaTable] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[observations]    Script Date: 2016-06-01 16:12:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[observations](
	[ID] [int] NOT NULL,
	[RowId] [bigint] NULL,
	[StarName] [varchar](50) NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[uPhotometryId] [bigint] NULL,
	[uPhotometryTimeId] [bigint] NULL,
	[vPhotometryId] [bigint] NULL,
	[vPhotometryTimeId] [bigint] NULL,
	[bPhotometryId] [bigint] NULL,
	[bPhotometryTimeId] [bigint] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[stagingObservations]    Script Date: 2016-06-01 16:12:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[stagingObservations](
	[ID] [bigint] NULL,
	[RowId] [bigint] NOT NULL,
	[StarName] [varchar](50) NULL,
	[StartDate] [varchar](50) NULL,
	[EndDate] [varchar](50) NULL,
	[uPhotometry] [varchar](50) NULL,
	[uPhotometryTime] [varchar](50) NULL,
	[vPhotometry] [varchar](50) NULL,
	[vPhotometryTime] [varchar](50) NULL,
	[bPhotometry] [varchar](50) NULL,
	[bPhotometryTime] [varchar](50) NULL,
	[Status] [varchar](50) NULL,
	[Active] [bit] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TestData]    Script Date: 2016-06-01 16:12:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TestData](
	[Column 0] [varchar](50) NULL,
	[Column 1] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[uPhotometry]    Script Date: 2016-06-01 16:12:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[uPhotometry](
	[uPhotometryId] [bigint] NOT NULL,
	[uPhotometry] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[uPhotometryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[uPhotometryTime]    Script Date: 2016-06-01 16:12:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[uPhotometryTime](
	[uPhotometryTimeId] [bigint] NOT NULL,
	[uPhotometryTime] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[uPhotometryTimeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[vPhotometry]    Script Date: 2016-06-01 16:12:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[vPhotometry](
	[vPhotometryId] [bigint] NOT NULL,
	[vPhotometry] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[vPhotometryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[vPhotometryTime]    Script Date: 2016-06-01 16:12:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[vPhotometryTime](
	[vPhotometryTimeId] [bigint] NOT NULL,
	[vPhotometryTime] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[vPhotometryTimeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  View [dbo].[bPhotometrySorted]    Script Date: 2016-06-01 16:12:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[bPhotometrySorted] as
SELECT        TOP (100) PERCENT dbo.observations.ID, dbo.observations.RowId, dbo.observations.StarName, dbo.observations.StartDate, dbo.observations.EndDate, dbo.bPhotometry.bPhotometry, 
                         dbo.bPhotometryTime.bPhotometryTime
FROM            dbo.bPhotometry INNER JOIN
                         dbo.observations ON dbo.bPhotometry.bPhotometryId = dbo.observations.bPhotometryId INNER JOIN
                         dbo.bPhotometryTime ON dbo.observations.bPhotometryTimeId = dbo.bPhotometryTime.bPhotometryTimeId
ORDER BY dbo.observations.ID, dbo.observations.RowId, dbo.observations.StartDate
GO
/****** Object:  View [dbo].[observationsSorted]    Script Date: 2016-06-01 16:12:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[observationsSorted] as (
SELECT        TOP (100) PERCENT ID, RowId, StarName, StartDate, EndDate, uPhotometryFlag, vPhotometryFlag, bPhotometryFlag
FROM            dbo.observations
ORDER BY ID, RowId, StartDate)
GO
/****** Object:  View [dbo].[uPhotometrySorted]    Script Date: 2016-06-01 16:12:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[uPhotometrySorted] as
SELECT        TOP (100) PERCENT dbo.observations.ID, dbo.observations.RowId, dbo.observations.StarName, dbo.observations.StartDate, dbo.observations.EndDate, dbo.uPhotometry.uPhotometry, 
                         dbo.uPhotometryTime.uPhotometryTime
FROM            dbo.uPhotometry INNER JOIN
                         dbo.observations ON dbo.uPhotometry.uPhotometryId = dbo.observations.uPhotometryId INNER JOIN
                         dbo.uPhotometryTime ON dbo.observations.uPhotometryTimeId = dbo.uPhotometryTime.uPhotometryTimeId
ORDER BY dbo.observations.ID, dbo.observations.RowId, dbo.observations.StartDate
GO
/****** Object:  View [dbo].[vPhotometrySorted]    Script Date: 2016-06-01 16:12:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[vPhotometrySorted] as
SELECT        TOP (100) PERCENT dbo.observations.ID, dbo.observations.RowId, dbo.observations.StarName, dbo.observations.StartDate, dbo.observations.EndDate, dbo.vPhotometry.vPhotometry, 
                         dbo.vPhotometryTime.vPhotometryTime
FROM            dbo.vPhotometry INNER JOIN
                         dbo.observations ON dbo.vPhotometry.vPhotometryId = dbo.observations.vPhotometryId INNER JOIN
                         dbo.vPhotometryTime ON dbo.observations.vPhotometryTimeId = dbo.vPhotometryTime.vPhotometryTimeId
ORDER BY dbo.observations.ID, dbo.observations.RowId, dbo.observations.StartDate
GO
USE [master]
GO
ALTER DATABASE [Astro] SET  READ_WRITE 
GO
