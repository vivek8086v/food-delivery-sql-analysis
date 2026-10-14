# Build Checklist

- [ ] Install/use MySQL 8.0+ and open a SQL client.
- [ ] Run `sql/01_schema.sql`.
- [ ] Import the five CSVs in foreign-key-safe order.
- [ ] Verify row counts against README dataset overview.
- [ ] Run `sql/02_analysis_queries.sql` from top to bottom.
- [ ] Save 3–5 findings from your query results in your own words.
- [ ] Add screenshots of selected query outputs to a `screenshots/` folder if useful.
- [ ] Create a Power BI or Tableau dashboard as a follow-up project.
- [ ] Update the README with your actual findings after running the analysis.
- [ ] Be ready to explain metric definitions and why `COUNT(DISTINCT order_id)` matters after joining order items.
