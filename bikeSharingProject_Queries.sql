/*create new table Yearly_Data_Sep2020_Aug2021
first copy datastructure from Aug 2021 data and start inserting data from sep 2020 to aug 2021*/

USE [BikeShareProject]
GO

/****** Object:  Table [dbo].[202108-divvy-tripdata]    Script Date: 22/9/2021 9:39:02 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Yearly_Data_Sep2020_Aug2021](
	[ride_id] [nvarchar](50) NULL,
	[rideable_type] [nvarchar](50) NULL,
	[started_at] [datetime2](7) NULL,
	[ended_at] [datetime2](7) NULL,
	[start_station_name] [nvarchar](max) NULL,
	[start_station_id] [nvarchar](50) NULL,
	[end_station_name] [nvarchar](max) NULL,
	[end_station_id] [nvarchar](50) NULL,
	[start_lat] [float] NULL,
	[start_lng] [float] NULL,
	[end_lat] [float] NULL,
	[end_lng] [float] NULL,
	[member_casual] [nvarchar](50) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/*insert sep 2020 to aug 2021 data into yearly data table*/

USE [BikeShareProject]
GO

INSERT INTO [dbo].[Yearly_Data_Sep2020_Aug2021]
         
   SELECT * FROM [dbo].[202108-divvy-tripdata]
   UNION ALL
   SELECT * FROM [dbo].[202107-divvy-tripdata]
   UNION ALL
   SELECT * FROM [dbo].[202106-divvy-tripdata]
   UNION ALL
   SELECT * FROM [dbo].[202105-divvy-tripdata]
   UNION ALL
   SELECT * FROM [dbo].[202104-divvy-tripdata]
   UNION ALL
   SELECT * FROM [dbo].[202103-divvy-tripdata]
   UNION ALL
   SELECT * FROM [dbo].[202102-divvy-tripdata]
   UNION ALL
   SELECT * FROM [dbo].[202101-divvy-tripdata]
   UNION ALL
   SELECT * FROM [dbo].[202012-divvy-tripdata]
   UNION ALL
   SELECT * FROM [dbo].[202011-divvy-tripdata]
   UNION ALL
   SELECT * FROM [dbo].[202010-divvy-tripdata]
   UNION ALL
   SELECT * FROM [dbo].[202009-divvy-tripdata]
GO

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [ride_id]
      ,[rideable_type]
      ,[started_at]
      ,[ended_at]
      ,[start_station_name]
      ,[start_station_id]
      ,[end_station_name]
      ,[end_station_id]
      ,[start_lat]
      ,[start_lng]
      ,[end_lat]
      ,[end_lng]
      ,[member_casual]
  FROM [BikeShareProject].[dbo].[Yearly_Data_Sep2020_Aug2021]

  /****** Script for all records from yearly data ******/
SELECT *
  FROM [BikeShareProject].[dbo].[Yearly_Data_Sep2020_Aug2021]


  /*total no:of rides from sep 2020 to aug 2021*/

  select count(*)  FROM [BikeShareProject].[dbo].[Yearly_Data_Sep2020_Aug2021]

  /*total no:of rides per subscrriber type from sep 2020 to aug 2021*/

   SELECT 
   DISTINCT(member_casual) AS SUBSCRIBER_TYPE, COUNT(*) AS COUNT  
   FROM [BikeShareProject].[dbo].[Yearly_Data_Sep2020_Aug2021] 
   GROUP BY member_casual

    /*total no:of rides per subscrriber type per month from sep 2020 to aug 2021*/

    SELECT 
          DISTINCT(member_casual) AS SUBSCRIBER_TYPE, DatePart(month,started_at) AS MONTH,DATENAME(month,started_at) AS MONTHNAME, COUNT(*) AS COUNT  
   FROM [BikeShareProject].[dbo].[Yearly_Data_Sep2020_Aug2021] 
   GROUP BY member_casual,DatePart(month,started_at) ,DATENAME(month,started_at)
   ORDER BY DatePart(month,started_at)


  /*total no:of rides per subscrriber type per month from sep 2020 to aug 2021*/

    SELECT 
          DISTINCT(member_casual) AS SUBSCRIBER_TYPE,
		  DATEPART(WEEKDAY,started_at),
		  DATENAME(WEEKDAY,started_at) AS WEEKDAY, 
		  COUNT(*) AS COUNT  
   FROM [BikeShareProject].[dbo].[Yearly_Data_Sep2020_Aug2021] 
   GROUP BY member_casual,DATENAME(WEEKDAY,started_at), DATEPART(WEEKDAY,started_at)
   ORDER BY DATEPART(WEEKDAY,started_at)
			