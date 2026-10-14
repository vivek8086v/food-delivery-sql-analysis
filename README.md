# Food Delivery SQL Analytics (MySQL)

An end-to-end SQL portfolio project analyzing a fictional food-delivery marketplace using MySQL 8. It demonstrates relational schema design, data validation, business KPIs, multi-table joins, CTEs, window functions, customer segmentation, and indexes.

> **Dataset note:** All records are synthetic and generated for practice. They do not represent a real company or real customers.

## Project files

The complete project currently lives in [food-delivery-sql-analysis/](./food-delivery-sql-analysis/).

- [Project README and setup guide](./food-delivery-sql-analysis/README.md)
- [Database schema](./food-delivery-sql-analysis/sql/01_schema.sql)
- [Business analysis queries](./food-delivery-sql-analysis/sql/02_analysis_queries.sql)
- [CSV datasets](./food-delivery-sql-analysis/data/)
- [Data dictionary](./food-delivery-sql-analysis/DATA_DICTIONARY.md)
- [Build checklist](./food-delivery-sql-analysis/BUILD_CHECKLIST.md)

## What this project answers

- How many orders are placed, delivered, or cancelled?
- What are delivered item revenue and average delivered order value?
- How do order volume and revenue change month to month?
- Which restaurants and products perform best?
- How many customers place repeat orders?
- Which cities have higher cancellation rates or longer delivery times?
- How can restaurants be ranked within each city?

## Skills demonstrated

MySQL 8, DDL, primary and foreign keys, constraints, indexes, multi-table joins, aggregate functions, CASE expressions, CTEs, LAG, ROW_NUMBER, DENSE_RANK, running totals, data-quality checks, and business interpretation.

## Quick start

1. Open the detailed [project setup guide](./food-delivery-sql-analysis/README.md).
2. Run the schema file in MySQL 8.0+.
3. Import the five CSV files in the documented parent-to-child order.
4. Run the analysis query file and interpret the results.

## Resume project description

**Food Delivery SQL Analytics | MySQL** — Designed a relational schema across five tables and analyzed 1,500 synthetic orders using multi-table joins, CTEs, and window functions; developed KPIs for delivered revenue, cancellation rate, repeat-customer behavior, restaurant performance, and delivery efficiency.

## Next improvement

Connect the analysis to Power BI or Tableau and build a dashboard for monthly revenue, cancellation rates, top restaurants, and delivery-time trends.