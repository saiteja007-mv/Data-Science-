# Day 14 30-10-23

select * from farmers_market.customer_purchases;
select * from `farmers_market.product`;
select * from `farmers_market.vendor`;
# Basic Queries 
select vendor_owner_first_name, vendor_owner_last_name from `farmers_market.vendor`;

# Getting data with limit 
select * from farmers_market.customer_purchases  order by customer_id limit 0;

# 30 Rows of Product sort by product size 
select * from `farmers_market.product` order by product_size desc limit 30;

# Getting full name which is not there in table 
select customer_first_name,customer_last_name,concat(customer_first_name,' ',customer_last_name) as customer_full_name from `farmers_market.customer`; 

/* Total amount spend on purchase */
select product_id,transaction_time,quantity*cost_to_customer_per_qty as Price from farmers_market.customer_purchases;



/* Day 15 31-10-23 */ 

/* Question 1 : Write a SQL query to get the first name of the customer name and first letter of lastname of the customer */
select customer_first_name,customer_last_name,
concat(customer_first_name," ",substr(customer_last_name,1,1)) as cust_full_name
from `farmers_market.customer`;

/* Using Offset */
/* Question 2 : Write a SQL query to extract 10 records from products table leaving the first 5 records */
select * from `farmers_market.product` order by product_id limit 10 offset 5;

/* Using Where clause */
/* Question 3 : Write a SQL query to extract all the purchase details with customer id 1 */
/* using IN in where clause */
select *,quantity*cost_to_customer_per_qty as total_amount from farmers_market.customer_purchases where customer_id in (1,3,5) order by customer_id ;

/* Using between in where clause */
select *,quantity*cost_to_customer_per_qty as total_amount from farmers_market.customer_purchases where customer_id between 1 and 5 order by customer_id ;

/* Logic or and 
/* Question 4 : Write a SQl query to Get all the products with ID between 3 and 8 (not inclusive and product with ID 10) */
select * from `farmers_market.product` where  (product_id > 3 and product_id < 8) or product_id = 10 ;

/* Using Upper and Lower */
/* Question 5 : Return a list of customers with the following lastname (DIAZ, EDWARDS, WILLSON) */
select * from `farmers_market.customer` where upper(customer_last_name) in ('DIAZ', 'EDWARDS', 'WILLSON');

# Using like
# Question 6 :
select * from `farmers_market.customer` where customer_last_name like "%z";



# Day 16 01-11-23

# NULL Values
# Question 1 Find all the products from the product table which dont have sizes mentioned 
select * from `farmers_market.product` where product_size is NULL or product_size = " " or trim(product_size) = "";

# Sub Queries
# Question 2 
# Analyse the purchases made at the market on days when it rained
select market_date, customer_id,quantity,cost_to_customer_per_qty from farmers_market.customer_purchases where market_date in (select market_date from `farmers_market.market_date_info` where market_rain_flag = 1); 

# Question 3
# List down all the product details where product category name contains fresh in it
select * from `farmers_market.product` where product_category_id in (select product_category_id from `farmers_market.product_category` where lower(product_category_name) like '%fresh%');

#Case & When 
# Question 4
# Find out which vendor primarily sell fresh products which don't
select vendor_id,vendor_name,vendor_type,
case 
  when lower(vendor_type) like '%fresh%'
  then "Fresh Product"
  else "Other"
end as Food_Category
from `farmers_market.vendor`; 



# Day 17 02-11-23

# Joins - Syntax 
# Select <column_name> 
# from <Left_Table> as <Alias_name>
# <Type_JOIN> 
# <Right_Table> as <Alias_name>
# ON 
# <Left_Table>.<column> = <Right_Table>.<column>;

# Question 1 : List all the products along with there product category names 
select pro.*,proc.product_category_name 
from `farmers_market.product` as pro 
left join 
`farmers_market.product_category` as proc 
on pro.product_category_id = proc.product_category_id;

# Question 2 : Get a list of customer's zip codes who made a purchase on 2019-04-06
select c.customer_zip
from `farmers_market.customer` as c
inner join
farmers_market.customer_purchases as cp
on c.customer_id = cp.customer_id
where cp.market_date = '2019-04-06';



select * from `farmers_market.customer` where customer_id not in (select customer_id from farmers_market.customer_purchases);


# Day 18 - 03 11 23
# Union 
(select * from `farmers_market.customer` order by customer_id) 
union distinct
(select * from `farmers_market.customer` order by customer_id);

(select product_id from `farmers_market.product`)
union all 
(select product_id from `farmers_market.vendor_inventory`);

select * from `farmers_market.customer` order by customer_id;

# Joining Multiple tables using Joins
# Question 1 : Write a SQL Query to get the details about all farmers markets booths and every vendor booth assignment for every market date along with the vendor details

select * from `farmers_market.booth` as b
left join 
`farmers_market.vendor_booth_assignments` as vs
on b.booth_number = vs.booth_number 
inner join
`farmers_market.vendor` as v 
on 
vs.vendor_id = v.vendor_id;

# Question 2 : Write a SQL Query to display each employees manager name along with the employee ID in the employee table
# select e.emp_id, e.name, em.name, e.salary
# from `farmers_market.Employee` as e 
# join
# `farmers_market.Employee` as em 
# on e.report_to = em.emp_id;

# Cross Join
# Syntax 
# select * from model cross join colors;


# Day 19 - 06 11 23
# Group by 
# It is a phenomina to increase the granularity of the data for the desired attribute

# Syntax 
# select 
#     <column name>,
#     Agg <column name>
# from <Dataset>.<Tablename>
# group by <column name>;

# Question 1 : Get a list of Customers who made purchase on each market date 
select market_date,count(customer_id) as No_of_Customers,sum(quantity*cost_to_customer_per_qty) as sale,round(avg(quantity*cost_to_customer_per_qty),2) as average_sale
from farmers_market.customer_purchases group by market_date order by market_date;


# Question 2 : Count the number of purchases each customer made on each market date
select market_date,customer_id,count(customer_id) as count_of_purchases
from farmers_market.customer_purchases group by market_date,customer_id order by market_date,count_of_purchases,customer_id;


# Day 20 - 07 11 23
# Question 1 : Write a SQL query to calcualte the total amount paid by customerid 3 per market_date
select customer_id,market_date,round(sum(quantity*cost_to_customer_per_qty),2) as total_amount from farmers_market.customer_purchases where customer_id = 3 group by customer_id,market_date order by market_date;

# Question 2 : Write a SQL Query to find the least and most expensive items prices in vendor inventory
select 
market_date,product_id,max(original_price) as Expensive_product,min(original_price) as Cheap_product 
from `farmers_market.vendor_inventory` 
group by market_date,product_id 
order by market_date;

# Question 3 : Write an SQL Query to Find the avg amount on each market by considering only those dates where the number of purchases are more than 3 and the transcation amount is greater than 5
select market_date,avg(quantity*cost_to_customer_per_qty) as avg_amount 
from farmers_market.customer_purchases 
where (quantity*cost_to_customer_per_qty) > 5 
group by market_date 
having count(customer_id) > 3;



# Day 21 - 08 11 23
# Window Functions
# Syntax : 
# select 
#   <Column>,
#   <Column>,
# window fun() over(partition by <Column> order by <column>)
# from database.tablename

# Window functions -> Rownumber(), Rank(), Denserank(), Sum(), Average(), Max(), Min()

# Question 1 : Write a SQL query to rank the products on there price per vendor 
select
  vendor_id,
  market_date,
  product_id,
  original_price,
  dense_rank() over(partition by vendor_id order by original_price desc) as dense_rank,
  row_number() over(partition by vendor_id order by original_price desc) as row_number,
  rank() over(partition by vendor_id order by original_price desc) as rank
from `farmers_market.vendor_inventory`;

# Question 2 : Write a SQL query to extract the highest sale done on each market dates 
# Using in line query
# Sub query gives us single columns but in line query give entire table 
select 
distinct r.market_date,
r.sale
from 
(select 
market_date,
quantity*cost_to_customer_per_qty as sale,
dense_rank() over(partition by market_date order by quantity*cost_to_customer_per_qty desc) as Highest_sale_rank
from farmers_market.customer_purchases) as r
where r.Highest_sale_rank = 1;

# Day 22 - 09 11 23
# Aggregation in window functions
# Syntax : Avg(<column>) over (partition by <column> order by <column>)
# Question 3 : Write a query to figure out which of the products where above the average price on each market date.
select 
distinct vi.market_date,
vi.original_price,
vi.avg_price
from 
(select
market_date,
original_price, 
avg(original_price) over (partition by market_date order by market_date) as avg_price
from `farmers_market.vendor_inventory`) as vi
where vi.original_price > vi.avg_price;

# Question 4 : Write a SQL query to count how many different products each vendor bought on each market date
select 
*,
count(product_id) over (partition by vendor_id,market_date) as diff_products
from `farmers_market.vendor_inventory`;


# Question 5 : Write a SQL Query to find the sum of the purchases of all customer on each market date.
select market_date,quantity*cost_to_customer_per_qty,transaction_time,
sum(quantity*cost_to_customer_per_qty) over (partition by customer_id order by market_date) as purchases
from farmers_market.customer_purchases;


select market_date,quantity*cost_to_customer_per_qty,transaction_time,customer_id,
sum(quantity*cost_to_customer_per_qty) over (partition by market_date) as purchases
from farmers_market.customer_purchases;

#
# Unbounded Preceeding
# |
# |
# |- Current
# |
# |
# Unbounded Successding
#

# Question 6: Write a SQL Query to Calcualte the 5 days moving average for all the customers with each market date.
select customer_id,market_date,quantity*cost_to_customer_per_qty,
avg(quantity*cost_to_customer_per_qty) over (partition by market_date order by market_date rows between 7 preceding and 7 following) as avg
from farmers_market.customer_purchases;


# Day 22 - 10 11 23
# Window Functions -> Lag() and Lead()
# Syntax 
# Lag(<column name>,no_of_precedings) over (partition by <col> order by <col>)
# Lead(<column name>,no_of_successding) over (partition by <col> order by <col>)

# Question 1 : Find out the who are the new vendor to the booth or vendor who are changes the booth every next day
select b.vendor_id,b.market_date,b.booth_number,b.changing_booth from
( select vendor_id,market_date,booth_number,
lag(booth_number) over (partition by vendor_id order by market_date) as changing_booth
from `farmers_market.vendor_booth_assignments` where vendor_id =4) as b
where b.changing_booth is NULL or b.changing_booth <> b.booth_number;

# Date and Time Functions
# Extract Function
# Syntax Extract(Day from <col name>) as Day
# If you want to get the name of Day we use format_date()
select market_date,
Extract(DAY from market_date) as Day,
Extract(MONTH from market_date) as Month_num,
Extract(YEAR from market_date) as Year,
Extract(Hour from market_start_datetime) as Hour,
Extract(Minute from market_start_datetime) as Minute,
format_date("%A",market_date) as Day_name,
format_date("%b",market_date) as Month
from `farmers_market.datetime_demo`;

# Date_add(<column>, interval num days)
select market_date,
date_add(market_date, INTERVAL 1 day) as Next_Day,
date_sub(market_date, INTERVAL 1 day) as previous_day
from `farmers_market.datetime_demo`;

# Write a SQL query to find out how many days where farmers market is active
select date_diff(max(market_date),min(market_date),Day) as days_diff
from farmers_market.customer_purchases;

select date_diff(current_date,max(market_date),Day) as days_diff
from farmers_market.customer_purchases;


# Write a SQL Query to find how many purchases did a customer make and how old the customer in the market ?
select customer_id,min(market_date) as Start_date,max(market_date) as End_date,count(transaction_time) as No_of_purchases,date_diff(max(market_date),min(market_date),Day) as Days_Old
from farmers_market.customer_purchases
group by customer_id;

# Find out the no of days between each purchase.
select market_date,
date_diff(market_date,lag(market_date) over (partition by customer_id order by market_date),Day) as No_of_Day_purchase
from farmers_market.customer_purchases;

# Day 23 - 14 11 23
# CTE Comman Table Expression
with 
product_all as 
( select * from farmers_market.product as p 
   left join farmers_market.product_category as pc 
   on p.product_category_id = pc.product_category_id )

select * from product_all;