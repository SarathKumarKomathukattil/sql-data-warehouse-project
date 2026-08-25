/*
=============================================================
Database and Schema Setup
=============================================================

Purpose:
    This script prepares the SQL Data Warehouse environment.

    It checks whether the 'DataWarehouse' database already exists.
    If it does, the existing database is removed and a new one is
    created.

    After creating the database, the following schemas are created:

        - bronze
        - silver
        - gold

Warning:
    If the 'DataWarehouse' database already exists, this script will
    delete it completely.

    Any existing data inside the database will be lost.

    Use this script only when you want to rebuild the database from
    scratch.
=============================================================
*/

USE master;
GO

-- Drop and recreate the 'DataWarehouse' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
	ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse;
END;
GO

--Create 'DataWarehouse' database

CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO


--Create Schemas
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;


