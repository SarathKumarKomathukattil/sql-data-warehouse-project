
/*
=============================================================
Stored Procedure: Load Bronze Layer
=============================================================

Purpose:
    This stored procedure loads raw CRM and ERP data from CSV files
    into the Bronze layer of the data warehouse.

    The process performs the following steps:
    - Clears existing data from the Bronze tables using TRUNCATE TABLE.
    - Loads fresh data from the source CSV files using BULK INSERT.
    - Loads both CRM and ERP source tables.
    - Tracks the load duration for each table and for the full process.

Parameters:
    None.
    This procedure does not require any input parameters
    and does not return a value.

Usage:
    EXEC bronze.load_bronze;
=============================================================
*/


CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT('=========================================')
		PRINT'Loading Bronze Layer'
		PRINT('=========================================')

		PRINT('-----------------------------------------')
		PRINT'Loading CRM Tables'
		PRINT('-----------------------------------------')

		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.crm_cust_info;

		BULK INSERT bronze.crm_cust_info 
		FROM 'C:\Users\ASUS\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: '+CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds'
		PRINT '>>----------------------------------'

		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.crm_prd_info;

		BULK INSERT bronze.crm_prd_info 
		FROM 'C:\Users\ASUS\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: '+CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds'
		PRINT '>>----------------------------------'

		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.crm_sales_details;

		BULK INSERT bronze.crm_sales_details 
		FROM 'C:\Users\ASUS\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: '+CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds'
		PRINT '>>----------------------------------'


		PRINT('-----------------------------------------')
		PRINT'Loading ERP Tables'
		PRINT('-----------------------------------------')
		
		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.erp_loc_a101;

		BULK INSERT bronze.erp_loc_a101 
		FROM 'C:\Users\ASUS\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: '+CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds'
		PRINT '>>----------------------------------'

		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.erp_cust_az12;

		BULK INSERT bronze.erp_cust_az12 
		FROM 'C:\Users\ASUS\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: '+CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds'
		PRINT '>>----------------------------------'

		SET @start_time = GETDATE();
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;

		BULK INSERT bronze.erp_px_cat_g1v2 
		FROM 'C:\Users\ASUS\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: '+CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds'
		PRINT '>>----------------------------------'

		SET @batch_end_time = GETDATE();
		PRINT '>> Total Load Duration: '+CAST(DATEDIFF(second,@batch_start_time,@batch_end_time) AS NVARCHAR) + ' seconds'
		PRINT('-----------------------------------------')

	END TRY
	BEGIN CATCH
		PRINT('-----------------------------------------')
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT('-----------------------------------------')
	END CATCH
END;
GO


EXEC bronze.load_bronze
