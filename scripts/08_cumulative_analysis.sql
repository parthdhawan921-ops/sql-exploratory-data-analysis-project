/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - To calculate running totals or moving averages for key metrics.
    - To track performance over time cumulatively.
    - Useful for growth analysis or identifying long-term trends.

MySQL Functions Used:
    - Window Functions: SUM() OVER(), AVG() OVER()
    - DATE_FORMAT()
    - SUM()
    - AVG()
===============================================================================
*/


-- Calculate total sales per year
-- and the running total of sales over time
SELECT
    order_date,
    total_sales,

    -- Running total of sales
    SUM(total_sales) OVER (
        ORDER BY order_date
    ) AS running_total_sales,

    -- Running average of average price
    AVG(avg_price) OVER (
        ORDER BY order_date
    ) AS moving_average_price

FROM
(
    SELECT
        CAST(DATE_FORMAT(order_date, '%Y-01-01') AS DATE) AS order_date,
        SUM(sales_amount) AS total_sales,
        AVG(price) AS avg_price
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATE_FORMAT(order_date, '%Y-01-01')
) AS t

ORDER BY order_date;
