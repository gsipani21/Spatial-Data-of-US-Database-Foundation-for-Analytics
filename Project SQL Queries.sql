-- Question 1--
select sr.NWGC_Unit_name as Forest_Name, f.STATE
from fire as f
Join nwgc_reporting_agency as sr on f.NWCG_REPORTING_UNIT_ID = sr.NWGC_Reporting_unit_id
where f.STAT_CAUSE_CODE = 5
group by f.STATE
order by count(f.STAT_CAUSE_CODE) asc 
Limit 2;
-- --

-- Question 2 --
select sr.NWGC_Unit_name as Forest_Name, count(f.STAT_CAUSE_CODE) as FIRES_INVOLING_CHILDREN
from nwgc_reporting_agency as sr
Join fire as f on f.NWCG_REPORTING_UNIT_ID = sr.NWGC_Reporting_unit_id
where f.STAT_CAUSE_CODE = 8
group by sr.NWGC_Unit_name
order by 2 asc
limit 5;

-- Question 3 --
select count(STAT_CAUSE_CODE) as Human_cause,(select count(STAT_CAUSE_CODE) from fire where STAT_CAUSE_CODE = '1') as Natural_cause
from fire
where STAT_CAUSE_CODE <> 9 And STAT_CAUSE_CODE <> 1 and STAT_CAUSE_CODE <> 13;

-- --
-- Question 5 --

select f.FIRE_NAME,  count(sr.NWGC_Reporting_unit_id) as Count_Fire_Reported
from fire as f
Join nwgc_reporting_agency as sr on f.NWCG_REPORTING_UNIT_ID = sr.NWGC_Reporting_unit_id
group by f.FIRE_NAME
having count(sr.NWGC_Reporting_unit_id) >= '2'
order by 2 ;

-- --
-- Question 6 -- 

select sr.NWGC_Unit_name as Forest_Name, count(f.FOD_ID) As Fire_Occurrence
from fire as f
Join nwgc_reporting_agency as sr on f.NWCG_REPORTING_UNIT_ID = sr.NWGC_Reporting_unit_id
where (DISCOVERY_DOY - CONT_DOY) > '2' 
group by f.NWCG_REPORTING_UNIT_ID
having  count(f.FOD_ID) = 1
Order BY count(f.FOD_ID) asc;

-- --
-- Question 7  -- 
select STATE, makedate(DISCOVERY_DATE/1000-449,DISCOVERY_DATE%1000 - 4.5) As DISCOVERY_DATE
from fire
where DISCOVERY_DOY >= '183'
group by STATE;

-- Question 8 --

-- Fire Count reported by the agency --
select sr.SOURCE_REPORTING_UNIT_NAME as Forest_Name, count(f.FOD_ID) as Fire_Count
from fire as f
Join source_reporting_unit as sr on f.SOURCE_REPORTING_UNIT = sr.SOURCE_REPORTING_UNIT
group by sr.SOURCE_REPORTING_UNIT_NAME
order by count(f.SOURCE_REPORTING_UNIT) desc;
 -- Average count of fire reported by agency in US --
select avg(Count) from
(select f.STATE, ud.Country, f.FOD_ID as Count  
from fire as f
join unit_details ud on f.STATE = ud.State
where ud.Country = 'US'
Group by f.STATE) as Counts;

-- Agency fire count equal to Avg Fire COunt --
select sr.SOURCE_REPORTING_UNIT_NAME as Forest_Name, count(f.SOURCE_REPORTING_UNIT) as Fire_Count
from fire as f
Join source_reporting_unit as sr on f.SOURCE_REPORTING_UNIT = sr.SOURCE_REPORTING_UNIT
Where "Fire_Count" =
(select avg(Count) from
(select f.STATE, ud.Country, f.FOD_ID as Count  
from fire as f
join unit_details ud on f.STATE = ud.State
where ud.Country = 'US'
Group by f.STATE) as Counts)
group by sr.SOURCE_REPORTING_UNIT_NAME;
