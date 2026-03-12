-- =========================================
-- E-commerce SQL Data Analysis Project
-- Author: Praveen Kumar
-- Tool: SQL Server Management Studio
-- =========================================
USE EcommerceAnalysis;
GO
-- Step 1: Check number of rows in each table

SELECT COUNT(*) AS Total_Customers
FROM customers;

SELECT COUNT(*) AS Total_Orders
FROM orders;

SELECT COUNT(*) AS Total_Order_Items
FROM order_items;

SELECT COUNT(*) AS Total_Products
FROM products;

SELECT COUNT(*) AS Total_Payments
FROM payments;

-- Step 2: Preview dataset

SELECT TOP 10 *
FROM customers;

SELECT TOP 10 *
FROM orders;

SELECT TOP 10 *
FROM order_items;

-- Step 3: Monthly Revenue Trend

SELECT 
    FORMAT(o.order_purchase_timestamp,'yyyy-MM') AS OrderMonth,
    SUM(oi.price) AS TotalRevenue
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
GROUP BY FORMAT(o.order_purchase_timestamp,'yyyy-MM')
ORDER BY OrderMonth;

-- Step 4: Top Product Categories by Revenue

SELECT TOP 10
    p.product_category_name,
    SUM(oi.price) AS Revenue
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY Revenue DESC;

-- Step 5: Cities with the Most Orders

SELECT TOP 10
    c.customer_city,
    COUNT(o.order_id) AS TotalOrders
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.customer_city
ORDER BY TotalOrders DESC;

-- Step 6: Average Order Value

SELECT 
    SUM(price) / COUNT(DISTINCT order_id) AS AvgOrderValue
FROM order_items;

-- Step 7: Payment Method Usage

SELECT 
    payment_type,
    COUNT(*) AS TotalPayments
FROM payments
GROUP BY payment_type
ORDER BY TotalPayments DESC;

-- Step 8: Customer Lifetime Value

SELECT 
    c.customer_unique_id,
    COUNT(DISTINCT o.order_id) AS TotalOrders,
    SUM(oi.price) AS TotalRevenue
FROM customers c
JOIN orders o 
ON c.customer_id = o.customer_id
JOIN order_items oi 
ON o.order_id = oi.order_id
GROUP BY c.customer_unique_id
ORDER BY TotalRevenue DESC;
-- Step 9: Repeat Customer Analysis

SELECT 
    COUNT(DISTINCT customer_id) AS TotalCustomers,
    SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END) AS RepeatCustomers
FROM (
    SELECT 
        customer_id,
        COUNT(order_id) AS order_count
    FROM orders
    GROUP BY customer_id
) t;