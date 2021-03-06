USE [master]
GO
/****** Object:  Database [DesignFinal]    Script Date: 11/20/2016 8:26:21 PM ******/
CREATE DATABASE [DesignFinal]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'DesignFinal', FILENAME = N'C:\Design-Project-DB\DesignFinal.mdf' , SIZE = 4096KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'DesignFinal_log', FILENAME = N'C:\Design-Project-DB\DesignFinal_log.ldf' , SIZE = 3136KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [DesignFinal] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [DesignFinal].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [DesignFinal] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [DesignFinal] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [DesignFinal] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [DesignFinal] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [DesignFinal] SET ARITHABORT OFF 
GO
ALTER DATABASE [DesignFinal] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [DesignFinal] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [DesignFinal] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [DesignFinal] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [DesignFinal] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [DesignFinal] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [DesignFinal] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [DesignFinal] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [DesignFinal] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [DesignFinal] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [DesignFinal] SET  DISABLE_BROKER 
GO
ALTER DATABASE [DesignFinal] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [DesignFinal] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [DesignFinal] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [DesignFinal] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [DesignFinal] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [DesignFinal] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [DesignFinal] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [DesignFinal] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [DesignFinal] SET  MULTI_USER 
GO
ALTER DATABASE [DesignFinal] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [DesignFinal] SET DB_CHAINING OFF 
GO
ALTER DATABASE [DesignFinal] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [DesignFinal] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [DesignFinal]
GO
/****** Object:  StoredProcedure [dbo].[DeleteRecord]    Script Date: 11/20/2016 8:26:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteRecord]
	
	@sid int
AS
BEGIN
	SET NOCOUNT ON;
	DELETE FROM Student WHERE SID = @sid
END

GO
/****** Object:  StoredProcedure [dbo].[GetAllStudents]    Script Date: 11/20/2016 8:26:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetAllStudents] 
	AS
BEGIN
	
	SET NOCOUNT ON;
	Select * from Student
END

GO
/****** Object:  StoredProcedure [dbo].[GetStudentTOR]    Script Date: 11/20/2016 8:26:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetStudentTOR]
	@sid int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Select TOR_Front, TOR_Back from Student where SID = @sid
END

GO
/****** Object:  StoredProcedure [dbo].[SaveStudentTOR]    Script Date: 11/20/2016 8:26:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SaveStudentTOR]
	@lname varchar(50),
	@fname varchar(50),
	@mi varchar(5),
	@TOR_Front image,
	@TOR_Back image
AS
BEGIN
	SET NOCOUNT ON;
	insert into Student(Last_Name, First_Name, Middle_Initial,TOR_Front,TOR_Back)
	values (@lname, @fname, @mi,@TOR_Front,@TOR_Back)
END

GO
/****** Object:  Table [dbo].[Student]    Script Date: 11/20/2016 8:26:22 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Student](
	[First_Name] [varchar](50) NULL,
	[Last_Name] [varchar](50) NULL,
	[Middle_Initial] [varchar](5) NULL,
	[SID] [int] IDENTITY(0,1) NOT NULL,
	[TOR_Front] [image] NULL,
	[TOR_Back] [image] NULL,
 CONSTRAINT [XPKStudent] PRIMARY KEY CLUSTERED 
(
	[SID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
USE [master]
GO
ALTER DATABASE [DesignFinal] SET  READ_WRITE 
GO
