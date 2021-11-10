/*create new table Yearly_Data_Sep2020_Aug2021
first copy datastructure from Aug 2021 data and start inserting data from sep 2020 to aug 2021*/

USE [BikeShareProject]
GO
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

  /****** Script for SelectTopNRows command from SSMS for records whose ended_at<started_at ******/
SELECT count(datediff(minute,started_at,ended_at))
FROM [BikeShareProject].[dbo].[Yearly_Data_Sep2020_Aug2021] where datediff(minute,started_at,ended_at)<0 

/* delete invalid records of 2285 whose ended_at < started_at*/

delete from [BikeShareProject].[dbo].[Yearly_Data_Sep2020_Aug2021] 
where datediff(minute,started_at,ended_at)<0 

/****** check whether ride-id is unique , it is ******/
SELECT distinct(ride_id),count(*) as ridecount
  FROM [BikeShareProject].[dbo].[Yearly_Data_Sep2020_Aug2021] group by ride_id order by ridecount desc

  
/****** check whether rideable_type is unique , it is ******/
SELECT distinct(rideable_type),count(*) as ridecount
  FROM [BikeShareProject].[dbo].[Yearly_Data_Sep2020_Aug2021] group by rideable_type order by ridecount desc

  /****** check whether started_at or ended_at is not null ******/
SELECT count(*) 
  FROM [BikeShareProject].[dbo].[Yearly_Data_Sep2020_Aug2021]  where started_at is null or ended_at is null


    /****** add a table for ride-length ******/
  ALTER TABLE [BikeShareProject].[dbo].[Yearly_Data_Sep2020_Aug2021]
   ADD [RIDE_LENGTH] float

   	 /*add a column with minutes of ride to the yearly trip data*/
   UPDATE [BikeShareProject].[dbo].[Yearly_Data_Sep2020_Aug2021] SET RIDE_LENGTH=datediff(minute,started_at,ended_at)
			