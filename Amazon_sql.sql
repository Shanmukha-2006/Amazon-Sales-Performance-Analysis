create database amazon;
use amazon;

#View the data
SELECT *
FROM amazon_sales
LIMIT 10;

#Total number of records
SELECT COUNT(*) AS total_records
FROM amazon_sales;

#Total revenue
SELECT ROUND(SUM(total_revenue), 2) AS total_revenue
FROM amazon_sales;

#Total orders
SELECT COUNT(DISTINCT order_id) AS total_orders
FROM amazon_sales;

#Total quantity sold
SELECT SUM(quantity_sold) AS total_quantity_sold
FROM amazon_sales;

#Average order value
SELECT ROUND(
    SUM(total_revenue) / COUNT(DISTINCT order_id), 2
) AS average_order_value
FROM amazon_sales;

#Average customer rating
SELECT ROUND(AVG(rating), 2) AS average_rating
FROM amazon_sales;

#Revenue by product category
SELECT 
    product_category,
    ROUND(SUM(total_revenue), 2) AS total_revenue
FROM amazon_sales
GROUP BY product_category
ORDER BY total_revenue DESC;

#Quantity sold by category
SELECT 
    product_category,
    SUM(quantity_sold) AS total_quantity
FROM amazon_sales
GROUP BY product_category
ORDER BY total_quantity DESC;
#Top 10 products by revenue
SELECT 
    product_id,
    ROUND(SUM(total_revenue), 2) AS total_revenue
FROM amazon_sales
GROUP BY product_id
ORDER BY total_revenue DESC
LIMIT 10;

#Top 10 products by quantity sold
SELECT 
    product_id,
    SUM(quantity_sold) AS total_quantity
FROM amazon_sales
GROUP BY product_id
ORDER BY total_quantity DESC
LIMIT 10;

#Revenue by customer region
SELECT 
    customer_region,
    ROUND(SUM(total_revenue), 2) AS total_revenue
FROM amazon_sales
GROUP BY customer_region
ORDER BY total_revenue DESC;

#Orders by region
SELECT 
    customer_region,
    COUNT(DISTINCT order_id) AS total_orders
FROM amazon_sales
GROUP BY customer_region
ORDER BY total_orders DESC;

#Revenue by payment method
SELECT 
    payment_method,
    ROUND(SUM(total_revenue), 2) AS total_revenue
FROM amazon_sales
GROUP BY payment_method
ORDER BY total_revenue DESC;

#Most-used payment method
SELECT 
    payment_method,
    COUNT(*) AS number_of_transactions
FROM amazon_sales
GROUP BY payment_method
ORDER BY number_of_transactions DESC;

#Monthly sales trend
SELECT 
    YEAR(order_date) AS year,
    MONTH(order_date) AS month,
    ROUND(SUM(total_revenue), 2) AS monthly_revenue
FROM amazon_sales
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY year, month;

#Yearly sales
SELECT 
    YEAR(order_date) AS year,
    ROUND(SUM(total_revenue), 2) AS total_revenue
FROM amazon_sales
GROUP BY YEAR(order_date)
ORDER BY year;

#Average discount by category
SELECT 
    product_category,
    ROUND(AVG(discount_percent), 2) AS average_discount
FROM amazon_sales
GROUP BY product_category
ORDER BY average_discount DESC;

#Average rating by category
SELECT 
    product_category,
    ROUND(AVG(rating), 2) AS average_rating
FROM amazon_sales
GROUP BY product_category
ORDER BY average_rating DESC;

#Most-reviewed categories
SELECT 
    product_category,
    SUM(review_count) AS total_reviews
FROM amazon_sales
GROUP BY product_category
ORDER BY total_reviews DESC;

#Best sales day
SELECT 
    DAYNAME(order_date) AS day_name,
    ROUND(SUM(total_revenue), 2) AS total_revenue
FROM amazon_sales
GROUP BY DAYNAME(order_date)
ORDER BY total_revenue DESC;

#Category performance summary
SELECT 
    product_category,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(quantity_sold) AS quantity_sold,
    ROUND(SUM(total_revenue), 2) AS total_revenue,
    ROUND(AVG(rating), 2) AS average_rating
FROM amazon_sales
GROUP BY product_category
ORDER BY total_revenue DESC;

#Rank categories by revenue
SELECT
    product_category,
    total_revenue,
    RANK() OVER (
        ORDER BY total_revenue DESC
    ) AS revenue_rank
FROM
(
    SELECT
        product_category,
        ROUND(SUM(total_revenue), 2) AS total_revenue
    FROM amazon_sales
    GROUP BY product_category
) AS category_sales;

#Month-over-month sales growth
WITH monthly_sales AS
(
    SELECT
        DATE_FORMAT(order_date, '%Y-%m') AS month,
        SUM(total_revenue) AS revenue
    FROM amazon_sales
    GROUP BY DATE_FORMAT(order_date, '%Y-%m')
),

sales_growth AS
(
    SELECT
        month,
        revenue,
        LAG(revenue) OVER (ORDER BY month) AS previous_month_revenue
    FROM monthly_sales
)

SELECT
    month,
    ROUND(revenue, 2) AS revenue,
    ROUND(previous_month_revenue, 2) AS previous_month_revenue,
    ROUND(
        ((revenue - previous_month_revenue)
        / previous_month_revenue) * 100,
        2
    ) AS growth_percentage
FROM sales_growth;

#Running total of monthly sales
WITH monthly_sales AS
(
    SELECT
        DATE_FORMAT(order_date, '%Y-%m') AS month,
        SUM(total_revenue) AS revenue
    FROM amazon_sales
    GROUP BY DATE_FORMAT(order_date, '%Y-%m')
)

SELECT
    month,
    ROUND(revenue, 2) AS monthly_revenue,
    ROUND(
        SUM(revenue) OVER (ORDER BY month),
        2
    ) AS cumulative_revenue
FROM monthly_sales;

