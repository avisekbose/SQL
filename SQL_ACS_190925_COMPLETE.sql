use `sql_dataset_acs`;

-- Q1
desc customers;
desc orderdetails;
desc orders;
desc products;

-- Q2
select location, count(customer_id) as number_of_customers
from customers
group by location
order by number_of_customers desc
limit 3;

-- Q3 MCQ option C

-- Q4 
SELECT NumberOfOrders, COUNT(*) AS CustomerCount
FROM 
(
	SELECT customer_id, COUNT(order_id) AS NumberOfOrders
    FROM Orders
    GROUP BY customer_id) AS CustomerOrders
GROUP BY NumberOfOrders
ORDER BY NumberOfOrders ASC;

-- Q5 MCQ option D 

-- Q6 MCQ option C 
    
-- Q7
select Product_Id, avg(quantity) as AvgQuantity, sum(quantity * price_per_unit) as TotalRevenue
from orderdetails
group by Product_Id
having AvgQuantity = 2
order by TotalRevenue desc;

-- Q8 MCQ option C 

-- Q9
select p.category, count(distinct o.customer_id) as unique_customers
from products as p
join orderdetails as od on p.product_id = od.product_id
join orders as o on od.order_id = o.order_id
group by p.category
order by unique_customers desc;

-- Q10 MCQ option C 

-- Q11
with o1 as (
	select date_format(order_date, '%Y-%m') as Month, sum(total_amount) as TotalSales
    from orders
    group by date_format(order_date, '%Y-%m')
),
o2 as (
	select Month, TotalSales, lag(TotalSales) over (order by month) as PreviousMonthSales
    from o1
)
select Month, TotalSales, round(((TotalSales - PreviousMonthSales) / PreviousMonthSales * 100), 2)
AS PercentChange
from o2
order by Month;

-- Q12 MCQ option A 

-- Q13 MCQ option D 

-- Q14
with o1 as (
	select date_format(order_date, '%Y-%m') as Month, round(Avg(total_amount), 2) as AvgOrderValue
    from orders
    group by date_format(order_date, '%Y-%m')
),
o2 as (
	select Month, AvgOrderValue, lag(AvgOrderValue) over (order by month) as PreviousMonthValue
    from o1
)
select Month, AvgOrderValue, round(AvgOrderValue - PreviousMonthValue, 2) AS ChangeInValue
from o2
group by Month, AvgOrderValue
order by ChangeInValue desc;

-- Q15 MCQ option C 

-- Q16
select product_id, count(*) as SalesFrequency
from orderdetails
group by product_id
order by SalesFrequency desc
limit 5;

-- Q17 MCQ option C 

-- Q18
WITH total_customers AS (
    SELECT COUNT(DISTINCT customer_id) AS total_customers
    FROM customers
)
SELECT od.product_id, p.name, COUNT(DISTINCT o.customer_id) AS UniqueCustomerCount
FROM orders o
JOIN orderdetails od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY od.product_id, p.name
HAVING COUNT(DISTINCT o.customer_id) < (SELECT total_customers * 0.4 FROM total_customers)
ORDER BY UniqueCustomerCount ASC;

-- Q19 MCQ option B 

-- Q20 MCQ option C 

-- Q21
WITH first_orders AS (
    SELECT customer_id, MIN(order_date) AS first_order_date
    FROM Orders
    GROUP BY customer_id
),
monthly_new_customers AS (
    SELECT DATE_FORMAT(first_order_date, '%Y-%m') AS FirstPurchaseMonth, COUNT(*) AS TotalNewCustomers
    FROM first_orders
    GROUP BY DATE_FORMAT(first_order_date, '%Y-%m')
)
SELECT FirstPurchaseMonth, TotalNewCustomers
FROM monthly_new_customers
ORDER BY FirstPurchaseMonth;

-- Q22 MCQ option A 

-- Q23
select date_format(order_date, '%Y-%m') as Month, sum(total_amount) as TotalSales
from orders
group by date_format(order_date, '%Y-%m')
order by TotalSales desc
limit 3;

-- Q24 MCQ option D 