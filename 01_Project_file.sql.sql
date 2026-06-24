-- =====================================================
-- SQL-Based Dynamic Pricing Intelligence System
-- =====================================================

-- =====================================================
-- Step 1: Create and Select Database
-- =====================================================

CREATE DATABASE dynamic_pricing;

USE dynamic_pricing;

-- =====================================================
-- Step 2: Create Tables
-- =====================================================

-- Products Table
-- Stores product details and base prices

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    category VARCHAR(50),
    base_price DECIMAL(10,2)
);

-- Sales Table
-- Stores sales transaction records

CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    product_id INT,
    quantity_sold INT,
    sale_date DATE,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Demand Table
-- Stores product demand levels

CREATE TABLE demand (
    demand_id INT PRIMARY KEY,
    product_id INT,
    demand_level VARCHAR(20),
    recorded_date DATE,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- =====================================================
-- Step 3: Insert Data into Products Table
-- =====================================================

INSERT INTO products VALUES
(1, 'Laptop', 'Electronics', 50000),
(2, 'Phone', 'Electronics', 20000),
(3, 'Shoes', 'Fashion', 3000),
(4, 'Headphones', 'Electronics', 4000),
(5, 'Smart Watch', 'Accessories', 7000),
(6, 'Backpack', 'Fashion', 1500),
(7, 'Keyboard', 'Electronics', 2500),
(8, 'Gaming Mouse', 'Electronics', 1800);

-- =====================================================
-- Step 4: Insert Data into Sales Table
-- =====================================================

INSERT INTO sales VALUES
(1, 1, 10, '2024-01-01'),
(2, 1, 15, '2024-01-05'),
(3, 2, 20, '2024-01-02'),
(4, 3, 5, '2024-01-03'),
(5, 4, 30, '2024-01-04'),
(6, 5, 12, '2024-01-06'),
(7, 6, 8, '2024-01-07'),
(8, 7, 22, '2024-01-08'),
(9, 8, 18, '2024-01-09');

-- =====================================================
-- Step 5: Insert Data into Demand Table
-- =====================================================

INSERT INTO demand VALUES
(1, 1, 'High', '2024-01-01'),
(2, 2, 'Medium', '2024-01-02'),
(3, 3, 'Low', '2024-01-03'),
(4, 4, 'High', '2024-01-04'),
(5, 5, 'Medium', '2024-01-06'),
(6, 6, 'Low', '2024-01-07'),
(7, 7, 'High', '2024-01-08'),
(8, 8, 'Medium', '2024-01-09');

-- =====================================================
-- Step 6: Display Product Data
-- =====================================================

SELECT * FROM products;

-- =====================================================
-- Step 7: Dynamic Pricing Analysis
-- Suggests prices based on demand levels
-- =====================================================

SELECT 
    p.product_name,
    p.base_price,
    d.demand_level,

    CASE 
        WHEN d.demand_level = 'High' THEN p.base_price * 1.2
        WHEN d.demand_level = 'Medium' THEN p.base_price * 1.0
        WHEN d.demand_level = 'Low' THEN p.base_price * 0.8
    END AS suggested_price

FROM products p
JOIN demand d 
ON p.product_id = d.product_id;

-- =====================================================
-- Step 8: Total Sales Analysis
-- Calculates total quantity sold for each product
-- =====================================================

SELECT 
    p.product_name,
    SUM(s.quantity_sold) AS total_sales

FROM products p
JOIN sales s 
ON p.product_id = s.product_id

GROUP BY p.product_name;

-- =====================================================
-- Step 9: Top Selling Product
-- Identifies highest selling product
-- =====================================================

SELECT 
    p.product_name,
    SUM(s.quantity_sold) AS total_sales

FROM products p
JOIN sales s 
ON p.product_id = s.product_id

GROUP BY p.product_name

ORDER BY total_sales DESC

LIMIT 1;

-- =====================================================
-- Step 10: Create Pricing View
-- Reusable view for pricing analysis
-- =====================================================

DROP VIEW IF EXISTS pricing_view;

CREATE VIEW pricing_view AS

SELECT 
    p.product_name,
    d.demand_level,
    p.base_price,

    CASE 
        WHEN d.demand_level = 'High' THEN p.base_price * 1.2
        WHEN d.demand_level = 'Medium' THEN p.base_price
        ELSE p.base_price * 0.8
    END AS suggested_price

FROM products p
JOIN demand d 
ON p.product_id = d.product_id;

-- Display Pricing View

SELECT * FROM pricing_view;

-- =====================================================
-- Step 11: Monthly Sales Trend Analysis
-- Uses date functions for sales trends
-- =====================================================

SELECT 
    MONTH(sale_date) AS month,
    SUM(quantity_sold) AS total_sales

FROM sales

GROUP BY MONTH(sale_date);

-- =====================================================
-- Step 12: High Demand Products
-- Displays products with high demand
-- =====================================================

SELECT 
    p.product_name,
    d.demand_level

FROM products p
JOIN demand d 
ON p.product_id = d.product_id

WHERE d.demand_level = 'High';

-- =====================================================
-- End of Project
-- =====================================================