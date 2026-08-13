/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - To compare performance or metrics across dimensions or time periods.
    - To evaluate differences between categories.
    - To calculate each category's contribution to overall sales.

MySQL Functions Used:
    - SUM()
    - ROUND()
    - Window Functions: SUM() OVER()
===============================================================================
*/


-- Which categories contribute the most to overall sales?

WITH category_sales AS (
    SELECT
        p.category,
        SUM(f.sales_amount) AS total_sales
    FROM gold.fact_sales AS f
    LEFT JOIN gold.dim_products AS p
        ON p.product_key = f.product_key
    GROUP BY p.category
)

SELECT
    category,
    total_sales,

    -- Overall sales across all categories
    SUM(total_sales) OVER () AS overall_sales,

    -- Percentage contribution of each category
    ROUND(
        (total_sales * 100.0)
        / SUM(total_sales) OVER (),
        2
    ) AS percentage_of_total

FROM category_sales
ORDER BY total_sales DESC;
