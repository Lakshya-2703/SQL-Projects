-- This data is downloaded through https://www.kaggle.com/datasets/mustafakeser4/looker-ecommerce-bigquery-dataset?select=inventory_items.csv
-- Looker Ecommerce BigQuery Dataset
-- For Practice purpose i only used 3 tables


select * from inventory_items

select * from order_items

select *from users

--Creating Duplicates to avoid changes in original data

select *
into Inventory
from inventory_items

select *
into items_odered
from order_items

Select *
into Users_1
from users

Select *
from Inventory

select * 
from items_odered

select * 
from Users_1

--Cleaning data

Select sold_at, convert(date, sold_at) , 
	created_at,convert(date,created_at),
	cost,convert(decimal(20,2),cost),
	product_retail_price,convert(decimal(20,2),product_retail_price)
from Inventory

update Inventory
set created_at = convert(date,created_at),
	sold_at = convert(date, sold_at),
	cost = convert(decimal(20,2),cost),
	product_retail_price = convert(decimal(20,2),product_retail_price)

select created_at, convert(date,created_at),
	shipped_at,convert(date,shipped_at),
	delivered_at,convert(date,delivered_at),
	sale_price,convert(decimal(20,2),sale_price)
from items_odered 

update items_odered
set created_at = convert(date,created_at),
	shipped_at = convert(date,shipped_at),
	delivered_at = convert(date,delivered_at),
	sale_price = convert(decimal(20,2),sale_price)
from items_odered

SELECT created_at, convert(date,created_at)
from Users_1

update Users_1
set created_at = convert(date,created_at)

alter table users_1 drop COLUMN latitude,longitude

--Product status for users

select u.id,first_name,last_name,product_name,it.created_at,status
from Users_1 as U 
join Inventory as inv
on u.id = inv.id
join items_odered as it
on inv.id = it.id
and inv.created_at = inv.created_at
order by 1

--each product no. of orders
select distinct inv.product_name,count(it.product_id)
from Inventory inv join items_odered it
on inv.id = it.id
group by product_name
order by 2 desc

-- No. of product under each category
select distinct product_category,count(product_name)
from Inventory
group by product_category
order by 2 desc

--Total days it took to deliver the orders

Select created_at, delivered_at , datediff(day,created_at,delivered_at) as totaldays
from items_odered
where delivered_at is not null
and created_at < delivered_at
order by 3 desc

--No. of orders from each country

select distinct country,count(it.id)
from Users_1 U join items_odered it
on u.id = it.id
group by country 
order by 2 desc


-- introducing a new column in user having full address

select street_address +','+ city +','+ country +','+postal_code 
from Users_1

alter table users_1
add full_address nvarchar(200)

update Users_1
set full_address = street_address +','+ city +','+ country +','+postal_code 

