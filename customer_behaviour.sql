create database customer_behavior;
use customer_behavior;

select * from customer limit 5;

-- q1 what is the total revenue generated  by male vs female customers

select gender,sum(purchase_amount) from customer group by gender;

-- q2 which customer used discount and still spend more than average purchase amount

select customer_id,purchase_amount from customer where discount_applied='yes' and purchase_amount>=(select AVG(purchase_amount) from customer);

-- q3 which are the top 5 products with the highest average revierw rating


select item_purchased ,avg(review_rating) as average_product_rating
from customer group by item_purchased
order by round(avg(review_rating),1) desc
limit 5;

-- q4 compare the average purchase amount between standrard and express shopping

select shipping_type,avg(purchase_amount) 
from customer 
where shipping_type in ('standard','express')
group by shipping_type


-- q5 do subscribed customers spend more ? 
--    compmare avg spend and total_revenue b/w subscribers and non-subscribers

select subscription_status,
count(customer_id) as total_customers,
round(AVG(purchase_amount),2) as avg_spend,
round(sum(purchase_amount),2) as total_revenue
from customer
group by subscription_status
order by total_revenue,avg_spend desc;

-- q6 which 5 products have the highest precentage of purchase with discount applied

select item_purchased,
100*SUM(CASE WHEN discount_applied='yes' THEN 1 else 0 end)/count(*) as discount_rate
from customer
group by item_purchased
order by discount_rate desc limit 5;

-- q7 segment customers into new , returining , and loyal based on their total number of previous purchase, and show the count of each segment

with customer_type as (
select customer_id,previous_purchases,
CASE
	WHEN previous_purchases= 1 THEN 'new'
    WHEN previous_purchases between 2 and 10 THEN 'new'
    ELSE 'loyal'
    END as customer_segment
from customer
)
select customer_segment,count(*)
 as 'number of customers'
 from customer_type
 group by customer_segment
 
-- q8 what are the top 3 most purchased products with each catageory

WITH item_counts AS (
    SELECT 
        category,
        item_purchased,
        COUNT(customer_id) AS total_orders,
        ROW_NUMBER() OVER (
            PARTITION BY category 
            ORDER BY COUNT(customer_id) DESC
        ) AS item_rank
    FROM customer
    GROUP BY category, item_purchased
)
SELECT 
    category,
    item_purchased,
    total_orders,
    item_rank
FROM item_counts
WHERE item_rank <= 3;

-- q9 are customers who are repeat buyers(more than 5 previous purchases) also likely to subscriber?

select subscription_status,
count(customer_id) as repeat_buyer
from customer 
where previous_purchases>5
group by subscription_status;

-- q10 what is the revenue contribution of each age group

select age_group,
SUM(purchase_amount) as total_revenue
from customer
group by age_group
order by total_revenue desc;

select * from customer limit 2;
