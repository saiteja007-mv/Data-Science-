/* Assignment 2 Question 2 */
select product_id, product_name from `farmers_market.product` order by product_id;

/* Assignment 2 Quesiton 3 */
select emp_id, name, salary, salary+(salary*0.2) as New_salary from `farmers_market.Employee` order by emp_id;

# Assignment 3 Question 1
select * from `farmers_market.vendor_booth_assignments` where vendor_id = 7 and market_date between '2019-04-03' and '2019-05-16';

# Assignment 3 Question 2
select * from `farmers_market.customer` where customer_first_name like 'Jer%';

# Assignment 3 Question 3
select * from farmers_market.customer_purchases where customer_id = 4 order by market_date;

# Assignment 3 Question 4 
# select * from 'Supermarket.Products' order by Revenue offset 2;

# Assignment 4 Question 1
select
*, cost_to_customer_per_qty*quantity as Transcation_value,
case
  when cost_to_customer_per_qty*quantity > 15
  then "Prime Customer"
  when cost_to_customer_per_qty*quantity < 10
  then "Non-Prime Customer"
end as Customer_type

from farmers_market.customer_purchases;

# Assignment 4 Question 2
select *,
case 
  when lower(booth_description) like '%left%'
  then 'Left Booth'
  when lower(booth_description) like '%right%'
  then 'Right Booth'
  else
  'Neutral Booth'
end as Booth
from `farmers_market.booth`;

# Assignment 4 Question 3
# Here %A is a format specifier which means full weekday name
select *,FORMAT_DATE('%A', DATE(market_date)) as Market_day 
from farmers_market.customer_purchases 
where lower(FORMAT_DATE('%A', DATE(market_date))) = 'wednesday';


# Assignment 4 Question 4
select * from farmers_market.customer_purchases 
where market_date 
in (select market_date from `farmers_market.market_date_info` where market_max_temp between '30' and '55' order by market_max_temp);

#select market_max_temp,market_min_temp,market_date from `farmers_market.market_date_info` where market_min_temp between '30' and '55' and market_max_temp between '30' and '55' order by market_min_temp

# Assignment 4 Question 5
#select employee_id, salary, 
#case
#  when salary > 20000
#  then 'Class A'
#  when salary between 10000 and 20000
#  then 'Class B'
#  when salary < 10000
#  then 'Class C'
#end as Salary_bin
#from `farmers_market.Employee` order by employee_id;

# Assignment 5 Question 1
# a) Write a SQL Query to find out customers who are new to the market and have not placed any order yet.
select * 
from 
`farmers_market.customer` as c
left join 
farmers_market.customer_purchases as cp 
on c.customer_id = cp.customer_id
where c.customer_id is null;

# b) Customers who deleted their account 
select * 
from
farmers_market.customer_purchases as cp
left join 
`farmers_market.customer` as c
on c.customer_id = cp.customer_id
where cp.customer_id is null;

# Assignment 6 Question 1
#Write a SQL Query to get all the products available for all the market dates with the Vendor details. Return columns (Product_ID, Market_date, Vendor_ID, Vendor_name)
select p.product_id,p.product_name,vi.market_date,v.vendor_id,v.vendor_name from `farmers_market.product` as p 
left join 
`farmers_market.vendor_inventory` as vi 
on p.product_id = vi.product_id

inner join 
`farmers_market.vendor` as v 
on vi.vendor_id = v.vendor_id;

# Assignment 6 Question 2 
# Write a SQL Query to Append columns (Product_ID, Vendor_Id, Booth_number)
((select product_id from `farmers_market.product`) union all (select vendor_id from `farmers_market.vendor`)) union all (select booth_number from `farmers_market.booth`);    

# Assignment 6 Question 3
# Write a SQL Query to find out how many days it has Rained and Snowed on the same day!
select count(market_date) from `farmers_market.market_date_info` where market_rain_flag = 1 and market_snow_flag = 1;

# Assignment 6 Question 4
# Write a SQL Query to find out the top 10 customers by purchases considering we have One transactions per customer
select distinct customer_id,round(quantity*cost_to_customer_per_qty,1) as price from farmers_market.customer_purchases order by price desc limit 10;

# Assignment 6 Question 5
# Write a SQL query to find out the sales that have happened at 4pm to 6pm and 7.30pm to 8pm
select * from farmers_market.customer_purchases where transaction_time between '16:00:00' and '18:00:00' or transaction_time between '19:30:00' and '20:00:00';

# Assignment 6 Question 6
# Write a SQL query to find all the customers with Odd customer ID’s
select * from `farmers_market.customer` where mod(customer_id,2) = 1 ;

# Assignment 6 Question 7
# Write a SQL query to display product category name and product name
select * from `farmers_market.product_category` 
cross join 
`farmers_market.product`;


# Assignment 7 Question 1
# Write a query to Calculate the total quantity purchased by each customer per market_date
select customer_id,market_date,sum(quantity) as total_quantity 
from farmers_market.customer_purchases 
group by market_date,customer_id;

# Assignment 7 Question 2
# Write a query to find how many different kinds of products were purchased by each customer on each market_date?
select customer_id,market_date,count(distinct product_id) as kinds_of_products 
from farmers_market.customer_purchases 
group by customer_id,market_date;

# Assignment 7 Question 3
# Write a query to Find out the average sales happened per vendor on each market date
select market_date,vendor_id,round(avg(quantity*cost_to_customer_per_qty),2) as avg_sales 
from farmers_market.customer_purchases 
group by vendor_id,market_date;

# Assignment 7 Question 4
# Write a query to find out the maximum and minimum quantities sold overall
select max(quantity) as max_quantity,min(quantity) as min_quantity 
from farmers_market.customer_purchases;


# Assignmen 8 Question 1
# Write a Query find all the market dates for which the total sales is are more that $150
select market_date,sum(quantity*cost_to_customer_per_qty) as Sales 
from farmers_market.customer_purchases 
group by market_date 
having sum(quantity*cost_to_customer_per_qty) > 150 order by sales; # Order by is taken for clear understanding 

# Assignment 8 Question 2
# Write a Query to get the Vendor ID for which the total sales is between $100 to $150 for every market date
select market_date,vendor_id,sum(quantity*cost_to_customer_per_qty) as sales 
from farmers_market.customer_purchases 
group by market_date,vendor_id 
having sum(quantity*cost_to_customer_per_qty) between 100 and 150;

# Assignment 8 Question 3
# Write a query to find all the products which have a minimum of 20 quantities sold on each market date
select market_date,product_id from farmers_market.customer_purchases 
group by market_date,product_id 
having min(quantity) = 20;

# Assignment 8 Question 4
# Errors 


#select market_date,product_id,sum(market_date)/0 from farmers_market.customer_purchases  group by market_date,product_id;
 
select * from farmers_market.customer_purchases where transaction_time between '00:00:16' and '18:00:00' or transaction_time between '19:30:00' and '20:00:00';


# Assignment 9 Question 1
# Here in this query we have write the over after the rank function ( rank() over ) and by is missing after partition which is not the right syntax
SELECT
vendor_id,
market_date,
product_id,
Original_price,
RANK() OVER (PARTITION by vendor_id ORDER BY original_price DESC)
AS price_rank
FROM `farmers_market.vendor_inventory`;

# Assignment 9 Question 2
# In this query there are three error .
# 1. DENSE RANK() does not have the right syntax should DENSE_RANK().
# 2. The database name is not mentioned before the table name, it should be `farmers_markets.vendor_inventory` .
# 3. While selecting the product_Id from the table, the product_Id is misspelled it should be product_id .
# 4. There is no comma between market_date and product_id which will throw a error.
SELECT
vendor_id,
market_date,
product_id,
original_price,
DENSE_RANK() OVER (PARTITION BY product_id ORDER BY original_price
DESC) AS price_rank
FROM `farmers_market.vendor_inventory`;

# Assignment 9 Question 3
# Complete the below query to get the desired result (Total_amt paid by customer_id 4 & 5 per market_date )
SELECT
market_date,
customer_id,
sum(quantity * cost_to_customer_per_qty) AS total_amt_spent
FROM farmers_market.customer_purchases 
where customer_id = 4 or customer_id = 5
group by market_date,customer_id
ORDER BY market_date;

# Assignment 9 Question 4
# Complete the below query to get the desired result (List down all the product details where product category contains “Fruits” in it.)
SELECT *
FROM `farmers_market.product`
WHERE product_category_id IN ( select  product_category_id
FROM `farmers_market.product_category`
WHERE INITCAP(product_category_name) like '%Fruits%');

# Assignment 9 Question 5
# Write a Query to Rank all the products bases on their Quantities sold per market date (Use all Rank(), Dense_Rank() & Row numbers() functions in your query)
select
market_date,
quantity,
rank() over (partition by market_date order by quantity) as rank,
dense_rank() over (partition by market_date order by quantity) as dense_rank,
row_number() over (partition by market_date order by quantity) as row_number
from farmers_market.customer_purchases;


# Assignment 10 Question 1
# Write a query to figure out which of your products were above the average price per vendor on each market date?
select * from (select product_id,market_date,original_price,
avg(original_price) over (partition by vendor_id,market_date order by market_date) as avg_price
from `farmers_market.vendor_inventory` ) as vi where vi.original_price > vi.avg_price;

# Assignment 10 Question 2
# Write a query to count how many different products each customer brought on each date.
select customer_id,market_date,
count(product_id) over (partition by customer_id,market_date order by customer_id,market_date) as count_product
from farmers_market.customer_purchases;

# Assignment 10 Question 3
# Write a query to count the avg of quantities bought by customers on each date.
select distinct market_date,
count(*) over (partition by market_date) as count_per_date,
avg(quantity) over (partition by customer_id,market_date order by market_date) as avg_quantity_per_date
from farmers_market.customer_purchases;

# Assignment 10 Question 4
# Write a query to calculate the 5 days running sum for each customers (Unbounded preceding and current row with average function )
select *,
sum(quantity*cost_to_customer_per_qty) over (partition by customer_id order by market_date) as sum_sales,
avg(quantity*cost_to_customer_per_qty) over (partition by customer_id order by market_date rows between 5 preceding and current row) as avg_sales
from farmers_market.customer_purchases;

# Assignment 10 Question 5
# Write a query to calculate how many days the total sales was higher than the previous day



# Assignment 11 Question 1
# Write a query to display the days which had more quantities sold on the current day than the next day.
select cp.market_date,round(sum(cp.quantity),2) as sum_of_curr,round(sum(cp.previous_day_quan),2) as sum_of_prev from 
(select market_date, quantity,
lead(quantity) over (partition by market_date order by market_date) as previous_day_quan
from farmers_market.customer_purchases) as cp
group by cp.market_date having sum(cp.quantity) > sum(cp.previous_day_quan) ;

# Assignment 11 Question 2
# Write a query to find the number of days gap between each purchase of each customer
select customer_id,
date_diff(market_date,lag(market_date) over (partition by market_date,customer_id order by market_date,customer_id),Day) as day_differ
from farmers_market.customer_purchases;

# Assignment 11 Question 3
# Write a query to find the duration between the first and last purchase of the Customer ID 4
select customer_id,
date_diff(max(market_date),min(market_date),Day) as Duration_of_purchase
from farmers_market.customer_purchases
group by customer_id having customer_id = 4;

# Assignment 11 Question 4
# Write a query to find the total count of Saturday’s and Wednesday’s of the market.
select
countif(extract(dayofweek from market_date) = 7) as SaturdayCount,
countif(extract(dayofweek from market_date) = 4) as WednesdayCount
from  farmers_market.customer_purchases
where  extract(dayofweek from market_date) in (4, 7);


# Assignment 11 Question 5
# Write a Query list out the dates where customers bought more quantities or Increased their total amount spent in their next purchase.
select cp.market_date,cp.customer_id,cp.next_quantity,cp.next_total_amount from 
(select market_date,quantity*cost_to_customer_per_qty as sale,customer_id,quantity,
lead(quantity) over (partition by market_date order by market_date) as next_quantity,
lead(cost_to_customer_per_qty*quantity) over (partition by market_date order by market_date) as next_total_amount
from farmers_market.customer_purchases) as cp
where cp.sale > cp.next_total_amount or cp.quantity > cp.next_quantity;

