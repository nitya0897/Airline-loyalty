create database air_loyality ;

use air_loyality ;

select * from calendar ;

create table flight
(
`Loyalty Number` int,
`Year` int,
`Month` int,
`Total Flights` int,
`distance` int,
`Points Accumulated` int,
`Points Redeemed` int,
`Dollar Cost Points Redeemed` int
);

LOAD DATA LOCAL INFILE 'D:\\SQL\\Data set Project\\Airline Loyality\\Customer Flight Activity.csv'
INTO TABLE flight
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n';

select * from flight;

create table loyalty
(
`Loyalty Number`int,
`Country` text,
`Province` text,
`City` text,
`Postal Code` text,
`Gender` text,
`Education` text,
`Salary` bigint,
`Marital Status` text,
`Loyalty Card` text,
`CLV` double,
`Enrollment Type` text,
`Enrollment Year` int,
`Enrollment Month` int,
`Cancellation Year` text,
`Cancellation Month` text

);

LOAD DATA LOCAL INFILE 'D:\\SQL\\Data set Project\\Airline Loyality\\Customer Loyalty History.csv'
INTO TABLE loyalty
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n';

select * from loyalty;

select * from flight;

select * from calendar;

delete from loyalty
where `loyalty Number` = 0
limit 1;
select * from loyalty
where `loyalty Number` =0 ;

select * from flight where	`loyalty number`= 0;

SET SQL_SAFE_UPDATEs = 0;
delete from flight
where `loyalty Number`= 0 ;

                                           /*How many customer are loyal to Indian airlines?*/

select count(`loyalty Number`) as total_number from loyalty ;

                                   /*How many passengers has come and ratio of male and female customer?*/
                                   
select 
sum(case when gender = "Male" then 1 else 0  end) as male_count,
sum(case when gender= "female" then 1 else 0 end) as female_count,
sum(case when gender = "male" then 1 else 0 end)/sum(case when gender = "female" then 1 else 0 end) as  ratio
from loyalty ;

-- total passenger- 16737
                                      
                                      /*  How many male and female according to marital status married, single and divorced?*/
                                      
select gender,`marital status`,count(*) as count from loyalty

group by gender, `marital status` 

order by gender, `marital status` ;

                                      /*How many customers has enrolled their name in the year of 2012,2018,2016,2014?*/
   


select `Enrollment year`, count(*) as Total_Customer from loyalty 

where `Enrollment year` in ("2012","2014","2016","2018")

group by   `Enrollment year` ; 
                                       
                     /* How many customers has enrolled their name  according  to year?*/

select `enrollment year`,count(*) as Total_Customer from loyalty

group by  `enrollment year` ;     

                           /*Find out the loyalty customer Id who traveled highest distance in Indian airline and find the details of that person*/   
                           
select * from flight ;

select `loyalty number`,distance  from flight

 order by distance desc limit 5;     
 
 select * from flight
 where `loyalty number` = 797704 ;
 
                            /*Find out the loyalty number who accumulated maximum points.*/
                            
select `loyalty number`,`points accumulated` from flight

order by `points accumulated`  desc  limit 5;  

 select * from flight
 
 where `loyalty number` = 797704 ;
 
                             /* Total number of passengers who collected no Points?*/
                                         
select count(`loyalty number`) as  Total_customer from flight
where `points accumulated` = 0 ;

                                /*Who has maximum customer lifetime value (CLV)?*/
                                
select * from loyalty 

order by clv desc limit 5 ;    

                                /*Count of customer who has more than average CLV and less than CLV?*/   
                                
with C as
(
select count(`loyalty number`),sum(CLV) as total_CLV, count(*) as total_order,
avg(sum(CLV)) over() as  avg_CLV
from loyalty

group by `loyalty number`
)

select 
count( case when total_CLV > avg_CLV then 1 else 0 end) as above_average,
count(case when total_CLV < avg_CLV then 1 else 0 end) as below_average

from C ;

                                              /*Find out the standard employment according to province?*/
                                              
                                            
                                
select province ,count(`enrollment type`) as standard_employment from loyalty

where `enrollment type` = "standard"

group by province;

                 /*How many married “FEMALE” persons with standard employment live in Toronto ,have star loyalty and their education are bachelor do that according  to province ?*/

select province ,count(*) as count_member from loyalty

where city = "toronto" and gender = "female" and education = "bachelor" and `loyalty Card` = "Star"

group by province;

/*Category the loyalty number with their income –100000-150000- HIGH 50000-100000- Medium
Less than5000 low 
*/

select * from loyalty;

select `loyalty number`,salary ,
case
when salary >=100000 then "HIGH"
when salary >= 50000 then "Medium"
else  "Low" 

end as salary_structure

from loyalty;
                                       
                                       /*In which quarter maximum customer has enrolled  their name ?*/

select * from calendar ;

alter table calendar
add column `new_cate` date ;

SET SQL_SAFE_UPDATEs = 0;

update calendar

set `new_cate` = str_to_date(`ï»¿Date` ,"%d/%m/%Y");

alter table calendar
add column `year` year ;

SET SQL_SAFE_UPDATEs = 0;


update  calendar
set `year` = year(new_cate);

alter table calendar
rename column `year` to `Enrollment Year`;


select * from calendar ;

select *  from loyalty ;


SELECT C.new_cate,
       extract(quarter from C.new_cate) AS quarter,
       count(L.`loyalty number`) AS loyalty_count
FROM calendar C
LEFT JOIN loyalty L ON C.`Enrollment Year` = L.`Enrollment Year`

GROUP BY C.new_cate, YEAR(C.new_cate)

order by loyalty_count desc limit 1 ; 


   














