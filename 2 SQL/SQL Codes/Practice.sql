USE farmers_market;
-- Easy
-- Select all customers from the customer table.
select * from customer;

-- Select all products from the product table where the original price is greater than 10.
select distinct p.product_name,v.original_price from product as p inner join vendor_inventory as v on p.product_id = v.product_id where v.original_price > 5;

-- Select all vendors from the vendor table where the vendor type is 'Farmer'.
select * from vendor where lower(vendor_type) like '%farmer%';

-- Group the customers by their zip code and count the number of customers in each zip code.

-- Select all the customer zip codes from the customer table where there are more than 100 customers in each zip code.
-- Select all the customers from the customer table ordered by their last name in ascending order.

-- Moderate

-- Select all the vendors from the vendor table who sell a product that is more expensive than $10, using a subquery.
-- Select all the market dates from the market_date table where the total sales are greater than the average sales for the market, using a subquery.
-- Join the customer, vendor, and product tables to select all the customers who purchased a specific product from a specific vendor on a specific date.
-- Calculate the running total of sales for each market date, using a window function.
-- Calculate the rank of each vendor by average sales, using a window function.
-- Hard

-- Select all the market seasons from the market_date table where the total sales for each season is greater than $100,000.
-- Select all the customers from the customer table who have made the most purchases in the last year.
-- Select all the vendors who sell products that are more popular than the product with the ID 1000, using an inline query.
-- Calculate the percentage of total sales for each product category, using a window function.
-- Select all the customers from the customer table who have made a purchase in the last month, ordered by the date of their most recent purchase in ascending order, using precedings.