--For use in SQL Server

/*1. Create table*/

create table warehouse
(
ID varchar(10),
OnHandQuantity int,
OnHandQuantityDelta int,
event_type varchar(10),
event_datetime datetime
);

insert into warehouse values
('SH0013', 278, 99 , 'OutBound', '2020-05-25 0:25'),
('SH0012', 377, 31 , 'InBound', '2020-05-24 22:00'),
('SH0011', 346, 1 , 'OutBound', '2020-05-24 15:01'),
('SH0010', 346, 1 , 'OutBound', '2020-05-23 5:00'),
('SH009', 348, 102, 'InBound', '2020-04-25 18:00'),
('SH008', 246, 43 , 'InBound', '2020-04-25 2:00'),
('SH007', 203, 2 , 'OutBound', '2020-02-25 9:00'),
('SH006', 205, 129, 'OutBound', '2020-02-18 7:00'),
('SH005', 334, 1 , 'OutBound', '2020-02-18 8:00'),
('SH004', 335, 27 , 'OutBound', '2020-01-29 5:00'),
('SH003', 362, 120, 'InBound', '2019-12-31 2:00'),
('SH002', 242, 8 , 'OutBound', '2019-05-22 0:50'),
('SH001', 250, 250, 'InBound', '2019-05-20 0:45');

/*2. Solutions*/

declare @totalSales as varchar(1000)
set @totalSales = (select sum(onhandquantitydelta) from warehouse
where event_type = 'OutBound');

declare @currentdate as date
set @currentdate = '2020-05-25';

--create category table using CTE
with inventory_tbl as (
select grp, sum(onhandquantitydelta) as inbound
from (select *, grp = case
when datediff(day, convert(DATE,event_datetime),@currentdate) <= 90 then 'a_0-90 days old'
when datediff(day, convert(DATE,event_datetime),@currentdate) <= 180 then 'b_91-180 days old'
when datediff(day, convert(DATE,event_datetime),@currentdate) <= 270 then 'c_181-270 days old'
else 'd_271+ days old' end
from warehouse
where event_type = 'InBound') a
group by grp)

--use CTE & the totalSales for calculation
select *,
unused_inventory = iif(@totalSales > cum, 0, iif(lead is null, inbound, inbound - (@totalSales - lag)))
from (select *,
lag(inbound) over (order by grp desc) lag
,lead(inbound) over (order by grp desc) lead
,sum(inbound) over (order by grp desc ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) cum
from inventory_tbl) b
order by grp;