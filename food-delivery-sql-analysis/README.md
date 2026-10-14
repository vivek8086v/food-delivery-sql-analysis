# Food Delivery SQL Analytics (MySQL)

An end-to-end SQL portfolio project analyzing a fictional food-delivery marketplace. It demonstrates relational schema design, data validation, business KPIs, joins across multiple tables, CTEs, window functions, segmentation, and performance-minded indexes.

> **Dataset note:** all records are synthetic and generated for practice. They do not represent a real company or customers.

## Business questions
- How many orders are placed, delivered, or cancelled?
- What is delivered item revenue and average delivered order value?
- How do orders and revenue change month to month?
- Which restaurants and products lead on revenue or units sold?
- How many customers place repeat orders?
- Which cities have high cancellation rates or longer delivery times?
- How can restaurants be ranked within each city?

## Repository structure
```text
food-delivery-sql-analysis/
├── README.md
├── DATA_DICTIONARY.md
├── BUILD_CHECKLIST.md
├── sql/
│   ├── 01_schema.sql
│   └── 02_analysis_queries.sql
└── data/
    ├── customers.csv
    ├── restaurants.csv
    ├── products.csv
    ├── orders.csv
    └── order_items.csv
```

## Dataset overview
- 200 customers
- 25 restaurants
- 40 products
- 1,500 orders across 2025
- Order-item rows created to support basket-level analysis

## Setup (MySQL 8.0+)
1. Create/open a MySQL 8 database connection in MySQL Workbench or your preferred client.
2. Run `sql/01_schema.sql` to create the database and tables.
3. Import each CSV from `data/` into its matching table. Use UTF-8 and keep the CSV header row mapped to columns. Import parent tables first: `customers`, `restaurants`, `products`, `orders`, then `order_items`.
4. Run `sql/02_analysis_queries.sql`.

### CSV import order
`customers.csv` → `restaurants.csv` → `products.csv` → `orders.csv` → `order_items.csv`

## Metric definitions
- **Delivered item revenue:** sum of `quantity * unit_price` for delivered orders. Delivery fees are excluded; discounts are not subtracted in this version.
- **Average delivered order value:** average item subtotal per delivered order.
- **Cancellation rate:** cancelled orders divided by all orders in the relevant group.
- **Delivery time:** `delivery_minutes` for delivered orders only.

## Important SQL design note
Joining `orders` directly to `order_items` creates one row per item, not one row per order. Use `COUNT(DISTINCT order_id)` for order counts and aggregate item revenue at the appropriate grain to avoid join fan-out.

## Skills demonstrated
MySQL 8, DDL, primary and foreign keys, constraints, indexes, multi-table joins, aggregate functions, `CASE`, CTEs, `LAG`, `ROW_NUMBER`, `DENSE_RANK`, running totals, data-quality checks, and business interpretation.

## Suggested resume bullet
**Food Delivery SQL Analytics | MySQL** — Designed a relational schema across five tables and analyzed 1,500 synthetic orders using multi-table joins, CTEs, and window functions; developed KPIs for delivered revenue, cancellation rate, repeat-customer behavior, restaurant performance, and delivery efficiency.

## Next improvement
Add a dashboard in Power BI or Tableau using monthly revenue, cancellation rate by city, top restaurants, and delivery-time trends.
