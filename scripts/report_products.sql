/*
=============================================================
Product Analytics Report
=============================================================

Purpose:
    This report summarizes product performance and sales activity
    for analysis and reporting.

Key Features:
    - Combines product information with sales transactions
    - Calculates product-level sales metrics
    - Groups products into performance segments

Metrics Included:
    - Total orders
    - Total sales
    - Total quantity sold
    - Average selling price
    - Product lifespan in months
    - Most recent order date

Additional KPIs:
    - Recency since the latest sale
    - Average revenue per order
    - Average monthly revenue

Product Segmentation:
    - High Performer
    - Mid-Range
    - Low-Performer

The final report helps evaluate product performance,
sales contribution, and product activity over time.
=============================================================
*/


IF OBJECT_ID('gold.report_products','V') IS NOT NULL
	DROP VIEW gold.report_products;

GO

CREATE VIEW gold.report_products AS

WITH base_query AS (
SELECT 
s.order_number,
s.order_date,
s.customer_key,
s.sales_amount,
s.quantity,
p.product_key,
p.product_name,
p.category,
p.subcategory,
p.cost
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
ON s.product_key = p.product_key
WHERE s.order_date IS NOT NULL)

, product_aggregation AS(
SELECT 
product_key,
product_name,
category,
subcategory,
cost,
DATEDIFF(month,MIN(order_date),MAX(order_date)) lifespan,
MAX(order_date) last_order,
COUNT(DISTINCT(order_number)) total_orders,
COUNT(DISTINCT(product_key)) total_products,
SUM(sales_amount) total_sales,
SUM(quantity) total_quantity,
ROUND(AVG(CAST(sales_amount AS FLOAT)/NULLIF(quantity,0)),1) avg_selling_price
FROM base_query
GROUP BY
product_key,
product_name,
category,
subcategory,
cost)


SELECT
product_key,
product_name,
category,
subcategory,
cost,
last_order,
DATEDIFF(MONTH,last_order,GETDATE()) recency_in_months,
CASE	
	WHEN total_sales > 50000 THEN 'High Performer'
	WHEN total_sales >= 10000 THEN 'Mid-Range'
	ELSE 'Low-Performer'
END AS product_segment,
lifespan,
total_orders,
total_products,
total_sales,
total_quantity,
avg_selling_price,
CASE
	WHEN total_orders = 0 THEN 0
	ELSE total_sales / total_orders
END avg_order_revenue,
CASE
	WHEN lifespan = 0 THEN total_sales
	ELSE total_sales / lifespan
END avg_monthly_revenue
FROM product_aggregation
