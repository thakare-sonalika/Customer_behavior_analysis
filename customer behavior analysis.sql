select * from customer;

--1
--select gender,sum(purchase_amount) as total_revenue FROM customer group by gender ;

--2
--select customer_id,purchase_amount from customer where purchase_amount >= (select avg(purchase_amount) from customer) and discount_applied = 'Yes' ;

--3
--select item_purchased,round(AVG(review_rating::numeric),2) AS avg_rating FROM customer GROUP BY item_purchased ORDER BY avg_rating DESC LIMIT 5;

--4
--select shipping_type as shipping_type,round(avg(purchase_amount),2) as avg_purchase_amount  from customer where shipping_type in ('Standard','Express') group by shipping_type;

--5
--select subscription_status,count(customer_id) as total_customers,round(sum(purchase_amount),2) as total_revenue, round(avg(purchase_amount),2) as avg_spend  from customer  group by subscription_status order by total_revenue, avg_spend desc;

--6
--SELECT item_purchased,ROUND (100 * SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END)/count(*),2) AS discount_percentage FROM customer GROUP BY item_purchased ORDER BY discount_percentage DESC LIMIT 5;

--7
with customer_type as (
select customer_id, previous_purchases,
CASE 
    WHEN previous_purchases = 1 THEN 'New' 
    WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning' 
	ELSE 'Loyal'  
	END AS customer_segment  
FROM customer 
)
select customer_segment , count(*) as Number_of_Customers 
from customer_type
GROUP BY customer_segment ;


--8 
with item_counts as (
select category,
item_purchased,
count(customer_id) as total_orders,
Row_number() over (partition by category order by count(customer_id) desc) as item_rank
from customer
group by category, item_purchased
)
select item_rank, category,item_purchased,total_orders
from item_counts
where item_rank <= 3;
 

--9
select subscription_status,
count(customer_id) as repeat_buyers
from customer
where previous_purchases > 5
group by subscription_status;


--10
--select sum(purchase_amount) as revenue_contribution ,age_group from customer group by age_group order by revenue_contribution desc ;
select age_group,
sum(purchase_amount) as total_revenue
from customer
group by age_group
order by total_revenue desc;
