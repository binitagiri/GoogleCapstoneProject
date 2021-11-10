

# Google Data Analytics Capstone Project

## Cyclistic Casestudy

### Introduction

Assuming I am a data analyst working as Marketing Analyst at Cyclistic , a bike sharing company in Chicago.

### About 'Cyclistic' company

In 2016, Cyclistic launched a successful bike-share offering. Since then, the program has grown to a fleet of 5,824 bicycles that are geotracked and locked into a network of 692 stations across Chicago. The bikes can be unlocked from one station and returned to any other station in the system anytime. 

Cyclistic offers reclining bikes , hand tricycles and cargo bikes. Cyclistic provides bike for people with disabilities who cant use a standard two-wheeled bike.Majority of riders opt traditional bike
8% use assistive bikes,30% of Cyclistic users ride for leisure , 30% for commute to work every day.

### Data Analysis Task

Lily Moreno is the Director of Marketing and my manager.She has given the below requirements:
1.	How to maximize the number of annual memberships ? Increasing annual membership can fuel company’s future success.
2.	How casual and annual members use Cyclistic bikes differently?
3.	Provide recommendation with compelling data sights and professional data visualisations for market analyst team to design a new marketing strategy to convert casual riders to annual members.

### Data Source

Data is located at https://divvy-tripdata.s3.amazonaws.com/index.html. Its updated every month with monthly data. Quarterly data of trips made by users are updated from 2016 Q1 when Cyclistic company was formed to till 2020 Q1. April 2020 to till current month is available on a monthly basis. There is data about the docking stations as well.
The data has been made available by Motivate International Inc. under this license.
Data-privacy issues prohibit you from using riders’ personally identifiable information. This means that you won’t be able to connect pass purchases to credit card numbers to determine if casual riders live in the Cyclistic service area or if they have purchased multiple single passes.

### Data Collection phase

Set of CSV files are downloaded to local folder and extracted. Open csv files and observe the data .

Here are the key observations:

1. All tripdata and Quarterly files have same number of columns 13
2. Station trip files are dated 2013, 2014, but doubts whether its current as Cyclistic company was started in 2016. 
3. There are shapefiles as well which can give the GIS (geometric information system) data.

Since the data is huge, it would be difficult to analyse in CSV file. So I exported all csv files to Microsoft SQL server using Microsoft SQL server management studio.

Issues faced:

1. Exporting issues like size constraint and datatype issues were inspected and resolved.
2. 2019 Q1 and Q2 files are corrupted and cannot be extracted.

### Data validation process


Last 12 months of data is our focus. Since all the data have same structure, I combined all data into one single table and it had close to 5M records. Inspected and did some data validations , removed invalid data , added column for ridelength.

SQL queries used are as below:
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

### Data Analysis

1. analyse how casual and annual members use bike sharing in daily/weekly/monthly basis.
2. usage of casual and annual members based on bike type
3. usage of casual and annual members based on ride length
4. usage of casual and annual members based on start and end points

SQL queries used are as below:

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
			


### Data visualisations

The cleaned data is exported to CSV file and imported to Tableau public.

My tableau dashboard is available in this link.
https://public.tableau.com/authoring/PortfolioProject_16319963364550/BikesharingDashboard#1

![alt text](https://github.com/binitagiri/GoogleCapstoneProject/blob/main/BikesharingDashboard%20(1).png?raw=true)


### Data Findings and recommendation

Observations:
1.	No of trips taken by members are more than casual
2.	There is no inference to be taken from ridertype
3.	July and august are the months where more no:of trips are taken
4.	Saturday and Sunday are busiest and casual riders take more rides on that day
5.	Average length of ride taken is more by casual driver. This might be because casual drivers are mostly tourists.

Recommendations :
1.	Introduce special member plan for casual riders on weekends.
2.	Target summer plan for casual members on summer months.
3.	Introduce special plan for tourists who are casual riders.

Future study: 

3.	Identify the casual drivers who are commuting to work daily using daily pass
4.	Identify the busiest stations and target special promotions targeted at them
