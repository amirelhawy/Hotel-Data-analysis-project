--1 update null valuse in column agent and rplace it with 0
use Hotel_management
update Hotel_data set [agent] = 0
where [agent] is null

update meal_cost$ set Cost = 0
where meal = 'sc'

-- 2 calculate the number of the guests and added to new column 
alter table Hotel_data
add Guest_number int
update Hotel_data 
set Guest_number = ([adults] +[children]+[babies])

 --3 add new column to calculate the total revenu and added to new column 
alter table Hotel_data
add revenue int
update Hotel_data
set revenue = (stays_in_week_nights + stays_in_weekend_nights)*adr

--4 know what is the year with the most arrivals and in which hotels 
select H.arrival_date_year, count(H.arrival_date_year) as arrival_counts from Hotel_data H 
where H.reservation_status = 'check-out'
--and H.is_canceled = 0
group by  H.arrival_date_year 
order by 2 desc




--5 wihch month with the more arrivels numbers in 2019
select H.arrival_date_month , count(H.adr) as monthly_arrivals
from Hotel_data H 
where H.arrival_date_year = 2019
and H.is_canceled = 0 
group by H.arrival_date_month
order by 2 desc


--6  calculate the average of adr in checked out reservation along the months 
-- and compar it with total revenue 
select H.arrival_date_month ,Round(AVG(H.adr),2) as avrageadr from Hotel_data H 
--where H.arrival_date_month in( 'october','september','august')
where H.reservation_status = 'check-out'
group by H.arrival_date_month 
order by 2 desc

-- the total uncancled reservation  revenue per month
select arrival_date_month , sum(revenue) as total_revenue
from Hotel_data 
where is_canceled = 0 
group by arrival_date_month
order by 2 desc



--7 calculate the revenue for un cacneled reservations for each hotel 
select H.hotel, sum(revenue) as  totalrevenue from Hotel_data H
where H.reservation_status = 'check-out'
group by H.hotel

-- 8 calculate the discount amount  

select H.hotel ,round(sum(H.revenue * MS.Discount),0) as totaldiscountamount from Hotel_data H left join market_segment$ MS 
on H.market_segment = MS.market_segment
--where H.reservation_status	= 'check-out'
group by  H.hotel 


--9 The numbers of not cancled bookings by  distribution_channel 
--(most and important distributed_channels are "TA" Travel Agents and "TO" means "Tour Operators")
select top 10 H.distribution_channel , sum(H.revenue) as total_revenue from Hotel_data H
--where H.distribution_channel = 'TA/TO'
where H.is_canceled = 0
group by H.distribution_channel
order by 2 desc




--10 calculate the revenue for each country  

use Hotel_management
select top 10 h.country ,sum(revenue) as total_revenu  
from Hotel_data H 
--where H.market_segment = 'Complementary'
--and H.reservation_status = 'Check-Out'
where is_canceled = 0
group by h.country 
order by 2 desc




-- 11 how many guest grouped by the hotel & Country

select H.hotel , sum(Guest_number) as guestnumber  from Hotel_data H 
where H.reservation_status = 'check-out'
group by H.hotel

select top 10  country , sum(Guest_number) guestnumber from Hotel_data H 
group by H.country
order by 2  desc

--12 how it cost the reservied meals for the guests 

select  H.meal , Round(sum(Guest_number * M.Cost),0) as Totalmealcost   
from Hotel_data H left join meal_cost$ M
on H.meal = M.meal
group by H.meal
order by 2 desc

select  H.meal , count(Guest_number) as mealcount  
from Hotel_data H left join meal_cost$ M
on H.meal = M.meal
group by H.meal
order by 2 desc




