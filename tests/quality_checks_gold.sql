/*
=============================================================
Gold Layer Data Quality Checks
=============================================================

Purpose:
    This script validates the final Gold layer used for reporting
    and analytics.

    The checks focus on:
    - Making sure dimension keys are unique
    - Detecting duplicate customer or product records
    - Verifying relationships between fact and dimension tables
    - Identifying fact records that do not have matching dimension records

    These checks help confirm that the Gold data model is reliable
    and ready for analytical use.
=============================================================
*/


-- =============================================================
-- Validate gold.dim_customers
-- =============================================================

-- Check for duplicate customer surrogate keys
-- Expected result: No rows
SELECT
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;



-- =============================================================
-- Validate gold.dim_products
-- =============================================================

-- Check for duplicate product surrogate keys
-- Expected result: No rows
SELECT
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;



-- =============================================================
-- Validate gold.fact_sales
-- =============================================================

-- Check relationships between fact sales and dimension tables
-- Expected result: No rows with missing customer or product matches
SELECT
    *
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
WHERE c.customer_key IS NULL
    OR p.product_key IS NULL;
