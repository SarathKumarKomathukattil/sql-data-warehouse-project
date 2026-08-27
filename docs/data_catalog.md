# Gold Layer Data Catalog

## Overview

The Gold layer contains the final business-ready data used for reporting and analysis.

It is organized using a dimensional model made up of:

- dimension tables for descriptive business information
- fact tables for measurable transactional data

The main Gold layer objects are:

- `gold.dim_customers`
- `gold.dim_products`
- `gold.fact_sales`

---

## 1. gold.dim_customers

**Purpose:**  
Stores customer-related information by combining customer, demographic, and location attributes into one dimension table.

| Column Name | Data Type | Description |
|---|---|---|
| customer_key | INT | Surrogate key used to uniquely identify each customer in the Gold layer. |
| customer_id | INT | Original customer identifier from the source system. |
| customer_number | NVARCHAR(50) | Customer reference code used for identification and tracking. |
| first_name | NVARCHAR(50) | Customer's first name. |
| last_name | NVARCHAR(50) | Customer's last name. |
| country | NVARCHAR(50) | Country associated with the customer. |
| marital_status | NVARCHAR(50) | Standardized marital status, such as Married or Single. |
| gender | NVARCHAR(50) | Standardized customer gender. |
| birthdate | DATE | Customer's date of birth. |
| create_date | DATE | Date when the customer record was created. |

---

## 2. gold.dim_products

**Purpose:**  
Stores descriptive product information used to analyze sales by product, category, subcategory, and product line.

| Column Name | Data Type | Description |
|---|---|---|
| product_key | INT | Surrogate key used to uniquely identify each product in the Gold layer. |
| product_id | INT | Original product identifier from the source system. |
| product_number | NVARCHAR(50) | Product reference code used for identification. |
| product_name | NVARCHAR(50) | Name or description of the product. |
| category_id | NVARCHAR(50) | Identifier associated with the product category. |
| category | NVARCHAR(50) | Main product category, such as Bikes or Components. |
| subcategory | NVARCHAR(50) | More detailed classification within the main category. |
| maintenance_required | NVARCHAR(50) | Indicates whether maintenance is required for the product. |
| cost | INT | Cost associated with the product. |
| product_line | NVARCHAR(50) | Product line or family, such as Road, Mountain, or Touring. |
| start_date | DATE | Date from which the product became active or available. |

---

## 3. gold.fact_sales

**Purpose:**  
Stores sales transaction details and connects each transaction to the corresponding customer and product dimensions.

| Column Name | Data Type | Description |
|---|---|---|
| order_number | NVARCHAR(50) | Identifier assigned to the sales order. |
| product_key | INT | Foreign key linking the transaction to `gold.dim_products`. |
| customer_key | INT | Foreign key linking the transaction to `gold.dim_customers`. |
| order_date | DATE | Date when the order was placed. |
| shipping_date | DATE | Date when the order was shipped. |
| due_date | DATE | Expected due date associated with the order. |
| sales_amount | INT | Total sales value for the transaction line. |
| quantity | INT | Number of product units sold. |
| price | INT | Selling price per unit. |

---

## Data Model Relationships

The Gold layer follows a star-schema design.

`gold.fact_sales` acts as the central fact table and connects to:

- `gold.dim_customers` through `customer_key`
- `gold.dim_products` through `product_key`

This structure allows sales to be analyzed easily by customer, product, category, country, date, and other business attributes.
