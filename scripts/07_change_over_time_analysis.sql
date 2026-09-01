/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - To track trends, growth, and changes in key metrics over time.
    - For time-series analysis and identifying seasonality.
    - To measure growth or decline over specific periods.

MySQL Functions Used:
    - YEAR()
    - MONTH()
    - DATE_FORMAT()
    - SUM()
    - COUNT()
===============================================================================
*/


-- Analyse sales performance over time
-- Using YEAR() and MONTH()
SELECT
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY
    YEAR(order_date),
    MONTH(order_date)
ORDER BY
    YEAR(order_date),
    MONTH(order_date);


-- Analyse sales performance by month
SELECT
    DATE_FORMAT(order_date, '%Y-%m-01') AS order_date,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATE_FORMAT(order_date, '%Y-%m-01')
ORDER BY DATE_FORMAT(order_date, '%Y-%m-01');


-- Analyse sales performance using formatted Year-Month
SELECT
    DATE_FORMAT(order_date, '%Y-%b') AS order_date,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATE_FORMAT(order_date, '%Y-%b')
ORDER BY DATE_FORMAT(order_date, '%Y-%b');
