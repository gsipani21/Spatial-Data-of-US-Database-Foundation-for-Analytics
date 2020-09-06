# Spatial-Data-of-US-Database-Foundation-for-Analytics
SQL based Project
-> Transformed US wildfires data with 1.8 million records to 3NF using ER model; uploaded on SQL Server & MongoDB
-> Evaluated the top cause, intensity, damage, and CI for wildfires across the nation by executing SQL and NoSQL queries

Created an ER diagram using SQL server (see the attached file)

Assumptions/Notes About Data Entities and Relationships
Assumption:
1.	From the SQLite dataset only fires, NWGC unit details table provides the information required.
2.	To remove the null values we have created separate data tables for ICS_209_NUMBER and MTBS_details.
3.	The NWGC Reporting Agency data will be stored in NWGC – Unit_Details table.
4.	Latitude and Longitude is used as composite key to define the location of the fire incident.
5.	Size of the area where the fire incident took place are divided into various classes like 0 but less than 0.25 acres is A.
6.	There are various agency that prepares the report of incidents which took place at a certain locations.
7.	The column county in the fire table from the SQLite dataset does not have a normalized entry.

Relationship:
1.	One Fire detail can have zero to many ICS_209_INCIDENT_NUMBER.
2.	One Fire detail can have zero to many MTBS_ID.
3.	One SOURCE_REPORTING_UNIT will one to many Fire incidents details.
4.	A Fire_size can be assigned to one to many fire incidents.
5.	 A Fire Location can have one or many fire incidents.
6.	One Owner can have one to many fire incidents and one fire incident can take place in a location that have only one owner.
7.	One NWGC Reporting Agency can report one to many fire incidents but one fire incident can be reported by one agency.
8.	A Stat_cause will have one to many fire incidents but one fire incident will have only one Stat_cause.

Include reasons why the data model is in 3NF:
1.	Each table has its own functionality. 
2.	Every table has a primary key and each table contains only atomic values which satisfies the condition of 1NF. 
3.	Every column in each table is dependent on a single primary key and there are no partial dependencies. 
4.	There are no transitive functional dependencies between any column in table which satisfies the condition of 3NF 

Data in the Database

Table Name		Primary Key		Foreign Key	           # of Rows in Table
FIRE			FOD_ID                      Latitude                  1880465
                                                    Longitde
                                                    NWGC_Reporting_Unit_Id
                                                    Unit_Details_Code
                                                    Unit_Details_State
                                                    Unit_Details_Country
                                                    Fire_Size
                                                    Stat_Cause_code
                                                    Source_Reporting_Unit
                                                    ICS_209_INCIDENT_NUMBER
                                                    Owner_Code
                                                    MTBS_ID	
ICS_209_INCIDENT      ICS_209_INCIDENT_NUMBER                                  23313
MTBS Details          MTBS_ID                                                  10481
SOURCE_REPORTING_UNIT SOURCE_REPORTING_UNIT                                     6646
STAT_CAUSE Details    Stat_Cause                                                  13
Fire_Size             Fire_Size                                                13602
Fire_Location         Latitude                                               1585927
                      Longitde
Unit_Details          Code                                                      5867
                      State
                      Country
NWGC_Reporting_Agency NWGC_REPORTING_UNIT	Code				5867
						State
                                                Country	
Owner_Details         OWNER_CODE		16

 
SQL Queries
Query 1
Question 1
A leading beverage company has announced a billion-dollar fund for removing debris from forests, rivers and mountains in the US. All states are interested. Which 2 states have the least chance to win a share of the fund?

Notes/Comments About SQL Query and Results (Include # of Rows in Result)
Number of rows #2

Translation
Select NWGC unit name and State of the Agency 
From Fire Table
Joining NWGC Reporting agency table and Fire table on NWGC Unit ID
On condition where stat_cause_code is equal to 5
Sorting in ascending order with respect to Stat Cause code

-- Clean Up --

/* 
select sr.NWGC_Unit_name as Forest_Name, f.STATE
from fire as f
Join nwgc_reporting_agency as sr on f.NWCG_REPORTING_UNIT_ID = sr.NWGC_Reporting_unit_id
where f.STAT_CAUSE_CODE = 5
group by f.STATE
order by count(f.STAT_CAUSE_CODE) asc 
Limit 2;
*/

Conclusion: The 2 states have the least chance to win a share of the fund are DC and PR


Query 2
Question 3
One advocacy group says human actions and nature are equally to blame for most wildfires. Write a query that can help determine the truth of this statement.
Notes/Comments About SQL Query and Results (Include # of Rows in Result)

Number of rows #1
Comments: The statement one advocacy group says human actions and nature are equally to blame for most wildfires is not true
Assumption: Considered Lightning as Natural cause and not including miscellaneous and Unidentified

Translation
Count the causes of fire which was caused by Human and using a subquery to find  count of fire caused Naturally  
From the fire table
using condition where the stat_code = 1 for Lightning  and rest stat_code for fire caused by Human

-- Clean up --
/* select count(STAT_CAUSE_CODE) as Human_cause,(select count(STAT_CAUSE_CODE) from fire where STAT_CAUSE_CODE = '1') as Natural_cause
from fire
where STAT_CAUSE_CODE <> 9 And STAT_CAUSE_CODE <> 1 and STAT_CAUSE_CODE <> 13; */
 
Conclusion: The statement one advocacy group says human actions and nature are equally to blame for most wildfires is not true


Query 3
Question 5
How many wildfires were reported by at least two units/agencies?

Notes/Comments About SQL Query and Results (Include # of Rows in Result)
Number of rows #79358 76281

Translation
Select Fire Description and count of the units/agency
from the fire table
joining the NWGC Reporting Agency  table with fire table
grouping by fire name from fire table
using condition where count of the NWGC Reporting unit id is at least 2

-- Clean up --
/* 
select f.FIRE_NAME,  count(sr.NWGC_Reporting_unit_id) as Count_Fire_Reported
from fire as f
Join nwgc_reporting_agency as sr on f.NWCG_REPORTING_UNIT_ID = sr.NWGC_Reporting_unit_id
group by f.FIRE_NAME
having count(sr.NWGC_Reporting_unit_id) >= '2'
order by 2 ; */

  
Conclusion:The number of wildfires reported by at least two agencies/units are 79358 

Query 4
Question 6
What were the forests that had only one fire that lasted more than two days?

Notes/Comments About SQL Query and Results (Include # of Rows in Result)
Number of rows #33

Translation
Select NWGC Unit name and Count of FOD_ID 
from the fire table
joining NWGC Reporting agency and Fire table
using condition where the differnce between the Discovery day of the year and Controll day of the year is greater than 2 and count of FOD_ID is equal to 1 
Sorting in ascending order with respect to count of FOD_ID

-- Clean up --
/* select sr.NWGC_Unit_name as Forest_Name, count(f.FOD_ID) As Fire_Occurrence
from fire as f
Join nwgc_reporting_agency as sr on f.NWCG_REPORTING_UNIT_ID = sr.NWGC_Reporting_unit_id
where (DISCOVERY_DOY - CONT_DOY) > '2' 
group by f.NWCG_REPORTING_UNIT_ID
having  count(f.FOD_ID) = 1
Order BY count(f.FOD_ID) asc; */
  
Query 5
Question 7
Which state had fires only in the second half of the calendar years?

Notes/Comments About SQL Query and Results (Include # of Rows in Result)
Number of rows # 0
Translation

-- Translation -- 
/* Select the state 
from the fire table
where the Discovery day of the year is  greater than or  equal to 183 days only
and grouping by with respect to STATE  */

-- Clean up --
/* Select gt.State,gt.H2_fires_cnt,lt.H1_fires_cnt from
(SELECT STATE, COUNT(FOD_ID) as H2_fires_cnt
FROM fire 
WHERE DISCOVERY_DOY > '183' GROUP BY STATE) as gt
Join (SELECT STATE, COUNT(FOD_ID) as H1_fires_cnt
FROM fire
WHERE DISCOVERY_DOY <= '183' GROUP BY STATE) as lt
on gt.STATE=lt.STATE Where gt.H2_fires_cnt> 0
and lt.H1_fires_cnt = 0; Screen Shot of SQL Query and Results

Conclusion: There were fire in all the state all round the year and the output is blank because there was no state in which there was fire only in second half of the calendar years.
 
Query 6
Question
Which forest had the number of fires equal to the average number of wild fires in the US?
Notes/Comments About SQL Query and Results (Include # of Rows in Result)
Number of rows # 0
Translation
-- Translation -- 

/* Select the source reporting unit name as the forest name and count of the FOD_ID 
from the fire table 
joining the source reporting unit and fire table
grouping by with respect to the source reporting unit
using subquery as a condition where 
fire count equals to average count of the fire that were reported by unit in the state US 
*/

-- Sub Query Translation --
/*selecting the avg count 
from the fire table
joing the fire and unit details table 
using condition where the country is US */

-- Clean up --
/* select sr.SOURCE_REPORTING_UNIT_NAME as Forest_Name, count(f.SOURCE_REPORTING_UNIT) as Fire_Count
from fire as f
Join source_reporting_unit as sr on f.SOURCE_REPORTING_UNIT = sr.SOURCE_REPORTING_UNIT
Where "Fire_Count" =
(select avg(Count) from
(select f.STATE, ud.Country, f.FOD_ID as Count  
from fire as f
join unit_details ud on f.STATE = ud.State
where ud.Country = 'US'
Group by f.STATE) as Counts)
group by sr.SOURCE_REPORTING_UNIT_NAME; */
Screen Shot of SQL Query and Results

  
Conclusion: The avg number of wildfires in US was 61857.3077 and no forest has number of fires equal to the average number of wild fires in US therefore the output is blank.


 

		


 
