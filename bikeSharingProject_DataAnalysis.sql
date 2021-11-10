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


  /*total no:of rides per subscrriber type per week from sep 2020 to aug 2021*/

    SELECT 
          DISTINCT(member_casual) AS SUBSCRIBER_TYPE,
		  DATEPART(WEEKDAY,started_at),
		  DATENAME(WEEKDAY,started_at) AS WEEKDAY, 
		  COUNT(*) AS COUNT  
   FROM [BikeShareProject].[dbo].[Yearly_Data_Sep2020_Aug2021] 
   GROUP BY member_casual,DATENAME(WEEKDAY,started_at), DATEPART(WEEKDAY,started_at)
   ORDER BY DATEPART(WEEKDAY,started_at)
			

