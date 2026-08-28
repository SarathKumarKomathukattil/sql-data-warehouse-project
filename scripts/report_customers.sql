/*
=============================================================
Customer Analytics Report
=============================================================

Purpose:
    This report summarizes important customer information and
    purchasing behavior for analysis.

Key Features:
    - Combines customer details with sales activity
    - Groups customers into meaningful segments
    - Calculates customer-level performance metrics

Metrics Included:
    - Total orders
    - Total sales
    - Total quantity purchased
    - Number of products purchased
    - Customer lifespan in months

Additional KPIs:
    - Recency since the most recent order
    - Average order value
    - Average monthly spend

The final report is designed to support customer analysis,
segmentation, and business decision-making.
=============================================================
*/


IF OBJECT_ID('gold.report_customers','V') IS NOT NULL
	DROP VIEW gold.report_customers;

GO

CREATE VIEW gold.report_customers AS

WITH base_query AS (
SELECT 
s.order_number,
s.product_key,
s.order_date,
s.sales_amount,
s.quantity,
c.customer_key,
c.customer_number,
CONCAT(c.first_name,' ',c.last_name) customer_name,
DATEDIFF(year,c.birthdate,GETDATE()) age
FROM gold.fact_sales s
LEFT JOIN gold.dim_customers c
ON s.customer_key = c.customer_key
WHERE s.order_date IS NOT NULL)

, customer_aggregation AS (
SELECT 
customer_key,
customer_number,
customer_name,
age,
COUNT(DISTINCT(order_number)) total_orders,
SUM(sales_amount) total_sales,
SUM(quantity) total_quantity,
COUNT(DISTINCT(product_key)) total_products,
MAX(order_date) last_order,
DATEDIFF(month,MIN(order_date),MAX(order_date)) lifespan
FROM base_query
GROUP BY 
customer_key,
customer_number,
customer_name,
age)

SELECT
customer_key,
customer_number,
customer_name,
age,
CASE 
	WHEN age < 20 THEN 'Under 20'
	WHEN age BETWEEN 20 AND 29  THEN '20-29'
	WHEN age BETWEEN 30 AND 39  THEN '30-39'
	WHEN age BETWEEN 40 AND 49  THEN '40-49'
	ELSE '50 and above'
END AS age_group,
CASE 
	WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
	WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
	ELSE 'New'
END AS customer_segment,
DATEDIFF(month,last_order,GETDATE()) recency,
total_orders,
total_sales,
total_quantity,
total_products,
lifespan,
CASE 
	WHEN total_orders = 0 THEN 0
	ELSE total_sales/total_orders
END avg_order_value,
CASE 
	WHEN lifespan = 0 THEN total_sales
	ELSE total_sales/lifespan
END avg_monthly_spend
FROM customer_aggregation




