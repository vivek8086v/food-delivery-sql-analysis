USE food_delivery_analytics;

-- 1. Table row counts / basic validation
SELECT 'customers' AS table_name, COUNT(*) AS row_count FROM customers
UNION ALL SELECT 'restaurants', COUNT(*) FROM restaurants
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'orders', COUNT(*) FROM orders
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items;

-- 2. Core order KPIs. Revenue is item subtotal for delivered orders, excluding fees.
WITH order_totals AS (
 SELECT o.order_id, o.order_status, SUM(oi.quantity * oi.unit_price) AS item_subtotal
 FROM orders o JOIN order_items oi ON oi.order_id=o.order_id GROUP BY o.order_id,o.order_status
)
SELECT COUNT(*) AS orders_with_items,
 SUM(order_status='Delivered') AS delivered_orders,
 ROUND(100*AVG(order_status='Cancelled'),2) AS cancellation_rate_pct,
 ROUND(SUM(CASE WHEN order_status='Delivered' THEN item_subtotal ELSE 0 END),2) AS delivered_item_revenue,
 ROUND(AVG(CASE WHEN order_status='Delivered' THEN item_subtotal END),2) AS avg_delivered_order_value
FROM order_totals;

-- 3. Monthly orders and delivered item revenue
SELECT DATE_FORMAT(o.order_datetime,'%Y-%m') AS order_month, COUNT(DISTINCT o.order_id) AS total_orders,
 SUM(o.order_status='Delivered') AS delivered_orders,
 ROUND(SUM(CASE WHEN o.order_status='Delivered' THEN oi.quantity*oi.unit_price ELSE 0 END),2) AS delivered_revenue
FROM orders o JOIN order_items oi ON oi.order_id=o.order_id
GROUP BY DATE_FORMAT(o.order_datetime,'%Y-%m') ORDER BY order_month;

-- 4. Month-over-month revenue change using LAG
WITH monthly AS (
 SELECT DATE_FORMAT(o.order_datetime,'%Y-%m') AS month,
 SUM(CASE WHEN o.order_status='Delivered' THEN oi.quantity*oi.unit_price ELSE 0 END) AS revenue
 FROM orders o JOIN order_items oi ON oi.order_id=o.order_id GROUP BY DATE_FORMAT(o.order_datetime,'%Y-%m')
), prior AS (SELECT month,revenue,LAG(revenue) OVER(ORDER BY month) AS prev_revenue FROM monthly)
SELECT month,ROUND(revenue,2) AS revenue,ROUND(prev_revenue,2) AS previous_month_revenue,
 ROUND(100*(revenue-prev_revenue)/NULLIF(prev_revenue,0),2) AS mom_change_pct FROM prior ORDER BY month;

-- 5. Top restaurants by delivered item revenue
SELECT r.restaurant_id,r.restaurant_name,r.city,r.cuisine,
 ROUND(SUM(oi.quantity*oi.unit_price),2) AS delivered_revenue,COUNT(DISTINCT o.order_id) AS delivered_orders
FROM restaurants r JOIN orders o ON o.restaurant_id=r.restaurant_id
JOIN order_items oi ON oi.order_id=o.order_id WHERE o.order_status='Delivered'
GROUP BY r.restaurant_id,r.restaurant_name,r.city,r.cuisine ORDER BY delivered_revenue DESC LIMIT 10;

-- 6. Repeat customers (at least 2 delivered orders)
SELECT c.customer_id,c.customer_name,COUNT(DISTINCT o.order_id) AS delivered_orders,
 ROUND(SUM(oi.quantity*oi.unit_price),2) AS lifetime_item_revenue
FROM customers c JOIN orders o ON o.customer_id=c.customer_id JOIN order_items oi ON oi.order_id=o.order_id
WHERE o.order_status='Delivered' GROUP BY c.customer_id,c.customer_name
HAVING COUNT(DISTINCT o.order_id)>=2 ORDER BY delivered_orders DESC,lifetime_item_revenue DESC;

-- 7. Segment customers by delivered order frequency
WITH customer_counts AS (SELECT c.customer_id,c.customer_name,COUNT(DISTINCT CASE WHEN o.order_status='Delivered' THEN o.order_id END) AS delivered_orders
FROM customers c LEFT JOIN orders o ON o.customer_id=c.customer_id GROUP BY c.customer_id,c.customer_name)
SELECT CASE WHEN delivered_orders=0 THEN 'No delivered orders' WHEN delivered_orders=1 THEN 'One-time' WHEN delivered_orders BETWEEN 2 AND 5 THEN 'Repeat' ELSE 'Loyal' END AS segment,
COUNT(*) AS customers FROM customer_counts GROUP BY segment ORDER BY customers DESC;

-- 8. Cancellation rate by restaurant city
SELECT r.city,COUNT(*) AS total_orders,SUM(o.order_status='Cancelled') AS cancelled_orders,
ROUND(100*AVG(o.order_status='Cancelled'),2) AS cancellation_rate_pct
FROM orders o JOIN restaurants r ON r.restaurant_id=o.restaurant_id GROUP BY r.city ORDER BY cancellation_rate_pct DESC;

-- 9. Average delivery time by city (delivered only)
SELECT r.city,COUNT(*) AS delivered_orders,ROUND(AVG(o.delivery_minutes),1) AS avg_delivery_minutes,
ROUND(MIN(o.delivery_minutes),1) AS min_delivery_minutes,ROUND(MAX(o.delivery_minutes),1) AS max_delivery_minutes
FROM orders o JOIN restaurants r ON r.restaurant_id=o.restaurant_id
WHERE o.order_status='Delivered' AND o.delivery_minutes IS NOT NULL GROUP BY r.city ORDER BY avg_delivery_minutes;

-- 10. Rank restaurants by delivered revenue within each city
WITH restaurant_revenue AS (SELECT r.restaurant_id,r.restaurant_name,r.city,
SUM(oi.quantity*oi.unit_price) AS revenue FROM restaurants r JOIN orders o ON o.restaurant_id=r.restaurant_id
JOIN order_items oi ON oi.order_id=o.order_id WHERE o.order_status='Delivered'
GROUP BY r.restaurant_id,r.restaurant_name,r.city)
SELECT *,DENSE_RANK() OVER(PARTITION BY city ORDER BY revenue DESC) AS city_revenue_rank FROM restaurant_revenue ORDER BY city,city_revenue_rank;

-- 11. Top-selling products by quantity
SELECT p.product_id,p.product_name,r.restaurant_name,SUM(oi.quantity) AS units_sold,
ROUND(SUM(oi.quantity*oi.unit_price),2) AS item_revenue FROM order_items oi JOIN products p ON p.product_id=oi.product_id
JOIN restaurants r ON r.restaurant_id=p.restaurant_id JOIN orders o ON o.order_id=oi.order_id
WHERE o.order_status='Delivered' GROUP BY p.product_id,p.product_name,r.restaurant_name ORDER BY units_sold DESC LIMIT 15;

-- 12. First and most recent delivered order per customer using ROW_NUMBER
WITH ranked AS (SELECT o.customer_id,o.order_id,o.order_datetime,
ROW_NUMBER() OVER(PARTITION BY o.customer_id ORDER BY o.order_datetime) AS first_rank,
ROW_NUMBER() OVER(PARTITION BY o.customer_id ORDER BY o.order_datetime DESC) AS latest_rank
FROM orders o WHERE o.order_status='Delivered')
SELECT customer_id,MAX(CASE WHEN first_rank=1 THEN order_id END) AS first_order_id,
MAX(CASE WHEN latest_rank=1 THEN order_id END) AS latest_order_id FROM ranked GROUP BY customer_id;

-- 13. Cumulative monthly delivered revenue
WITH monthly AS (SELECT DATE_FORMAT(o.order_datetime,'%Y-%m') AS month,
SUM(CASE WHEN o.order_status='Delivered' THEN oi.quantity*oi.unit_price ELSE 0 END) AS revenue
FROM orders o JOIN order_items oi ON oi.order_id=o.order_id GROUP BY DATE_FORMAT(o.order_datetime,'%Y-%m'))
SELECT month,ROUND(revenue,2) AS revenue,ROUND(SUM(revenue) OVER(ORDER BY month),2) AS cumulative_revenue FROM monthly ORDER BY month;

-- 14. Data quality checks
SELECT COUNT(*) AS orders_missing_customer FROM orders o LEFT JOIN customers c ON c.customer_id=o.customer_id WHERE c.customer_id IS NULL;
SELECT COUNT(*) AS order_items_with_invalid_quantity FROM order_items WHERE quantity<=0;
SELECT COUNT(*) AS delivered_orders_missing_delivery_time FROM orders WHERE order_status='Delivered' AND delivery_minutes IS NULL;
