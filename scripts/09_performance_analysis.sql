/*
===============================================================================
Performance Analysis (Year-over-Year, Month-over-Month)
===============================================================================
Purpose:
    - To measure the performance of products over time.
    - To compare current sales with average product sales.
    - To perform Year-over-Year (YoY) analysis.
    - To identify increases and decreases in product performance.

MySQL Functions Used:
    - YEAR()
    - LAG()
    - AVG() OVER()
    - CASE
    - CTE (WITH)
===============================================================================
*/


/*
-------------------------------------------------------------------------------
Analyze yearly product performance by comparing:
    1. Current year's sales
    2. Average sales of the product across all years
    3. Previous year's sales
-------------------------------------------------------------------------------
*/

WITH yearly_product_sales AS (
    SELECT
        YEAR(f.order_date) AS order_year,
        p.product_name,
        SUM(f.sales_amount) AS current_sales
    FROM gold.fact_sales AS f
    LEFT JOIN gold.dim_products AS p
        ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL
    GROUP BY
        YEAR(f.order_date),
        p.product_name
),

performance_analysis AS (
    SELECT
        order_year,
        product_name,
        current_sales,

        -- Average sales of the product across all years
        AVG(current_sales) OVER (
            PARTITION BY product_name
        ) AS avg_sales,

        -- Previous year's sales
        LAG(current_sales) OVER (
            PARTITION BY product_name
            ORDER BY order_year
        ) AS py_sales

    FROM yearly_product_sales
)

SELECT
    order_year,
    product_name,
    current_sales,
    avg_sales,

    -- Difference from average sales
    current_sales - avg_sales AS diff_avg,

    -- Performance compared with average
    CASE
        WHEN current_sales > avg_sales THEN 'Above Avg'
        WHEN current_sales < avg_sales THEN 'Below Avg'
        ELSE 'Avg'
    END AS avg_change,

    -- Previous year's sales
    py_sales,

    -- Difference from previous year
    current_sales - py_sales AS diff_py,

    -- Year-over-Year performance
    CASE
        WHEN current_sales > py_sales THEN 'Increase'
        WHEN current_sales < py_sales THEN 'Decrease'
        ELSE 'No Change'
    END AS py_change

FROM performance_analysis
ORDER BY
    product_name,
    order_year;
