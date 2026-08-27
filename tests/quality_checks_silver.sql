/*
=============================================================
Silver Layer Data Quality Checks
=============================================================

Purpose:
    This script validates the quality of data stored in the Silver layer.

    The checks focus on:
    - Missing or duplicate key values
    - Extra spaces in text fields
    - Standardized categorical values
    - Invalid or unrealistic dates
    - Negative or missing numeric values
    - Logical consistency between related columns
    - Consistency between sales, quantity, and price

    Most validation queries should return no rows when the data
    has been cleaned correctly.
=============================================================
*/


-- =============================================================
-- Validate silver.crm_cust_info
-- =============================================================

-- Check for duplicate or missing customer IDs
-- Expected result: No rows
SELECT
    cst_id,
    COUNT(*) AS record_count
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1
    OR cst_id IS NULL;


-- Check for leading or trailing spaces in customer keys
-- Expected result: No rows
SELECT
    cst_key
FROM silver.crm_cust_info
WHERE cst_key != TRIM(cst_key);


-- Review standardized marital status values
SELECT DISTINCT
    cst_marital_status
FROM silver.crm_cust_info;


-- Review standardized gender values
SELECT DISTINCT
    cst_gndr
FROM silver.crm_cust_info;



-- =============================================================
-- Validate silver.crm_prd_info
-- =============================================================

-- Check for duplicate or missing product IDs
-- Expected result: No rows
SELECT
    prd_id,
    COUNT(*) AS record_count
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1
    OR prd_id IS NULL;


-- Check for leading or trailing spaces in product names
-- Expected result: No rows
SELECT
    prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);


-- Check for missing or negative product costs
-- Expected result: No rows
SELECT
    prd_cost
FROM silver.crm_prd_info
WHERE prd_cost IS NULL
    OR prd_cost < 0;


-- Review standardized product line values
SELECT DISTINCT
    prd_line
FROM silver.crm_prd_info;


-- Check that product end date is not before start date
-- Expected result: No rows
SELECT
    *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;



-- =============================================================
-- Validate silver.crm_sales_details
-- =============================================================

-- Check source date values that may be invalid before conversion
-- Expected result: No invalid values
SELECT
    sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0
    OR LEN(CAST(sls_due_dt AS VARCHAR(20))) != 8
    OR sls_due_dt > 20500101
    OR sls_due_dt < 19000101;


-- Check logical order of sales dates
-- Order date should not be after shipping date or due date
-- Expected result: No rows
SELECT
    *
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt
    OR sls_order_dt > sls_due_dt;


-- Check consistency between sales amount, quantity, and price
-- Expected result: No rows
SELECT DISTINCT
    sls_sales,
    sls_quantity,
    sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
    OR sls_sales IS NULL
    OR sls_quantity IS NULL
    OR sls_price IS NULL
    OR sls_sales <= 0
    OR sls_quantity <= 0
    OR sls_price <= 0
ORDER BY
    sls_sales,
    sls_quantity,
    sls_price;



-- =============================================================
-- Validate silver.erp_cust_az12
-- =============================================================

-- Check for unrealistic customer birth dates
-- Expected result: Birth dates should be within a reasonable range
SELECT DISTINCT
    bdate
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01'
    OR bdate > GETDATE();


-- Review standardized gender values
SELECT DISTINCT
    gen
FROM silver.erp_cust_az12;



-- =============================================================
-- Validate silver.erp_loc_a101
-- =============================================================

-- Review standardized country values
SELECT DISTINCT
    cntry
FROM silver.erp_loc_a101
ORDER BY cntry;



-- =============================================================
-- Validate silver.erp_px_cat_g1v2
-- =============================================================

-- Check for leading or trailing spaces
-- Expected result: No rows
SELECT
    *
FROM silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat)
    OR subcat != TRIM(subcat)
    OR maintenance != TRIM(maintenance);


-- Review standardized maintenance values
SELECT DISTINCT
    maintenance
FROM silver.erp_px_cat_g1v2;
